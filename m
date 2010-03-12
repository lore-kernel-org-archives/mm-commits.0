From: akpm@linux-foundation.org
Subject: + char-drivers-ram-oops-panic-logger.patch added to -mm tree
Date: Fri, 12 Mar 2010 14:51:24 -0800
Message-ID: <201003122251.o2CMpOvQ012611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932205Ab0CLWvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 17:51:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marco.stornelli@gmail.com, David.Woodhouse@intel.com, anders.grafstrom@netinsight.net, simon.kagstrom@netinsight.net, yuasa@linux-mips.org


The patch titled
     char drivers: RAM oops/panic logger
has been added to the -mm tree.  Its filename is
     char-drivers-ram-oops-panic-logger.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char drivers: RAM oops/panic logger
From: Marco Stornelli <marco.stornelli@gmail.com>

Ramoops, like mtdoops, can log oops/panic information but in RAM.  It can
be used with persistent RAM for systems without flash support.  In
addition, for this systems, with this driver, it's no more needed add to
the kernel the mtd subsystem with advantage in footprint.

It can be used in a very easy way with persistent RAM for systems without
flash support.  For these systems, with this driver, it is no longer
required to cinlude mtd subsystem with an advantage in footprint.  In
addition, you can save flash space and store this information only in RAM.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc; Anders Grafstrom <anders.grafstrom@netinsight.net>
Cc: Yuasa Yoichi <yuasa@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig   |    7 +
 drivers/char/Makefile  |    1 
 drivers/char/ramoops.c |  162 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 170 insertions(+)

diff -puN drivers/char/Kconfig~char-drivers-ram-oops-panic-logger drivers/char/Kconfig
--- a/drivers/char/Kconfig~char-drivers-ram-oops-panic-logger
+++ a/drivers/char/Kconfig
@@ -1113,5 +1113,12 @@ config DEVPORT
 
 source "drivers/s390/char/Kconfig"
 
+config RAMOOPS
+	tristate "Log panic/oops to a RAM buffer"
+	default n
+	help
+	  This enables panic and oops messages to be logged to a circular
+	  buffer in RAM where it can be read back at some later point.
+
 endmenu
 
diff -puN drivers/char/Makefile~char-drivers-ram-oops-panic-logger drivers/char/Makefile
--- a/drivers/char/Makefile~char-drivers-ram-oops-panic-logger
+++ a/drivers/char/Makefile
@@ -107,6 +107,7 @@ obj-$(CONFIG_HANGCHECK_TIMER)	+= hangche
 obj-$(CONFIG_TCG_TPM)		+= tpm/
 
 obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
+obj-$(CONFIG_RAMOOPS)		+= ramoops.o
 
 obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
diff -puN /dev/null drivers/char/ramoops.c
--- /dev/null
+++ a/drivers/char/ramoops.c
@@ -0,0 +1,162 @@
+/*
+ * RAM Oops/Panic logger
+ *
+ * Copyright (C) 2009 Marco Stornelli <marco.stornelli@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kmsg_dump.h>
+#include <linux/time.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+
+#define RAMOOPS_KERNMSG_HDR "===="
+#define RAMOOPS_HEADER_SIZE   (5 + sizeof(struct timeval))
+
+#define RECORD_SIZE 4096
+
+static ulong mem_address;
+module_param(mem_address, ulong, 0600);
+MODULE_PARM_DESC(mem_address,
+		"start of reserved RAM used to store oops/panic logs");
+
+static ulong mem_size;
+module_param(mem_size, ulong, 0600);
+MODULE_PARM_DESC(mem_size,
+		"size of reserved RAM used to store oops/panic logs");
+
+static int dump_oops = 1;
+module_param(dump_oops, int, 0600);
+MODULE_PARM_DESC(dump_oops,
+		"set to 1 to dump oopses, 0 to only dump panics (default 1)");
+
+static struct ramoops_context {
+	struct kmsg_dumper dump;
+	void *virt_addr;
+	phys_addr_t phys_addr;
+	unsigned long size;
+	int count;
+	int max_count;
+} oops_cxt;
+
+static void ramoops_do_dump(struct kmsg_dumper *dumper,
+		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
+		const char *s2, unsigned long l2)
+{
+	struct ramoops_context *cxt = container_of(dumper,
+			struct ramoops_context, dump);
+	unsigned long s1_start, s2_start;
+	unsigned long l1_cpy, l2_cpy;
+	int res;
+	char *buf;
+	struct timeval timestamp;
+
+	/* Only dump oopses if dump_oops is set */
+	if (reason == KMSG_DUMP_OOPS && !dump_oops)
+		return;
+
+	buf = (char *)(cxt->virt_addr + (cxt->count * RECORD_SIZE));
+	memset(buf, '\0', RECORD_SIZE);
+	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
+	buf += res;
+	do_gettimeofday(&timestamp);
+	res = sprintf(buf, "%lu.%lu\n", (long)timestamp.tv_sec, (long)timestamp.tv_usec);
+	buf += res;
+
+	l2_cpy = min(l2, (unsigned long)(RECORD_SIZE - RAMOOPS_HEADER_SIZE));
+	l1_cpy = min(l1, (unsigned long)(RECORD_SIZE - RAMOOPS_HEADER_SIZE) - l2_cpy);
+
+	s2_start = l2 - l2_cpy;
+	s1_start = l1 - l1_cpy;
+
+	memcpy(buf, s1 + s1_start, l1_cpy);
+	memcpy(buf + l1_cpy, s2 + s2_start, l2_cpy);
+
+	cxt->count = (cxt->count + 1) % cxt->max_count;
+}
+
+static int __init ramoops_init(void)
+{
+	struct ramoops_context *cxt = &oops_cxt;
+	int err = -EINVAL;
+
+	if (!mem_size) {
+		printk(KERN_ERR "Invalid size specification");
+		goto fail3;
+	}
+
+	rounddown_pow_of_two(mem_size);
+
+	if (mem_size < RECORD_SIZE) {
+		printk(KERN_ERR "size too small");
+		goto fail3;
+	}
+
+	cxt->max_count = mem_size / RECORD_SIZE;
+	cxt->count = 0;
+	cxt->size = mem_size;
+	cxt->phys_addr = mem_address;
+
+	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
+		printk(KERN_ERR "ramoops: request mem region failed");
+		err = -EINVAL;
+		goto fail3;
+	}
+
+	cxt->virt_addr = ioremap(cxt->phys_addr,  cxt->size);
+	if (!cxt->virt_addr) {
+		printk(KERN_ERR "ramoops: ioremap failed");
+		goto fail2;
+	}
+
+	cxt->dump.dump = ramoops_do_dump;
+	err = kmsg_dump_register(&cxt->dump);
+	if (err) {
+		printk(KERN_ERR "ramoops: registering kmsg dumper failed");
+		goto fail1;
+	}
+
+	return 0;
+
+fail1:
+	iounmap(cxt->virt_addr);
+fail2:
+	release_mem_region(cxt->phys_addr, cxt->size);
+fail3:
+	return err;
+}
+
+static void __exit ramoops_exit(void)
+{
+	struct ramoops_context *cxt = &oops_cxt;
+
+	if (kmsg_dump_unregister(&cxt->dump) < 0)
+		printk(KERN_WARNING "ramoops: could not unregister kmsg_dumper\n");
+
+	iounmap(cxt->virt_addr);
+	release_mem_region(cxt->phys_addr, cxt->size);
+}
+
+
+module_init(ramoops_init);
+module_exit(ramoops_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marco Stornelli <marco.stornelli@gmail.com>");
+MODULE_DESCRIPTION("RAM Oops/Panic logger/driver");
_

Patches currently in -mm which might be from marco.stornelli@gmail.com are

char-drivers-ram-oops-panic-logger.patch


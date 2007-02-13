From: akpm@linux-foundation.org
Subject: + lguest-trivial-guest-console-driver.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:03:35 -0800
Message-ID: <200702130703.l1D73ZqH024562@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57025 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbXBMHDm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:03:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     lguest: trivial guest console driver
has been added to the -mm tree.  Its filename is
     lguest-trivial-guest-console-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: trivial guest console driver
From: Rusty Russell <rusty@rustcorp.com.au>

A trivial driver to have a basic lguest console, using the hvc_console
infrastructure.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Makefile     |    1 
 drivers/char/hvc_lguest.c |   99 ++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)

diff -puN drivers/char/Makefile~lguest-trivial-guest-console-driver drivers/char/Makefile
--- a/drivers/char/Makefile~lguest-trivial-guest-console-driver
+++ a/drivers/char/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += am
 obj-$(CONFIG_SX)		+= sx.o generic_serial.o
 obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
 obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o hvsi.o
+obj-$(CONFIG_LGUEST_GUEST)	+= hvc_lguest.o
 obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries.o
 obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
 obj-$(CONFIG_HVC_BEAT)		+= hvc_beat.o
diff -puN /dev/null drivers/char/hvc_lguest.c
--- /dev/null
+++ a/drivers/char/hvc_lguest.c
@@ -0,0 +1,99 @@
+/* Simple console for lguest.
+ *
+ * Copyright (C) 2006 Rusty Russell, IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/err.h>
+#include <linux/init.h>
+#include <asm/lguest_device.h>
+#include "hvc_console.h"
+
+static int cons_irq;
+static int cons_offset;
+static char inbuf[256];
+static struct lguest_dma cons_input = { .used_len = 0,
+					.addr[0] = __pa(inbuf),
+					.len[0] = sizeof(inbuf),
+					.len[1] = 0 };
+
+static int get_chars(u32 vtermno, char *buf, int count)
+{
+	if (!cons_input.used_len)
+		return 0;
+
+	if (cons_input.used_len - cons_offset < count)
+		count = cons_input.used_len - cons_offset;
+
+	memcpy(buf, inbuf + cons_offset, count);
+	cons_offset += count;
+	if (cons_offset == cons_input.used_len) {
+		cons_offset = 0;
+		cons_input.used_len = 0;
+	}
+	return count;
+}
+
+static int put_chars(u32 vtermno, const char *buf, int count)
+{
+	struct lguest_dma dma;
+
+	/* FIXME: what if it's over a page boundary? */
+	dma.len[0] = count;
+	dma.len[1] = 0;
+	dma.addr[0] = __pa(buf);
+
+	hcall(LHCALL_SEND_DMA, 4, __pa(&dma), 0);
+	return count;
+}
+
+struct hv_ops lguest_cons = {
+	.get_chars = get_chars,
+	.put_chars = put_chars,
+};
+
+static int __init cons_init(void)
+{
+	if (strcmp(paravirt_ops.name, "lguest") != 0)
+		return 0;
+
+	return hvc_instantiate(0, 0, &lguest_cons);
+}
+console_initcall(cons_init);
+
+static int lguestcons_probe(struct lguest_device *lhdev)
+{
+	cons_irq = lhdev->index+1;
+	lhdev->private = hvc_alloc(0, cons_irq, &lguest_cons, 256);
+	if (IS_ERR(lhdev->private))
+		return PTR_ERR(lhdev->private);
+
+	if (!hcall(LHCALL_BIND_DMA, 0, __pa(&cons_input), (1<<8)+cons_irq))
+		printk("lguest console: failed to bind buffer.\n");
+	return 0;
+}
+
+static struct lguest_driver lguestcons_drv = {
+	.name = "lguestcons",
+	.owner = THIS_MODULE,
+	.device_type = LGUEST_DEVICE_T_CONSOLE,
+	.probe = lguestcons_probe,
+};
+
+static int __init hvc_lguest_init(void)
+{
+	return register_lguest_driver(&lguestcons_drv);
+}
+module_init(hvc_lguest_init);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
cleanup-paravirt-unhandled-fallthrough.patch
cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
cleanup-move-mce_disabled-to-asm-mceh.patch
cleanup-rename-cpu_gdt_descr-and-remove-extern.patch
cleanup-remove-extern-declaration-from.patch
cleanup-make-disable_acpi-valid-w-o-config_acpi.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-network-driver-fix.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
vmi-versus-hrtimers.patch

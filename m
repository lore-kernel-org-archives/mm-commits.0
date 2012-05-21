From: akpm@linux-foundation.org
Subject: [wrecked] ramoops-use-pstore-interface.patch removed from -mm tree
Date: Mon, 21 May 2012 15:15:40 -0700
Message-ID: <20120521221540.9B824A0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:53480 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab2EUWPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 May 2012 18:15:43 -0400
Received: by faaa25 with SMTP id a25so323715faa.1
        for <mm-commits@vger.kernel.org>; Mon, 21 May 2012 15:15:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, arnd@arndb.de, greg@kroah.com, marco.stornelli@gmail.com, rdunlap@xenotime.net, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ramoops: use pstore interface
has been removed from the -mm tree.  Its filename was
     ramoops-use-pstore-interface.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ramoops: use pstore interface

Instead of using /dev/mem directly and forcing userspace to know (or
extract) where the platform has defined persistent memory, how many slots
it has, the sizes, etc, use the common pstore infrastructure to handle
Oops gathering and extraction.  This presents a much easier to use
filesystem-based view to the memory region.  This also means that any
other tools that are written to understand pstore will automatically be
able to process ramoops too.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ramoops.txt |    8 -
 drivers/char/Kconfig      |    1 
 drivers/char/ramoops.c    |  205 +++++++++++++++++++++++++++---------
 3 files changed, 163 insertions(+), 51 deletions(-)

diff -puN Documentation/ramoops.txt~ramoops-use-pstore-interface Documentation/ramoops.txt
--- a/Documentation/ramoops.txt~ramoops-use-pstore-interface
+++ a/Documentation/ramoops.txt
@@ -3,7 +3,7 @@ Ramoops oops/panic logger
 
 Sergiu Iordache <sergiu@chromium.org>
 
-Updated: 8 August 2011
+Updated: 17 November 2011
 
 0. Introduction
 
@@ -71,6 +71,6 @@ timestamp and a new line. The dump then 
 
 4. Reading the data
 
-The dump data can be read from memory (through /dev/mem or other means).
-Getting the module parameters, which are needed in order to parse the data, can
-be done through /sys/module/ramoops/parameters/* .
+The dump data can be read from the pstore filesystem. The format for these
+files is "dmesg-ramoops-N", where N is the record number in memory. To delete
+a stored record from RAM, simply unlink the respective pstore file.
diff -puN drivers/char/Kconfig~ramoops-use-pstore-interface drivers/char/Kconfig
--- a/drivers/char/Kconfig~ramoops-use-pstore-interface
+++ a/drivers/char/Kconfig
@@ -588,6 +588,7 @@ source "drivers/s390/char/Kconfig"
 config RAMOOPS
 	tristate "Log panic/oops to a RAM buffer"
 	depends on HAS_IOMEM
+	depends on PSTORE
 	default n
 	help
 	  This enables panic and oops messages to be logged to a circular
diff -puN drivers/char/ramoops.c~ramoops-use-pstore-interface drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~ramoops-use-pstore-interface
+++ a/drivers/char/ramoops.c
@@ -2,6 +2,7 @@
  * RAM Oops/Panic logger
  *
  * Copyright (C) 2010 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright (C) 2011 Kees Cook <keescook@chromium.org>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -24,7 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/module.h>
-#include <linux/kmsg_dump.h>
+#include <linux/pstore.h>
 #include <linux/time.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
@@ -55,73 +56,156 @@ module_param(dump_oops, int, 0600);
 MODULE_PARM_DESC(dump_oops,
 		"set to 1 to dump oopses, 0 to only dump panics (default 1)");
 
-static struct ramoops_context {
-	struct kmsg_dumper dump;
+struct ramoops_context {
 	void *virt_addr;
 	phys_addr_t phys_addr;
 	unsigned long size;
-	unsigned long record_size;
+	size_t record_size;
 	int dump_oops;
-	int count;
-	int max_count;
-} oops_cxt;
+	unsigned int count;
+	unsigned int max_count;
+	unsigned int read_count;
+	struct pstore_info pstore;
+};
 
 static struct platform_device *dummy;
 static struct ramoops_platform_data *dummy_data;
 
-static void ramoops_do_dump(struct kmsg_dumper *dumper,
-		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
-		const char *s2, unsigned long l2)
-{
-	struct ramoops_context *cxt = container_of(dumper,
-			struct ramoops_context, dump);
-	unsigned long s1_start, s2_start;
-	unsigned long l1_cpy, l2_cpy;
-	int res, hdr_size;
-	char *buf, *buf_orig;
+static int ramoops_pstore_open(struct pstore_info *psi)
+{
+	struct ramoops_context *cxt = psi->data;
+
+	cxt->read_count = 0;
+	return 0;
+}
+
+static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
+				   struct timespec *time,
+				   char **buf,
+				   struct pstore_info *psi)
+{
+	ssize_t size;
+	char *rambuf;
+	struct ramoops_context *cxt = psi->data;
+
+	if (cxt->read_count >= cxt->max_count)
+		return -EINVAL;
+	*id = cxt->read_count++;
+	/* Only supports dmesg output so far. */
+	*type = PSTORE_TYPE_DMESG;
+	/* TODO(kees): Bogus time for the moment. */
+	time->tv_sec = 0;
+	time->tv_nsec = 0;
+
+	rambuf = cxt->virt_addr + (*id * cxt->record_size);
+	size = strnlen(rambuf, cxt->record_size);
+	*buf = kmalloc(size, GFP_KERNEL);
+	if (*buf == NULL)
+		return -ENOMEM;
+	memcpy(*buf, rambuf, size);
+
+	return size;
+}
+
+static int ramoops_pstore_write(enum pstore_type_id type,
+				enum kmsg_dump_reason reason,
+				u64 *id,
+				unsigned int part,
+				size_t size, struct pstore_info *psi)
+{
+	char *buf;
+	size_t res;
 	struct timeval timestamp;
+	struct ramoops_context *cxt = psi->data;
+	size_t available = cxt->record_size;
 
+	/* Currently ramoops is designed to only store dmesg dumps. */
+	if (type != PSTORE_TYPE_DMESG)
+		return -EINVAL;
+
+	/* Out of the various dmesg dump types, ramoops is currently designed
+	 * to only store crash logs, rather than storing general kernel logs.
+	 */
 	if (reason != KMSG_DUMP_OOPS &&
 	    reason != KMSG_DUMP_PANIC)
-		return;
+		return -EINVAL;
 
-	/* Only dump oopses if dump_oops is set */
+	/* Skip Oopes when configured to do so. */
 	if (reason == KMSG_DUMP_OOPS && !cxt->dump_oops)
-		return;
+		return -EINVAL;
+
+	/* Explicitly only take the first part of any new crash.
+	 * If our buffer is larger than kmsg_bytes, this can never happen,
+	 * and if our buffer is smaller than kmsg_bytes, we don't want the
+	 * report split across multiple records.
+	 */
+	if (part != 1)
+		return -ENOSPC;
 
 	buf = cxt->virt_addr + (cxt->count * cxt->record_size);
-	buf_orig = buf;
 
-	memset(buf, '\0', cxt->record_size);
 	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
 	buf += res;
+	available -= res;
+
 	do_gettimeofday(&timestamp);
 	res = sprintf(buf, "%lu.%lu\n", (long)timestamp.tv_sec, (long)timestamp.tv_usec);
 	buf += res;
+	available -= res;
 
-	hdr_size = buf - buf_orig;
-	l2_cpy = min(l2, cxt->record_size - hdr_size);
-	l1_cpy = min(l1, cxt->record_size - hdr_size - l2_cpy);
-
-	s2_start = l2 - l2_cpy;
-	s1_start = l1 - l1_cpy;
+	if (size > available)
+		size = available;
 
-	memcpy(buf, s1 + s1_start, l1_cpy);
-	memcpy(buf + l1_cpy, s2 + s2_start, l2_cpy);
+	memcpy(buf, cxt->pstore.buf, size);
+	memset(buf + size, '\0', available - size);
 
 	cxt->count = (cxt->count + 1) % cxt->max_count;
+
+	return 0;
+}
+
+static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
+				struct pstore_info *psi)
+{
+	char *buf;
+	struct ramoops_context *cxt = psi->data;
+
+	if (id >= cxt->max_count)
+		return -EINVAL;
+
+	buf = cxt->virt_addr + (id * cxt->record_size);
+	memset(buf, '\0', cxt->record_size);
+
+	return 0;
 }
 
+static struct ramoops_context oops_cxt = {
+	.pstore = {
+		.owner	= THIS_MODULE,
+		.name	= "ramoops",
+		.open	= ramoops_pstore_open,
+		.read	= ramoops_pstore_read,
+		.write	= ramoops_pstore_write,
+		.erase	= ramoops_pstore_erase,
+	},
+};
+
 static int __init ramoops_probe(struct platform_device *pdev)
 {
 	struct ramoops_platform_data *pdata = pdev->dev.platform_data;
 	struct ramoops_context *cxt = &oops_cxt;
 	int err = -EINVAL;
 
+	/* Only a single ramoops area allowed at a time, so fail extra
+	 * probes.
+	 */
+	if (cxt->max_count)
+		goto fail_out;
+
 	if (!pdata->mem_size || !pdata->record_size) {
 		pr_err("The memory size and the record size must be "
 			"non-zero\n");
-		goto fail3;
+		goto fail_out;
 	}
 
 	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
@@ -130,14 +214,15 @@ static int __init ramoops_probe(struct p
 	/* Check for the minimum memory size */
 	if (pdata->mem_size < MIN_MEM_SIZE &&
 			pdata->record_size < MIN_MEM_SIZE) {
-		pr_err("memory size too small, minium is %lu\n", MIN_MEM_SIZE);
-		goto fail3;
+		pr_err("memory size too small, minimum is %lu\n",
+			MIN_MEM_SIZE);
+		goto fail_out;
 	}
 
 	if (pdata->mem_size < pdata->record_size) {
 		pr_err("The memory size must be larger than the "
 			"records size\n");
-		goto fail3;
+		goto fail_out;
 	}
 
 	cxt->max_count = pdata->mem_size / pdata->record_size;
@@ -147,23 +232,32 @@ static int __init ramoops_probe(struct p
 	cxt->record_size = pdata->record_size;
 	cxt->dump_oops = pdata->dump_oops;
 
+	cxt->pstore.data = cxt;
+	cxt->pstore.bufsize = cxt->record_size;
+	cxt->pstore.buf = kmalloc(cxt->pstore.bufsize, GFP_KERNEL);
+	spin_lock_init(&cxt->pstore.buf_lock);
+	if (!cxt->pstore.buf) {
+		pr_err("cannot allocate pstore buffer\n");
+		goto fail_clear;
+	}
+
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
-		pr_err("request mem region failed\n");
+		pr_err("request mem region (0x%lx@0x%llx) failed\n",
+			cxt->size, cxt->phys_addr);
 		err = -EINVAL;
-		goto fail3;
+		goto fail_buf;
 	}
 
 	cxt->virt_addr = ioremap(cxt->phys_addr,  cxt->size);
 	if (!cxt->virt_addr) {
 		pr_err("ioremap failed\n");
-		goto fail2;
+		goto fail_mem_region;
 	}
 
-	cxt->dump.dump = ramoops_do_dump;
-	err = kmsg_dump_register(&cxt->dump);
+	err = pstore_register(&cxt->pstore);
 	if (err) {
-		pr_err("registering kmsg dumper failed\n");
-		goto fail1;
+		pr_err("registering with pstore failed\n");
+		goto fail_iounmap;
 	}
 
 	/*
@@ -175,26 +269,43 @@ static int __init ramoops_probe(struct p
 	record_size = pdata->record_size;
 	dump_oops = pdata->dump_oops;
 
+	pr_info("attached 0x%lx@0x%llx (%ux0x%zx)\n",
+		cxt->size, cxt->phys_addr, cxt->max_count, cxt->record_size);
+
 	return 0;
 
-fail1:
+fail_iounmap:
 	iounmap(cxt->virt_addr);
-fail2:
+fail_mem_region:
 	release_mem_region(cxt->phys_addr, cxt->size);
-fail3:
+fail_buf:
+	kfree(cxt->pstore.buf);
+fail_clear:
+	cxt->pstore.bufsize = 0;
+	cxt->max_count = 0;
+fail_out:
 	return err;
 }
 
 static int __exit ramoops_remove(struct platform_device *pdev)
 {
+#if 0
+	/* TODO(kees): We cannot unload ramoops since pstore doesn't support
+	 * unregistering yet.
+	 */
 	struct ramoops_context *cxt = &oops_cxt;
 
-	if (kmsg_dump_unregister(&cxt->dump) < 0)
-		pr_warn("could not unregister kmsg_dumper\n");
-
 	iounmap(cxt->virt_addr);
 	release_mem_region(cxt->phys_addr, cxt->size);
+	cxt->max_count = 0;
+
+	/* TODO(kees): When pstore supports unregistering, call it here. */
+	kfree(cxt->pstore.buf);
+	cxt->pstore.bufsize = 0;
+
 	return 0;
+#endif
+	return -EBUSY;
 }
 
 static struct platform_driver ramoops_driver = {
_

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch
ramoops-use-pstore-interface-fix.patch


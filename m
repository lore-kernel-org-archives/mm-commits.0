From: akpm@linux-foundation.org
Subject: - make-dev-kmem-a-config-option.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:39 -0700
Message-ID: <200804300538.m3U5cdEo028765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854AbYD3Fil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:38:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     make /dev/kmem a config option
has been removed from the -mm tree.  Its filename was
     make-dev-kmem-a-config-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make /dev/kmem a config option
From: Arjan van de Ven <arjan@linux.intel.com>

Make /dev/kmem a config option; /dev/kmem is VERY rarely used, and when
used, it's generally for no good (rootkits tend to be the most common
users).  With this config option, users have the choice to disable
/dev/kmem, saving some size as well.

A patch to disable /dev/kmem has been in the Fedora and RHEL kernels for
4+ years now without any known problems or legit users of /dev/kmem.

[akpm@linux-foundation.org: make CONFIG_DEVKMEM default to y]
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    9 +++++++++
 drivers/char/mem.c   |   10 ++++++++++
 2 files changed, 19 insertions(+)

diff -puN drivers/char/Kconfig~make-dev-kmem-a-config-option drivers/char/Kconfig
--- a/drivers/char/Kconfig~make-dev-kmem-a-config-option
+++ a/drivers/char/Kconfig
@@ -80,6 +80,15 @@ config VT_HW_CONSOLE_BINDING
 	 information. For framebuffer console users, please refer to
 	 <file:Documentation/fb/fbcon.txt>.
 
+config DEVKMEM
+	bool "/dev/kmem virtual device support"
+	default y
+	help
+	  Say Y here if you want to support the /dev/kmem device. The
+	  /dev/kmem device is rarely used, but can be used for certain
+	  kind of kernel debugging operations.
+	  When in doubt, say "N".
+
 config SERIAL_NONSTANDARD
 	bool "Non-standard serial port support"
 	depends on HAS_IOMEM
diff -puN drivers/char/mem.c~make-dev-kmem-a-config-option drivers/char/mem.c
--- a/drivers/char/mem.c~make-dev-kmem-a-config-option
+++ a/drivers/char/mem.c
@@ -364,6 +364,7 @@ static int mmap_mem(struct file * file, 
 	return 0;
 }
 
+#ifdef CONFIG_DEVKMEM
 static int mmap_kmem(struct file * file, struct vm_area_struct * vma)
 {
 	unsigned long pfn;
@@ -384,6 +385,7 @@ static int mmap_kmem(struct file * file,
 	vma->vm_pgoff = pfn;
 	return mmap_mem(file, vma);
 }
+#endif
 
 #ifdef CONFIG_CRASH_DUMP
 /*
@@ -422,6 +424,7 @@ static ssize_t read_oldmem(struct file *
 extern long vread(char *buf, char *addr, unsigned long count);
 extern long vwrite(char *buf, char *addr, unsigned long count);
 
+#ifdef CONFIG_DEVKMEM
 /*
  * This function reads the *virtual* memory as seen by the kernel.
  */
@@ -626,6 +629,7 @@ static ssize_t write_kmem(struct file * 
  	*ppos = p;
  	return virtr + wrote;
 }
+#endif
 
 #ifdef CONFIG_DEVPORT
 static ssize_t read_port(struct file * file, char __user * buf,
@@ -803,6 +807,7 @@ static const struct file_operations mem_
 	.get_unmapped_area = get_unmapped_area_mem,
 };
 
+#ifdef CONFIG_DEVKMEM
 static const struct file_operations kmem_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_kmem,
@@ -811,6 +816,7 @@ static const struct file_operations kmem
 	.open		= open_kmem,
 	.get_unmapped_area = get_unmapped_area_mem,
 };
+#endif
 
 static const struct file_operations null_fops = {
 	.llseek		= null_lseek,
@@ -889,11 +895,13 @@ static int memory_open(struct inode * in
 			filp->f_mapping->backing_dev_info =
 				&directly_mappable_cdev_bdi;
 			break;
+#ifdef CONFIG_DEVKMEM
 		case 2:
 			filp->f_op = &kmem_fops;
 			filp->f_mapping->backing_dev_info =
 				&directly_mappable_cdev_bdi;
 			break;
+#endif
 		case 3:
 			filp->f_op = &null_fops;
 			break;
@@ -942,7 +950,9 @@ static const struct {
 	const struct file_operations	*fops;
 } devlist[] = { /* list of minor devices */
 	{1, "mem",     S_IRUSR | S_IWUSR | S_IRGRP, &mem_fops},
+#ifdef CONFIG_DEVKMEM
 	{2, "kmem",    S_IRUSR | S_IWUSR | S_IRGRP, &kmem_fops},
+#endif
 	{3, "null",    S_IRUGO | S_IWUGO,           &null_fops},
 #ifdef CONFIG_DEVPORT
 	{4, "port",    S_IRUSR | S_IWUSR | S_IRGRP, &port_fops},
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch


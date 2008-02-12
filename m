From: akpm@linux-foundation.org
Subject: + make-dev-kmem-a-config-option.patch added to -mm tree
Date: Mon, 11 Feb 2008 20:59:25 -0800
Message-ID: <200802120500.m1C50Wtu018735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbYBLFAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 00:00:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     make /dev/kmem a config option
has been added to the -mm tree.  Its filename is
     make-dev-kmem-a-config-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    8 ++++++++
 drivers/char/mem.c   |   10 ++++++++++
 2 files changed, 18 insertions(+)

diff -puN drivers/char/Kconfig~make-dev-kmem-a-config-option drivers/char/Kconfig
--- a/drivers/char/Kconfig~make-dev-kmem-a-config-option
+++ a/drivers/char/Kconfig
@@ -80,6 +80,14 @@ config VT_HW_CONSOLE_BINDING
 	 information. For framebuffer console users, please refer to
 	 <file:Documentation/fb/fbcon.txt>.
 
+config DEVKMEM
+	bool "/dev/kmem virtual device support"
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
@@ -323,6 +323,7 @@ static int mmap_mem(struct file * file, 
 	return 0;
 }
 
+#ifdef CONFIG_DEVKMEM
 static int mmap_kmem(struct file * file, struct vm_area_struct * vma)
 {
 	unsigned long pfn;
@@ -343,6 +344,7 @@ static int mmap_kmem(struct file * file,
 	vma->vm_pgoff = pfn;
 	return mmap_mem(file, vma);
 }
+#endif
 
 #ifdef CONFIG_CRASH_DUMP
 /*
@@ -381,6 +383,7 @@ static ssize_t read_oldmem(struct file *
 extern long vread(char *buf, char *addr, unsigned long count);
 extern long vwrite(char *buf, char *addr, unsigned long count);
 
+#ifdef CONFIG_DEVKMEM
 /*
  * This function reads the *virtual* memory as seen by the kernel.
  */
@@ -585,6 +588,7 @@ static ssize_t write_kmem(struct file * 
  	*ppos = p;
  	return virtr + wrote;
 }
+#endif
 
 #ifdef CONFIG_DEVPORT
 static ssize_t read_port(struct file * file, char __user * buf,
@@ -762,6 +766,7 @@ static const struct file_operations mem_
 	.get_unmapped_area = get_unmapped_area_mem,
 };
 
+#ifdef CONFIG_DEVKMEM
 static const struct file_operations kmem_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_kmem,
@@ -770,6 +775,7 @@ static const struct file_operations kmem
 	.open		= open_kmem,
 	.get_unmapped_area = get_unmapped_area_mem,
 };
+#endif
 
 static const struct file_operations null_fops = {
 	.llseek		= null_lseek,
@@ -848,11 +854,13 @@ static int memory_open(struct inode * in
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
@@ -901,7 +909,9 @@ static const struct {
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
git-agpgart.patch
hci_ldisc-fix-null-pointer-deref.patch
git-sched.patch
git-x86.patch
make-dev-kmem-a-config-option.patch
make-dev-kmem-a-config-option-fix.patch
proc-print-more-information-when-removing-non-empty-directories.patch

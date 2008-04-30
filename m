From: akpm@linux-foundation.org
Subject: - drivers-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:33 -0700
Message-ID: <200804300547.m3U5lXsF029715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758647AbYD3FsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, dtor@mail.ru, ebiederm@xmission.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     drivers-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/i8k.c     |    6 ++----
 drivers/char/misc.c    |   27 +++++++++++++++------------
 drivers/char/rtc.c     |    6 ++----
 drivers/char/toshiba.c |    3 +--
 drivers/char/viotape.c |    9 +++------
 5 files changed, 23 insertions(+), 28 deletions(-)

diff -puN drivers/char/i8k.c~drivers-use-non-racy-method-for-proc-entries-creation drivers/char/i8k.c
--- a/drivers/char/i8k.c~drivers-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/char/i8k.c
@@ -82,6 +82,7 @@ static int i8k_ioctl(struct inode *, str
 		     unsigned long);
 
 static const struct file_operations i8k_fops = {
+	.owner		= THIS_MODULE,
 	.open		= i8k_open_fs,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -554,13 +555,10 @@ static int __init i8k_init(void)
 		return -ENODEV;
 
 	/* Register the proc entry */
-	proc_i8k = create_proc_entry("i8k", 0, NULL);
+	proc_i8k = proc_create("i8k", 0, NULL, &i8k_fops);
 	if (!proc_i8k)
 		return -ENOENT;
 
-	proc_i8k->proc_fops = &i8k_fops;
-	proc_i8k->owner = THIS_MODULE;
-
 	printk(KERN_INFO
 	       "Dell laptop SMM driver v%s Massimo Dal Zotto (dz@debian.org)\n",
 	       I8K_VERSION);
diff -puN drivers/char/misc.c~drivers-use-non-racy-method-for-proc-entries-creation drivers/char/misc.c
--- a/drivers/char/misc.c~drivers-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/char/misc.c
@@ -263,23 +263,26 @@ EXPORT_SYMBOL(misc_deregister);
 
 static int __init misc_init(void)
 {
-#ifdef CONFIG_PROC_FS
-	struct proc_dir_entry *ent;
+	int err;
 
-	ent = create_proc_entry("misc", 0, NULL);
-	if (ent)
-		ent->proc_fops = &misc_proc_fops;
+#ifdef CONFIG_PROC_FS
+	proc_create("misc", 0, NULL, &misc_proc_fops);
 #endif
 	misc_class = class_create(THIS_MODULE, "misc");
+	err = PTR_ERR(misc_class);
 	if (IS_ERR(misc_class))
-		return PTR_ERR(misc_class);
+		goto fail_remove;
 
-	if (register_chrdev(MISC_MAJOR,"misc",&misc_fops)) {
-		printk("unable to get major %d for misc devices\n",
-		       MISC_MAJOR);
-		class_destroy(misc_class);
-		return -EIO;
-	}
+	err = -EIO;
+	if (register_chrdev(MISC_MAJOR,"misc",&misc_fops))
+		goto fail_printk;
 	return 0;
+
+fail_printk:
+	printk("unable to get major %d for misc devices\n", MISC_MAJOR);
+	class_destroy(misc_class);
+fail_remove:
+	remove_proc_entry("misc", NULL);
+	return err;
 }
 subsys_initcall(misc_init);
diff -puN drivers/char/rtc.c~drivers-use-non-racy-method-for-proc-entries-creation drivers/char/rtc.c
--- a/drivers/char/rtc.c~drivers-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/char/rtc.c
@@ -1069,10 +1069,8 @@ no_irq:
 	}
 
 #ifdef CONFIG_PROC_FS
-	ent = create_proc_entry("driver/rtc", 0, NULL);
-	if (ent)
-		ent->proc_fops = &rtc_proc_fops;
-	else
+	ent = proc_create("driver/rtc", 0, NULL, &rtc_proc_fops);
+	if (!ent)
 		printk(KERN_WARNING "rtc: Failed to register with procfs.\n");
 #endif
 
diff -puN drivers/char/toshiba.c~drivers-use-non-racy-method-for-proc-entries-creation drivers/char/toshiba.c
--- a/drivers/char/toshiba.c~drivers-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/char/toshiba.c
@@ -520,12 +520,11 @@ static int __init toshiba_init(void)
 	{
 		struct proc_dir_entry *pde;
 
-		pde = create_proc_entry("toshiba", 0, NULL);
+		pde = proc_create("toshiba", 0, NULL, &proc_toshiba_fops);
 		if (!pde) {
 			misc_deregister(&tosh_device);
 			return -ENOMEM;
 		}
-		pde->proc_fops = &proc_toshiba_fops;
 	}
 #endif
 
diff -puN drivers/char/viotape.c~drivers-use-non-racy-method-for-proc-entries-creation drivers/char/viotape.c
--- a/drivers/char/viotape.c~drivers-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/char/viotape.c
@@ -249,6 +249,7 @@ static int proc_viotape_open(struct inod
 }
 
 static const struct file_operations proc_viotape_operations = {
+	.owner		= THIS_MODULE,
 	.open		= proc_viotape_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -915,7 +916,6 @@ static struct vio_driver viotape_driver 
 int __init viotap_init(void)
 {
 	int ret;
-	struct proc_dir_entry *e;
 
 	if (!firmware_has_feature(FW_FEATURE_ISERIES))
 		return -ENODEV;
@@ -968,11 +968,8 @@ int __init viotap_init(void)
 	if (ret)
 		goto unreg_class;
 
-	e = create_proc_entry("iSeries/viotape", S_IFREG|S_IRUGO, NULL);
-	if (e) {
-		e->owner = THIS_MODULE;
-		e->proc_fops = &proc_viotape_operations;
-	}
+	proc_create("iSeries/viotape", S_IFREG|S_IRUGO, NULL,
+		    &proc_viotape_operations);
 
 	return 0;
 
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree.patch
net-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv6-assign-pde-data-before-gluing-pde-into-proc-tree.patch
atm-assign-pde-data-before-gluing-pde-into-proc-tree.patch
vlan-assign-pde-data-before-gluing-pde-into-proc-tree.patch
cciss-assign-pde-data-before-gluing-pde-into-proc-tree.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv4-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2.patch
netns-assign-pde-data-before-gluing-entry-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch


From: akpm@linux-foundation.org
Subject: - proc-remove-proc_root_driver.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:59 -0700
Message-ID: <200804300545.m3U5jxSE029561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756905AbYD3Fqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: remove proc_root_driver
has been removed from the -mm tree.  Its filename was
     proc-remove-proc_root_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: remove proc_root_driver
From: Alexey Dobriyan <adobriyan@gmail.com>

Use creation by full path: "driver/foo".

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c       |    4 ++--
 drivers/block/cpqarray.c    |    4 ++--
 drivers/block/pktcdvd.c     |    4 ++--
 drivers/net/wireless/airo.c |    8 ++++----
 fs/proc/root.c              |    5 +----
 include/linux/proc_fs.h     |    3 ---
 6 files changed, 11 insertions(+), 17 deletions(-)

diff -puN drivers/block/cciss.c~proc-remove-proc_root_driver drivers/block/cciss.c
--- a/drivers/block/cciss.c~proc-remove-proc_root_driver
+++ a/drivers/block/cciss.c
@@ -425,7 +425,7 @@ static void __devinit cciss_procinit(int
 	struct proc_dir_entry *pde;
 
 	if (proc_cciss == NULL)
-		proc_cciss = proc_mkdir("cciss", proc_root_driver);
+		proc_cciss = proc_mkdir("driver/cciss", NULL);
 	if (!proc_cciss)
 		return;
 	pde = proc_create(hba[i]->devname, S_IWUSR | S_IRUSR | S_IRGRP |
@@ -3700,7 +3700,7 @@ static void __exit cciss_cleanup(void)
 			cciss_remove_one(hba[i]->pdev);
 		}
 	}
-	remove_proc_entry("cciss", proc_root_driver);
+	remove_proc_entry("driver/cciss", NULL);
 }
 
 static void fail_all_cmds(unsigned long ctlr)
diff -puN drivers/block/cpqarray.c~proc-remove-proc_root_driver drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~proc-remove-proc_root_driver
+++ a/drivers/block/cpqarray.c
@@ -214,7 +214,7 @@ static struct proc_dir_entry *proc_array
 static void __init ida_procinit(int i)
 {
 	if (proc_array == NULL) {
-		proc_array = proc_mkdir("cpqarray", proc_root_driver);
+		proc_array = proc_mkdir("driver/cpqarray", NULL);
 		if (!proc_array) return;
 	}
 
@@ -1796,7 +1796,7 @@ static void __exit cpqarray_exit(void)
 		}
 	}
 
-	remove_proc_entry("cpqarray", proc_root_driver);
+	remove_proc_entry("driver/cpqarray", NULL);
 }
 
 module_init(cpqarray_init)
diff -puN drivers/block/pktcdvd.c~proc-remove-proc_root_driver drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~proc-remove-proc_root_driver
+++ a/drivers/block/pktcdvd.c
@@ -3101,7 +3101,7 @@ static int __init pkt_init(void)
 		goto out_misc;
 	}
 
-	pkt_proc = proc_mkdir(DRIVER_NAME, proc_root_driver);
+	pkt_proc = proc_mkdir("driver/"DRIVER_NAME, NULL);
 
 	return 0;
 
@@ -3117,7 +3117,7 @@ out2:
 
 static void __exit pkt_exit(void)
 {
-	remove_proc_entry(DRIVER_NAME, proc_root_driver);
+	remove_proc_entry("driver/"DRIVER_NAME, NULL);
 	misc_deregister(&pkt_misc);
 
 	pkt_debugfs_cleanup();
diff -puN drivers/net/wireless/airo.c~proc-remove-proc_root_driver drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~proc-remove-proc_root_driver
+++ a/drivers/net/wireless/airo.c
@@ -5625,9 +5625,9 @@ static int __init airo_init_module( void
 	int have_isa_dev = 0;
 #endif
 
-	airo_entry = create_proc_entry("aironet",
+	airo_entry = create_proc_entry("driver/aironet",
 				       S_IFDIR | airo_perm,
-				       proc_root_driver);
+				       NULL);
 
 	if (airo_entry) {
 		airo_entry->uid = proc_uid;
@@ -5651,7 +5651,7 @@ static int __init airo_init_module( void
 	airo_print_info("", "Finished probing for PCI adapters");
 
 	if (i) {
-		remove_proc_entry("aironet", proc_root_driver);
+		remove_proc_entry("driver/aironet", NULL);
 		return i;
 	}
 #endif
@@ -5673,7 +5673,7 @@ static void __exit airo_cleanup_module( 
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&airo_driver);
 #endif
-	remove_proc_entry("aironet", proc_root_driver);
+	remove_proc_entry("driver/aironet", NULL);
 }
 
 /*
diff -puN fs/proc/root.c~proc-remove-proc_root_driver fs/proc/root.c
--- a/fs/proc/root.c~proc-remove-proc_root_driver
+++ a/fs/proc/root.c
@@ -22,8 +22,6 @@
 
 #include "internal.h"
 
-struct proc_dir_entry *proc_root_driver;
-
 static int proc_test_super(struct super_block *sb, void *data)
 {
 	return sb->s_fs_info == data;
@@ -127,7 +125,7 @@ void __init proc_root_init(void)
 	proc_mkdir("sysvipc", NULL);
 #endif
 	proc_mkdir("fs", NULL);
-	proc_root_driver = proc_mkdir("driver", NULL);
+	proc_mkdir("driver", NULL);
 	proc_mkdir("fs/nfsd", NULL); /* somewhere for the nfsd filesystem to be mounted */
 #if defined(CONFIG_SUN_OPENPROMFS) || defined(CONFIG_SUN_OPENPROMFS_MODULE)
 	/* just give it a mountpoint */
@@ -235,4 +233,3 @@ EXPORT_SYMBOL(create_proc_entry);
 EXPORT_SYMBOL(proc_create);
 EXPORT_SYMBOL(remove_proc_entry);
 EXPORT_SYMBOL(proc_root);
-EXPORT_SYMBOL(proc_root_driver);
diff -puN include/linux/proc_fs.h~proc-remove-proc_root_driver include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-remove-proc_root_driver
+++ a/include/linux/proc_fs.h
@@ -97,7 +97,6 @@ struct vmcore {
 #ifdef CONFIG_PROC_FS
 
 extern struct proc_dir_entry proc_root;
-extern struct proc_dir_entry *proc_root_driver;
 extern struct proc_dir_entry *proc_root_kcore;
 
 extern spinlock_t proc_subdir_lock;
@@ -211,8 +210,6 @@ extern void dup_mm_exe_file(struct mm_st
 
 #else
 
-#define proc_root_driver NULL

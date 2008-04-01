From: akpm@linux-foundation.org
Subject: + proc-remove-proc_root_fs.patch added to -mm tree
Date: Tue, 01 Apr 2008 13:13:10 -0700
Message-ID: <200804012013.m31KDA7J011126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756897AbYDAUNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 16:13:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     proc: remove proc_root_fs
has been added to the -mm tree.  Its filename is
     proc-remove-proc_root_fs.patch

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
Subject: proc: remove proc_root_fs
From: Alexey Dobriyan <adobriyan@gmail.com>

Use creation by full path instead: "fs/foo".

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifs_debug.c    |    4 ++--
 fs/ext4/mballoc.c       |    7 +++----
 fs/jfs/jfs_debug.c      |    4 ++--
 fs/nfs/client.c         |    6 +++---
 fs/proc/root.c          |    5 ++---
 include/linux/proc_fs.h |    1 -
 6 files changed, 12 insertions(+), 15 deletions(-)

diff -puN fs/cifs/cifs_debug.c~proc-remove-proc_root_fs fs/cifs/cifs_debug.c
--- a/fs/cifs/cifs_debug.c~proc-remove-proc_root_fs
+++ a/fs/cifs/cifs_debug.c
@@ -468,7 +468,7 @@ cifs_proc_init(void)
 {
 	struct proc_dir_entry *pde;
 
-	proc_fs_cifs = proc_mkdir("cifs", proc_root_fs);
+	proc_fs_cifs = proc_mkdir("fs/cifs", NULL);
 	if (proc_fs_cifs == NULL)
 		return;
 
@@ -559,7 +559,7 @@ cifs_proc_clean(void)
 	remove_proc_entry("LinuxExtensionsEnabled", proc_fs_cifs);
 	remove_proc_entry("Experimental", proc_fs_cifs);
 	remove_proc_entry("LookupCacheEnabled", proc_fs_cifs);
-	remove_proc_entry("cifs", proc_root_fs);
+	remove_proc_entry("fs/cifs", NULL);
 }
 
 static int
diff -puN fs/ext4/mballoc.c~proc-remove-proc_root_fs fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~proc-remove-proc_root_fs
+++ a/fs/ext4/mballoc.c
@@ -2873,7 +2873,6 @@ static noinline void ext4_mb_free_commit
 	mb_debug("freed %u blocks in %u structures\n", count, count2);
 }
 
-#define EXT4_ROOT			"ext4"
 #define EXT4_MB_STATS_NAME		"stats"
 #define EXT4_MB_MAX_TO_SCAN_NAME	"max_to_scan"
 #define EXT4_MB_MIN_TO_SCAN_NAME	"min_to_scan"
@@ -3013,9 +3012,9 @@ int __init init_ext4_mballoc(void)
 		return -ENOMEM;
 	}
 #ifdef CONFIG_PROC_FS
-	proc_root_ext4 = proc_mkdir(EXT4_ROOT, proc_root_fs);
+	proc_root_ext4 = proc_mkdir("fs/ext4", NULL);
 	if (proc_root_ext4 == NULL)
-		printk(KERN_ERR "EXT4-fs: Unable to create %s\n", EXT4_ROOT);
+		printk(KERN_ERR "EXT4-fs: Unable to create fs/ext4\n");
 #endif
 	return 0;
 }
@@ -3026,7 +3025,7 @@ void exit_ext4_mballoc(void)
 	kmem_cache_destroy(ext4_pspace_cachep);
 	kmem_cache_destroy(ext4_ac_cachep);
 #ifdef CONFIG_PROC_FS
-	remove_proc_entry(EXT4_ROOT, proc_root_fs);
+	remove_proc_entry("fs/ext4", NULL);
 #endif
 }
 
diff -puN fs/jfs/jfs_debug.c~proc-remove-proc_root_fs fs/jfs/jfs_debug.c
--- a/fs/jfs/jfs_debug.c~proc-remove-proc_root_fs
+++ a/fs/jfs/jfs_debug.c
@@ -89,7 +89,7 @@ void jfs_proc_init(void)
 {
 	int i;
 
-	if (!(base = proc_mkdir("jfs", proc_root_fs)))
+	if (!(base = proc_mkdir("fs/jfs", NULL)))
 		return;
 	base->owner = THIS_MODULE;
 
@@ -109,7 +109,7 @@ void jfs_proc_clean(void)
 	if (base) {
 		for (i = 0; i < NPROCENT; i++)
 			remove_proc_entry(Entries[i].name, base);
-		remove_proc_entry("jfs", proc_root_fs);
+		remove_proc_entry("fs/jfs", NULL);
 	}
 }
 
diff -puN fs/nfs/client.c~proc-remove-proc_root_fs fs/nfs/client.c
--- a/fs/nfs/client.c~proc-remove-proc_root_fs
+++ a/fs/nfs/client.c
@@ -1493,7 +1493,7 @@ int __init nfs_fs_proc_init(void)
 {
 	struct proc_dir_entry *p;
 
-	proc_fs_nfs = proc_mkdir("nfsfs", proc_root_fs);
+	proc_fs_nfs = proc_mkdir("fs/nfsfs", NULL);
 	if (!proc_fs_nfs)
 		goto error_0;
 
@@ -1519,7 +1519,7 @@ int __init nfs_fs_proc_init(void)
 error_2:
 	remove_proc_entry("servers", proc_fs_nfs);
 error_1:
-	remove_proc_entry("nfsfs", proc_root_fs);
+	remove_proc_entry("fs/nfsfs", NULL);
 error_0:
 	return -ENOMEM;
 }
@@ -1531,7 +1531,7 @@ void nfs_fs_proc_exit(void)
 {
 	remove_proc_entry("volumes", proc_fs_nfs);
 	remove_proc_entry("servers", proc_fs_nfs);
-	remove_proc_entry("nfsfs", proc_root_fs);
+	remove_proc_entry("fs/nfsfs", NULL);
 }
 
 #endif /* CONFIG_PROC_FS */
diff -puN fs/proc/root.c~proc-remove-proc_root_fs fs/proc/root.c
--- a/fs/proc/root.c~proc-remove-proc_root_fs
+++ a/fs/proc/root.c
@@ -22,7 +22,7 @@
 
 #include "internal.h"
 
-struct proc_dir_entry *proc_root_fs, *proc_root_driver;
+struct proc_dir_entry *proc_root_driver;
 
 static int proc_test_super(struct super_block *sb, void *data)
 {
@@ -126,7 +126,7 @@ void __init proc_root_init(void)
 #ifdef CONFIG_SYSVIPC
 	proc_mkdir("sysvipc", NULL);
 #endif
-	proc_root_fs = proc_mkdir("fs", NULL);
+	proc_mkdir("fs", NULL);
 	proc_root_driver = proc_mkdir("driver", NULL);
 	proc_mkdir("fs/nfsd", NULL); /* somewhere for the nfsd filesystem to be mounted */
 #if defined(CONFIG_SUN_OPENPROMFS) || defined(CONFIG_SUN_OPENPROMFS_MODULE)
@@ -235,5 +235,4 @@ EXPORT_SYMBOL(create_proc_entry);
 EXPORT_SYMBOL(proc_create);
 EXPORT_SYMBOL(remove_proc_entry);
 EXPORT_SYMBOL(proc_root);
-EXPORT_SYMBOL(proc_root_fs);
 EXPORT_SYMBOL(proc_root_driver);
diff -puN include/linux/proc_fs.h~proc-remove-proc_root_fs include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-remove-proc_root_fs
+++ a/include/linux/proc_fs.h
@@ -97,7 +97,6 @@ struct vmcore {
 #ifdef CONFIG_PROC_FS
 
 extern struct proc_dir_entry proc_root;
-extern struct proc_dir_entry *proc_root_fs;
 extern struct proc_dir_entry *proc_root_driver;
 extern struct proc_dir_entry *proc_root_kcore;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

tags-add-menuconfig-symbols-as-well.patch
remove-the-macro-get_personality.patch
nv-drop-useless-module-ifdefs.patch
nv-drop-useless-config_pci-checks.patch
nv-fix-sparse-noise.patch
procfs-mem-permission-cleanup.patch
proc-simplify-locking-in-remove_proc_entry.patch
proc-less-special-case-in-xlate-code.patch
proc-drop-several-pde-valid-invalid-checks.patch
proc-remove-proc_bus.patch
proc-remove-proc_root_fs.patch
proc-remove-proc_root_driver.patch
proc-remove-proc_root-from-drivers.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch


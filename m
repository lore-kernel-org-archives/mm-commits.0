From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-error-handling.patch added to -mm tree
Date: Thu, 27 Sep 2007 16:52:12 -0700
Message-ID: <200709272352.l8RNqCUn001601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756234AbXI0XwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 19:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     ecryptfs: fix error handling
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-error-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs: fix error handling
From: Michael Halcrow <mhalcrow@us.ibm.com>

The error paths and the module exit code need work. sysfs
unregistration is not the right place to tear down the crypto
subsystem, and the code to undo subsystem initializations on various
error paths is unnecessarily duplicated. This patch addresses those
issues.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/ecryptfs/main.c~ecryptfs-fix-error-handling fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-fix-error-handling
+++ a/fs/ecryptfs/main.c
@@ -798,13 +798,6 @@ out:
 
 static void do_sysfs_unregistration(void)
 {
-	int rc;
-
-	rc = ecryptfs_destroy_crypto();
-	if (rc) {
-		printk(KERN_ERR "Failure whilst attempting to destroy crypto; "
-		       "rc = [%d]\n", rc);
-	}
 	sysfs_remove_file(&ecryptfs_subsys.kobj,
 			  &sysfs_attr_version.attr);
 	sysfs_remove_file(&ecryptfs_subsys.kobj,
@@ -835,43 +828,49 @@ static int __init ecryptfs_init(void)
 	rc = register_filesystem(&ecryptfs_fs_type);
 	if (rc) {
 		printk(KERN_ERR "Failed to register filesystem\n");
-		ecryptfs_free_kmem_caches();
-		goto out;
+		goto out_free_kmem_caches;
 	}
 	kobj_set_kset_s(&ecryptfs_subsys, fs_subsys);
 	rc = do_sysfs_registration();
 	if (rc) {
 		printk(KERN_ERR "sysfs registration failed\n");
-		unregister_filesystem(&ecryptfs_fs_type);
-		ecryptfs_free_kmem_caches();
-		goto out;
+		goto out_unregister_filesystem;
 	}
 	rc = ecryptfs_init_messaging(ecryptfs_transport);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Failure occured while attempting to "
 				"initialize the eCryptfs netlink socket\n");
-		do_sysfs_unregistration();
-		unregister_filesystem(&ecryptfs_fs_type);
-		ecryptfs_free_kmem_caches();
-		goto out;
+		goto out_do_sysfs_unregistration;
 	}
 	rc = ecryptfs_init_crypto();
 	if (rc) {
 		printk(KERN_ERR "Failure whilst attempting to init crypto; "
 		       "rc = [%d]\n", rc);
-		do_sysfs_unregistration();
-		unregister_filesystem(&ecryptfs_fs_type);
-		ecryptfs_free_kmem_caches();
-		goto out;
+		goto out_release_messaging;
 	}
+	goto out;
+out_release_messaging:
+	ecryptfs_release_messaging(ecryptfs_transport);
+out_do_sysfs_unregistration:
+	do_sysfs_unregistration();
+out_unregister_filesystem:
+	unregister_filesystem(&ecryptfs_fs_type);
+out_free_kmem_caches:
+	ecryptfs_free_kmem_caches();
 out:
 	return rc;
 }
 
 static void __exit ecryptfs_exit(void)
 {
-	do_sysfs_unregistration();
+	int rc;
+
+	rc = ecryptfs_destroy_crypto();
+	if (rc)
+		printk(KERN_ERR "Failure whilst attempting to destroy crypto; "
+		       "rc = [%d]\n", rc);
 	ecryptfs_release_messaging(ecryptfs_transport);
+	do_sysfs_unregistration();
 	unregister_filesystem(&ecryptfs_fs_type);
 	ecryptfs_free_kmem_caches();
 }
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
ecryptfs-add-key-list-structure-search-keyring.patch
ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch
ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
ecryptfs-fix-tag-1-parsing-code.patch
ecryptfs-fix-tag-3-parsing-code.patch
ecryptfs-fix-tag-11-parsing-code.patch
ecryptfs-fix-tag-11-writing-code.patch
ecryptfs-update-comment-and-debug-statement.patch
ecryptfs-printk-warning-fixes.patch
ecryptfs-remove-unnecessary-bug_on.patch
ecryptfs-collapse-flag-set-into-one-statement.patch
ecryptfs-grammatical-fix-destruct-to-destroy.patch
ecryptfs-comments-for-some-structs.patch
ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec.patch
ecryptfs-remove-unnecessary-variable-initializations.patch
ecryptfs-make-needlessly-global-symbols-static.patch
ecryptfs-use-generic_file_splice_read.patch
ecryptfs-remove-header_extent_size.patch
ecryptfs-remove-header_extent_size-fix.patch
ecryptfs-remove-assignments-in-if-statements.patch
ecryptfs-fix-error-handling.patch
ecryptfs-read_writec-routines.patch
ecryptfs-replace-encrypt-decrypt-and-inode-size-write.patch
ecryptfs-set-up-and-destroy-persistent-lower-file.patch
ecryptfs-update-metadata-read-write-functions.patch
ecryptfs-update-metadata-read-write-functions-cleanup.patch
ecryptfs-make-open-truncate-and-setattr-use-persistent-file.patch
ecryptfs-convert-mmap-functions-to-use-persistent-file.patch
ecryptfs-convert-mmap-functions-to-use-persistent-file-fix.patch
ecryptfs-fix-data-types.patch
ecryptfs-initialize-persistent-lower-file-on-inode-create.patch
ecryptfs-remove-unused-functions-and-kmem_cache.patch
ecryptfs-replace-magic-numbers.patch
ecryptfs-clean-up-page-flag-handling.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch

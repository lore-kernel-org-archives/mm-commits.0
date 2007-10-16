From: akpm@linux-foundation.org
Subject: - ecryptfs-fix-error-handling.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:48 -0700
Message-ID: <200710162040.l9GKemLH015723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58640 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965131AbXJPVDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: fix error handling
has been removed from the -mm tree.  Its filename was
     ecryptfs-fix-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 fs/ecryptfs/main.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff -puN fs/ecryptfs/main.c~ecryptfs-fix-error-handling fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-fix-error-handling
+++ a/fs/ecryptfs/main.c
@@ -799,13 +799,6 @@ out:
 
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
@@ -836,43 +829,49 @@ static int __init ecryptfs_init(void)
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

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch

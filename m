From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-error-handling-in-ecryptfs_init.patch added to -mm tree
Date: Thu, 02 Aug 2007 11:54:07 -0700
Message-ID: <200708021854.l72Is7W5004106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59523 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbXHBSyc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Aug 2007 14:54:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, mhalcrow@us.ibm.com


The patch titled
     eCryptfs: fix error handling in ecryptfs_init
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-error-handling-in-ecryptfs_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: fix error handling in ecryptfs_init
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

ecryptfs_init() exits without doing any cleanup jobs if
ecryptfs_init_messaging() fails.  In that case, eCryptfs leaves
sysfs entries, leaks memory, and causes an invalid page fault.
This patch fixes the problem.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/main.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/ecryptfs/main.c~ecryptfs-fix-error-handling-in-ecryptfs_init fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-fix-error-handling-in-ecryptfs_init
+++ a/fs/ecryptfs/main.c
@@ -813,6 +813,15 @@ out:
 	return rc;
 }
 
+static void do_sysfs_unregistration(void)
+{
+	sysfs_remove_file(&ecryptfs_subsys.kobj,
+			  &sysfs_attr_version.attr);
+	sysfs_remove_file(&ecryptfs_subsys.kobj,
+			  &sysfs_attr_version_str.attr);
+	subsystem_unregister(&ecryptfs_subsys);
+}
+
 static int __init ecryptfs_init(void)
 {
 	int rc;
@@ -851,6 +860,9 @@ static int __init ecryptfs_init(void)
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Failure occured while attempting to "
 				"initialize the eCryptfs netlink socket\n");
+		do_sysfs_unregistration();
+		unregister_filesystem(&ecryptfs_fs_type);
+		ecryptfs_free_kmem_caches();
 	}
 out:
 	return rc;
@@ -858,11 +870,7 @@ out:
 
 static void __exit ecryptfs_exit(void)
 {
-	sysfs_remove_file(&ecryptfs_subsys.kobj,
-			  &sysfs_attr_version.attr);
-	sysfs_remove_file(&ecryptfs_subsys.kobj,
-			  &sysfs_attr_version_str.attr);
-	subsystem_unregister(&ecryptfs_subsys);
+	do_sysfs_unregistration();
 	ecryptfs_release_messaging(ecryptfs_transport);
 	unregister_filesystem(&ecryptfs_fs_type);
 	ecryptfs_free_kmem_caches();
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch
ecryptfs-fix-lookup-error-for-special-files.patch
ecryptfs-fix-error-handling-in-ecryptfs_init.patch

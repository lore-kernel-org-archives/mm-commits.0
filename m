From: akpm@linux-foundation.org
Subject: + ecryptfs-protect-crypt_stat-flags-in-ecryptfs_open.patch added to -mm tree
Date: Sun, 27 Apr 2008 13:35:32 -0700
Message-ID: <200804272035.m3RKZWfl023615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007AbYD0Ul3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 16:41:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, viro@ZenIV.linux.org.uk


The patch titled
     eCryptfs: protect crypt_stat->flags in ecryptfs_open()
has been added to the -mm tree.  Its filename is
     ecryptfs-protect-crypt_stat-flags-in-ecryptfs_open.patch

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
Subject: eCryptfs: protect crypt_stat->flags in ecryptfs_open()
From: Michael Halcrow <mhalcrow@us.ibm.com>

Make sure crypt_stat->flags is protected with a lock in ecryptfs_open().

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ecryptfs/file.c~ecryptfs-protect-crypt_stat-flags-in-ecryptfs_open fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-protect-crypt_stat-flags-in-ecryptfs_open
+++ a/fs/ecryptfs/file.c
@@ -195,7 +195,9 @@ static int ecryptfs_open(struct inode *i
 		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
 		ecryptfs_printk(KERN_DEBUG, "This is a directory\n");
+		mutex_lock(&crypt_stat->cs_mutex);
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+		mutex_unlock(&crypt_stat->cs_mutex);
 		rc = 0;
 		goto out;
 	}
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

git-unionfs.patch
remove-ecryptfs_header_cache_0.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
ecryptfs-add-missing-lock-around-notify_change.patch
ecryptfs-introduce-device-handle-for-userspace-daemon-communications.patch
ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch
ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes.patch
ecryptfs-make-key-module-subsystem-respect-namespaces.patch
ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns.patch
ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns-fix.patch
ecryptfs-protect-crypt_stat-flags-in-ecryptfs_open.patch
remove-duplicated-unlikely-in-is_err.patch
notify_change-callers-must-hold-i_mutex.patch


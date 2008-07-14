From: akpm@linux-foundation.org
Subject: + ecryptfs-do-not-try-to-open-device-files-on-mknodpatch-build-error.patch added to -mm tree
Date: Sun, 13 Jul 2008 20:55:58 -0700
Message-ID: <200807140355.m6E3twka021062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442AbYGND4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 23:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     ecryptfs-do-not-try-to-open-device-files-on-mknod.patch build error
has been added to the -mm tree.  Its filename is
     ecryptfs-do-not-try-to-open-device-files-on-mknodpatch-build-error.patch

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
Subject: ecryptfs-do-not-try-to-open-device-files-on-mknod.patch build error
From: Valdis.Kletnieks@vt.edu

causes a build error:

  CC [M]  fs/ecryptfs/file.o
fs/ecryptfs/file.c: In function ecryptfs_open:
fs/ecryptfs/file.c:207: error: implicit declaration of function ecryptfs_initersistent_file

Here's what I did to work around it:

Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/ecryptfs_kernel.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-do-not-try-to-open-device-files-on-mknodpatch-build-error fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-do-not-try-to-open-device-files-on-mknodpatch-build-error
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -712,5 +712,6 @@ void ecryptfs_destroy_kthread(void);
 int ecryptfs_privileged_open(struct file **lower_file,
 			     struct dentry *lower_dentry,
 			     struct vfsmount *lower_mnt);
+int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

git-unionfs.patch
fsstack-fsstack_copy_inode_size-locking.patch
ecryptfs-privileged-kthread-for-lower-file-opens.patch
ecryptfs-discard-ecryptfsd-registration-messages-in-miscdev.patch
ecryptfs-propagate-key-errors-up-at-mount-time.patch
ecryptfs-string-copy-cleanup.patch
ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch
ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch
ecryptfs-do-not-try-to-open-device-files-on-mknod.patch
ecryptfs-do-not-try-to-open-device-files-on-mknodpatch-build-error.patch
tpm-use-correct-data-types-for-sizes-in-tpm_write-and-tpm_read.patch
notify_change-callers-must-hold-i_mutex.patch


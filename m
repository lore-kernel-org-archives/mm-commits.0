From: akpm@linux-foundation.org
Subject: + ecryptfs-redo-dgetmntget-on-dentry_open-failure.patch added to -mm tree
Date: Wed, 19 Dec 2007 15:27:34 -0800
Message-ID: <200712192327.lBJNRYci024739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243AbXLSXeV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Dec 2007 18:34:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, jmoyer@redhat.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: redo dget,mntget on dentry_open failure
has been added to the -mm tree.  Its filename is
     ecryptfs-redo-dgetmntget-on-dentry_open-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs: redo dget,mntget on dentry_open failure
From: Eric Sandeen <sandeen@redhat.com>

Thanks to Jeff Moyer for pointing this out.

If the RDWR dentry_open() in ecryptfs_init_persistent_file fails,
it will do a dput/mntput.  Need to re-take references if we
retry as RDONLY.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Mike Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/ecryptfs/main.c~ecryptfs-redo-dgetmntget-on-dentry_open-failure fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-redo-dgetmntget-on-dentry_open-failure
+++ a/fs/ecryptfs/main.c
@@ -138,11 +138,14 @@ int ecryptfs_init_persistent_file(struct
 		inode_info->lower_file = dentry_open(lower_dentry,
 						     lower_mnt,
 						     (O_RDWR | O_LARGEFILE));
-		if (IS_ERR(inode_info->lower_file))
+		if (IS_ERR(inode_info->lower_file)) {
+			dget(lower_dentry);
+			mntget(lower_mnt);
 			inode_info->lower_file = dentry_open(lower_dentry,
 							     lower_mnt,
 							     (O_RDONLY
 							      | O_LARGEFILE));
+		}
 		if (IS_ERR(inode_info->lower_file)) {
 			printk(KERN_ERR "Error opening lower persistent file "
 			       "for lower_dentry [0x%p] and lower_mnt [0x%p]\n",
_

Patches currently in -mm which might be from sandeen@redhat.com are

ecryptfs-initialize-new-auth_tokens-before-teardown.patch
ecryptfs-set-s_blocksize-from-lower-fs-in-sb.patch
ecryptfs-fix-fsx-data-corruption-problems.patch
ecryptfs-fix-string-overflow-on-long-cipher-names.patch
ecryptfs-fix-unlocking-in-error-paths.patch
ecryptfs-redo-dgetmntget-on-dentry_open-failure.patch
ext2-change-the-default-behaviour-on-error.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ext4-fix-mb_debug-format-warnings.patch
ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch
ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch
ext4-fix-up-ext4fs_debug-builds.patch
ext3-change-the-default-behaviour-on-error.patch

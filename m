From: akpm@linux-foundation.org
Subject: - ecryptfs-redo-dgetmntget-on-dentry_open-failure.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:12 -0800
Message-ID: <200801072138.m07LcqS8013508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757028AbYAGVjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:39:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, jmoyer@redhat.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: redo dget,mntget on dentry_open failure
has been removed from the -mm tree.  Its filename was
     ecryptfs-redo-dgetmntget-on-dentry_open-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

hfs-handle-more-on-disk-corruptions-without-oopsing.patch
hfs-handle-more-on-disk-corruptions-without-oopsing-fix.patch
git-kbuild.patch
ext2-change-the-default-behaviour-on-error.patch
export-iov_shorten-for-ext4s-use.patch
export-iov_shorten-for-ext4s-use-fix.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
ext3-change-the-default-behaviour-on-error.patch

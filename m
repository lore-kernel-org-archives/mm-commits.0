From: akpm@linux-foundation.org
Subject: - ecryptfs-set-s_blocksize-from-lower-fs-in-sb.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:36:30 -0800
Message-ID: <200712202336.lBKNaUvK018807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759152AbXLTXsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: set s_blocksize from lower fs in sb
has been removed from the -mm tree.  Its filename was
     ecryptfs-set-s_blocksize-from-lower-fs-in-sb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ecryptfs: set s_blocksize from lower fs in sb
From: Eric Sandeen <sandeen@redhat.com>

eCryptfs wasn't setting s_blocksize in it's superblock; just pick it up
from the lower FS.  Having an s_blocksize of 0 made things like "filefrag"
which call FIGETBSZ unhappy.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Mike Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/main.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ecryptfs/main.c~ecryptfs-set-s_blocksize-from-lower-fs-in-sb fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-set-s_blocksize-from-lower-fs-in-sb
+++ a/fs/ecryptfs/main.c
@@ -523,6 +523,7 @@ static int ecryptfs_read_super(struct su
 	lower_mnt = nd.mnt;
 	ecryptfs_set_superblock_lower(sb, lower_root->d_sb);
 	sb->s_maxbytes = lower_root->d_sb->s_maxbytes;
+	sb->s_blocksize = lower_root->d_sb->s_blocksize;
 	ecryptfs_set_dentry_lower(sb->s_root, lower_root);
 	ecryptfs_set_dentry_lower_mnt(sb->s_root, lower_mnt);
 	rc = ecryptfs_interpose(lower_root, sb->s_root, sb, 0);
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
ecryptfs-fix-string-overflow-on-long-cipher-names.patch
ecryptfs-fix-unlocking-in-error-paths.patch
ecryptfs-redo-dgetmntget-on-dentry_open-failure.patch
hfs-handle-more-on-disk-corruptions-without-oopsing.patch
ext2-change-the-default-behaviour-on-error.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ext3-change-the-default-behaviour-on-error.patch

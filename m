From: akpm@osdl.org
Subject: - reiser-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:26 -0800
Message-ID: <200612072307.kB7N7QWI030363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52779 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163944AbWLGXHb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: burman.yan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     reiser-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiser: replace kmalloc+memset with kzalloc
From: Yan Burman <burman.yan@gmail.com>

Replace kmalloc+memset with kzalloc

Signed-off-by: Yan Burman <burman.yan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiserfs/file.c  |    3 +--
 fs/reiserfs/inode.c |    7 ++-----
 fs/reiserfs/super.c |    3 +--
 3 files changed, 4 insertions(+), 9 deletions(-)

diff -puN fs/reiserfs/file.c~reiser-replace-kmallocmemset-with-kzalloc fs/reiserfs/file.c
--- a/fs/reiserfs/file.c~reiser-replace-kmallocmemset-with-kzalloc
+++ a/fs/reiserfs/file.c
@@ -317,12 +317,11 @@ static int reiserfs_allocate_blocks_for_
 			/* area filled with zeroes, to supply as list of zero blocknumbers
 			   We allocate it outside of loop just in case loop would spin for
 			   several iterations. */
-			char *zeros = kmalloc(to_paste * UNFM_P_SIZE, GFP_ATOMIC);	// We cannot insert more than MAX_ITEM_LEN bytes anyway.
+			char *zeros = kzalloc(to_paste * UNFM_P_SIZE, GFP_ATOMIC);	// We cannot insert more than MAX_ITEM_LEN bytes anyway.
 			if (!zeros) {
 				res = -ENOMEM;
 				goto error_exit_free_blocks;
 			}
-			memset(zeros, 0, to_paste * UNFM_P_SIZE);
 			do {
 				to_paste =
 				    min_t(__u64, hole_size,
diff -puN fs/reiserfs/inode.c~reiser-replace-kmallocmemset-with-kzalloc fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiser-replace-kmallocmemset-with-kzalloc
+++ a/fs/reiserfs/inode.c
@@ -929,15 +929,12 @@ int reiserfs_get_block(struct inode *ino
 			if (blocks_needed == 1) {
 				un = &unf_single;
 			} else {
-				un = kmalloc(min(blocks_needed, max_to_insert) * UNFM_P_SIZE, GFP_ATOMIC);	// We need to avoid scheduling.
+				un = kzalloc(min(blocks_needed, max_to_insert) * UNFM_P_SIZE, GFP_ATOMIC);	// We need to avoid scheduling.
 				if (!un) {
 					un = &unf_single;
 					blocks_needed = 1;
 					max_to_insert = 0;
-				} else
-					memset(un, 0,
-					       UNFM_P_SIZE * min(blocks_needed,
-								 max_to_insert));
+				}
 			}
 			if (blocks_needed <= max_to_insert) {
 				/* we are going to add target block to the file. Use allocated
diff -puN fs/reiserfs/super.c~reiser-replace-kmallocmemset-with-kzalloc fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiser-replace-kmallocmemset-with-kzalloc
+++ a/fs/reiserfs/super.c
@@ -1549,13 +1549,12 @@ static int reiserfs_fill_super(struct su
 	struct reiserfs_sb_info *sbi;
 	int errval = -EINVAL;
 
-	sbi = kmalloc(sizeof(struct reiserfs_sb_info), GFP_KERNEL);
+	sbi = kzalloc(sizeof(struct reiserfs_sb_info), GFP_KERNEL);
 	if (!sbi) {
 		errval = -ENOMEM;
 		goto error;
 	}
 	s->s_fs_info = sbi;
-	memset(sbi, 0, sizeof(struct reiserfs_sb_info));
 	/* Set default values for options: non-aggressive tails, RO on errors */
 	REISERFS_SB(s)->s_mount_opt |= (1 << REISERFS_SMALLTAIL);
 	REISERFS_SB(s)->s_mount_opt |= (1 << REISERFS_ERROR_RO);
_

Patches currently in -mm which might be from burman.yan@gmail.com are

origin.patch
ia64-replace-kmallocmemset-with-kzalloc.patch
jffs2-replace-kmallocmemset-with-kzalloc.patch
nfsd-replace-kmallocmemset-with-kcalloc.patch


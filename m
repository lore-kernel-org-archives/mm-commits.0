From: akpm@linux-foundation.org
Subject: + fs-reiserfs-bitmapc-coding-style-fixes.patch added to -mm tree
Date: Wed, 16 Apr 2014 15:13:45 -0700
Message-ID: <534f0099.mV9RbYur7kdyM7nC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPWNq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 18:13:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jeffm@suse.com, fabf@skynet.be

Subject: + fs-reiserfs-bitmapc-coding-style-fixes.patch added to -mm tree
To: fabf@skynet.be,jeffm@suse.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 15:13:45 -0700


The patch titled
     Subject: fs/reiserfs/bitmap.c: coding style fixes
has been added to the -mm tree.  Its filename is
     fs-reiserfs-bitmapc-coding-style-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-reiserfs-bitmapc-coding-style-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-reiserfs-bitmapc-coding-style-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/reiserfs/bitmap.c: coding style fixes

-Trivial code clean-up
-Fix endif }; (coccinelle warning)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/bitmap.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/reiserfs/bitmap.c~fs-reiserfs-bitmapc-coding-style-fixes fs/reiserfs/bitmap.c
--- a/fs/reiserfs/bitmap.c~fs-reiserfs-bitmapc-coding-style-fixes
+++ a/fs/reiserfs/bitmap.c
@@ -142,7 +142,6 @@ static int scan_bitmap_block(struct reis
 	int org = *beg;
 
 	BUG_ON(!th->t_trans_id);
-
 	RFALSE(bmap_n >= reiserfs_bmap_count(s), "Bitmap %u is out of "
 	       "range (0..%u)", bmap_n, reiserfs_bmap_count(s) - 1);
 	PROC_INFO_INC(s, scan_bitmap.bmap);
@@ -321,7 +320,6 @@ static int scan_bitmap(struct reiserfs_t
 	unsigned int off_max = s->s_blocksize << 3;
 
 	BUG_ON(!th->t_trans_id);
-
 	PROC_INFO_INC(s, scan_bitmap.call);
 	if (SB_FREE_BLOCKS(s) <= 0)
 		return 0;	// No point in looking for more free blocks
@@ -388,9 +386,7 @@ static void _reiserfs_free_block(struct
 	unsigned int nr, offset;
 
 	BUG_ON(!th->t_trans_id);
-
 	PROC_INFO_INC(s, free_block);
-
 	rs = SB_DISK_SUPER_BLOCK(s);
 	sbh = SB_BUFFER_WITH_SB(s);
 	apbi = SB_AP_BITMAP(s);
@@ -435,8 +431,8 @@ void reiserfs_free_block(struct reiserfs
 			 int for_unformatted)
 {
 	struct super_block *s = th->t_super;
-	BUG_ON(!th->t_trans_id);
 
+	BUG_ON(!th->t_trans_id);
 	RFALSE(!s, "vs-4061: trying to free block on nonexistent device");
 	if (!is_reusable(s, block, 1))
 		return;
@@ -471,6 +467,7 @@ static void __discard_prealloc(struct re
 	unsigned long save = ei->i_prealloc_block;
 	int dirty = 0;
 	struct inode *inode = &ei->vfs_inode;
+
 	BUG_ON(!th->t_trans_id);
 #ifdef CONFIG_REISERFS_CHECK
 	if (ei->i_prealloc_count < 0)
@@ -494,6 +491,7 @@ void reiserfs_discard_prealloc(struct re
 			       struct inode *inode)
 {
 	struct reiserfs_inode_info *ei = REISERFS_I(inode);
+
 	BUG_ON(!th->t_trans_id);
 	if (ei->i_prealloc_count)
 		__discard_prealloc(th, ei);
@@ -504,7 +502,6 @@ void reiserfs_discard_all_prealloc(struc
 	struct list_head *plist = &SB_JOURNAL(th->t_super)->j_prealloc_list;
 
 	BUG_ON(!th->t_trans_id);
-
 	while (!list_empty(plist)) {
 		struct reiserfs_inode_info *ei;
 		ei = list_entry(plist->next, struct reiserfs_inode_info,
@@ -562,7 +559,7 @@ int reiserfs_parse_alloc_options(struct
 		if (!strcmp(this_char, "displacing_new_packing_localities")) {
 			SET_OPTION(displacing_new_packing_localities);
 			continue;
-		};
+		}
 
 		if (!strcmp(this_char, "old_hashed_relocation")) {
 			SET_OPTION(old_hashed_relocation);
@@ -729,6 +726,7 @@ void show_alloc_options(struct seq_file
 static inline void new_hashed_relocation(reiserfs_blocknr_hint_t * hint)
 {
 	char *hash_in;
+
 	if (hint->formatted_node) {
 		hash_in = (char *)&hint->key.k_dir_id;
 	} else {
@@ -757,6 +755,7 @@ static void dirid_groups(reiserfs_blockn
 	__u32 dirid = 0;
 	int bm = 0;
 	struct super_block *sb = hint->th->t_super;
+
 	if (hint->inode)
 		dirid = le32_to_cpu(INODE_PKEY(hint->inode)->k_dir_id);
 	else if (hint->formatted_node)
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch


From: akpm@linux-foundation.org
Subject: - ext4-error-processing-and-coding-enhancement-for-mballoc.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:04:12 -0700
Message-ID: <200806232104.m5NL4Cmi016255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbYFWVKD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:10:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shen@cn.fujitsu.com, aneesh.kumar@linux.vnet.ibm.com, cmm@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ext4: error processing and coding enhancement for mballoc
has been removed from the -mm tree.  Its filename was
     ext4-error-processing-and-coding-enhancement-for-mballoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: error processing and coding enhancement for mballoc
From: Shen Feng <shen@cn.fujitsu.com>

*ext4_mb_seq_history_open: check if sbi->s_mb_history is NULL
*ext4_mb_history_init: replace kmalloc and memset with kzalloc
*ext4_mb_init_backend: remove memset since kzalloc is used
*ext4_mb_init: the return value of ext4_mb_init_backend is int,
 but i is unsigned, replace it with a new int variable.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/mballoc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/ext4/mballoc.c~ext4-error-processing-and-coding-enhancement-for-mballoc fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-error-processing-and-coding-enhancement-for-mballoc
+++ a/fs/ext4/mballoc.c
@@ -1969,6 +1969,8 @@ static int ext4_mb_seq_history_open(stru
 	int rc;
 	int size;
 
+	if (unlikely(sbi->s_mb_history == NULL))
+		return -ENOMEM;
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (s == NULL)
 		return -ENOMEM;
@@ -2171,9 +2173,7 @@ static void ext4_mb_history_init(struct 
 	sbi->s_mb_history_cur = 0;
 	spin_lock_init(&sbi->s_mb_history_lock);
 	i = sbi->s_mb_history_max * sizeof(struct ext4_mb_history);
-	sbi->s_mb_history = kmalloc(i, GFP_KERNEL);
-	if (likely(sbi->s_mb_history != NULL))
-		memset(sbi->s_mb_history, 0, i);
+	sbi->s_mb_history = kzalloc(i, GFP_KERNEL);
 	/* if we can't allocate history, then we simple won't use it */
 }
 
@@ -2287,7 +2287,6 @@ static int ext4_mb_init_backend(struct s
 			i++;
 			goto err_freebuddy;
 		}
-		memset(meta_group_info[j], 0, len);
 		set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
 			&(meta_group_info[j]->bb_state));
 
@@ -2342,6 +2341,7 @@ int ext4_mb_init(struct super_block *sb,
 	unsigned i;
 	unsigned offset;
 	unsigned max;
+	int ret;
 
 	if (!test_opt(sb, MBALLOC))
 		return 0;
@@ -2376,12 +2376,12 @@ int ext4_mb_init(struct super_block *sb,
 	} while (i <= sb->s_blocksize_bits + 1);
 
 	/* init file for buddy data */
-	i = ext4_mb_init_backend(sb);
-	if (i) {
+	ret = ext4_mb_init_backend(sb);
+	if (ret != 0) {
 		clear_opt(sbi->s_mount_opt, MBALLOC);
 		kfree(sbi->s_mb_offsets);
 		kfree(sbi->s_mb_maxs);
-		return i;
+		return ret;
 	}
 
 	spin_lock_init(&sbi->s_md_lock);
_

Patches currently in -mm which might be from shen@cn.fujitsu.com are

linux-next.patch
ext2-remove-double-definitions-of-xattr-macros.patch
ext3-improve-some-code-in-rb-tree-part-of-dirc.patch
ext3-remove-double-definitions-of-xattr-macros.patch
reiserfs-remove-double-definitions-of-xattr-macros.patch
ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created.patch
ext4-fix-error-processing-in-mb_free_blocks.patch


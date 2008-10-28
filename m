From: akpm@linux-foundation.org
Subject: + quota-convert-union-in-mem_dqinfo-to-a-pointer.patch added to -mm tree
Date: Mon, 27 Oct 2008 22:56:20 -0700
Message-ID: <200810280556.m9S5uKRV013521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbYJ1GAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 02:00:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     quota: convert union in mem_dqinfo to a pointer
has been added to the -mm tree.  Its filename is
     quota-convert-union-in-mem_dqinfo-to-a-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: convert union in mem_dqinfo to a pointer
From: Jan Kara <jack@suse.cz>

Coming quota support for OCFS2 is going to need quite a bit of additional
per-sb quota information.  Moreover having fs.h include all the types
needed for this structure would be a pain in the a**.  So remove the union
from mem_dqinfo and add a private pointer for filesystem's use.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota_v2.c            |   53 +++++++++++++++++++++++--------------
 include/linux/dqblk_v1.h |    4 --
 include/linux/dqblk_v2.h |    4 --
 include/linux/quota.h    |    5 ---
 4 files changed, 35 insertions(+), 31 deletions(-)

diff -puN fs/quota_v2.c~quota-convert-union-in-mem_dqinfo-to-a-pointer fs/quota_v2.c
--- a/fs/quota_v2.c~quota-convert-union-in-mem_dqinfo-to-a-pointer
+++ a/fs/quota_v2.c
@@ -71,6 +71,7 @@ static int v2_read_file_info(struct supe
 {
 	struct v2_disk_dqinfo dinfo;
 	struct mem_dqinfo *info = sb_dqinfo(sb, type);
+	struct qtree_mem_dqinfo *qinfo;
 	ssize_t size;
 
 	size = sb->s_op->quota_read(sb, type, (char *)&dinfo,
@@ -80,22 +81,29 @@ static int v2_read_file_info(struct supe
 			sb->s_id);
 		return -1;
 	}
+	info->dqi_priv = kmalloc(sizeof(struct qtree_mem_dqinfo), GFP_NOFS);
+	if (!info->dqi_priv) {
+		printk(KERN_WARNING "Not enough memory for quota information"
+				    "structure.\n");
+		return -1;
+	}
+	qinfo = info->dqi_priv;
 	/* limits are stored as unsigned 32-bit data */
 	info->dqi_maxblimit = 0xffffffff;
 	info->dqi_maxilimit = 0xffffffff;
 	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
 	info->dqi_igrace = le32_to_cpu(dinfo.dqi_igrace);
 	info->dqi_flags = le32_to_cpu(dinfo.dqi_flags);
-	info->u.v2_i.i.dqi_sb = sb;
-	info->u.v2_i.i.dqi_type = type;
-	info->u.v2_i.i.dqi_blocks = le32_to_cpu(dinfo.dqi_blocks);
-	info->u.v2_i.i.dqi_free_blk = le32_to_cpu(dinfo.dqi_free_blk);
-	info->u.v2_i.i.dqi_free_entry = le32_to_cpu(dinfo.dqi_free_entry);
-	info->u.v2_i.i.dqi_blocksize_bits = V2_DQBLKSIZE_BITS;
-	info->u.v2_i.i.dqi_usable_bs = 1 << V2_DQBLKSIZE_BITS;
-	info->u.v2_i.i.dqi_qtree_depth = qtree_depth(&info->u.v2_i.i);
-	info->u.v2_i.i.dqi_entry_size = sizeof(struct v2_disk_dqblk);
-	info->u.v2_i.i.dqi_ops = &v2_qtree_ops;
+	qinfo->dqi_sb = sb;
+	qinfo->dqi_type = type;
+	qinfo->dqi_blocks = le32_to_cpu(dinfo.dqi_blocks);
+	qinfo->dqi_free_blk = le32_to_cpu(dinfo.dqi_free_blk);
+	qinfo->dqi_free_entry = le32_to_cpu(dinfo.dqi_free_entry);
+	qinfo->dqi_blocksize_bits = V2_DQBLKSIZE_BITS;
+	qinfo->dqi_usable_bs = 1 << V2_DQBLKSIZE_BITS;
+	qinfo->dqi_qtree_depth = qtree_depth(qinfo);
+	qinfo->dqi_entry_size = sizeof(struct v2_disk_dqblk);
+	qinfo->dqi_ops = &v2_qtree_ops;
 	return 0;
 }
 
@@ -104,6 +112,7 @@ static int v2_write_file_info(struct sup
 {
 	struct v2_disk_dqinfo dinfo;
 	struct mem_dqinfo *info = sb_dqinfo(sb, type);
+	struct qtree_mem_dqinfo *qinfo = info->dqi_priv;
 	ssize_t size;
 
 	spin_lock(&dq_data_lock);
@@ -112,9 +121,9 @@ static int v2_write_file_info(struct sup
 	dinfo.dqi_igrace = cpu_to_le32(info->dqi_igrace);
 	dinfo.dqi_flags = cpu_to_le32(info->dqi_flags & DQF_MASK);
 	spin_unlock(&dq_data_lock);
-	dinfo.dqi_blocks = cpu_to_le32(info->u.v2_i.i.dqi_blocks);
-	dinfo.dqi_free_blk = cpu_to_le32(info->u.v2_i.i.dqi_free_blk);
-	dinfo.dqi_free_entry = cpu_to_le32(info->u.v2_i.i.dqi_free_entry);
+	dinfo.dqi_blocks = cpu_to_le32(qinfo->dqi_blocks);
+	dinfo.dqi_free_blk = cpu_to_le32(qinfo->dqi_free_blk);
+	dinfo.dqi_free_entry = cpu_to_le32(qinfo->dqi_free_entry);
 	size = sb->s_op->quota_write(sb, type, (char *)&dinfo,
 	       sizeof(struct v2_disk_dqinfo), V2_DQINFOOFF);
 	if (size != sizeof(struct v2_disk_dqinfo)) {
@@ -150,7 +159,7 @@ static void v2_mem2diskdqb(void *dp, str
 	struct v2_disk_dqblk *d = dp;
 	struct mem_dqblk *m = &dquot->dq_dqb;
 	struct qtree_mem_dqinfo *info =
-			&sb_dqinfo(dquot->dq_sb, dquot->dq_type)->u.v2_i.i;
+			sb_dqinfo(dquot->dq_sb, dquot->dq_type)->dqi_priv;
 
 	d->dqb_ihardlimit = cpu_to_le32(m->dqb_ihardlimit);
 	d->dqb_isoftlimit = cpu_to_le32(m->dqb_isoftlimit);
@@ -169,7 +178,7 @@ static int v2_is_id(void *dp, struct dqu
 {
 	struct v2_disk_dqblk *d = dp;
 	struct qtree_mem_dqinfo *info =
-			&sb_dqinfo(dquot->dq_sb, dquot->dq_type)->u.v2_i.i;
+			sb_dqinfo(dquot->dq_sb, dquot->dq_type)->dqi_priv;
 
 	if (qtree_entry_unused(info, dp))
 		return 0;
@@ -178,24 +187,30 @@ static int v2_is_id(void *dp, struct dqu
 
 static int v2_read_dquot(struct dquot *dquot)
 {
-	return qtree_read_dquot(&sb_dqinfo(dquot->dq_sb, dquot->dq_type)->u.v2_i.i, dquot);
+	return qtree_read_dquot(sb_dqinfo(dquot->dq_sb, dquot->dq_type)->dqi_priv, dquot);
 }
 
 static int v2_write_dquot(struct dquot *dquot)
 {
-	return qtree_write_dquot(&sb_dqinfo(dquot->dq_sb, dquot->dq_type)->u.v2_i.i, dquot);
+	return qtree_write_dquot(sb_dqinfo(dquot->dq_sb, dquot->dq_type)->dqi_priv, dquot);
 }
 
 static int v2_release_dquot(struct dquot *dquot)
 {
-	return qtree_release_dquot(&sb_dqinfo(dquot->dq_sb, dquot->dq_type)->u.v2_i.i, dquot);
+	return qtree_release_dquot(sb_dqinfo(dquot->dq_sb, dquot->dq_type)->dqi_priv, dquot);
+}
+
+static int v2_free_file_info(struct super_block *sb, int type)
+{
+	kfree(sb_dqinfo(sb, type)->dqi_priv);
+	return 0;
 }
 
 static struct quota_format_ops v2_format_ops = {
 	.check_quota_file	= v2_check_quota_file,
 	.read_file_info		= v2_read_file_info,
 	.write_file_info	= v2_write_file_info,
-	.free_file_info		= NULL,
+	.free_file_info		= v2_free_file_info,
 	.read_dqblk		= v2_read_dquot,
 	.commit_dqblk		= v2_write_dquot,
 	.release_dqblk		= v2_release_dquot,
diff -puN include/linux/dqblk_v1.h~quota-convert-union-in-mem_dqinfo-to-a-pointer include/linux/dqblk_v1.h
--- a/include/linux/dqblk_v1.h~quota-convert-union-in-mem_dqinfo-to-a-pointer
+++ a/include/linux/dqblk_v1.h
@@ -17,8 +17,4 @@
 #define V1_DEL_ALLOC 0
 #define V1_DEL_REWRITE 2
 
-/* Special information about quotafile */
-struct v1_mem_dqinfo {
-};
-
 #endif	/* _LINUX_DQBLK_V1_H */
diff -puN include/linux/dqblk_v2.h~quota-convert-union-in-mem_dqinfo-to-a-pointer include/linux/dqblk_v2.h
--- a/include/linux/dqblk_v2.h~quota-convert-union-in-mem_dqinfo-to-a-pointer
+++ a/include/linux/dqblk_v2.h
@@ -16,8 +16,4 @@
 #define V2_DEL_ALLOC QTREE_DEL_ALLOC
 #define V2_DEL_REWRITE QTREE_DEL_REWRITE
 
-struct v2_mem_dqinfo {
-	struct qtree_mem_dqinfo i;
-};
-
 #endif /* _LINUX_DQBLK_V2_H */
diff -puN include/linux/quota.h~quota-convert-union-in-mem_dqinfo-to-a-pointer include/linux/quota.h
--- a/include/linux/quota.h~quota-convert-union-in-mem_dqinfo-to-a-pointer
+++ a/include/linux/quota.h
@@ -208,10 +208,7 @@ struct mem_dqinfo {
 	unsigned int dqi_igrace;
 	qsize_t dqi_maxblimit;
 	qsize_t dqi_maxilimit;
-	union {
-		struct v1_mem_dqinfo v1_i;
-		struct v2_mem_dqinfo v2_i;
-	} u;
+	void *dqi_priv;
 };
 
 struct super_block;
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ext4-fix-a-bug-accessing-freed-memory-in-ext4_abort.patch
ext3-fix-a-bug-accessing-freed-memory-in-ext3_abort.patch
quota-add-callbacks-for-allocating-and-destroying-dquot-structures.patch
quota-increase-size-of-variables-for-limits-and-inode-usage.patch
quota-remove-bogus-optimization-in-check_idq-and-check_bdq.patch
quota-make-_suspended-just-a-flag.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits.patch
ext3-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
ext4-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
quota-remove-compatibility-function-sb_any_quota_enabled.patch
quota-introduce-dquot_quota_sys_file-flag.patch
quota-move-quotaio_vh-from-include-linux-to-fs.patch
quota-split-off-quota-tree-handling-into-a-separate-file.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format.patch


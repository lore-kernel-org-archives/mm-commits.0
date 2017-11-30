From: akpm@linux-foundation.org
Subject: [folded-merged] ocfs2-add-ocfs2_overwrite_io-function-v2.patch
 removed from -mm tree
Date: Thu, 30 Nov 2017 14:19:32 -0800
Message-ID: <5a2083f4.zl3JStiKacDnH8Ey%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdK3WTe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 17:19:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-add-ocfs2_overwrite_io-function-v2
has been removed from the -mm tree.  Its filename was
     ocfs2-add-ocfs2_overwrite_io-function-v2.patch

This patch was dropped because it was folded into ocfs2-add-ocfs2_overwrite_io-function.patch

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2-add-ocfs2_overwrite_io-function-v2

Link: http://lkml.kernel.org/r/1511944612-9629-3-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/extent_map.c |   38 ++++++--------------------------------
 fs/ocfs2/extent_map.h |    4 ++--
 2 files changed, 8 insertions(+), 34 deletions(-)

diff -puN fs/ocfs2/extent_map.c~ocfs2-add-ocfs2_overwrite_io-function-v2 fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~ocfs2-add-ocfs2_overwrite_io-function-v2
+++ a/fs/ocfs2/extent_map.c
@@ -833,34 +833,17 @@ out:
 }
 
 /* Is IO overwriting allocated blocks? */
-int ocfs2_overwrite_io(struct inode *inode, u64 map_start, u64 map_len,
-		       int wait)
+int ocfs2_overwrite_io(struct inode *inode, struct buffer_head *di_bh,
+		       u64 map_start, u64 map_len)
 {
 	int ret = 0, is_last;
 	u32 mapping_end, cpos;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct buffer_head *di_bh = NULL;
 	struct ocfs2_extent_rec rec;
 
-	if (wait)
-		ret = ocfs2_inode_lock(inode, &di_bh, 0);
-	else
-		ret = ocfs2_try_inode_lock(inode, &di_bh, 0);
-	if (ret)
-		goto out;
-
-	if (wait)
-		down_read(&OCFS2_I(inode)->ip_alloc_sem);
-	else {
-		if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
-			ret = -EAGAIN;
-			goto out_unlock1;
-		}
-	}
-
 	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
 	   ((map_start + map_len) <= i_size_read(inode)))
-		goto out_unlock2;
+		goto out;
 
 	cpos = map_start >> osb->s_clustersize_bits;
 	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
@@ -871,7 +854,7 @@ int ocfs2_overwrite_io(struct inode *ino
 						 NULL, &rec, &is_last);
 		if (ret) {
 			mlog_errno(ret);
-			goto out_unlock2;
+			goto out;
 		}
 
 		if (rec.e_blkno == 0ULL)
@@ -885,18 +868,9 @@ int ocfs2_overwrite_io(struct inode *ino
 	}
 
 	if (cpos < mapping_end)
-		ret = 1;
-
-out_unlock2:
-	brelse(di_bh);
-
-	up_read(&OCFS2_I(inode)->ip_alloc_sem);
-
-out_unlock1:
-	ocfs2_inode_unlock(inode, 0);
-
+		ret = -EAGAIN;
 out:
-	return (ret ? 0 : 1);
+	return ret;
 }
 
 int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int whence)
diff -puN fs/ocfs2/extent_map.h~ocfs2-add-ocfs2_overwrite_io-function-v2 fs/ocfs2/extent_map.h
--- a/fs/ocfs2/extent_map.h~ocfs2-add-ocfs2_overwrite_io-function-v2
+++ a/fs/ocfs2/extent_map.h
@@ -53,8 +53,8 @@ int ocfs2_extent_map_get_blocks(struct i
 int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		 u64 map_start, u64 map_len);
 
-int ocfs2_overwrite_io(struct inode *inode, u64 map_start, u64 map_len,
-		       int wait);
+int ocfs2_overwrite_io(struct inode *inode, struct buffer_head *di_bh,
+		       u64 map_start, u64 map_len);
 
 int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int origin);
 
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
ocfs2-move-some-definitions-to-header-file.patch
ocfs2-fix-some-small-problems.patch
ocfs2-add-kobject-for-online-file-check.patch
ocfs2-add-duplicative-ino-number-check.patch
ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch
ocfs2-add-ocfs2_overwrite_io-function.patch
ocfs2-nowait-aio-support.patch
ocfs2-nowait-aio-support-v2.patch


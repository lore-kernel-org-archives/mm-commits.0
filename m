From: akpm@linux-foundation.org
Subject: + ocfs2-add-ocfs2_overwrite_io-function.patch added to -mm tree
Date: Mon, 27 Nov 2017 15:36:44 -0800
Message-ID: <5a1ca18c.Ckk9Mj0l0J/oljiB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46358 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752932AbdK0Xgq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 18:36:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: add ocfs2_overwrite_io()
has been added to the -mm tree.  Its filename is
     ocfs2-add-ocfs2_overwrite_io-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-ocfs2_overwrite_io-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-ocfs2_overwrite_io-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: add ocfs2_overwrite_io()

Add ocfs2_overwrite_io(), which is used to judge if overwrite allocated
blocks, otherwise, the write will bring extra block allocation overhead.

Link: http://lkml.kernel.org/r/1511775987-841-3-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/extent_map.c |   67 ++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/extent_map.h |    3 +
 2 files changed, 70 insertions(+)

diff -puN fs/ocfs2/extent_map.c~ocfs2-add-ocfs2_overwrite_io-function fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~ocfs2-add-ocfs2_overwrite_io-function
+++ a/fs/ocfs2/extent_map.c
@@ -832,6 +832,73 @@ out:
 	return ret;
 }
 
+/* Is IO overwriting allocated blocks? */
+int ocfs2_overwrite_io(struct inode *inode, u64 map_start, u64 map_len,
+		       int wait)
+{
+	int ret = 0, is_last;
+	u32 mapping_end, cpos;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_extent_rec rec;
+
+	if (wait)
+		ret = ocfs2_inode_lock(inode, &di_bh, 0);
+	else
+		ret = ocfs2_try_inode_lock(inode, &di_bh, 0);
+	if (ret)
+		goto out;
+
+	if (wait)
+		down_read(&OCFS2_I(inode)->ip_alloc_sem);
+	else {
+		if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
+			ret = -EAGAIN;
+			goto out_unlock1;
+		}
+	}
+
+	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
+	   ((map_start + map_len) <= i_size_read(inode)))
+		goto out_unlock2;
+
+	cpos = map_start >> osb->s_clustersize_bits;
+	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
+					       map_start + map_len);
+	is_last = 0;
+	while (cpos < mapping_end && !is_last) {
+		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos,
+						 NULL, &rec, &is_last);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_unlock2;
+		}
+
+		if (rec.e_blkno == 0ULL)
+			break;
+
+		if (rec.e_flags & OCFS2_EXT_REFCOUNTED)
+			break;
+
+		cpos = le32_to_cpu(rec.e_cpos) +
+			le16_to_cpu(rec.e_leaf_clusters);
+	}
+
+	if (cpos < mapping_end)
+		ret = 1;
+
+out_unlock2:
+	brelse(di_bh);
+
+	up_read(&OCFS2_I(inode)->ip_alloc_sem);
+
+out_unlock1:
+	ocfs2_inode_unlock(inode, 0);
+
+out:
+	return (ret ? 0 : 1);
+}
+
 int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int whence)
 {
 	struct inode *inode = file->f_mapping->host;
diff -puN fs/ocfs2/extent_map.h~ocfs2-add-ocfs2_overwrite_io-function fs/ocfs2/extent_map.h
--- a/fs/ocfs2/extent_map.h~ocfs2-add-ocfs2_overwrite_io-function
+++ a/fs/ocfs2/extent_map.h
@@ -53,6 +53,9 @@ int ocfs2_extent_map_get_blocks(struct i
 int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		 u64 map_start, u64 map_len);
 
+int ocfs2_overwrite_io(struct inode *inode, u64 map_start, u64 map_len,
+		       int wait);
+
 int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int origin);
 
 int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch
ocfs2-move-some-definitions-to-header-file.patch
ocfs2-fix-some-small-problems.patch
ocfs2-add-kobject-for-online-file-check.patch
ocfs2-add-duplicative-ino-number-check.patch
ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch
ocfs2-add-ocfs2_overwrite_io-function.patch
ocfs2-nowait-aio-support.patch


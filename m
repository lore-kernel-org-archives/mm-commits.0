From: akpm@linux-foundation.org
Subject: [patch 022/119] ocfs2: add ocfs2_overwrite_io()
Date: Wed, 31 Jan 2018 16:15:21 -0800
Message-ID: <20180201001521.pvDO2VzWe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33846 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbeBAAPX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:15:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.chen@huawei.com, ge.changwei@h3c.com, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org

From: Gang He <ghe@suse.com>
Subject: ocfs2: add ocfs2_overwrite_io()

Add ocfs2_overwrite_io function, which is used to judge if overwrite
allocated blocks, otherwise, the write will bring extra block allocation
overhead.

[ghe@suse.com: v3]
  Link: http://lkml.kernel.org/r/1514455665-16325-3-git-send-email-ghe@suse.com
[ghe@suse.com: v2]
  Link: http://lkml.kernel.org/r/1511944612-9629-3-git-send-email-ghe@suse.com
Link: http://lkml.kernel.org/r/1511775987-841-3-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/extent_map.c |   45 ++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/extent_map.h |    3 ++
 2 files changed, 48 insertions(+)

diff -puN fs/ocfs2/extent_map.c~ocfs2-add-ocfs2_overwrite_io-function fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~ocfs2-add-ocfs2_overwrite_io-function
+++ a/fs/ocfs2/extent_map.c
@@ -38,6 +38,7 @@
 #include "inode.h"
 #include "super.h"
 #include "symlink.h"
+#include "aops.h"
 #include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
@@ -832,6 +833,50 @@ out:
 	return ret;
 }
 
+/* Is IO overwriting allocated blocks? */
+int ocfs2_overwrite_io(struct inode *inode, struct buffer_head *di_bh,
+		       u64 map_start, u64 map_len)
+{
+	int ret = 0, is_last;
+	u32 mapping_end, cpos;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_extent_rec rec;
+
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		if (ocfs2_size_fits_inline_data(di_bh, map_start + map_len))
+			return ret;
+		else
+			return -EAGAIN;
+	}
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
+			goto out;
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
+		ret = -EAGAIN;
+out:
+	return ret;
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
 
+int ocfs2_overwrite_io(struct inode *inode, struct buffer_head *di_bh,
+		       u64 map_start, u64 map_len);
+
 int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int origin);
 
 int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
_

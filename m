From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing.patch removed from -mm tree
Date: Tue, 02 Jan 2018 14:09:46 -0800
Message-ID: <5a4c032a.L4snJg2eUpFlV9oX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48174 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750960AbeABWJs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jan 2018 17:09:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, alex.chen@huawei.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fall back to buffer IO when append dio is disabled with file hole existing
has been removed from the -mm tree.  Its filename was
     ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Changwei Ge <ge.changwei@h3c.com>
Subject: ocfs2: fall back to buffer IO when append dio is disabled with file hole existing

Before ocfs2 supporting allocating clusters while doing append-dio, all
append dio will fall back to buffer io to allocate clusters firstly. 
Also, when it steps on a file hole, it will fall back to buffer io, too. 
But for current code, writing to file hole will leverage dio to allocate
clusters.  This is not right, since whether append-io is enabled tells the
capability whether ocfs2 can allocate space while doing dio.

So introduce file hole check function back into ocfs2.  Once ocfs2 is
doing dio upon a file hole with append-dio disabled, it will fall back to
buffer IO to allocate clusters.

[akpm@linux-foundation.org: rename ocfs2_check_range_for_holes(), make it return bool]
Link: http://lkml.kernel.org/r/63ADC13FD55D6546B7DECE290D39E373F1F5C2CE@H3CMLB14-EX.srv.huawei-3com.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing
+++ a/fs/ocfs2/aops.c
@@ -2414,6 +2414,43 @@ static int ocfs2_dio_end_io(struct kiocb
 	return ret;
 }
 
+/*
+ * Will look for holes and unwritten extents in the range starting at
+ * pos for count bytes (inclusive).
+ */
+static bool ocfs2_range_has_holes(struct inode *inode, loff_t pos, size_t count)
+{
+	bool ret = false;
+	unsigned int extent_flags;
+	u32 cpos, clusters, extent_len, phys_cpos;
+	struct super_block *sb = inode->i_sb;
+
+	cpos = pos >> OCFS2_SB(sb)->s_clustersize_bits;
+	clusters = ocfs2_clusters_for_bytes(sb, pos + count) - cpos;
+
+	while (clusters) {
+		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &extent_len,
+					 &extent_flags);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (phys_cpos == 0 || (extent_flags & OCFS2_EXT_UNWRITTEN)) {
+			ret = true;
+			goto out;
+		}
+
+		if (extent_len > clusters)
+			extent_len = clusters;
+
+		clusters -= extent_len;
+		cpos += extent_len;
+	}
+out:
+	return ret;
+}
+
 static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
@@ -2429,8 +2466,10 @@ static ssize_t ocfs2_direct_IO(struct ki
 		return 0;
 
 	/* Fallback to buffered I/O if we do not support append dio. */
-	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
-	    !ocfs2_supports_append_dio(osb))
+	if (!ocfs2_supports_append_dio(osb) &&
+			(iocb->ki_pos + iter->count > i_size_read(inode) ||
+			 ocfs2_range_has_holes(inode, iocb->ki_pos,
+						     iter->count)))
 		return 0;
 
 	if (iov_iter_rw(iter) == READ)
_

Patches currently in -mm which might be from ge.changwei@h3c.com are

ocfs2-dlm-clean-dead-code-up.patch
ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch
ocfs2-clean-dead-code-in-suballocc.patch


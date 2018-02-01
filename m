From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:29:50 -0800
Message-ID: <20180201192950.z4xBLHC9J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57048 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754728AbeBAT3v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:29:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: add trimfs lock to avoid duplicated trims in cluster
has been removed from the -mm tree.  Its filename was
     ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: add trimfs lock to avoid duplicated trims in cluster

ocfs2 supports trimming the underlying disk via the fstrim command.  But
there is a problem, ocfs2 is a shared disk cluster file system, if the
user configures a scheduled fstrim job on each file system node, this will
trigger multiple nodes trimming a shared disk simultaneously, which is
very wasteful for CPU and IO consumption.  This also might negatively
affect the lifetime of poor-quality SSD devices.

So we introduce a trimfs dlm lock to communicate with each other in this
case, which will make only one fstrim command to do the trimming on a
shared disk among the cluster.  The fstrim commands from the other nodes
should wait for the first fstrim to finish and return success directly, to
avoid running the same trim on the shared disk again.

Link: http://lkml.kernel.org/r/1513228484-2084-2-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff -puN fs/ocfs2/alloc.c~ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster
+++ a/fs/ocfs2/alloc.c
@@ -7561,6 +7561,7 @@ int ocfs2_trim_fs(struct super_block *sb
 	struct buffer_head *gd_bh = NULL;
 	struct ocfs2_dinode *main_bm;
 	struct ocfs2_group_desc *gd = NULL;
+	struct ocfs2_trim_fs_info info, *pinfo = NULL;
 
 	start = range->start >> osb->s_clustersize_bits;
 	len = range->len >> osb->s_clustersize_bits;
@@ -7598,6 +7599,42 @@ int ocfs2_trim_fs(struct super_block *sb
 
 	trace_ocfs2_trim_fs(start, len, minlen);
 
+	ocfs2_trim_fs_lock_res_init(osb);
+	ret = ocfs2_trim_fs_lock(osb, NULL, 1);
+	if (ret < 0) {
+		if (ret != -EAGAIN) {
+			mlog_errno(ret);
+			ocfs2_trim_fs_lock_res_uninit(osb);
+			goto out_unlock;
+		}
+
+		mlog(ML_NOTICE, "Wait for trim on device (%s) to "
+		     "finish, which is running from another node.\n",
+		     osb->dev_str);
+		ret = ocfs2_trim_fs_lock(osb, &info, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			ocfs2_trim_fs_lock_res_uninit(osb);
+			goto out_unlock;
+		}
+
+		if (info.tf_valid && info.tf_success &&
+		    info.tf_start == start && info.tf_len == len &&
+		    info.tf_minlen == minlen) {
+			/* Avoid sending duplicated trim to a shared device */
+			mlog(ML_NOTICE, "The same trim on device (%s) was "
+			     "just done from node (%u), return.\n",
+			     osb->dev_str, info.tf_nodenum);
+			range->len = info.tf_trimlen;
+			goto out_trimunlock;
+		}
+	}
+
+	info.tf_nodenum = osb->node_num;
+	info.tf_start = start;
+	info.tf_len = len;
+	info.tf_minlen = minlen;
+
 	/* Determine first and last group to examine based on start and len */
 	first_group = ocfs2_which_cluster_group(main_bm_inode, start);
 	if (first_group == osb->first_cluster_group_blkno)
@@ -7642,6 +7679,13 @@ int ocfs2_trim_fs(struct super_block *sb
 			group += ocfs2_clusters_to_blocks(sb, osb->bitmap_cpg);
 	}
 	range->len = trimmed * sb->s_blocksize;
+
+	info.tf_trimlen = range->len;
+	info.tf_success = (ret ? 0 : 1);
+	pinfo = &info;
+out_trimunlock:
+	ocfs2_trim_fs_unlock(osb, pinfo);
+	ocfs2_trim_fs_lock_res_uninit(osb);
 out_unlock:
 	ocfs2_inode_unlock(main_bm_inode, 0);
 	brelse(main_bm_bh);
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
ocfs2-move-some-definitions-to-header-file.patch
ocfs2-fix-some-small-problems.patch
ocfs2-add-kobject-for-online-file-check.patch
ocfs2-add-duplicative-ino-number-check.patch


From: akpm@linux-foundation.org
Subject: +
 ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster.patch added to
 -mm tree
Date: Thu, 14 Dec 2017 14:50:16 -0800
Message-ID: <5a330028.IRYTv2bA+DnozN5p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754279AbdLNWuW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 17:50:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: add trimfs lock to avoid duplicated trims in cluster
has been added to the -mm tree.  Its filename is
     ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster.patch

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
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff -puN fs/ocfs2/alloc.c~ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster
+++ a/fs/ocfs2/alloc.c
@@ -7382,6 +7382,7 @@ int ocfs2_trim_fs(struct super_block *sb
 	struct buffer_head *gd_bh = NULL;
 	struct ocfs2_dinode *main_bm;
 	struct ocfs2_group_desc *gd = NULL;
+	struct ocfs2_trim_fs_info info, *pinfo = NULL;
 
 	start = range->start >> osb->s_clustersize_bits;
 	len = range->len >> osb->s_clustersize_bits;
@@ -7419,6 +7420,42 @@ int ocfs2_trim_fs(struct super_block *sb
 
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
@@ -7463,6 +7500,13 @@ int ocfs2_trim_fs(struct super_block *sb
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

ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
ocfs2-move-some-definitions-to-header-file.patch
ocfs2-fix-some-small-problems.patch
ocfs2-add-kobject-for-online-file-check.patch
ocfs2-add-duplicative-ino-number-check.patch
ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch
ocfs2-add-ocfs2_overwrite_io-function.patch
ocfs2-nowait-aio-support.patch
ocfs2-add-trimfs-dlm-lock-resource.patch
ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster.patch


From: akpm@linux-foundation.org
Subject: + ocfs2-take-inode-lock-when-get-clusters.patch added to -mm tree
Date: Mon, 02 Mar 2015 11:07:33 -0800
Message-ID: <54f4b4f5.f2Hyn8uJIo2fz7+n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbbCBTHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 14:07:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: take inode lock when get clusters
has been added to the -mm tree.  Its filename is
     ocfs2-take-inode-lock-when-get-clusters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-take-inode-lock-when-get-clusters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-take-inode-lock-when-get-clusters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: take inode lock when get clusters

We need take inode lock when calling ocfs2_get_clusters.
And use GFP_NOFS instead of GFP_KERNEL.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/aops.c~ocfs2-take-inode-lock-when-get-clusters fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-take-inode-lock-when-get-clusters
+++ a/fs/ocfs2/aops.c
@@ -772,10 +772,17 @@ static ssize_t ocfs2_direct_IO_write(str
 		u32 p_cpos = 0;
 		u32 v_cpos = ocfs2_bytes_to_clusters(osb->sb, offset);
 
+		ret = ocfs2_inode_lock(inode, NULL, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto clean_orphan;
+		}
+
 		ret = ocfs2_get_clusters(inode, v_cpos, &p_cpos,
 				&num_clusters, &ext_flags);
 		if (ret < 0) {
 			mlog_errno(ret);
+			ocfs2_inode_unlock(inode, 0);
 			goto clean_orphan;
 		}
 
@@ -783,9 +790,11 @@ static ssize_t ocfs2_direct_IO_write(str
 
 		ret = blkdev_issue_zeroout(osb->sb->s_bdev,
 				p_cpos << (osb->s_clustersize_bits - 9),
-				zero_len >> 9, GFP_KERNEL, false);
+				zero_len >> 9, GFP_NOFS, false);
 		if (ret < 0)
 			mlog_errno(ret);
+
+		ocfs2_inode_unlock(inode, 0);
 	}
 
 clean_orphan:
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-make-append_dio-an-incompat-feature.patch
ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch
ocfs2-no-need-get-dinode-bh-when-zeroing-extend.patch
ocfs2-take-inode-lock-when-get-clusters.patch
ocfs2-do-not-use-ocfs2_zero_extend-during-direct-io.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch


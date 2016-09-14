From: akpm@linux-foundation.org
Subject: + ocfs2-fix-start-offset-to-ocfs2_zero_range_for_truncate.patch
 added to -mm tree
Date: Wed, 14 Sep 2016 15:44:00 -0700
Message-ID: <57d9d2b0.qL9KPfkmjePKHuq9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43674 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755686AbcINWoB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2016 18:44:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ashish.samant@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, srinivas.eeda@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix start offset to ocfs2_zero_range_for_truncate()
has been added to the -mm tree.  Its filename is
     ocfs2-fix-start-offset-to-ocfs2_zero_range_for_truncate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-start-offset-to-ocfs2_zero_range_for_truncate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-start-offset-to-ocfs2_zero_range_for_truncate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ashish Samant <ashish.samant@oracle.com>
Subject: ocfs2: fix start offset to ocfs2_zero_range_for_truncate()

If we do fallocate with punch hole option on a reflink, with start offset
on a cluster boundary and end offset somewhere in another cluster, we dont
COW the first cluster starting at the start offset.  But in this case, we
were wrongly passing this cluster to ocfs2_zero_range_for_truncate() to
zero out.

Fix this by skipping this cluster in such a scenario.

Link: http://lkml.kernel.org/r/1470957147-14185-1-git-send-email-ashish.samant@oracle.com
Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-fix-start-offset-to-ocfs2_zero_range_for_truncate fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-start-offset-to-ocfs2_zero_range_for_truncate
+++ a/fs/ocfs2/file.c
@@ -1506,7 +1506,8 @@ static int ocfs2_zero_partial_clusters(s
 				       u64 start, u64 len)
 {
 	int ret = 0;
-	u64 tmpend, end = start + len;
+	u64 tmpend = 0;
+	u64 end = start + len;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	unsigned int csize = osb->s_clustersize;
 	handle_t *handle;
@@ -1538,18 +1539,31 @@ static int ocfs2_zero_partial_clusters(s
 	}
 
 	/*
-	 * We want to get the byte offset of the end of the 1st cluster.
+	 * If start is on a cluster boundary and end is somewhere in another
+	 * cluster, we have not COWed the cluster starting at start, unless
+	 * end is also within the same cluster. So, in this case, we skip this
+	 * first call to ocfs2_zero_range_for_truncate() truncate and move on
+	 * to the next one.
 	 */
-	tmpend = (u64)osb->s_clustersize + (start & ~(osb->s_clustersize - 1));
-	if (tmpend > end)
-		tmpend = end;
-
-	trace_ocfs2_zero_partial_clusters_range1((unsigned long long)start,
-						 (unsigned long long)tmpend);
-
-	ret = ocfs2_zero_range_for_truncate(inode, handle, start, tmpend);
-	if (ret)
-		mlog_errno(ret);
+	if ((start & (csize - 1)) != 0) {
+		/*
+		 * We want to get the byte offset of the end of the 1st
+		 * cluster.
+		 */
+		tmpend = (u64)osb->s_clustersize +
+			(start & ~(osb->s_clustersize - 1));
+		if (tmpend > end)
+			tmpend = end;
+
+		trace_ocfs2_zero_partial_clusters_range1(
+			(unsigned long long)start,
+			(unsigned long long)tmpend);
+
+		ret = ocfs2_zero_range_for_truncate(inode, handle, start,
+						    tmpend);
+		if (ret)
+			mlog_errno(ret);
+	}
 
 	if (tmpend < end) {
 		/*
_

Patches currently in -mm which might be from ashish.samant@oracle.com are

ocfs2-fix-start-offset-to-ocfs2_zero_range_for_truncate.patch


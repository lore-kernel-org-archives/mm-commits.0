From: akpm@linux-foundation.org
Subject: [patch 18/20] ocfs2: fix start offset to
 ocfs2_zero_range_for_truncate()
Date: Mon, 19 Sep 2016 14:44:42 -0700
Message-ID: <57e05c4a.iElftT93zY0fYoBv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52887 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932283AbcISVon (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2016 17:44:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ashish.samant@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, saar.maoz@oracle.com, srinivas.eeda@oracle.com, stable@vger.kernel.org, zren@suse.com

From: Ashish Samant <ashish.samant@oracle.com>
Subject: ocfs2: fix start offset to ocfs2_zero_range_for_truncate()

If we punch a hole on a reflink such that following conditions are met:

1. start offset is on a cluster boundary
2. end offset is not on a cluster boundary
3. (end offset is somewhere in another extent) or
   (hole range > MAX_CONTIG_BYTES(1MB)),

we dont COW the first cluster starting at the start offset.  But in
this case, we were wrongly passing this cluster to
ocfs2_zero_range_for_truncate() to zero out.  This will modify the
cluster in place and zero it in the source too.

Fix this by skipping this cluster in such a scenario.

To reproduce:

1. Create a random file of say 10 MB
     xfs_io -c 'pwrite -b 4k 0 10M' -f 10MBfile
2. Reflink  it
     reflink -f 10MBfile reflnktest
3. Punch a hole at starting at cluster boundary  with range greater that 
1MB. You can also use a range that will put the end offset in another 
extent.
     fallocate -p -o 0 -l 1048615 reflnktest
4. sync
5. Check the  first cluster in the source file. (It will be zeroed out).
    dd if=10MBfile iflag=direct bs=<cluster size> count=1 | hexdump -C

Link: http://lkml.kernel.org/r/1470957147-14185-1-git-send-email-ashish.samant@oracle.com
Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
Reported-by: Saar Maoz <saar.maoz@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Eric Ren <zren@suse.com>
Cc: <stable@vger.kernel.org>
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

From: akpm@linux-foundation.org
Subject: +
 ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters.patch added to
 -mm tree
Date: Tue, 06 Aug 2013 14:21:06 -0700
Message-ID: <520168c2.vr4nkK0f26d94QrR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab3HFVVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 17:21:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: + ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters.patch added to -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 14:21:06 -0700


The patch titled
     Subject: ocfs2: add missing return value check of ocfs2_get_clusters()
has been added to the -mm tree.  Its filename is
     ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters.patch

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
Subject: ocfs2: add missing return value check of ocfs2_get_clusters()

In ocfs2_attach_refcount_tree() and ocfs2_duplicate_extent_list(), if
error occurs when calling ocfs2_get_clusters(), it will go with
unexpected behavior as local variables p_cluster, num_clusters and
ext_flags are declared without initialization.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters
+++ a/fs/ocfs2/refcounttree.c
@@ -3891,7 +3891,10 @@ static int ocfs2_attach_refcount_tree(st
 	while (cpos < clusters) {
 		ret = ocfs2_get_clusters(inode, cpos, &p_cluster,
 					 &num_clusters, &ext_flags);
-
+		if (ret) {
+			mlog_errno(ret);
+			goto unlock;
+		}
 		if (p_cluster && !(ext_flags & OCFS2_EXT_REFCOUNTED)) {
 			ret = ocfs2_add_refcount_flag(inode, &di_et,
 						      &ref_tree->rf_ci,
@@ -4062,7 +4065,10 @@ static int ocfs2_duplicate_extent_list(s
 	while (cpos < clusters) {
 		ret = ocfs2_get_clusters(s_inode, cpos, &p_cluster,
 					 &num_clusters, &ext_flags);

From: akpm@linux-foundation.org
Subject: +
 ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch
 added to -mm tree
Date: Thu, 08 Aug 2013 12:51:20 -0700
Message-ID: <5203f6b8.QONlB/H5NNYfQlqq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965572Ab3HHTvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 15:51:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: + ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch added to -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 12:51:20 -0700


The patch titled
     Subject: ocfs2: add the missing return value check of ocfs2_xattr_get_clusters
has been added to the -mm tree.  Its filename is
     ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch

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
Subject: ocfs2: add the missing return value check of ocfs2_xattr_get_clusters

In ocfs2_xattr_value_attach_refcount(), if error occurs when calling
ocfs2_xattr_get_clusters(), it will go with unexpected behavior since
local variables p_cluster, num_clusters and ext_flags are declared without
initialization.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ocfs2/xattr.c~ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters
+++ a/fs/ocfs2/xattr.c
@@ -5881,6 +5881,10 @@ static int ocfs2_xattr_value_attach_refc
 	while (cpos < clusters) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
 					       &num_clusters, el, &ext_flags);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
 
 		cpos += num_clusters;
 		if ((ext_flags & OCFS2_EXT_REFCOUNTED))
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

fs-ocfs2-cluster-tcpc-fix-possible-null-pointer-dereferences.patch
ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch
ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters.patch
ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch


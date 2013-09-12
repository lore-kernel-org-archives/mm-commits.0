From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:41:35 -0700
Message-ID: <523218ef.pEQyKINv2sieOy53%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: [merged] ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch removed from -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:35 -0700


The patch titled
     Subject: ocfs2: add the missing return value check of ocfs2_xattr_get_clusters
has been removed from the -mm tree.  Its filename was
     ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch


From: akpm@linux-foundation.org
Subject: + ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch added to -mm tree
Date: Thu, 08 Aug 2013 15:20:16 -0700
Message-ID: <520419a0.4yb2Z6hXEm9+Xyxk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419Ab3HHWUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 18:20:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: + ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch added to -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 15:20:16 -0700


The patch titled
     Subject: ocfs2: fix possible double free in ocfs2_reflink_xattr_rec
has been added to the -mm tree.  Its filename is
     ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch

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
Subject: ocfs2: fix possible double free in ocfs2_reflink_xattr_rec

In ocfs2_reflink_xattr_rec(), meta_ac and data_ac are allocated by calling
ocfs2_lock_reflink_xattr_rec_allocators().

Once an error occurs when allocating *data_ac, it frees *meta_ac which is
allocated before.  Here it mistakenly sets meta_ac to NULL but *meta_ac. 
Then ocfs2_reflink_xattr_rec() will try to free meta_ac again which is
already invalid.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/xattr.c~ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec
+++ a/fs/ocfs2/xattr.c
@@ -6802,7 +6802,7 @@ out:
 	if (ret) {
 		if (*meta_ac) {
 			ocfs2_free_alloc_context(*meta_ac);
-			meta_ac = NULL;
+			*meta_ac = NULL;
 		}
 	}
 
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

fs-ocfs2-cluster-tcpc-fix-possible-null-pointer-dereferences.patch
ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch
ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters.patch
ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch
ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch
ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch


From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:41:43 -0700
Message-ID: <523218f7.KxhSRW9Uzujte4JA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: [merged] ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch removed from -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:43 -0700


The patch titled
     Subject: ocfs2: fix possible double free in ocfs2_reflink_xattr_rec
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch


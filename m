From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2.patch
 removed from -mm tree
Date: Fri, 07 Oct 2016 16:41:51 -0700
Message-ID: <57f832bf.8IFGkUwfS+phrFpF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38397 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754882AbcJGXlw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:41:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,ksm: add __GFP_HIGH to the allocation in alloc_stable_node()
has been removed from the -mm tree.  Its filename was
     mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2.patch

This patch was dropped because it was folded into mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node.patch

------------------------------------------------------
From: zhongjiang <zhongjiang@huawei.com>
Subject: mm,ksm: add __GFP_HIGH to the allocation in alloc_stable_node()

From: zhong jiang <zhongjiang@huawei.com>

According to HUgh's suggestion, alloc_stable_node() with GFP_KERNEL
will cause the hungtask, despite less possiblity.

At present, if alloc_stable_node allocate fails, two break_cow may
want to allocate a couple of pages, and the issue will come up when
free memory is under pressure.

we fix it by adding the __GFP_HIGH to GFP. because it grant access to
some of meory reserves. it will make progress to make it allocation
successful at the utmost.

Link: http://lkml.kernel.org/r/1475070362-44469-1-git-send-email-zhongjiang@huawei.com
Acked-by: Hugh Dickins <hughd@google.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 1 file changed, 8 insertions(+), 1 deletion(-)

index 5048083..5e98c0b 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/ksm.c~mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2 mm/ksm.c
--- a/mm/ksm.c~mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2
+++ a/mm/ksm.c
@@ -299,6 +299,13 @@ static inline void free_rmap_item(struct
 
 static inline struct stable_node *alloc_stable_node(void)
 {
+	/*
+	 * The caller can take too long time with GFP_KERNEL when memory
+	 * is under pressure, it may be lead to the hung task. Therefore,
+	 * Adding the __GFP_HIGH to this. it grant access to some of
+	 * memory reserves. and it will make progress to make it allocation
+	 * successful at the utmost.
+	 */
 	return kmem_cache_alloc(stable_node_cache, GFP_KERNEL | __GFP_HIGH);
 }
 
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node.patch
mm-remove-unnecessary-condition-in-remove_inode_hugepages.patch


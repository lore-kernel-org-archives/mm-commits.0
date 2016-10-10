From: akpm@linux-foundation.org
Subject: [merged]
 mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node.patch removed
 from -mm tree
Date: Mon, 10 Oct 2016 15:46:06 -0700
Message-ID: <57fc1a2e.jKxT8HrcacF1qsrA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37219 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbcJJWqH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:46:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,ksm: add __GFP_HIGH to the allocation in alloc_stable_node()
has been removed from the -mm tree.  Its filename was
     mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm,ksm: add __GFP_HIGH to the allocation in alloc_stable_node()

According to Hugh's suggestion, alloc_stable_node() with GFP_KERNEL can in
rare cases cause a hung task warning.

At present, if alloc_stable_node() allocation fails, two break_cows may
want to allocate a couple of pages, and the issue will come up when free
memory is under pressure.

We fix it by adding __GFP_HIGH to GFP, to grant access to memory reserves,
increasing the likelihood of allocation success.

[akpm@linux-foundation.org: tweak comment]
Link: http://lkml.kernel.org/r/1474354484-58233-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/ksm.c~mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node mm/ksm.c
--- a/mm/ksm.c~mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node
+++ a/mm/ksm.c
@@ -299,7 +299,12 @@ static inline void free_rmap_item(struct
 
 static inline struct stable_node *alloc_stable_node(void)
 {
-	return kmem_cache_alloc(stable_node_cache, GFP_KERNEL);
+	/*
+	 * The allocation can take too long with GFP_KERNEL when memory is under
+	 * pressure, which may lead to hung task warnings.  Adding __GFP_HIGH
+	 * grants access to memory reserves, helping to avoid this problem.
+	 */
+	return kmem_cache_alloc(stable_node_cache, GFP_KERNEL | __GFP_HIGH);
 }
 
 static inline void free_stable_node(struct stable_node *stable_node)
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch


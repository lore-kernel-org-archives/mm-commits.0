From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch
 removed from -mm tree
Date: Fri, 07 Oct 2016 16:41:54 -0700
Message-ID: <57f832c2.CBJKiYwlfUHtzET3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754882AbcJGXlz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:41:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix
has been removed from the -mm tree.  Its filename was
     mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch

This patch was dropped because it was folded into mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix

tweak comment

Cc: Hugh Dickins <hughd@google.com>
Cc: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/ksm.c~mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix mm/ksm.c
--- a/mm/ksm.c~mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix
+++ a/mm/ksm.c
@@ -300,11 +300,9 @@ static inline void free_rmap_item(struct
 static inline struct stable_node *alloc_stable_node(void)
 {
 	/*
-	 * The caller can take too long time with GFP_KERNEL when memory
-	 * is under pressure, it may be lead to the hung task. Therefore,
-	 * Adding the __GFP_HIGH to this. it grant access to some of
-	 * memory reserves. and it will make progress to make it allocation
-	 * successful at the utmost.
+	 * The allocation can take too long with GFP_KERNEL when memory is under
+	 * pressure, which may lead to hung task warnings.  Adding __GFP_HIGH
+	 * grants access to memory reserves, helping to avoid this problem.
 	 */
 	return kmem_cache_alloc(stable_node_cache, GFP_KERNEL | __GFP_HIGH);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
a.patch


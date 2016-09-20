From: akpm@linux-foundation.org
Subject: +
 mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node.patch added to
 -mm tree
Date: Tue, 20 Sep 2016 14:06:52 -0700
Message-ID: <57e1a4ec.Zw+F9iedmW+jZVDl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50016 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbcITVGx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 17:06:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,ksm: add __GFP_HIGH to the allocation in alloc_stable_node()
has been added to the -mm tree.  Its filename is
     mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Suggested-by: Hugh Dickins <hughd@google.com>
Link: http://lkml.kernel.org/r/1474354484-58233-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/ksm.c~mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node mm/ksm.c
--- a/mm/ksm.c~mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node
+++ a/mm/ksm.c
@@ -299,7 +299,7 @@ static inline void free_rmap_item(struct
 
 static inline struct stable_node *alloc_stable_node(void)
 {
-	return kmem_cache_alloc(stable_node_cache, GFP_KERNEL);
+	return kmem_cache_alloc(stable_node_cache, GFP_KERNEL | __GFP_HIGH);
 }
 
 static inline void free_stable_node(struct stable_node *stable_node)
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mmksm-fix-endless-looping-in-allocating-memory-when-ksm-enable.patch
mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch


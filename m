From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-simplify-alloc_swap_slot_cache.patch added to
 -mm tree
Date: Wed, 08 Jul 2020 16:41:37 -0700
Message-ID: <20200708234137.ZRfEQWbVY%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgGHXli (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 19:41:38 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, thunder.leizhen@huawei.com, tim.c.chen@linux.intel.com


The patch titled
     Subject: mm/swap_slots.c: simplify alloc_swap_slot_cache()
has been added to the -mm tree.  Its filename is
     mm-swap-simplify-alloc_swap_slot_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-simplify-alloc_swap_slot_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-simplify-alloc_swap_slot_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm/swap_slots.c: simplify alloc_swap_slot_cache()

Patch series "clean up some functions in mm/swap_slots.c".

When I studied the code of mm/swap_slots.c, I found some places can be
improved.


This patch (of 3):

Both "slots" and "slots_ret" are only need to be freed when cache already
allocated.  Make them closer, seems more clear.

No functional change.

Link: http://lkml.kernel.org/r/20200430061143.450-1-thunder.leizhen@huawei.com
Link: http://lkml.kernel.org/r/20200430061143.450-2-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/swap_slots.c~mm-swap-simplify-alloc_swap_slot_cache
+++ a/mm/swap_slots.c
@@ -136,9 +136,16 @@ static int alloc_swap_slot_cache(unsigne
 
 	mutex_lock(&swap_slots_cache_mutex);
 	cache = &per_cpu(swp_slots, cpu);
-	if (cache->slots || cache->slots_ret)
+	if (cache->slots || cache->slots_ret) {
 		/* cache already allocated */
-		goto out;
+		mutex_unlock(&swap_slots_cache_mutex);
+
+		kvfree(slots);
+		kvfree(slots_ret);
+
+		return 0;
+	}
+
 	if (!cache->lock_initialized) {
 		mutex_init(&cache->alloc_lock);
 		spin_lock_init(&cache->free_lock);
@@ -155,15 +162,8 @@ static int alloc_swap_slot_cache(unsigne
 	 */
 	mb();
 	cache->slots = slots;
-	slots = NULL;
 	cache->slots_ret = slots_ret;
-	slots_ret = NULL;
-out:
 	mutex_unlock(&swap_slots_cache_mutex);
-	if (slots)
-		kvfree(slots);
-	if (slots_ret)
-		kvfree(slots_ret);
 	return 0;
 }
 
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

mm-swap-simplify-alloc_swap_slot_cache.patch
mm-swap-simplify-enable_swap_slots_cache.patch
mm-swap-remove-redundant-check-for-swap_slot_cache_initialized.patch
mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff.patch

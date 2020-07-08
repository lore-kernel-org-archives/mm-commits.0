From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-simplify-enable_swap_slots_cache.patch added to
 -mm tree
Date: Wed, 08 Jul 2020 16:41:39 -0700
Message-ID: <20200708234139.FxeOCxDvZ%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgGHXlk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 19:41:40 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, thunder.leizhen@huawei.com, tim.c.chen@linux.intel.com


The patch titled
     Subject: mm/swap_slots.c: simplify enable_swap_slots_cache()
has been added to the -mm tree.  Its filename is
     mm-swap-simplify-enable_swap_slots_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-simplify-enable_swap_slots_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-simplify-enable_swap_slots_cache.patch

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
Subject: mm/swap_slots.c: simplify enable_swap_slots_cache()

Whether swap_slot_cache_initialized is true or false,
__reenable_swap_slots_cache() is always called.  To make this meaning
clear, leave only one call to __reenable_swap_slots_cache().  This also
make it clearer what extra needs be done when swap_slot_cache_initialized
is false.

No functional change.

Link: http://lkml.kernel.org/r/20200430061143.450-3-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/mm/swap_slots.c~mm-swap-simplify-enable_swap_slots_cache
+++ a/mm/swap_slots.c
@@ -240,21 +240,19 @@ static int free_slot_cache(unsigned int
 
 int enable_swap_slots_cache(void)
 {
-	int ret = 0;
-
 	mutex_lock(&swap_slots_cache_enable_mutex);
-	if (swap_slot_cache_initialized) {
-		__reenable_swap_slots_cache();
-		goto out_unlock;
-	}
+	if (!swap_slot_cache_initialized) {
+		int ret;
 
-	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "swap_slots_cache",
-				alloc_swap_slot_cache, free_slot_cache);
-	if (WARN_ONCE(ret < 0, "Cache allocation failed (%s), operating "
-			       "without swap slots cache.\n", __func__))
-		goto out_unlock;
+		ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "swap_slots_cache",
+					alloc_swap_slot_cache, free_slot_cache);
+		if (WARN_ONCE(ret < 0, "Cache allocation failed (%s), operating "
+				       "without swap slots cache.\n", __func__))
+			goto out_unlock;
+
+		swap_slot_cache_initialized = true;
+	}
 
-	swap_slot_cache_initialized = true;
 	__reenable_swap_slots_cache();
 out_unlock:
 	mutex_unlock(&swap_slots_cache_enable_mutex);
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

mm-swap-simplify-alloc_swap_slot_cache.patch
mm-swap-simplify-enable_swap_slots_cache.patch
mm-swap-remove-redundant-check-for-swap_slot_cache_initialized.patch
mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff.patch

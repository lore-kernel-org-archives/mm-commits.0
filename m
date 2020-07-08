From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-swap-remove-redundant-check-for-swap_slot_cache_initialized.patch added
 to -mm tree
Date: Wed, 08 Jul 2020 16:41:41 -0700
Message-ID: <20200708234141.0reVw_uIa%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgGHXlm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 19:41:42 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, thunder.leizhen@huawei.com, tim.c.chen@linux.intel.com


The patch titled
     Subject: mm/swap_slots.c: remove redundant check for swap_slot_cache_initialized
has been added to the -mm tree.  Its filename is
     mm-swap-remove-redundant-check-for-swap_slot_cache_initialized.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-remove-redundant-check-for-swap_slot_cache_initialized.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-remove-redundant-check-for-swap_slot_cache_initialized.patch

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
Subject: mm/swap_slots.c: remove redundant check for swap_slot_cache_initialized

Because enable_swap_slots_cache can only become true in
enable_swap_slots_cache(), and depends on swap_slot_cache_initialized is
true before.  That means, when enable_swap_slots_cache is true,
swap_slot_cache_initialized is true also.

So the condition:
"swap_slot_cache_enabled && swap_slot_cache_initialized"
can be reduced to "swap_slot_cache_enabled"

And in mathematics:
"!swap_slot_cache_enabled || !swap_slot_cache_initialized"
is equal to "!(swap_slot_cache_enabled && swap_slot_cache_initialized)"

So no functional change.

Link: http://lkml.kernel.org/r/20200430061143.450-4-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/swap_slots.c~mm-swap-remove-redundant-check-for-swap_slot_cache_initialized
+++ a/mm/swap_slots.c
@@ -46,8 +46,7 @@ static void __drain_swap_slots_cache(uns
 static void deactivate_swap_slots_cache(void);
 static void reactivate_swap_slots_cache(void);
 
-#define use_swap_slot_cache (swap_slot_cache_active && \
-		swap_slot_cache_enabled && swap_slot_cache_initialized)
+#define use_swap_slot_cache (swap_slot_cache_active && swap_slot_cache_enabled)
 #define SLOTS_CACHE 0x1
 #define SLOTS_CACHE_RET 0x2
 
@@ -94,7 +93,7 @@ static bool check_cache_active(void)
 {
 	long pages;
 
-	if (!swap_slot_cache_enabled || !swap_slot_cache_initialized)
+	if (!swap_slot_cache_enabled)
 		return false;
 
 	pages = get_nr_swap_pages();
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

mm-swap-simplify-alloc_swap_slot_cache.patch
mm-swap-simplify-enable_swap_slots_cache.patch
mm-swap-remove-redundant-check-for-swap_slot_cache_initialized.patch
mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff.patch

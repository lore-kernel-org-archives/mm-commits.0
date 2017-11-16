From: akpm@linux-foundation.org
Subject: [merged]
 mm-swap-fix-race-conditions-in-swap_slots-cache-init.patch removed from -mm
 tree
Date: Thu, 16 Nov 2017 12:01:13 -0800
Message-ID: <20171116200113.INt-B6mKQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46436 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdKPUBP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:01:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hannes@cmpxchg.org, hdanton@sina.com, hughd@google.com, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, tim.c.chen@linux.intel.com, wenwei.tww@alibaba-inc.com, ying.huang@intel.com


The patch titled
     Subject: mm/swap_slots.c: fix race conditions in swap_slots cache init
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-race-conditions-in-swap_slots-cache-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: mm/swap_slots.c: fix race conditions in swap_slots cache init

Memory allocations can happen before the swap_slots cache initialization
is completed during cpu bring up.  If we are low on memory, we could call
get_swap_page() and access swap_slots_cache before it is fully
initialized.

Add a check in get_swap_page() for initialized swap_slots_cache to prevent
this condition.  Similar check already exists in free_swap_slot.  Also
annotate the checks to indicate the likely condition.

We also added a memory barrier to make sure that the locks initialization
are done before the assignment of cache->slots and cache->slots_ret
pointers.  This ensures the assumption that it is safe to acquire the
slots cache locks and use the slots cache when the corresponding
cache->slots or cache->slots_ret pointers are non null.

[akpm@linux-foundation.org: tidy up comment]
[akpm@linux-foundation.org: fix spello in comment]
Link: http://lkml.kernel.org/r/65a9d0f133f63e66bba37b53b2fd0464b7cae771.1500677066.git.tim.c.chen@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Reported-by: Wenwei Tao <wenwei.tww@alibaba-inc.com>
Acked-by: Ying Huang <ying.huang@intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/swap_slots.c~mm-swap-fix-race-conditions-in-swap_slots-cache-init mm/swap_slots.c
--- a/mm/swap_slots.c~mm-swap-fix-race-conditions-in-swap_slots-cache-init
+++ a/mm/swap_slots.c
@@ -149,6 +149,13 @@ static int alloc_swap_slot_cache(unsigne
 	cache->nr = 0;
 	cache->cur = 0;
 	cache->n_ret = 0;
+	/*
+	 * We initialized alloc_lock and free_lock earlier.  We use
+	 * !cache->slots or !cache->slots_ret to know if it is safe to acquire
+	 * the corresponding lock and use the cache.  Memory barrier below
+	 * ensures the assumption.
+	 */
+	mb();
 	cache->slots = slots;
 	slots = NULL;
 	cache->slots_ret = slots_ret;
@@ -275,7 +282,7 @@ int free_swap_slot(swp_entry_t entry)
 	struct swap_slots_cache *cache;
 
 	cache = raw_cpu_ptr(&swp_slots);
-	if (use_swap_slot_cache && cache->slots_ret) {
+	if (likely(use_swap_slot_cache && cache->slots_ret)) {
 		spin_lock_irq(&cache->free_lock);
 		/* Swap slots cache may be deactivated before acquiring lock */
 		if (!use_swap_slot_cache || !cache->slots_ret) {
@@ -326,7 +333,7 @@ swp_entry_t get_swap_page(struct page *p
 	 */
 	cache = raw_cpu_ptr(&swp_slots);
 
-	if (check_cache_active()) {
+	if (likely(check_cache_active() && cache->slots)) {
 		mutex_lock(&cache->alloc_lock);
 		if (cache->slots) {
 repeat:
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are



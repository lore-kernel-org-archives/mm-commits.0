From: akpm@linux-foundation.org
Subject: + mm-swap-fix-race-conditions-in-swap_slots-cache-init.patch
 added to -mm tree
Date: Tue, 03 Oct 2017 15:28:41 -0700
Message-ID: <59d40f19.gwxU5wTh+IZiLbYr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56844 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdJCW2m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 18:28:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.c.chen@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hdanton@sina.com, hughd@google.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, wenwei.tww@alibaba-inc.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: fix race conditions in swap_slots cache init
has been added to the -mm tree.  Its filename is
     mm-swap-fix-race-conditions-in-swap_slots-cache-init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-race-conditions-in-swap_slots-cache-init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-race-conditions-in-swap_slots-cache-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 mm/swap_slots.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/swap_slots.c~mm-swap-fix-race-conditions-in-swap_slots-cache-init mm/swap_slots.c
--- a/mm/swap_slots.c~mm-swap-fix-race-conditions-in-swap_slots-cache-init
+++ a/mm/swap_slots.c
@@ -148,6 +148,14 @@ static int alloc_swap_slot_cache(unsigne
 	cache->nr = 0;
 	cache->cur = 0;
 	cache->n_ret = 0;
+	/*
+	 * We intialized alloc_lock and free_lock earlier.
+	 * We use !cache->slots or !cache->slots_ret
+	 * to know if it is safe to acquire the corresponding
+	 * lock and use the cache.  Memory barrier
+	 * below ensures the assumption.
+	 */
+	mb();
 	cache->slots = slots;
 	slots = NULL;
 	cache->slots_ret = slots_ret;
@@ -274,7 +282,7 @@ int free_swap_slot(swp_entry_t entry)
 	struct swap_slots_cache *cache;
 
 	cache = raw_cpu_ptr(&swp_slots);
-	if (use_swap_slot_cache && cache->slots_ret) {
+	if (likely(use_swap_slot_cache && cache->slots_ret)) {
 		spin_lock_irq(&cache->free_lock);
 		/* Swap slots cache may be deactivated before acquiring lock */
 		if (!use_swap_slot_cache || !cache->slots_ret) {
@@ -325,7 +333,7 @@ swp_entry_t get_swap_page(struct page *p
 	 */
 	cache = raw_cpu_ptr(&swp_slots);
 
-	if (check_cache_active()) {
+	if (likely(check_cache_active() && cache->slots)) {
 		mutex_lock(&cache->alloc_lock);
 		if (cache->slots) {
 repeat:
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

mm-swap-fix-race-conditions-in-swap_slots-cache-init.patch
mm-swap-remove-lock_initialized-flag-from-swap_slots_cache.patch


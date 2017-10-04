From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-swap-remove-lock_initialized-flag-from-swap_slots_cache.patch removed
 from -mm tree
Date: Wed, 04 Oct 2017 14:54:54 -0700
Message-ID: <59d558ae.RIqaJHh2cKrJirkh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbdJDVy5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 17:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.c.chen@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hdanton@sina.com, hughd@google.com, junaids@google.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, wenwei.tww@alibaba-inc.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: remove lock_initialized flag from swap_slots_cache
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-lock_initialized-flag-from-swap_slots_cache.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: mm/swap_slots.c: remove lock_initialized flag from swap_slots_cache

We will only reach the lock initialization code in alloc_swap_slot_cache
when the cpu's swap_slots_cache's slots have not been allocated and
swap_slots_cache has not been initialized previously.  So the
lock_initialized check is redundant and unnecessary.  Remove
lock_initialized flag from swap_slots_cache to save memory.

Link: http://lkml.kernel.org/r/867d1fb070644e6d5f0ac7780f63e75259b82cc3.1500677066.git.tim.c.chen@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Reported-by: Wenwei Tao <wenwei.tww@alibaba-inc.com>
Cc: Ying Huang <ying.huang@intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Junaid Shahid <junaids@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap_slots.h |    1 -
 mm/swap_slots.c            |    9 ++++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff -puN include/linux/swap_slots.h~mm-swap-remove-lock_initialized-flag-from-swap_slots_cache include/linux/swap_slots.h
--- a/include/linux/swap_slots.h~mm-swap-remove-lock_initialized-flag-from-swap_slots_cache
+++ a/include/linux/swap_slots.h
@@ -10,7 +10,6 @@
 #define THRESHOLD_DEACTIVATE_SWAP_SLOTS_CACHE	(2*SWAP_SLOTS_CACHE_SIZE)
 
 struct swap_slots_cache {
-	bool		lock_initialized;
 	struct mutex	alloc_lock; /* protects slots, nr, cur */
 	swp_entry_t	*slots;
 	int		nr;
diff -puN mm/swap_slots.c~mm-swap-remove-lock_initialized-flag-from-swap_slots_cache mm/swap_slots.c
--- a/mm/swap_slots.c~mm-swap-remove-lock_initialized-flag-from-swap_slots_cache
+++ a/mm/swap_slots.c
@@ -140,11 +140,10 @@ static int alloc_swap_slot_cache(unsigne
 	if (cache->slots || cache->slots_ret)
 		/* cache already allocated */
 		goto out;
-	if (!cache->lock_initialized) {
-		mutex_init(&cache->alloc_lock);
-		spin_lock_init(&cache->free_lock);
-		cache->lock_initialized = true;
-	}
+
+	mutex_init(&cache->alloc_lock);
+	spin_lock_init(&cache->free_lock);
+
 	cache->nr = 0;
 	cache->cur = 0;
 	cache->n_ret = 0;
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

mm-swap-fix-race-conditions-in-swap_slots-cache-init.patch


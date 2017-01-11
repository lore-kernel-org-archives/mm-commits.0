From: akpm@linux-foundation.org
Subject: +
 mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled.patch added to
 -mm tree
Date: Wed, 11 Jan 2017 15:42:59 -0800
Message-ID: <5876c303.FVqOs+9h5Wi8bxYb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38862 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762005AbdAKXnH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 18:43:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, aaron.lu@intel.com, ak@linux.intel.com, borntraeger@de.ibm.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@linux.intel.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: skip readahead only when swap slot cache is enabled
has been added to the -mm tree.  Its filename is
     mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm/swap: skip readahead only when swap slot cache is enabled

Because during swap off, a swap entry may have swap_map[] ==
SWAP_HAS_CACHE (for example, just allocated).  If we return NULL in
__read_swap_cache_async(), the swap off will abort.  So when swap slot
cache is disabled, (for swap off), we will wait for page to be put into
swap cache in such race condition.  This should not be a problem for swap
slot cache, because swap slot cache should be drained after clearing
swap_slot_cache_enabled.

Link: http://lkml.kernel.org/r/5e2c5f6abe8e6eb0797408897b1bba80938e9b9d.1484082593.git.tim.c.chen@linux.intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net> escreveu:
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap_slots.h |    2 ++
 mm/swap_slots.c            |    2 +-
 mm/swap_state.c            |   11 +++++++++--
 3 files changed, 12 insertions(+), 3 deletions(-)

diff -puN include/linux/swap_slots.h~mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled include/linux/swap_slots.h
--- a/include/linux/swap_slots.h~mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled
+++ a/include/linux/swap_slots.h
@@ -25,4 +25,6 @@ void reenable_swap_slots_cache_unlock(vo
 int enable_swap_slots_cache(void);
 int free_swap_slot(swp_entry_t entry);
 
+extern bool swap_slot_cache_enabled;
+
 #endif /* _LINUX_SWAP_SLOTS_H */
diff -puN mm/swap_slots.c~mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled mm/swap_slots.c
--- a/mm/swap_slots.c~mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled
+++ a/mm/swap_slots.c
@@ -36,7 +36,7 @@
 
 static DEFINE_PER_CPU(struct swap_slots_cache, swp_slots);
 static bool	swap_slot_cache_active;
-static bool	swap_slot_cache_enabled;
+bool	swap_slot_cache_enabled;
 static bool	swap_slot_cache_initialized;
 DEFINE_MUTEX(swap_slots_cache_mutex);
 /* Serialize swap slots cache enable/disable operations */
diff -puN mm/swap_state.c~mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled
+++ a/mm/swap_state.c
@@ -324,8 +324,15 @@ struct page *__read_swap_cache_async(swp
 		if (found_page)
 			break;
 
-		/* Just skip read ahead for unused swap slot */
-		if (!__swp_swapcount(entry))
+		/*
+		 * Just skip read ahead for unused swap slot.
+		 * During swap_off when swap_slot_cache is disabled,
+		 * we have to handle the race between putting
+		 * swap entry in swap cache and marking swap slot
+		 * as SWAP_HAS_CACHE.  That's done in later part of code or
+		 * else swap_off will be aborted if we return NULL.
+		 */
+		if (!__swp_swapcount(entry) && swap_slot_cache_enabled)
 			return NULL;
 
 		/*
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-kernel-message-in-swap_info_get.patch
mm-swap-add-cluster-lock.patch
mm-swap-split-swap-cache-into-64mb-trunks.patch
mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled.patch


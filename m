From: akpm@linux-foundation.org
Subject: +
 mm-swap-dont-disable-preemption-while-taking-the-per-cpu-cache.patch added
 to -mm tree
Date: Fri, 23 Jun 2017 13:33:23 -0700
Message-ID: <594d7b13.B8apofVuUlMCzUci%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754892AbdFWUdY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 16:33:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, hughd@google.com, mhocko@suse.com, tglx@linutronix.de, tim.c.chen@linux.intel.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: don't disable preemption while taking the per-CPU cache
has been added to the -mm tree.  Its filename is
     mm-swap-dont-disable-preemption-while-taking-the-per-cpu-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-dont-disable-preemption-while-taking-the-per-cpu-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-dont-disable-preemption-while-taking-the-per-cpu-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/swap_slots.c: don't disable preemption while taking the per-CPU cache

get_cpu_var() disables preemption and returns the per-CPU version of the
variable.  Disabling preemption is useful to ensure atomic access to the
variable within the critical section.

In this case however, after the per-CPU version of the variable is
obtained the ->free_lock is acquired.  For that reason it seems the raw
accessor could be used.  It only seems that ->slots_ret should be retested
(because with disabled preemption this variable can not be set to NULL
otherwise).

This popped up during PREEMPT-RT testing because it tries to take
spinlocks in a preempt disabled section.  In RT, spinlocks can sleep.

Link: http://lkml.kernel.org/r/20170623114755.2ebxdysacvgxzott@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ying Huang <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/swap_slots.c~mm-swap-dont-disable-preemption-while-taking-the-per-cpu-cache mm/swap_slots.c
--- a/mm/swap_slots.c~mm-swap-dont-disable-preemption-while-taking-the-per-cpu-cache
+++ a/mm/swap_slots.c
@@ -273,11 +273,11 @@ int free_swap_slot(swp_entry_t entry)
 {
 	struct swap_slots_cache *cache;
 
-	cache = &get_cpu_var(swp_slots);
+	cache = raw_cpu_ptr(&swp_slots);
 	if (use_swap_slot_cache && cache->slots_ret) {
 		spin_lock_irq(&cache->free_lock);
 		/* Swap slots cache may be deactivated before acquiring lock */
-		if (!use_swap_slot_cache) {
+		if (!use_swap_slot_cache || !cache->slots_ret) {
 			spin_unlock_irq(&cache->free_lock);
 			goto direct_free;
 		}
@@ -297,7 +297,6 @@ int free_swap_slot(swp_entry_t entry)
 direct_free:
 		swapcache_free_entries(&entry, 1);
 	}
-	put_cpu_var(swp_slots);
 
 	return 0;
 }
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-swap-dont-disable-preemption-while-taking-the-per-cpu-cache.patch


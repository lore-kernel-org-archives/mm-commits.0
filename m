From: akpm@linux-foundation.org
Subject: + swap-add-warning-if-swap-slots-cache-failed-to-initialize.patch added to -mm tree
Date: Tue, 28 Mar 2017 16:59:17 -0700
Message-ID: <58daf8d5.FpVktkAOM2mbpWfj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53262 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932392AbdC1X7T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 19:59:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: add warning if swap slots cache failed to initialize
has been added to the -mm tree.  Its filename is
     swap-add-warning-if-swap-slots-cache-failed-to-initialize.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-add-warning-if-swap-slots-cache-failed-to-initialize.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-add-warning-if-swap-slots-cache-failed-to-initialize.patch

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
Subject: mm/swap_slots.c: add warning if swap slots cache failed to initialize

Add a warning diagnostics to user if we failed to allocate swap slots
cache and use it.

Link: http://lkml.kernel.org/r/20170328234827.GA10107@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/swap_slots.c~swap-add-warning-if-swap-slots-cache-failed-to-initialize mm/swap_slots.c
--- a/mm/swap_slots.c~swap-add-warning-if-swap-slots-cache-failed-to-initialize
+++ a/mm/swap_slots.c
@@ -241,8 +241,11 @@ int enable_swap_slots_cache(void)
 
 	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "swap_slots_cache",
 				alloc_swap_slot_cache, free_slot_cache);
-	if (ret < 0)
+	if (ret < 0) {
+		WARN_ONCE(1, "Cache allocation failed (%s), operate without swap slots cache.\n",
+				__func__);
 		goto out_unlock;
+	}
 	swap_slot_cache_initialized = true;
 	__reenable_swap_slots_cache();
 out_unlock:
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

swap-add-warning-if-swap-slots-cache-failed-to-initialize.patch


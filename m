From: akpm@linux-foundation.org
Subject: [patch 063/102] mm/swap_slots.c: add warning if swap slots
 cache failed to initialize
Date: Wed, 03 May 2017 14:54:48 -0700
Message-ID: <20170503215448.ApICWxkDq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49704 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751700AbdECVzD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com, torvalds@linux-foundation.org

From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: mm/swap_slots.c: add warning if swap slots cache failed to initialize

Add a warning diagnostics to user if we failed to allocate swap slots
cache and use it.

[akpm@linux-foundation.org: use WARN_ONCE return value, fix grammar in message]
Link: http://lkml.kernel.org/r/20170328234827.GA10107@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/swap_slots.c~swap-add-warning-if-swap-slots-cache-failed-to-initialize mm/swap_slots.c
--- a/mm/swap_slots.c~swap-add-warning-if-swap-slots-cache-failed-to-initialize
+++ a/mm/swap_slots.c
@@ -241,8 +241,10 @@ int enable_swap_slots_cache(void)
 
 	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "swap_slots_cache",
 				alloc_swap_slot_cache, free_slot_cache);
-	if (ret < 0)
+	if (WARN_ONCE(ret < 0, "Cache allocation failed (%s), operating "
+			       "without swap slots cache.\n", __func__))
 		goto out_unlock;
+
 	swap_slot_cache_initialized = true;
 	__reenable_swap_slots_cache();
 out_unlock:
_

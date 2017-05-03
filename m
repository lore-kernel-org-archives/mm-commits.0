From: akpm@linux-foundation.org
Subject: [folded-merged]
 swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch removed from -mm tree
Date: Wed, 03 May 2017 14:42:58 -0700
Message-ID: <590a4ee2.hx8VRtn3XTiFqCFA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45916 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdECVm7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix
has been removed from the -mm tree.  Its filename was
     swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch

This patch was dropped because it was folded into swap-add-warning-if-swap-slots-cache-failed-to-initialize.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix

use WARN_ONCE return value, fix grammar in message

Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/swap_slots.c~swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix mm/swap_slots.c
--- a/mm/swap_slots.c~swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix
+++ a/mm/swap_slots.c
@@ -241,11 +241,10 @@ int enable_swap_slots_cache(void)
 
 	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "swap_slots_cache",
 				alloc_swap_slot_cache, free_slot_cache);
-	if (ret < 0) {
-		WARN_ONCE(1, "Cache allocation failed (%s), operate without swap slots cache.\n",
-				__func__);
+	if (WARN_ONCE(ret < 0, "Cache allocation failed (%s), operating "
+			       "without swap slots cache.\n", __func__))
 		goto out_unlock;
-	}
+
 	swap_slot_cache_initialized = true;
 	__reenable_swap_slots_cache();
 out_unlock:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

swap-add-warning-if-swap-slots-cache-failed-to-initialize.patch


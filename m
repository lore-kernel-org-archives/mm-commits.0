From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch removed from -mm tree
Date: Wed, 15 Nov 2017 16:58:09 -0800
Message-ID: <5a0ce2a1.4jOF9vNxMOTVfF46%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35726 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758657AbdKPA6K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 19:58:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch

This patch was dropped because it was folded into mm-swap-fix-race-conditions-in-swap_slots-cache-init.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix

tidy up comment

Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/swap_slots.c~mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix mm/swap_slots.c
--- a/mm/swap_slots.c~mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix
+++ a/mm/swap_slots.c
@@ -150,11 +150,10 @@ static int alloc_swap_slot_cache(unsigne
 	cache->cur = 0;
 	cache->n_ret = 0;
 	/*
-	 * We intialized alloc_lock and free_lock earlier.
-	 * We use !cache->slots or !cache->slots_ret
-	 * to know if it is safe to acquire the corresponding
-	 * lock and use the cache.  Memory barrier
-	 * below ensures the assumption.
+	 * We intialized alloc_lock and free_lock earlier.  We use
+	 * !cache->slots or !cache->slots_ret to know if it is safe to acquire
+	 * the corresponding lock and use the cache.  Memory barrier below
+	 * ensures the assumption.
 	 */
 	mb();
 	cache->slots = slots;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
mm-simplify-nodemask-printing-fix.patch
mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix.patch


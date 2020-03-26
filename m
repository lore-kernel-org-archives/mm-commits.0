From: akpm@linux-foundation.org
Subject: [merged]
 mm-mmu_notifier-silence-prove_rcu_list-warnings.patch removed from -mm tree
Date: Thu, 26 Mar 2020 11:16:14 -0700
Message-ID: <20200326181614.YPvNcclO2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbgCZSQP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 26 Mar 2020 14:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, jgg@mellanox.com, mm-commits@vger.kernel.org, paulmck@kernel.org


The patch titled
     Subject: mm/mmu_notifier: silence PROVE_RCU_LIST warnings
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-silence-prove_rcu_list-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/mmu_notifier: silence PROVE_RCU_LIST warnings

It is safe to traverse mm->notifier_subscriptions->list either under SRCU
read lock or mm->notifier_subscriptions->lock using
hlist_for_each_entry_rcu().  Silence the PROVE_RCU_LIST false positives,
for example,

 WARNING: suspicious RCU usage
 -----------------------------
 mm/mmu_notifier.c:484 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 3 locks held by libvirtd/802:
  #0: ffff9321e3f58148 (&mm->mmap_sem#2){++++}, at: do_mprotect_pkey+0xe1/0x3e0
  #1: ffffffff91ae6160 (mmu_notifier_invalidate_range_start){+.+.}, at: change_p4d_range+0x5fa/0x800
  #2: ffffffff91ae6e08 (srcu){....}, at: __mmu_notifier_invalidate_range_start+0x178/0x460

 stack backtrace:
 CPU: 7 PID: 802 Comm: libvirtd Tainted: G          I       5.6.0-rc6-next-20200317+ #2
 Hardware name: HP ProLiant BL460c Gen8, BIOS I31 11/02/2014
 Call Trace:
  dump_stack+0xa4/0xfe
  lockdep_rcu_suspicious+0xeb/0xf5
  __mmu_notifier_invalidate_range_start+0x3ff/0x460
  change_p4d_range+0x746/0x800
  change_protection+0x1df/0x300
  mprotect_fixup+0x245/0x3e0
  do_mprotect_pkey+0x23b/0x3e0
  __x64_sys_mprotect+0x51/0x70
  do_syscall_64+0x91/0xae8
  entry_SYSCALL_64_after_hwframe+0x49/0xb3

Link: http://lkml.kernel.org/r/20200317175640.2047-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/mm/mmu_notifier.c~mm-mmu_notifier-silence-prove_rcu_list-warnings
+++ a/mm/mmu_notifier.c
@@ -307,7 +307,8 @@ static void mn_hlist_release(struct mmu_
 	 * ->release returns.
 	 */
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist)
+	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
+				 srcu_read_lock_held(&srcu))
 		/*
 		 * If ->release runs before mmu_notifier_unregister it must be
 		 * handled, as it's the only way for the driver to flush all
@@ -370,7 +371,8 @@ int __mmu_notifier_clear_flush_young(str
 
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_rcu(subscription,
-				 &mm->notifier_subscriptions->list, hlist) {
+				 &mm->notifier_subscriptions->list, hlist,
+				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->clear_flush_young)
 			young |= subscription->ops->clear_flush_young(
 				subscription, mm, start, end);
@@ -389,7 +391,8 @@ int __mmu_notifier_clear_young(struct mm
 
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_rcu(subscription,
-				 &mm->notifier_subscriptions->list, hlist) {
+				 &mm->notifier_subscriptions->list, hlist,
+				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->clear_young)
 			young |= subscription->ops->clear_young(subscription,
 								mm, start, end);
@@ -407,7 +410,8 @@ int __mmu_notifier_test_young(struct mm_
 
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_rcu(subscription,
-				 &mm->notifier_subscriptions->list, hlist) {
+				 &mm->notifier_subscriptions->list, hlist,
+				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->test_young) {
 			young = subscription->ops->test_young(subscription, mm,
 							      address);
@@ -428,7 +432,8 @@ void __mmu_notifier_change_pte(struct mm
 
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_rcu(subscription,
-				 &mm->notifier_subscriptions->list, hlist) {
+				 &mm->notifier_subscriptions->list, hlist,
+				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->change_pte)
 			subscription->ops->change_pte(subscription, mm, address,
 						      pte);
@@ -476,7 +481,8 @@ static int mn_hlist_invalidate_range_sta
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist) {
+	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
+				 srcu_read_lock_held(&srcu)) {
 		const struct mmu_notifier_ops *ops = subscription->ops;
 
 		if (ops->invalidate_range_start) {
@@ -528,7 +534,8 @@ mn_hlist_invalidate_end(struct mmu_notif
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist) {
+	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
+				 srcu_read_lock_held(&srcu)) {
 		/*
 		 * Call invalidate_range here too to avoid the need for the
 		 * subsystem of having to register an invalidate_range_end
@@ -582,7 +589,8 @@ void __mmu_notifier_invalidate_range(str
 
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_rcu(subscription,
-				 &mm->notifier_subscriptions->list, hlist) {
+				 &mm->notifier_subscriptions->list, hlist,
+				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->invalidate_range)
 			subscription->ops->invalidate_range(subscription, mm,
 							    start, end);
@@ -714,7 +722,8 @@ find_get_mmu_notifier(struct mm_struct *
 
 	spin_lock(&mm->notifier_subscriptions->lock);
 	hlist_for_each_entry_rcu(subscription,
-				 &mm->notifier_subscriptions->list, hlist) {
+				 &mm->notifier_subscriptions->list, hlist,
+				 lockdep_is_held(&mm->notifier_subscriptions->lock)) {
 		if (subscription->ops != ops)
 			continue;
 
_

Patches currently in -mm which might be from cai@lca.pw are

mm-disable-kcsan-for-kmemleak.patch
mm-swapfile-fix-data-races-in-try_to_unuse.patch
kasan-detect-negative-size-in-memory-operation-function-fix.patch
mm-vmscan-fix-data-races-at-kswapd_classzone_idx.patch
percpu_counter-fix-a-data-race-at-vm_committed_as.patch
mm-kmemleak-silence-kcsan-splats-in-checksum.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch

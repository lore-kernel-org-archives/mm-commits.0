From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-swap-add-cache-for-swap-slots-allocation-fix.patch removed from -mm tree
Date: Wed, 22 Feb 2017 15:26:48 -0800
Message-ID: <58ae1e38.XphsLRRKybM5pJOZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47088 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933949AbdBVX0u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:26:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, mhocko@kernel.org, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: Use raw_cpu_ptr over this_cpu_ptr for swap slots access
has been removed from the -mm tree.  Its filename was
     mm-swap-add-cache-for-swap-slots-allocation-fix.patch

This patch was dropped because it was folded into mm-swap-add-cache-for-swap-slots-allocation.patch

------------------------------------------------------
From: "Huang, Ying" <ying.huang@intel.com>
Subject: mm/swap: Use raw_cpu_ptr over this_cpu_ptr for swap slots access

The usage of this_cpu_ptr in get_swap_page causes a bug warning
as it is used in pre-emptible code.

[   57.812314] BUG: using smp_processor_id() in preemptible [00000000] code=
: kswapd0/527
[   57.814360] caller is debug_smp_processor_id+0x17/0x19
[   57.815237] CPU: 1 PID: 527 Comm: kswapd0 Tainted: G        W 4.9.0-mmot=
m-00135-g4e9a9895ebef #1042
[   57.816019] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.10.1-1 04/01/2014
[   57.816019]  ffffc900001939c0 ffffffff81329c60 0000000000000001 ffffffff=
81a0ce06
[   57.816019]  ffffc900001939f0 ffffffff81343c2a 00000000000137a0 ffffea00=
00dfd2a0
[   57.816019]  ffff88003c49a700 ffffc90000193b10 ffffc90000193a00 ffffffff=
81343c53
[   57.816019] Call Trace:
[   57.816019]  [<ffffffff81329c60>] dump_stack+0x68/0x92
[   57.816019]  [<ffffffff81343c2a>] check_preemption_disabled+0xce/0xe0
[   57.816019]  [<ffffffff81343c53>] debug_smp_processor_id+0x17/0x19
[   57.816019]  [<ffffffff8115f06f>] get_swap_page+0x19/0x183
[   57.816019]  [<ffffffff8114e01d>] shmem_writepage+0xce/0x38c
[   57.816019]  [<ffffffff81148916>] shrink_page_list+0x81f/0xdbf
[   57.816019]  [<ffffffff81149652>] shrink_inactive_list+0x2ab/0x594
[   57.816019]  [<ffffffff8114a22f>] shrink_node_memcg+0x4c7/0x673
[   57.816019]  [<ffffffff8114a49f>] shrink_node+0xc4/0x282
[   57.816019]  [<ffffffff8114a49f>] ? shrink_node+0xc4/0x282
[   57.816019]  [<ffffffff8114b8cb>] kswapd+0x656/0x834

Logic wise, We do allow pre-emption as per cpu ptr cache->slots is
protected by the mutex cache->alloc_lock.  We switch the
inappropriately used this_cpu_ptr to raw_cpu_ptr for per cpu ptr
access of cache->slots.

Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Reported-by: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/swap_slots.c~mm-swap-add-cache-for-swap-slots-allocation-fix mm/swap_slots.c
--- a/mm/swap_slots.c~mm-swap-add-cache-for-swap-slots-allocation-fix
+++ a/mm/swap_slots.c
@@ -303,7 +303,16 @@ swp_entry_t get_swap_page(void)
 	swp_entry_t entry, *pentry;
 	struct swap_slots_cache *cache;
 
-	cache = this_cpu_ptr(&swp_slots);
+	/*
+	 * Preemption is allowed here, because we may sleep
+	 * in refill_swap_slots_cache().  But it is safe, because
+	 * accesses to the per-CPU data structure are protected by the
+	 * mutex cache->alloc_lock.
+	 *
+	 * The alloc path here does not touch cache->slots_ret
+	 * so cache->free_lock is not taken.
+	 */
+	cache = raw_cpu_ptr(&swp_slots);
 
 	entry.val = 0;
 	if (check_cache_active()) {
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-kernel-message-in-swap_info_get.patch
mm-swap-add-cluster-lock.patch
mm-swap-split-swap-cache-into-64mb-trunks.patch
mm-swap-add-cache-for-swap-slots-allocation.patch
mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled.patch
mm-swap-skip-readahead-only-when-swap-slot-cache-is-enabled-fix.patch


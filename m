From: akpm@linux-foundation.org
Subject: - vm-statistics-make-timer-deferrable.patch removed from -mm tree
Date: Fri, 11 May 2007 22:32:54 -0700
Message-ID: <200705120532.l4C5WsZK002069@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756777AbXELFc6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:32:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     VM statistics: Make timer deferrable
has been removed from the -mm tree.  Its filename was
     vm-statistics-make-timer-deferrable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: VM statistics: Make timer deferrable
From: Christoph Lameter <clameter@sgi.com>

VM statistics updates do not matter if the kernel is in idle powersaving
mode.  So allow the timer to be deferred.

It would be better though if we could switch the timer between deferrable
and nondeferrable based on differentials present.  The timer would start
out nondeferrable and if we find that there were no updates in the last
statistics interval then we would switch the timer to deferrable.  If the
timer later finds again that there are differentials then go to
nondeferrable again.

And yet another way would be to run the timer shortly before going to idle?

The solution here means that the VM counters may be slightly off during
idle since differentials may be still pending while the timer is deferred.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~vm-statistics-make-timer-deferrable mm/vmstat.c
--- a/mm/vmstat.c~vm-statistics-make-timer-deferrable
+++ a/mm/vmstat.c
@@ -698,7 +698,7 @@ static void __devinit start_cpu_timer(in
 {
 	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
 
-	INIT_DELAYED_WORK(vmstat_work, vmstat_update);
+	INIT_DELAYED_WORK_DEFERRABLE(vmstat_work, vmstat_update);
 	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
ubi-remove-inverted-check-in-ltree_entry_ctor.patch
quicklist-support-for-x86_64.patch
slub-i386-support.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch

From: akpm@linux-foundation.org
Subject: - slab-shutdown-cache_reaper-when-cpu-goes-down.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:18 -0700
Message-ID: <200705092152.l49LqIGH002985@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756758AbXEIVwr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     slab: shut down cache_reaper when cpu goes down
has been removed from the -mm tree.  Its filename was
     slab-shutdown-cache_reaper-when-cpu-goes-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: shut down cache_reaper when cpu goes down
From: Christoph Lameter <clameter@sgi.com>

Shutdown the cache_reaper if the cpu is brought down and set the
cache_reap.func to NULL.  Otherwise hotplug shuts down the reaper for good.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN mm/slab.c~slab-shutdown-cache_reaper-when-cpu-goes-down mm/slab.c
--- a/mm/slab.c~slab-shutdown-cache_reaper-when-cpu-goes-down
+++ a/mm/slab.c
@@ -1279,6 +1279,20 @@ static int __cpuinit cpuup_callback(stru
 		start_cpu_timer(cpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
+  	case CPU_DOWN_PREPARE:
+		/*
+		 * Shutdown cache reaper. Note that the cache_chain_mutex is
+		 * held so that if cache_reap() is invoked it cannot do
+		 * anything expensive but will only modify reap_work
+		 * and reschedule the timer.
+		*/
+		cancel_rearming_delayed_work(&per_cpu(reap_work, cpu));
+		/* Now the cache_reaper is guaranteed to be not running. */
+		per_cpu(reap_work, cpu).work.func = NULL;
+  		break;
+  	case CPU_DOWN_FAILED:
+		start_cpu_timer(cpu);
+  		break;
 	case CPU_DEAD:
 		/*
 		 * Even if all the cpus of a node are down, we don't free the
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch

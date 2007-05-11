From: akpm@linux-foundation.org
Subject: - forcedeth-improve-napi-logic.patch removed from -mm tree
Date: Fri, 11 May 2007 00:18:41 -0700
Message-ID: <200705110718.l4B7IfqG009541@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbXEKHSy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 03:18:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: improve NAPI logic
has been removed from the -mm tree.  Its filename was
     forcedeth-improve-napi-logic.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: forcedeth: improve NAPI logic
From: Ingo Molnar <mingo@elte.hu>

Another forcedeth.c thing: i noticed that its NAPI handler does not do
tx-ring processing.  The patch below implements this - tested on DESC_VER_2
hardware, with CONFIG_FORCEDETH_NAPI=y.


Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
---
Auke said:

the patch needs to be improved.

The following needs to be done when NAPI is enabled:
- remove the tx handling within the ISRs
- mask off the tx interrupts within the ISRs that handle tx processing
- re-enable tx interrupts within the NAPI handler
- add tx handling within the NAPI handler (this patch covers it)

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/net/forcedeth.c~forcedeth-improve-napi-logic drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-improve-napi-logic
+++ a/drivers/net/forcedeth.c
@@ -3111,9 +3111,17 @@ static int nv_napi_poll(struct net_devic
 	int retcode;
 
 	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
+		spin_lock_irqsave(&np->lock, flags);
+		nv_tx_done(dev);
+		spin_unlock_irqrestore(&np->lock, flags);
+
 		pkts = nv_rx_process(dev, limit);
 		retcode = nv_alloc_rx(dev);
 	} else {
+		spin_lock_irqsave(&np->lock, flags);
+		nv_tx_done_optimized(dev, np->tx_ring_size);
+		spin_unlock_irqrestore(&np->lock, flags);
+
 		pkts = nv_rx_process_optimized(dev, limit);
 		retcode = nv_alloc_rx_optimized(dev);
 	}
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
use-defines-in-sys_getpriority-sys_setpriority.patch
forcedeth-improve-napi-logic.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
introduce-freezer-flags-rev-2.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
introduce-write_trylock_irqsave.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch

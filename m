From: akpm@osdl.org
Subject: - sched-domain-increase-the-smt-busy-rebalance-interval.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:53:20 -0800
Message-ID: <200612130653.kBD6rKoJ030520@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57502 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964997AbWLMGxY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:53:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     sched domain: increase the SMT busy rebalance interval
has been removed from the -mm tree.  Its filename was
     sched-domain-increase-the-smt-busy-rebalance-interval.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched domain: increase the SMT busy rebalance interval
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

With SMT, if the logical processor is busy, load balance happens for every
8msec(min)-16msec(max).  There is no need to do this often, as this is just
for fairness(to maintain uniform runqueue lengths) and default time slice
anyhow is 100msec.

Appended patch increases this interval to 64msec(min)-128msec(max) when the
logical processor is busy.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/topology.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/topology.h~sched-domain-increase-the-smt-busy-rebalance-interval include/linux/topology.h
--- a/include/linux/topology.h~sched-domain-increase-the-smt-busy-rebalance-interval
+++ a/include/linux/topology.h
@@ -93,7 +93,7 @@
 	.groups			= NULL,			\
 	.min_interval		= 1,			\
 	.max_interval		= 2,			\
-	.busy_factor		= 8,			\
+	.busy_factor		= 64,			\
 	.imbalance_pct		= 110,			\
 	.cache_nice_tries	= 0,			\
 	.per_cpu_gain		= 25,			\
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
optimize-calc_load.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch


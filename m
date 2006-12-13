From: akpm@osdl.org
Subject: - user-of-the-jiffies-rounding-patch-slab.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:36 -0800
Message-ID: <200612130655.kBD6tah9030655@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57796 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965022AbWLMGzi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     user of the jiffies rounding patch: Slab
has been removed from the -mm tree.  Its filename was
     user-of-the-jiffies-rounding-patch-slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: user of the jiffies rounding patch: Slab
From: Arjan van de Ven <arjan@linux.intel.com>

This patch introduces users of the round_jiffies() function in the slab code.

The slab code has a few "run every second" timers for background work; these
are obviously not timing critical as long as they happen roughly at the right
frequency.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/slab.c~user-of-the-jiffies-rounding-patch-slab mm/slab.c
--- a/mm/slab.c~user-of-the-jiffies-rounding-patch-slab
+++ a/mm/slab.c
@@ -946,7 +946,8 @@ static void __devinit start_cpu_timer(in
 	if (keventd_up() && reap_work->work.func == NULL) {
 		init_reap_node(cpu);
 		INIT_DELAYED_WORK(reap_work, cache_reap);
-		schedule_delayed_work_on(cpu, reap_work, HZ + 3 * cpu);
+		schedule_delayed_work_on(cpu, reap_work,
+					__round_jiffies_relative(HZ, cpu));
 	}
 }
 
@@ -4006,7 +4007,7 @@ static void cache_reap(struct work_struc
 	if (!mutex_trylock(&cache_chain_mutex)) {
 		/* Give up. Setup the next iteration. */
 		schedule_delayed_work(&__get_cpu_var(reap_work),
-				      REAPTIMEOUT_CPUC);
+				      round_jiffies_relative(REAPTIMEOUT_CPUC));
 		return;
 	}
 
@@ -4052,7 +4053,8 @@ next:
 	next_reap_node();
 	refresh_cpu_vm_stats(smp_processor_id());
 	/* Set up the next iteration */
-	schedule_delayed_work(&__get_cpu_var(reap_work), REAPTIMEOUT_CPUC);
+	schedule_delayed_work(&__get_cpu_var(reap_work),
+		round_jiffies_relative(REAPTIMEOUT_CPUC));
 }
 
 #ifdef CONFIG_PROC_FS
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
user-of-the-jiffies-rounding-code-networking.patch


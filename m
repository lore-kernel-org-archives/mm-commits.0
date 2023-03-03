Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084D0C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 22:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjCCWpY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 17:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbjCCWpX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 17:45:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95BB5251
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 14:44:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 969F9B81A40
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 22:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515D5C433D2;
        Fri,  3 Mar 2023 22:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677882760;
        bh=e2V/Y3MIjRJru4lU6sDcVJMaBMzN63idzSux7l6o6v4=;
        h=Date:To:From:Subject:From;
        b=rcZZJBDdYKY/j86ST1PfLnhMICLj7z9W89pseTELnUMIRe1TWjR1U/1q6c+B6M7J2
         Zb07EVAHtw3/52PgduUfyyEWUaX4SllWTrViHNUK4npECJ4rfX8AfivMfq9dctvPNr
         muf0hojbY+KPudCAMUGK9VxhFx2BW1geqURb2Cq4=
Date:   Fri, 03 Mar 2023 14:32:39 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, peterx@redhat.com,
        mingo@elte.hu, linux@armlinux.org.uk, hpa@zytor.com,
        hca@linux.ibm.com, frederic@kernel.org, david@redhat.com,
        cl@linux.com, chenhuacai@kernel.org, atomlin@atomlin.com,
        mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-switch-counter-modification-to-cmpxchg.patch added to mm-unstable branch
Message-Id: <20230303223240.515D5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: switch counter modification to cmpxchg
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-switch-counter-modification-to-cmpxchg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-switch-counter-modification-to-cmpxchg.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: mm/vmstat: switch counter modification to cmpxchg
Date: Fri, 03 Mar 2023 16:58:49 -0300

In preparation for switching vmstat shepherd to flush per-CPU counters
remotely, switch the __{mod,inc,dec} functions that modify the counters to
use cmpxchg.

To facilitate reviewing, functions are ordered in the text file, as:

__{mod,inc,dec}_{zone,node}_page_state
#ifdef CONFIG_HAVE_CMPXCHG_LOCAL
{mod,inc,dec}_{zone,node}_page_state
#else
{mod,inc,dec}_{zone,node}_page_state
#endif

This patch defines the __ versions for the
CONFIG_HAVE_CMPXCHG_LOCAL case to be their non-"__" counterparts:

#ifdef CONFIG_HAVE_CMPXCHG_LOCAL
{mod,inc,dec}_{zone,node}_page_state
__{mod,inc,dec}_{zone,node}_page_state = {mod,inc,dec}_{zone,node}_page_state
#else
{mod,inc,dec}_{zone,node}_page_state
__{mod,inc,dec}_{zone,node}_page_state
#endif

To test the performance difference, a page allocator microbenchmark:
https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/mm/bench/page_bench01.c
with loops=1000000 was used, on Intel Core i7-11850H @ 2.50GHz.

For the single_page_alloc_free test, which does

        /** Loop to measure **/
        for (i = 0; i < rec->loops; i++) {
                my_page = alloc_page(gfp_mask);
                if (unlikely(my_page == NULL))
                        return 0;
                __free_page(my_page);
        }

Unit is cycles.

Vanilla			Patched		Diff
115.25			117		1.4%

Link: https://lkml.kernel.org/r/20230303195908.952010050@redhat.com
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Xu <peterx@redhat.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~mm-vmstat-switch-counter-modification-to-cmpxchg
+++ a/mm/page_alloc.c
@@ -8539,9 +8539,6 @@ static int page_alloc_cpu_dead(unsigned
 	/*
 	 * Zero the differential counters of the dead processor
 	 * so that the vm statistics are consistent.
-	 *
-	 * This is only okay since the processor is dead and cannot
-	 * race with what we are doing.
 	 */
 	cpu_vm_stats_fold(cpu);
 
--- a/mm/vmstat.c~mm-vmstat-switch-counter-modification-to-cmpxchg
+++ a/mm/vmstat.c
@@ -334,6 +334,188 @@ void set_pgdat_percpu_threshold(pg_data_
 	}
 }
 
+#ifdef CONFIG_HAVE_CMPXCHG_LOCAL
+/*
+ * If we have cmpxchg_local support then we do not need to incur the overhead
+ * that comes with local_irq_save/restore if we use this_cpu_cmpxchg.
+ *
+ * mod_state() modifies the zone counter state through atomic per cpu
+ * operations.
+ *
+ * Overstep mode specifies how overstep should handled:
+ *     0       No overstepping
+ *     1       Overstepping half of threshold
+ *     -1      Overstepping minus half of threshold
+ */
+static inline void mod_zone_state(struct zone *zone, enum zone_stat_item item,
+				  long delta, int overstep_mode)
+{
+	struct per_cpu_zonestat __percpu *pcp = zone->per_cpu_zonestats;
+	s8 __percpu *p = pcp->vm_stat_diff + item;
+	long o, n, t, z;
+
+	do {
+		z = 0;  /* overflow to zone counters */
+
+		/*
+		 * The fetching of the stat_threshold is racy. We may apply
+		 * a counter threshold to the wrong the cpu if we get
+		 * rescheduled while executing here. However, the next
+		 * counter update will apply the threshold again and
+		 * therefore bring the counter under the threshold again.
+		 *
+		 * Most of the time the thresholds are the same anyways
+		 * for all cpus in a zone.
+		 */
+		t = this_cpu_read(pcp->stat_threshold);
+
+		o = this_cpu_read(*p);
+		n = delta + o;
+
+		if (abs(n) > t) {
+			int os = overstep_mode * (t >> 1);
+
+			/* Overflow must be added to zone counters */
+			z = n + os;
+			n = -os;
+		}
+	} while (this_cpu_cmpxchg(*p, o, n) != o);
+
+	if (z)
+		zone_page_state_add(z, zone, item);
+}
+
+void mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
+			 long delta)
+{
+	mod_zone_state(zone, item, delta, 0);
+}
+EXPORT_SYMBOL(mod_zone_page_state);
+
+void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
+			   long delta)
+{
+	mod_zone_state(zone, item, delta, 0);
+}
+EXPORT_SYMBOL(__mod_zone_page_state);
+
+void inc_zone_page_state(struct page *page, enum zone_stat_item item)
+{
+	mod_zone_state(page_zone(page), item, 1, 1);
+}
+EXPORT_SYMBOL(inc_zone_page_state);
+
+void __inc_zone_page_state(struct page *page, enum zone_stat_item item)
+{
+	mod_zone_state(page_zone(page), item, 1, 1);
+}
+EXPORT_SYMBOL(__inc_zone_page_state);
+
+void dec_zone_page_state(struct page *page, enum zone_stat_item item)
+{
+	mod_zone_state(page_zone(page), item, -1, -1);
+}
+EXPORT_SYMBOL(dec_zone_page_state);
+
+void __dec_zone_page_state(struct page *page, enum zone_stat_item item)
+{
+	mod_zone_state(page_zone(page), item, -1, -1);
+}
+EXPORT_SYMBOL(__dec_zone_page_state);
+
+static inline void mod_node_state(struct pglist_data *pgdat,
+				  enum node_stat_item item,
+				  int delta, int overstep_mode)
+{
+	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
+	s8 __percpu *p = pcp->vm_node_stat_diff + item;
+	long o, n, t, z;
+
+	if (vmstat_item_in_bytes(item)) {
+		/*
+		 * Only cgroups use subpage accounting right now; at
+		 * the global level, these items still change in
+		 * multiples of whole pages. Store them as pages
+		 * internally to keep the per-cpu counters compact.
+		 */
+		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
+		delta >>= PAGE_SHIFT;
+	}
+
+	do {
+		z = 0;  /* overflow to node counters */
+
+		/*
+		 * The fetching of the stat_threshold is racy. We may apply
+		 * a counter threshold to the wrong the cpu if we get
+		 * rescheduled while executing here. However, the next
+		 * counter update will apply the threshold again and
+		 * therefore bring the counter under the threshold again.
+		 *
+		 * Most of the time the thresholds are the same anyways
+		 * for all cpus in a node.
+		 */
+		t = this_cpu_read(pcp->stat_threshold);
+
+		o = this_cpu_read(*p);
+		n = delta + o;
+
+		if (abs(n) > t) {
+			int os = overstep_mode * (t >> 1);
+
+			/* Overflow must be added to node counters */
+			z = n + os;
+			n = -os;
+		}
+	} while (this_cpu_cmpxchg(*p, o, n) != o);
+
+	if (z)
+		node_page_state_add(z, pgdat, item);
+}
+
+void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
+					long delta)
+{
+	mod_node_state(pgdat, item, delta, 0);
+}
+EXPORT_SYMBOL(mod_node_page_state);
+
+void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
+					long delta)
+{
+	mod_node_state(pgdat, item, delta, 0);
+}
+EXPORT_SYMBOL(__mod_node_page_state);
+
+void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
+{
+	mod_node_state(pgdat, item, 1, 1);
+}
+
+void inc_node_page_state(struct page *page, enum node_stat_item item)
+{
+	mod_node_state(page_pgdat(page), item, 1, 1);
+}
+EXPORT_SYMBOL(inc_node_page_state);
+
+void __inc_node_page_state(struct page *page, enum node_stat_item item)
+{
+	mod_node_state(page_pgdat(page), item, 1, 1);
+}
+EXPORT_SYMBOL(__inc_node_page_state);
+
+void dec_node_page_state(struct page *page, enum node_stat_item item)
+{
+	mod_node_state(page_pgdat(page), item, -1, -1);
+}
+EXPORT_SYMBOL(dec_node_page_state);
+
+void __dec_node_page_state(struct page *page, enum node_stat_item item)
+{
+	mod_node_state(page_pgdat(page), item, -1, -1);
+}
+EXPORT_SYMBOL(__dec_node_page_state);
+#else
 /*
  * For use when we know that interrupts are disabled,
  * or when we know that preemption is disabled and that
@@ -541,149 +723,6 @@ void __dec_node_page_state(struct page *
 }
 EXPORT_SYMBOL(__dec_node_page_state);
 
-#ifdef CONFIG_HAVE_CMPXCHG_LOCAL
-/*
- * If we have cmpxchg_local support then we do not need to incur the overhead
- * that comes with local_irq_save/restore if we use this_cpu_cmpxchg.
- *
- * mod_state() modifies the zone counter state through atomic per cpu
- * operations.
- *
- * Overstep mode specifies how overstep should handled:
- *     0       No overstepping
- *     1       Overstepping half of threshold
- *     -1      Overstepping minus half of threshold
-*/
-static inline void mod_zone_state(struct zone *zone,
-       enum zone_stat_item item, long delta, int overstep_mode)
-{
-	struct per_cpu_zonestat __percpu *pcp = zone->per_cpu_zonestats;
-	s8 __percpu *p = pcp->vm_stat_diff + item;
-	long o, n, t, z;
-
-	do {
-		z = 0;  /* overflow to zone counters */
-
-		/*
-		 * The fetching of the stat_threshold is racy. We may apply
-		 * a counter threshold to the wrong the cpu if we get
-		 * rescheduled while executing here. However, the next
-		 * counter update will apply the threshold again and
-		 * therefore bring the counter under the threshold again.
-		 *
-		 * Most of the time the thresholds are the same anyways
-		 * for all cpus in a zone.
-		 */
-		t = this_cpu_read(pcp->stat_threshold);
-
-		o = this_cpu_read(*p);
-		n = delta + o;
-
-		if (abs(n) > t) {
-			int os = overstep_mode * (t >> 1) ;
-
-			/* Overflow must be added to zone counters */
-			z = n + os;
-			n = -os;
-		}
-	} while (this_cpu_cmpxchg(*p, o, n) != o);
-
-	if (z)
-		zone_page_state_add(z, zone, item);
-}
-
-void mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
-			 long delta)
-{
-	mod_zone_state(zone, item, delta, 0);
-}
-EXPORT_SYMBOL(mod_zone_page_state);
-
-void inc_zone_page_state(struct page *page, enum zone_stat_item item)
-{
-	mod_zone_state(page_zone(page), item, 1, 1);
-}
-EXPORT_SYMBOL(inc_zone_page_state);
-
-void dec_zone_page_state(struct page *page, enum zone_stat_item item)
-{
-	mod_zone_state(page_zone(page), item, -1, -1);
-}
-EXPORT_SYMBOL(dec_zone_page_state);
-
-static inline void mod_node_state(struct pglist_data *pgdat,
-       enum node_stat_item item, int delta, int overstep_mode)
-{
-	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
-	long o, n, t, z;
-
-	if (vmstat_item_in_bytes(item)) {
-		/*
-		 * Only cgroups use subpage accounting right now; at
-		 * the global level, these items still change in
-		 * multiples of whole pages. Store them as pages
-		 * internally to keep the per-cpu counters compact.
-		 */
-		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
-		delta >>= PAGE_SHIFT;
-	}
-
-	do {
-		z = 0;  /* overflow to node counters */
-
-		/*
-		 * The fetching of the stat_threshold is racy. We may apply
-		 * a counter threshold to the wrong the cpu if we get
-		 * rescheduled while executing here. However, the next
-		 * counter update will apply the threshold again and
-		 * therefore bring the counter under the threshold again.
-		 *
-		 * Most of the time the thresholds are the same anyways
-		 * for all cpus in a node.
-		 */
-		t = this_cpu_read(pcp->stat_threshold);
-
-		o = this_cpu_read(*p);
-		n = delta + o;
-
-		if (abs(n) > t) {
-			int os = overstep_mode * (t >> 1) ;
-
-			/* Overflow must be added to node counters */
-			z = n + os;
-			n = -os;
-		}
-	} while (this_cpu_cmpxchg(*p, o, n) != o);
-
-	if (z)
-		node_page_state_add(z, pgdat, item);
-}
-
-void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
-					long delta)
-{
-	mod_node_state(pgdat, item, delta, 0);
-}
-EXPORT_SYMBOL(mod_node_page_state);
-
-void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
-{
-	mod_node_state(pgdat, item, 1, 1);
-}
-
-void inc_node_page_state(struct page *page, enum node_stat_item item)
-{
-	mod_node_state(page_pgdat(page), item, 1, 1);
-}
-EXPORT_SYMBOL(inc_node_page_state);
-
-void dec_node_page_state(struct page *page, enum node_stat_item item)
-{
-	mod_node_state(page_pgdat(page), item, -1, -1);
-}
-EXPORT_SYMBOL(dec_node_page_state);
-#else
 /*
  * Use interrupt disable to serialize counter updates
  */
_

Patches currently in -mm which might be from mtosatti@redhat.com are

mm-vmstat-remove-remote-node-draining.patch
this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-loongarch-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-s390-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch
convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch
mm-vmstat-switch-counter-modification-to-cmpxchg.patch
mm-vmstat-use-xchg-in-cpu_vm_stats_fold.patch
mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch
mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch


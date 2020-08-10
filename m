Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8924BC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 532342075D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026988;
	bh=FFWp6vhO/5WZdu31kDrhhlkhSejQbAV3dQtPDfOAsZc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mftJZKCvJZhOddTh+s2BIQu1listrBpYqVZyxrayrprv3n8eDoI8IcoQZ4OGznVnK
	 LF33UHjJyo2lbHSZx2/79158pWmjcWaQOU+GvnwOJIVik14tri3RD1/YAT8+yooRML
	 ROqTJbpiXlaAh4SzMxhx+pTCzX4JRjYLkwYuJX0Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgHJCg2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCg1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:27 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFABE206CD;
        Mon, 10 Aug 2020 02:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026986;
        bh=FFWp6vhO/5WZdu31kDrhhlkhSejQbAV3dQtPDfOAsZc=;
        h=Date:From:To:Subject:From;
        b=WDXzg1R8X3nwXQJa9wUZW4QKQyq5bh8TB8G2BooWgH4AuQoT3vfiQLVaLUX7SyR8M
         ghR/LxdXkLyazG0wgqPxL87eEWRklhK3yIW9RAFlauLJaNfbTPuGMtxxWo3gSOSRBP
         8bhAzStNsydhH83IGFa17/QQWuBbU51S293xUC9E=
Date:   Sun, 09 Aug 2020 19:36:25 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-?=
 =?US-ASCII?Q?=5F=5Fmod=5Flruvec=5Fstate.patch?= removed from -mm tree
Message-ID: <20200810023625.8f_jB3cfz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: factor out memcg- and lruvec-level changes out of __mod_lruvec_state()
has been removed from the -mm tree.  Its filename was
     mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg: factor out memcg- and lruvec-level changes out of __mod_lruvec_state()

Patch series "The new cgroup slab memory controller", v7.

The patchset moves the accounting from the page level to the object level.
It allows to share slab pages between memory cgroups.  This leads to a
significant win in the slab utilization (up to 45%) and the corresponding
drop in the total kernel memory footprint.  The reduced number of
unmovable slab pages should also have a positive effect on the memory
fragmentation.

The patchset makes the slab accounting code simpler: there is no more need
in the complicated dynamic creation and destruction of per-cgroup slab
caches, all memory cgroups use a global set of shared slab caches.  The
lifetime of slab caches is not more connected to the lifetime of memory
cgroups.

The more precise accounting does require more CPU, however in practice the
difference seems to be negligible.  We've been using the new slab
controller in Facebook production for several months with different
workloads and haven't seen any noticeable regressions.  What we've seen
were memory savings in order of 1 GB per host (it varied heavily depending
on the actual workload, size of RAM, number of CPUs, memory pressure,
etc).

The third version of the patchset added yet another step towards the
simplification of the code: sharing of slab caches between accounted and
non-accounted allocations.  It comes with significant upsides (most
noticeable, a complete elimination of dynamic slab caches creation) but
not without some regression risks, so this change sits on top of the
patchset and is not completely merged in.  So in the unlikely event of a
noticeable performance regression it can be reverted separately.

The slab memory accounting works in exactly the same way for SLAB and
SLUB.  With both allocators the new controller shows significant memory
savings, with SLUB the difference is bigger.  On my 16-core desktop
machine running Fedora 32 the size of the slab memory measured after the
start of the system was lower by 58% and 38% with SLUB and SLAB
correspondingly.

As an estimation of a potential CPU overhead, below are results of
slab_bulk_test01 test, kindly provided by Jesper D.  Brouer.  He also
helped with the evaluation of results.

The test can be found here: https://github.com/netoptimizer/prototype-kernel/
The smallest number in each row should be picked for a comparison.

SLUB-patched - bulk-API
 - SLUB-patched : bulk_quick_reuse objects=1 : 187 -  90 - 224  cycles(tsc)
 - SLUB-patched : bulk_quick_reuse objects=2 : 110 -  53 - 133  cycles(tsc)
 - SLUB-patched : bulk_quick_reuse objects=3 :  88 -  95 -  42  cycles(tsc)
 - SLUB-patched : bulk_quick_reuse objects=4 :  91 -  85 -  36  cycles(tsc)
 - SLUB-patched : bulk_quick_reuse objects=8 :  32 -  66 -  32  cycles(tsc)

SLUB-original -  bulk-API
 - SLUB-original: bulk_quick_reuse objects=1 :  87 -  87 - 142  cycles(tsc)
 - SLUB-original: bulk_quick_reuse objects=2 :  52 -  53 -  53  cycles(tsc)
 - SLUB-original: bulk_quick_reuse objects=3 :  42 -  42 -  91  cycles(tsc)
 - SLUB-original: bulk_quick_reuse objects=4 :  91 -  37 -  37  cycles(tsc)
 - SLUB-original: bulk_quick_reuse objects=8 :  31 -  79 -  76  cycles(tsc)

SLAB-patched -  bulk-API
 - SLAB-patched : bulk_quick_reuse objects=1 :  67 -  67 - 140  cycles(tsc)
 - SLAB-patched : bulk_quick_reuse objects=2 :  55 -  46 -  46  cycles(tsc)
 - SLAB-patched : bulk_quick_reuse objects=3 :  93 -  94 -  39  cycles(tsc)
 - SLAB-patched : bulk_quick_reuse objects=4 :  35 -  88 -  85  cycles(tsc)
 - SLAB-patched : bulk_quick_reuse objects=8 :  30 -  30 -  30  cycles(tsc)

SLAB-original-  bulk-API
 - SLAB-original: bulk_quick_reuse objects=1 : 143 - 136 -  67  cycles(tsc)
 - SLAB-original: bulk_quick_reuse objects=2 :  45 -  46 -  46  cycles(tsc)
 - SLAB-original: bulk_quick_reuse objects=3 :  38 -  39 -  39  cycles(tsc)
 - SLAB-original: bulk_quick_reuse objects=4 :  35 -  87 -  87  cycles(tsc)
 - SLAB-original: bulk_quick_reuse objects=8 :  29 -  66 -  30  cycles(tsc)


This patch (of 19):

To convert memcg and lruvec slab counters to bytes there must be a way to
change these counters without touching node counters.  Factor out
__mod_memcg_lruvec_state() out of __mod_lruvec_state().

Link: http://lkml.kernel.org/r/20200623174037.3951353-1-guro@fb.com
Link: http://lkml.kernel.org/r/20200623174037.3951353-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 +++++++++++++
 mm/memcontrol.c            |   43 +++++++++++++++++++----------------
 2 files changed, 41 insertions(+), 19 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state
+++ a/include/linux/memcontrol.h
@@ -679,11 +679,23 @@ static inline unsigned long lruvec_page_
 	return x;
 }
 
+void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			      int val);
 void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val);
 void mod_memcg_obj_state(void *p, int idx, int val);
 
+static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
+					  enum node_stat_item idx, int val)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__mod_memcg_lruvec_state(lruvec, idx, val);
+	local_irq_restore(flags);
+}
+
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
 {
@@ -1057,6 +1069,11 @@ static inline unsigned long lruvec_page_
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+					    enum node_stat_item idx, int val)
+{
+}
+
 static inline void __mod_lruvec_state(struct lruvec *lruvec,
 				      enum node_stat_item idx, int val)
 {
--- a/mm/memcontrol.c~mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state
+++ a/mm/memcontrol.c
@@ -713,30 +713,13 @@ parent_nodeinfo(struct mem_cgroup_per_no
 	return mem_cgroup_nodeinfo(parent, nid);
 }
 
-/**
- * __mod_lruvec_state - update lruvec memory statistics
- * @lruvec: the lruvec
- * @idx: the stat item
- * @val: delta to add to the counter, can be negative
- *
- * The lruvec is the intersection of the NUMA node and a cgroup. This
- * function updates the all three counters that are affected by a
- * change of state at this level: per-node, per-cgroup, per-lruvec.
- */
-void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
-			int val)
+void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			      int val)
 {
-	pg_data_t *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
 	long x;
 
-	/* Update node */
-	__mod_node_page_state(pgdat, idx, val);
-
-	if (mem_cgroup_disabled())
-		return;
-
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	memcg = pn->memcg;
 
@@ -748,6 +731,7 @@ void __mod_lruvec_state(struct lruvec *l
 
 	x = val + __this_cpu_read(pn->lruvec_stat_cpu->count[idx]);
 	if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
+		pg_data_t *pgdat = lruvec_pgdat(lruvec);
 		struct mem_cgroup_per_node *pi;
 
 		for (pi = pn; pi; pi = parent_nodeinfo(pi, pgdat->node_id))
@@ -757,6 +741,27 @@ void __mod_lruvec_state(struct lruvec *l
 	__this_cpu_write(pn->lruvec_stat_cpu->count[idx], x);
 }
 
+/**
+ * __mod_lruvec_state - update lruvec memory statistics
+ * @lruvec: the lruvec
+ * @idx: the stat item
+ * @val: delta to add to the counter, can be negative
+ *
+ * The lruvec is the intersection of the NUMA node and a cgroup. This
+ * function updates the all three counters that are affected by a
+ * change of state at this level: per-node, per-cgroup, per-lruvec.
+ */
+void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			int val)
+{
+	/* Update node */
+	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+
+	/* Update memcg and lruvec */
+	if (!mem_cgroup_disabled())
+		__mod_memcg_lruvec_state(lruvec, idx, val);
+}
+
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
_

Patches currently in -mm which might be from guro@fb.com are

percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch


Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08457C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC76220723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026989;
	bh=C84+lfFlrZLc+VW73m7KngaMKLKNeBijCturnT8SOFA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1uzaaPRo1LnXQe1XmJcniSpqWVQpk1IYqf3kJ8cUwU1zxAL0gynbkKYbgoXErfkDI
	 cz4iQULBHexcP3Fa4csAPQNq7HdDgLzs8aXSqC0dIC3odgQDqNgnikgvYKSnXhlzGJ
	 lqIcYjYps7ql3tAX6qi6q2++YJ5Lo3irUD9puHck=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgHJCg3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCg2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B1F82065D;
        Mon, 10 Aug 2020 02:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026987;
        bh=C84+lfFlrZLc+VW73m7KngaMKLKNeBijCturnT8SOFA=;
        h=Date:From:To:Subject:From;
        b=NhiDMIneUsloQXKsocE3b02Zg8VHZf751BTVtO/a6+Q/AJ9ihaWKNumZXGu74/N+r
         jqDEyhFuVn+OWxMcW9LXxIdESkg56S2VqqWLNxyQHrhOfcMA5fUYRF08BFgInaoVNO
         62IVNymju+L6Ay6V7Uc3TAEwdNhMqxAcCbWqKy2c=
Date:   Sun, 09 Aug 2020 19:36:27 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  [merged]
 mm-memcg-prepare-for-byte-sized-vmstat-items.patch removed from -mm tree
Message-ID: <20200810023627.YARgGU8lF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: prepare for byte-sized vmstat items
has been removed from the -mm tree.  Its filename was
     mm-memcg-prepare-for-byte-sized-vmstat-items.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg: prepare for byte-sized vmstat items

To implement per-object slab memory accounting, we need to convert slab
vmstat counters to bytes.  Actually, out of 4 levels of counters: global,
per-node, per-memcg and per-lruvec only two last levels will require
byte-sized counters.  It's because global and per-node counters will be
counting the number of slab pages, and per-memcg and per-lruvec will be
counting the amount of memory taken by charged slab objects.

Converting all vmstat counters to bytes or even all slab counters to bytes
would introduce an additional overhead.  So instead let's store global and
per-node counters in pages, and memcg and lruvec counters in bytes.

To make the API clean all access helpers (both on the read and write
sides) are dealing with bytes.

To avoid back-and-forth conversions a new flavor of read-side helpers is
introduced, which always returns values in pages: node_page_state_pages()
and global_node_page_state_pages().

Actually new helpers are just reading raw values.  Old helpers are simple
wrappers, which will complain on an attempt to read byte value, because at
the moment no one actually needs bytes.

Thanks to Johannes Weiner for the idea of having the byte-sized API on top
of the page-sized internal storage.

Link: http://lkml.kernel.org/r/20200623174037.3951353-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    2 +-
 include/linux/mmzone.h |   10 ++++++++++
 include/linux/vmstat.h |   14 +++++++++++++-
 mm/memcontrol.c        |   14 ++++++++++----
 mm/vmstat.c            |   30 ++++++++++++++++++++++++++----
 5 files changed, 60 insertions(+), 10 deletions(-)

--- a/drivers/base/node.c~mm-memcg-prepare-for-byte-sized-vmstat-items
+++ a/drivers/base/node.c
@@ -513,7 +513,7 @@ static ssize_t node_read_vmstat(struct d
 
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 		n += sprintf(buf+n, "%s %lu\n", node_stat_name(i),
-			     node_page_state(pgdat, i));
+			     node_page_state_pages(pgdat, i));
 
 	return n;
 }
--- a/include/linux/mmzone.h~mm-memcg-prepare-for-byte-sized-vmstat-items
+++ a/include/linux/mmzone.h
@@ -207,6 +207,16 @@ enum node_stat_item {
 };
 
 /*
+ * Returns true if the value is measured in bytes (most vmstat values are
+ * measured in pages). This defines the API part, the internal representation
+ * might be different.
+ */
+static __always_inline bool vmstat_item_in_bytes(int idx)
+{
+	return false;
+}
+
+/*
  * We do arithmetic on the LRU lists in various places in the code,
  * so it is important to keep the active lists LRU_ACTIVE higher in
  * the array than the corresponding inactive lists, and to keep
--- a/include/linux/vmstat.h~mm-memcg-prepare-for-byte-sized-vmstat-items
+++ a/include/linux/vmstat.h
@@ -8,6 +8,7 @@
 #include <linux/vm_event_item.h>
 #include <linux/atomic.h>
 #include <linux/static_key.h>
+#include <linux/mmdebug.h>
 
 extern int sysctl_stat_interval;
 
@@ -192,7 +193,8 @@ static inline unsigned long global_zone_
 	return x;
 }
 
-static inline unsigned long global_node_page_state(enum node_stat_item item)
+static inline
+unsigned long global_node_page_state_pages(enum node_stat_item item)
 {
 	long x = atomic_long_read(&vm_node_stat[item]);
 #ifdef CONFIG_SMP
@@ -202,6 +204,13 @@ static inline unsigned long global_node_
 	return x;
 }
 
+static inline unsigned long global_node_page_state(enum node_stat_item item)
+{
+	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
+
+	return global_node_page_state_pages(item);
+}
+
 static inline unsigned long zone_page_state(struct zone *zone,
 					enum zone_stat_item item)
 {
@@ -242,9 +251,12 @@ extern unsigned long sum_zone_node_page_
 extern unsigned long sum_zone_numa_state(int node, enum numa_stat_item item);
 extern unsigned long node_page_state(struct pglist_data *pgdat,
 						enum node_stat_item item);
+extern unsigned long node_page_state_pages(struct pglist_data *pgdat,
+					   enum node_stat_item item);
 #else
 #define sum_zone_node_page_state(node, item) global_zone_page_state(item)
 #define node_page_state(node, item) global_node_page_state(item)
+#define node_page_state_pages(node, item) global_node_page_state_pages(item)
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_SMP
--- a/mm/memcontrol.c~mm-memcg-prepare-for-byte-sized-vmstat-items
+++ a/mm/memcontrol.c
@@ -681,13 +681,16 @@ mem_cgroup_largest_soft_limit_node(struc
  */
 void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val)
 {
-	long x;
+	long x, threshold = MEMCG_CHARGE_BATCH;
 
 	if (mem_cgroup_disabled())
 		return;
 
+	if (vmstat_item_in_bytes(idx))
+		threshold <<= PAGE_SHIFT;
+
 	x = val + __this_cpu_read(memcg->vmstats_percpu->stat[idx]);
-	if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
+	if (unlikely(abs(x) > threshold)) {
 		struct mem_cgroup *mi;
 
 		/*
@@ -718,7 +721,7 @@ void __mod_memcg_lruvec_state(struct lru
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
-	long x;
+	long x, threshold = MEMCG_CHARGE_BATCH;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	memcg = pn->memcg;
@@ -729,8 +732,11 @@ void __mod_memcg_lruvec_state(struct lru
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stat_local->count[idx], val);
 
+	if (vmstat_item_in_bytes(idx))
+		threshold <<= PAGE_SHIFT;
+
 	x = val + __this_cpu_read(pn->lruvec_stat_cpu->count[idx]);
-	if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
+	if (unlikely(abs(x) > threshold)) {
 		pg_data_t *pgdat = lruvec_pgdat(lruvec);
 		struct mem_cgroup_per_node *pi;
 
--- a/mm/vmstat.c~mm-memcg-prepare-for-byte-sized-vmstat-items
+++ a/mm/vmstat.c
@@ -341,6 +341,11 @@ void __mod_node_page_state(struct pglist
 	long x;
 	long t;
 
+	if (vmstat_item_in_bytes(item)) {
+		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
+		delta >>= PAGE_SHIFT;
+	}
+
 	x = delta + __this_cpu_read(*p);
 
 	t = __this_cpu_read(pcp->stat_threshold);
@@ -398,6 +403,8 @@ void __inc_node_state(struct pglist_data
 	s8 __percpu *p = pcp->vm_node_stat_diff + item;
 	s8 v, t;
 
+	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
+
 	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
@@ -442,6 +449,8 @@ void __dec_node_state(struct pglist_data
 	s8 __percpu *p = pcp->vm_node_stat_diff + item;
 	s8 v, t;
 
+	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
+
 	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
@@ -541,6 +550,11 @@ static inline void mod_node_state(struct
 	s8 __percpu *p = pcp->vm_node_stat_diff + item;
 	long o, n, t, z;
 
+	if (vmstat_item_in_bytes(item)) {
+		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
+		delta >>= PAGE_SHIFT;
+	}
+
 	do {
 		z = 0;  /* overflow to node counters */
 
@@ -989,8 +1003,8 @@ unsigned long sum_zone_numa_state(int no
 /*
  * Determine the per node value of a stat item.
  */
-unsigned long node_page_state(struct pglist_data *pgdat,
-				enum node_stat_item item)
+unsigned long node_page_state_pages(struct pglist_data *pgdat,
+				    enum node_stat_item item)
 {
 	long x = atomic_long_read(&pgdat->vm_stat[item]);
 #ifdef CONFIG_SMP
@@ -999,6 +1013,14 @@ unsigned long node_page_state(struct pgl
 #endif
 	return x;
 }
+
+unsigned long node_page_state(struct pglist_data *pgdat,
+			      enum node_stat_item item)
+{
+	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
+
+	return node_page_state_pages(pgdat, item);
+}
 #endif
 
 #ifdef CONFIG_COMPACTION
@@ -1577,7 +1599,7 @@ static void zoneinfo_show_print(struct s
 		seq_printf(m, "\n  per-node stats");
 		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
 			seq_printf(m, "\n      %-12s %lu", node_stat_name(i),
-				   node_page_state(pgdat, i));
+				   node_page_state_pages(pgdat, i));
 		}
 	}
 	seq_printf(m,
@@ -1698,7 +1720,7 @@ static void *vmstat_start(struct seq_fil
 #endif
 
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
-		v[i] = global_node_page_state(i);
+		v[i] = global_node_page_state_pages(i);
 	v += NR_VM_NODE_STAT_ITEMS;
 
 	global_dirty_limits(v + NR_DIRTY_BG_THRESHOLD,
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


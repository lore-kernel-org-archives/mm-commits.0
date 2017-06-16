From: akpm@linux-foundation.org
Subject: [failures]
 mm-memcontrol-per-lruvec-stats-infrastructure-fix-4.patch removed from -mm
 tree
Date: Fri, 16 Jun 2017 12:14:58 -0700
Message-ID: <59442e32.BY07kp9DuKDQGtIO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41314 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751739AbdFPTPJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 15:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, private@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-per-lruvec-stats-infrastructure-fix-4
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-per-lruvec-stats-infrastructure-fix-4.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-memcontrol-per-lruvec-stats-infrastructure-fix-4

On Wed, Jun 14, 2017 at 12:26:46AM -0700, Guenter Roeck wrote:
> Hi,
>
> I see the following build error in -next when building hexagon images.
>
>   CC      arch/hexagon/kernel/asm-offsets.s
> In file included from ./include/linux/memcontrol.h:30:0,
>                  from ./include/linux/swap.h:8,
>                  from ./arch/hexagon/include/asm/pgtable.h:27,
>                  from ./include/linux/mm.h:70,
>                  from arch/hexagon/kernel/asm-offsets.c:28:
> ./include/linux/vmstat.h: In function '__inc_zone_page_state':
> ./include/linux/vmstat.h:294:2: error: implicit declaration of function 'page_zone' [-Werror=implicit-function-declaration]
> ./include/linux/vmstat.h:294:2: warning: passing argument 1 of '__inc_zone_state' makes pointer from integer without a cast [enabled by default]
> ./include/linux/vmstat.h:267:20: note: expected 'struct zone *' but argument is of type 'int'

vmstat.h depends on definitions in mm.h, but mm.h through the above
chain includes vmstat.h first. It worked in my x86 test because x86
pgtable.h doesn't include swap.h.

The headers are a bit of a mess. memcontrol.h is supposed to be a
lower level header than mm.h and vmstat.h, yet the new accounting
functions depend on mm.h definitions.

Let's move the lruvec accounting infra to vmstat.h and shuffle
memcontrol.h into the stack under mm.h and vmstat.h.

Reported-by: Guenter Roeck <private@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |  152 ----------------------------------
 include/linux/vmstat.h     |  153 +++++++++++++++++++++++++++++++++++
 2 files changed, 153 insertions(+), 152 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-per-lruvec-stats-infrastructure-fix-4 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-per-lruvec-stats-infrastructure-fix-4
+++ a/include/linux/memcontrol.h
@@ -26,8 +26,6 @@
 #include <linux/page_counter.h>
 #include <linux/vmpressure.h>
 #include <linux/eventfd.h>
-#include <linux/mm.h>
-#include <linux/vmstat.h>
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
 
@@ -547,78 +545,6 @@ static inline void mod_memcg_page_state(
 		mod_memcg_state(page->mem_cgroup, idx, val);
 }
 
-static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
-					      enum node_stat_item idx)
-{
-	struct mem_cgroup_per_node *pn;
-	long val = 0;
-	int cpu;
-
-	if (mem_cgroup_disabled())
-		return node_page_state(lruvec_pgdat(lruvec), idx);
-
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	for_each_possible_cpu(cpu)
-		val += per_cpu(pn->lruvec_stat->count[idx], cpu);
-
-	if (val < 0)
-		val = 0;
-
-	return val;
-}
-
-static inline void __mod_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx, int val)
-{
-	struct mem_cgroup_per_node *pn;
-
-	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
-	if (mem_cgroup_disabled())
-		return;
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	__mod_memcg_state(pn->memcg, idx, val);
-	__this_cpu_add(pn->lruvec_stat->count[idx], val);
-}
-
-static inline void mod_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx, int val)
-{
-	struct mem_cgroup_per_node *pn;
-
-	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
-	if (mem_cgroup_disabled())
-		return;
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	mod_memcg_state(pn->memcg, idx, val);
-	this_cpu_add(pn->lruvec_stat->count[idx], val);
-}
-
-static inline void __mod_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx, int val)
-{
-	struct mem_cgroup_per_node *pn;
-
-	__mod_node_page_state(page_pgdat(page), idx, val);
-	if (mem_cgroup_disabled() || !page->mem_cgroup)
-		return;
-	__mod_memcg_state(page->mem_cgroup, idx, val);
-	pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
-	__this_cpu_add(pn->lruvec_stat->count[idx], val);
-}
-
-static inline void mod_lruvec_page_state(struct page *page,
-					 enum node_stat_item idx, int val)
-{
-	struct mem_cgroup_per_node *pn;
-
-	mod_node_page_state(page_pgdat(page), idx, val);
-	if (mem_cgroup_disabled() || !page->mem_cgroup)
-		return;
-	mod_memcg_state(page->mem_cgroup, idx, val);
-	pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
-	this_cpu_add(pn->lruvec_stat->count[idx], val);
-}
-
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
@@ -869,36 +795,6 @@ static inline void mod_memcg_page_state(
 {
 }
 
-static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
-					      enum node_stat_item idx)
-{
-	return node_page_state(lruvec_pgdat(lruvec), idx);
-}
-
-static inline void __mod_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx, int val)
-{
-	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
-}
-
-static inline void mod_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx, int val)
-{
-	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
-}
-
-static inline void __mod_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx, int val)
-{
-	__mod_node_page_state(page_pgdat(page), idx, val);
-}
-
-static inline void mod_lruvec_page_state(struct page *page,
-					 enum node_stat_item idx, int val)
-{
-	mod_node_page_state(page_pgdat(page), idx, val);
-}
-
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					    gfp_t gfp_mask,
@@ -952,30 +848,6 @@ static inline void __dec_memcg_page_stat
 	__mod_memcg_page_state(page, idx, -1);
 }
 
-static inline void __inc_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx)
-{
-	__mod_lruvec_state(lruvec, idx, 1);
-}
-
-static inline void __dec_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx)
-{
-	__mod_lruvec_state(lruvec, idx, -1);
-}
-
-static inline void __inc_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx)
-{
-	__mod_lruvec_page_state(page, idx, 1);
-}
-
-static inline void __dec_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx)
-{
-	__mod_lruvec_page_state(page, idx, -1);
-}
-
 static inline void inc_memcg_state(struct mem_cgroup *memcg,
 				   enum memcg_stat_item idx)
 {
@@ -1000,30 +872,6 @@ static inline void dec_memcg_page_state(
 	mod_memcg_page_state(page, idx, -1);
 }
 
-static inline void inc_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx)
-{
-	mod_lruvec_state(lruvec, idx, 1);
-}
-
-static inline void dec_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx)
-{
-	mod_lruvec_state(lruvec, idx, -1);
-}
-
-static inline void inc_lruvec_page_state(struct page *page,
-					 enum node_stat_item idx)
-{
-	mod_lruvec_page_state(page, idx, 1);
-}
-
-static inline void dec_lruvec_page_state(struct page *page,
-					 enum node_stat_item idx)
-{
-	mod_lruvec_page_state(page, idx, -1);
-}
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 struct list_head *mem_cgroup_cgwb_list(struct mem_cgroup *memcg);
diff -puN include/linux/vmstat.h~mm-memcontrol-per-lruvec-stats-infrastructure-fix-4 include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-memcontrol-per-lruvec-stats-infrastructure-fix-4
+++ a/include/linux/vmstat.h
@@ -6,6 +6,7 @@
 #include <linux/mmzone.h>
 #include <linux/vm_event_item.h>
 #include <linux/atomic.h>
+#include <linux/memcontrol.h>
 
 extern int sysctl_stat_interval;
 
@@ -350,4 +351,156 @@ static inline void __mod_zone_freepage_s
 
 extern const char * const vmstat_text[];
 
+#ifdef CONFIG_MEMCG
+static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
+					      enum node_stat_item idx)
+{
+	struct mem_cgroup_per_node *pn;
+	long val = 0;
+	int cpu;
+
+	if (mem_cgroup_disabled())
+		return node_page_state(lruvec_pgdat(lruvec), idx);
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	for_each_possible_cpu(cpu)
+		val += per_cpu(pn->lruvec_stat->count[idx], cpu);
+
+	if (val < 0)
+		val = 0;
+
+	return val;
+}
+
+static inline void __mod_lruvec_state(struct lruvec *lruvec,
+				      enum node_stat_item idx, int val)
+{
+	struct mem_cgroup_per_node *pn;
+
+	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+	if (mem_cgroup_disabled())
+		return;
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	__mod_memcg_state(pn->memcg, idx, val);
+	__this_cpu_add(pn->lruvec_stat->count[idx], val);
+}
+
+static inline void mod_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx, int val)
+{
+	struct mem_cgroup_per_node *pn;
+
+	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+	if (mem_cgroup_disabled())
+		return;
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	mod_memcg_state(pn->memcg, idx, val);
+	this_cpu_add(pn->lruvec_stat->count[idx], val);
+}
+
+static inline void __mod_lruvec_page_state(struct page *page,
+					   enum node_stat_item idx, int val)
+{
+	struct mem_cgroup_per_node *pn;
+
+	__mod_node_page_state(page_pgdat(page), idx, val);
+	if (mem_cgroup_disabled() || !page->mem_cgroup)
+		return;
+	__mod_memcg_state(page->mem_cgroup, idx, val);
+	pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
+	__this_cpu_add(pn->lruvec_stat->count[idx], val);
+}
+
+static inline void mod_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx, int val)
+{
+	struct mem_cgroup_per_node *pn;
+
+	mod_node_page_state(page_pgdat(page), idx, val);
+	if (mem_cgroup_disabled() || !page->mem_cgroup)
+		return;
+	mod_memcg_state(page->mem_cgroup, idx, val);
+	pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
+	this_cpu_add(pn->lruvec_stat->count[idx], val);
+}
+#else /* CONFIG_MEMCG */
+static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
+					      enum node_stat_item idx)
+{
+	return node_page_state(lruvec_pgdat(lruvec), idx);
+}
+
+static inline void __mod_lruvec_state(struct lruvec *lruvec,
+				      enum node_stat_item idx, int val)
+{
+	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+}
+
+static inline void mod_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx, int val)
+{
+	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+}
+
+static inline void __mod_lruvec_page_state(struct page *page,
+					   enum node_stat_item idx, int val)
+{
+	__mod_node_page_state(page_pgdat(page), idx, val);
+}
+
+static inline void mod_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx, int val)
+{
+	mod_node_page_state(page_pgdat(page), idx, val);
+}
+#endif /* CONFIG_MEMCG */
+
+static inline void __inc_lruvec_state(struct lruvec *lruvec,
+				      enum node_stat_item idx)
+{
+	__mod_lruvec_state(lruvec, idx, 1);
+}
+
+static inline void __dec_lruvec_state(struct lruvec *lruvec,
+				      enum node_stat_item idx)
+{
+	__mod_lruvec_state(lruvec, idx, -1);
+}
+
+static inline void __inc_lruvec_page_state(struct page *page,
+					   enum node_stat_item idx)
+{
+	__mod_lruvec_page_state(page, idx, 1);
+}
+
+static inline void __dec_lruvec_page_state(struct page *page,
+					   enum node_stat_item idx)
+{
+	__mod_lruvec_page_state(page, idx, -1);
+}
+
+static inline void inc_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx)
+{
+	mod_lruvec_state(lruvec, idx, 1);
+}
+
+static inline void dec_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx)
+{
+	mod_lruvec_state(lruvec, idx, -1);
+}
+
+static inline void inc_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx)
+{
+	mod_lruvec_page_state(page, idx, 1);
+}
+
+static inline void dec_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx)
+{
+	mod_lruvec_page_state(page, idx, -1);
+}
+
 #endif /* _LINUX_VMSTAT_H */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
mm-vmstat-move-slab-statistics-from-zone-to-node-counters-fix.patch
mm-memcontrol-use-the-node-native-slab-memory-counters.patch
mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
mm-memcontrol-per-lruvec-stats-infrastructure.patch
mm-memcontrol-per-lruvec-stats-infrastructure-fix.patch
mm-memcontrol-per-lruvec-stats-infrastructure-fix-2.patch
mm-memcontrol-per-lruvec-stats-infrastructure-fix-3.patch
mm-memcontrol-account-slab-stats-per-lruvec.patch


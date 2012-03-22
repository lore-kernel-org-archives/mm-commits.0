From: akpm@linux-foundation.org
Subject: [merged] mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:38 -0700
Message-ID: <20120322201838.7D1B3A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51317 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759036Ab2CVUSj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:39 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so201658qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, cl@linux-foundation.org, dave@linux.vnet.ibm.com, ebmunson@us.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drain percpu lru add/rotate page-vectors on cpu hot-unplug
has been removed from the -mm tree.  Its filename was
     mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: drain percpu lru add/rotate page-vectors on cpu hot-unplug

This cpu hotplug hook was accidentally removed in commit
v2.6.30-rc4-18-g00a62ce ("mm: fix Committed_AS underflow on large NR_CPUS
environment")

The visible effect of this accident: some pages are borrowed in per-cpu
page-vectors.  Truncate can deal with it, but these pages cannot be reused
while this cpu is offline.  So this is like a temporary memory leak.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 +
 mm/page_alloc.c      |    1 +
 mm/swap.c            |    4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug include/linux/swap.h
--- a/include/linux/swap.h~mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug
+++ a/include/linux/swap.h
@@ -223,6 +223,7 @@ extern void lru_add_page_tail(struct zon
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
+extern void lru_add_drain_cpu(int cpu);
 extern int lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void deactivate_page(struct page *page);
diff -puN mm/page_alloc.c~mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug mm/page_alloc.c
--- a/mm/page_alloc.c~mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug
+++ a/mm/page_alloc.c
@@ -4825,6 +4825,7 @@ static int page_alloc_cpu_notify(struct 
 	int cpu = (unsigned long)hcpu;
 
 	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+		lru_add_drain_cpu(cpu);
 		drain_pages(cpu);
 
 		/*
diff -puN mm/swap.c~mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug mm/swap.c
--- a/mm/swap.c~mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug
+++ a/mm/swap.c
@@ -496,7 +496,7 @@ static void lru_deactivate_fn(struct pag
  * Either "cpu" is the current CPU, and preemption has already been
  * disabled; or "cpu" is being hot-unplugged, and is already dead.
  */
-static void drain_cpu_pagevecs(int cpu)
+void lru_add_drain_cpu(int cpu)
 {
 	struct pagevec *pvecs = per_cpu(lru_add_pvecs, cpu);
 	struct pagevec *pvec;
@@ -553,7 +553,7 @@ void deactivate_page(struct page *page)
 
 void lru_add_drain(void)
 {
-	drain_cpu_pagevecs(get_cpu());
+	lru_add_drain_cpu(get_cpu());
 	put_cpu();
 }
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch


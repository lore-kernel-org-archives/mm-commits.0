From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-tick-timer-stall-during-deferred-page-init.patch
 added to -mm tree
Date: Wed, 11 Mar 2020 16:42:01 -0700
Message-ID: <20200311234201.ckHCFI1R_%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgCKXmE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 19:42:04 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ktkhai@virtuozzo.com, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, shile.zhang@linux.alibaba.com


The patch titled
     Subject: mm/page_alloc.c: fix tick timer stall during deferred page init
has been added to the -mm tree.  Its filename is
     mm-fix-tick-timer-stall-during-deferred-page-init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-tick-timer-stall-during-deferred-page-init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-tick-timer-stall-during-deferred-page-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shile Zhang <shile.zhang@linux.alibaba.com>
Subject: mm/page_alloc.c: fix tick timer stall during deferred page init

When 'CONFIG_DEFERRED_STRUCT_PAGE_INIT' is set, 'pgdatinit' kthread will
initialise the deferred pages with local interrupts disabled.  It is
introduced by commit 3a2d7fa8a3d5 ("mm: disable interrupts while
initializing deferred pages").

On machine with NCPUS <= 2, the 'pgdatinit' kthread could be bound to the
boot CPU, which could caused the tick timer long time stall, system
jiffies not be updated in time.

The dmesg shown that:

    [    0.197975] node 0 initialised, 32170688 pages in 1ms

Obviously, 1ms is unreasonable.

Now, fix it by restore in the pending interrupts for every 32*1204 pages
(128MB) initialized, give the chance to update the systemd jiffies.  The
reasonable demsg shown likes:

    [    1.069306] node 0 initialised, 32203456 pages in 894ms

Link: http://lkml.kernel.org/r/20200311123848.118638-1-shile.zhang@linux.alibaba.com
Fixes: 3a2d7fa8a3d5 ("mm: disable interrupts while initializing deferred pages")
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Co-developed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-fix-tick-timer-stall-during-deferred-page-init
+++ a/mm/page_alloc.c
@@ -1765,12 +1765,17 @@ deferred_init_maxorder(u64 *i, struct zo
 	return nr_pages;
 }
 
+/*
+ * Release the pending interrupts for every TICK_PAGE_COUNT pages.
+ */
+#define TICK_PAGE_COUNT	(32 * 1024)
+
 /* Initialise remaining memory on a node */
 static int __init deferred_init_memmap(void *data)
 {
 	pg_data_t *pgdat = data;
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
-	unsigned long spfn = 0, epfn = 0, nr_pages = 0;
+	unsigned long spfn = 0, epfn = 0, nr_pages = 0, prev_nr_pages = 0;
 	unsigned long first_init_pfn, flags;
 	unsigned long start = jiffies;
 	struct zone *zone;
@@ -1781,6 +1786,7 @@ static int __init deferred_init_memmap(v
 	if (!cpumask_empty(cpumask))
 		set_cpus_allowed_ptr(current, cpumask);
 
+again:
 	pgdat_resize_lock(pgdat, &flags);
 	first_init_pfn = pgdat->first_deferred_pfn;
 	if (first_init_pfn == ULONG_MAX) {
@@ -1792,7 +1798,6 @@ static int __init deferred_init_memmap(v
 	/* Sanity check boundaries */
 	BUG_ON(pgdat->first_deferred_pfn < pgdat->node_start_pfn);
 	BUG_ON(pgdat->first_deferred_pfn > pgdat_end_pfn(pgdat));
-	pgdat->first_deferred_pfn = ULONG_MAX;
 
 	/* Only the highest zone is deferred so find it */
 	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
@@ -1811,9 +1816,23 @@ static int __init deferred_init_memmap(v
 	 * that we can avoid introducing any issues with the buddy
 	 * allocator.
 	 */
-	while (spfn < epfn)
+	while (spfn < epfn) {
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		/*
+		 * Release the interrupts for every TICK_PAGE_COUNT pages
+		 * (128MB) to give tick timer the chance to update the
+		 * system jiffies.
+		 */
+		if ((nr_pages - prev_nr_pages) > TICK_PAGE_COUNT) {
+			prev_nr_pages = nr_pages;
+			pgdat->first_deferred_pfn = spfn;
+			pgdat_resize_unlock(pgdat, &flags);
+			goto again;
+		}
+	}
+
 zone_empty:
+	pgdat->first_deferred_pfn = ULONG_MAX;
 	pgdat_resize_unlock(pgdat, &flags);
 
 	/* Sanity check that the next zone really is unpopulated */
_

Patches currently in -mm which might be from shile.zhang@linux.alibaba.com are

mm-fix-tick-timer-stall-during-deferred-page-init.patch

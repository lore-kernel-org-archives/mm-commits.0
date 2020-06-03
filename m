From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 056/131] mm: don't track number of pages during
 deferred initialization
Date: Wed, 03 Jun 2020 15:59:47 -0700
Message-ID: <20200603225947.hsl9dZhU9%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCW7t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:59:49 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.williamson@redhat.com, alexander.h.duyck@linux.intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.m.jordan@oracle.com, dave.hansen@linux.intel.com, david@redhat.com, elliott@hpe.com, herbert@gondor.apana.org.au, jgg@ziepe.ca, josh@joshtriplett.org, ktkhai@virtuozzo.com, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, pavel@ucw.cz, peterz@infradead.org, rdunlap@infradead.org, shile.zhang@linux.alibaba.com, steffen.klassert@secunet.com, steven.sistare@oracle.com, tj@kernel.org, torvalds@linux-foundation.org, ziy@nvidia.com

From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: mm: don't track number of pages during deferred initialization

Deferred page init used to report the number of pages initialized:

  node 0 initialised, 32439114 pages in 97ms

Tracking this makes the code more complicated when using multiple threads.
Given that the statistic probably has limited value, especially since a
zone grows on demand so that the page count can vary, just remove it.

The boot message now looks like

  node 0 deferred pages initialised in 97ms

Link: http://lkml.kernel.org/r/20200527173608.2885243-6-daniel.m.jordan@oracle.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Suggested-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Robert Elliott <elliott@hpe.com>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-dont-track-number-of-pages-during-deferred-initialization
+++ a/mm/page_alloc.c
@@ -1820,7 +1820,7 @@ static int __init deferred_init_memmap(v
 {
 	pg_data_t *pgdat = data;
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
-	unsigned long spfn = 0, epfn = 0, nr_pages = 0;
+	unsigned long spfn = 0, epfn = 0;
 	unsigned long first_init_pfn, flags;
 	unsigned long start = jiffies;
 	struct zone *zone;
@@ -1869,15 +1869,15 @@ static int __init deferred_init_memmap(v
 	 * allocator.
 	 */
 	while (spfn < epfn) {
-		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		deferred_init_maxorder(&i, zone, &spfn, &epfn);
 		cond_resched();
 	}
 zone_empty:
 	/* Sanity check that the next zone really is unpopulated */
 	WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
 
-	pr_info("node %d initialised, %lu pages in %ums\n",
-		pgdat->node_id,	nr_pages, jiffies_to_msecs(jiffies - start));
+	pr_info("node %d deferred pages initialised in %ums\n",
+		pgdat->node_id, jiffies_to_msecs(jiffies - start));
 
 	pgdat_init_report_one_done();
 	return 0;
_

From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-dont-track-number-of-pages-during-deferred-initialization.patch added to
 -mm tree
Date: Wed, 27 May 2020 14:49:05 -0700
Message-ID: <20200527214905.Q8Vv7SOdl%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgE0VtI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 17:49:08 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, alexander.h.duyck@linux.intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.m.jordan@oracle.com, dave.hansen@linux.intel.com, david@redhat.com, elliott@hpe.com, herbert@gondor.apana.org.au, jgg@ziepe.ca, josh@joshtriplett.org, ktkhai@virtuozzo.com, mhocko@kernel.org, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, pavel@ucw.cz, peterz@infradead.org, rdunlap@infradead.org, shile.zhang@linux.alibaba.com, steffen.klassert@secunet.com, steven.sistare@oracle.com, tj@kernel.org, ziy@nvidia.com


The patch titled
     Subject: mm: don't track number of pages during deferred initialization
has been added to the -mm tree.  Its filename is
     mm-dont-track-number-of-pages-during-deferred-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-track-number-of-pages-during-deferred-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-track-number-of-pages-during-deferred-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from daniel.m.jordan@oracle.com are

mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch
padata-remove-exit-routine.patch
padata-initialize-earlier.patch
padata-allocate-work-structures-for-parallel-jobs-from-a-pool.patch
padata-add-basic-support-for-multithreaded-jobs.patch
mm-dont-track-number-of-pages-during-deferred-initialization.patch
mm-parallelize-deferred_init_memmap.patch
mm-make-deferred-inits-max-threads-arch-specific.patch
padata-document-multithreaded-jobs.patch

From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-page=5Freporting-add-budget-limit-on-how-many-pages-ca?=
 =?US-ASCII?Q?n-be-reported-per-pass.patch?= added to -mm tree
Date: Tue, 11 Feb 2020 16:20:04 -0800
Message-ID: <20200212002004.zK8uNGb_j%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbgBLAUG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 19:20:06 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com, dave.hansen@intel.com, david@redhat.com, konrad.wilk@oracle.com, lcapitulino@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com, nitesh@redhat.com, osalvador@suse.de, pagupta@redhat.com, pbonzini@redhat.com, riel@surriel.com, vbabka@suse.cz, wei.w.wang@intel.com, willy@infradead.org, yang.zhang.wz@gmail.com


The patch titled
     Subject: mm/page_reporting: add budget limit on how many pages can be reported per pass
has been added to the -mm tree.  Its filename is
     mm-page_reporting-add-budget-limit-on-how-many-pages-can-be-reported-per-pass.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_reporting-add-budget-limit-on-how-many-pages-can-be-reported-per-pass.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_reporting-add-budget-limit-on-how-many-pages-can-be-reported-per-pass.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: mm/page_reporting: add budget limit on how many pages can be reported per pass

In order to keep ourselves from reporting pages that are just going to be
reused again in the case of heavy churn we can put a limit on how many
total pages we will process per pass.  Doing this will allow the worker
thread to go into idle much more quickly so that we avoid competing with
other threads that might be allocating or freeing pages.

The logic added here will limit the worker thread to no more than one
sixteenth of the total free pages in a given area per list.  Once that
limit is reached it will update the state so that at the end of the pass
we will reschedule the worker to try again in 2 seconds when the memory
churn has hopefully settled down.

Again this optimization doesn't show much of a benefit in the standard
case as the memory churn is minmal.  However with page allocator shuffling
enabled the gain is quite noticeable.  Below are the results with a THP
enabled version of the will-it-scale page_fault1 test showing the
improvement in iterations for 16 processes or threads.

Without:
tasks   processes       processes_idle  threads         threads_idle
16      8283274.75      0.17            5594261.00      38.15

With:
tasks   processes       processes_idle  threads         threads_idle
16      8767010.50      0.21            5791312.75      36.98

Link: http://lkml.kernel.org/r/20200211224719.29318.72113.stgit@localhost.localdomain
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pagupta@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Wang <wei.w.wang@intel.com>
Cc: Yang Zhang <yang.zhang.wz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_reporting.h |    1 
 mm/page_reporting.c            |   33 ++++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

--- a/include/linux/page_reporting.h~mm-page_reporting-add-budget-limit-on-how-many-pages-can-be-reported-per-pass
+++ a/include/linux/page_reporting.h
@@ -5,6 +5,7 @@
 #include <linux/mmzone.h>
 #include <linux/scatterlist.h>
 
+/* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY		32
 
 struct page_reporting_dev_info {
--- a/mm/page_reporting.c~mm-page_reporting-add-budget-limit-on-how-many-pages-can-be-reported-per-pass
+++ a/mm/page_reporting.c
@@ -114,6 +114,7 @@ page_reporting_cycle(struct page_reporti
 	struct list_head *list = &area->free_list[mt];
 	unsigned int page_len = PAGE_SIZE << order;
 	struct page *page, *next;
+	long budget;
 	int err = 0;
 
 	/*
@@ -125,12 +126,39 @@ page_reporting_cycle(struct page_reporti
 
 	spin_lock_irq(&zone->lock);
 
+	/*
+	 * Limit how many calls we will be making to the page reporting
+	 * device for this list. By doing this we avoid processing any
+	 * given list for too long.
+	 *
+	 * The current value used allows us enough calls to process over a
+	 * sixteenth of the current list plus one additional call to handle
+	 * any pages that may have already been present from the previous
+	 * list processed. This should result in us reporting all pages on
+	 * an idle system in about 30 seconds.
+	 *
+	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
+	 * should always be a power of 2.
+	 */
+	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
+
 	/* loop through free list adding unreported pages to sg list */
 	list_for_each_entry_safe(page, next, list, lru) {
 		/* We are going to skip over the reported pages. */
 		if (PageReported(page))
 			continue;
 
+		/*
+		 * If we fully consumed our budget then update our
+		 * state to indicate that we are requesting additional
+		 * processing and exit this list.
+		 */
+		if (budget < 0) {
+			atomic_set(&prdev->state, PAGE_REPORTING_REQUESTED);
+			next = page;
+			break;
+		}
+
 		/* Attempt to pull page from list and place in scatterlist */
 		if (*offset) {
 			if (!__isolate_free_page(page, order)) {
@@ -146,7 +174,7 @@ page_reporting_cycle(struct page_reporti
 		}
 
 		/*
-		 * Make the first non-processed page in the free list
+		 * Make the first non-reported page in the free list
 		 * the new head of the free list before we release the
 		 * zone lock.
 		 */
@@ -162,6 +190,9 @@ page_reporting_cycle(struct page_reporti
 		/* reset offset since the full list was reported */
 		*offset = PAGE_REPORTING_CAPACITY;
 
+		/* update budget to reflect call to report function */
+		budget--;
+
 		/* reacquire zone lock and resume processing */
 		spin_lock_irq(&zone->lock);
 
_

Patches currently in -mm which might be from alexander.h.duyck@linux.intel.com are

mm-adjust-shuffle-code-to-allow-for-future-coalescing.patch
mm-use-zone-and-order-instead-of-free-area-in-free_list-manipulators.patch
mm-add-function-__putback_isolated_page.patch
mm-introduce-reported-pages.patch
virtio-balloon-pull-page-poisoning-config-out-of-free-page-hinting.patch
virtio-balloon-add-support-for-providing-free-page-reports-to-host.patch
mm-page_reporting-rotate-reported-pages-to-the-tail-of-the-list.patch
mm-page_reporting-add-budget-limit-on-how-many-pages-can-be-reported-per-pass.patch
mm-page_reporting-add-free-page-reporting-documentation.patch

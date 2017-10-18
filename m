From: akpm@linux-foundation.org
Subject: + mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage.patch
 added to -mm tree
Date: Wed, 18 Oct 2017 15:16:44 -0700
Message-ID: <59e7d2cc.DwaYErTbW6U1nRpk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37762 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751041AbdJRWQp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2017 18:16:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: only drain per-cpu pagevecs once per pagevec usage
has been added to the -mm tree.  Its filename is
     mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: only drain per-cpu pagevecs once per pagevec usage

When a pagevec is initialised on the stack, it is generally used multiple
times over a range of pages, looking up entries and then releasing them. 
On each pagevec_release, the per-cpu deferred LRU pagevecs are drained on
the grounds the page being released may be on those queues and the pages
may be cache hot.  In many cases only the first drain is necessary as it's
unlikely that the range of pages being walked is racing against LRU
addition.  Even if there is such a race, the impact is marginal where as
constantly redraining the lru pagevecs costs.

This patch ensures that pagevec is only drained once in a given lifecycle
without increasing the cache footprint of the pagevec structure.  Only
sparsetruncate tiny is shown here as large files have many exceptional
entries and calls pagecache_release less frequently.

sparsetruncate (tiny)
                              4.14.0-rc4             4.14.0-rc4
                        batchshadow-v1r1          onedrain-v1r1
Min          Time      141.00 (   0.00%)      141.00 (   0.00%)
1st-qrtle    Time      142.00 (   0.00%)      142.00 (   0.00%)
2nd-qrtle    Time      142.00 (   0.00%)      142.00 (   0.00%)
3rd-qrtle    Time      143.00 (   0.00%)      143.00 (   0.00%)
Max-90%      Time      144.00 (   0.00%)      144.00 (   0.00%)
Max-95%      Time      146.00 (   0.00%)      145.00 (   0.68%)
Max-99%      Time      198.00 (   0.00%)      194.00 (   2.02%)
Max          Time      254.00 (   0.00%)      208.00 (  18.11%)
Amean        Time      145.12 (   0.00%)      144.30 (   0.56%)
Stddev       Time       12.74 (   0.00%)        9.62 (  24.49%)
Coeff        Time        8.78 (   0.00%)        6.67 (  24.06%)
Best99%Amean Time      144.29 (   0.00%)      143.82 (   0.32%)
Best95%Amean Time      142.68 (   0.00%)      142.31 (   0.26%)
Best90%Amean Time      142.52 (   0.00%)      142.19 (   0.24%)
Best75%Amean Time      142.26 (   0.00%)      141.98 (   0.20%)
Best50%Amean Time      141.90 (   0.00%)      141.71 (   0.13%)
Best25%Amean Time      141.80 (   0.00%)      141.43 (   0.26%)

The impact on bonnie is marginal and within the noise because a
significant percentage of the file being truncated has been reclaimed and
consists of shadow entries which reduce the hotness of the pagevec_release
path.

Link: http://lkml.kernel.org/r/20171018075952.10627-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    4 +++-
 mm/swap.c               |    5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/pagevec.h~mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage
+++ a/include/linux/pagevec.h
@@ -16,7 +16,8 @@ struct address_space;
 
 struct pagevec {
 	unsigned long nr;
-	unsigned long cold;
+	bool cold;
+	bool drained;
 	struct page *pages[PAGEVEC_SIZE];
 };
 
@@ -53,6 +54,7 @@ static inline void pagevec_init(struct p
 {
 	pvec->nr = 0;
 	pvec->cold = cold;
+	pvec->drained = false;
 }
 
 static inline void pagevec_reinit(struct pagevec *pvec)
diff -puN mm/swap.c~mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage mm/swap.c
--- a/mm/swap.c~mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage
+++ a/mm/swap.c
@@ -833,7 +833,10 @@ EXPORT_SYMBOL(release_pages);
  */
 void __pagevec_release(struct pagevec *pvec)
 {
-	lru_add_drain();
+	if (!pvec->drained) {
+		lru_add_drain();
+		pvec->drained = true;
+	}
 	release_pages(pvec->pages, pagevec_count(pvec), pvec->cold);
 	pagevec_reinit(pvec);
 }
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages.patch
mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages-fix.patch
mm-truncate-do-not-check-mapping-for-every-page-being-truncated.patch
mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock.patch
mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage.patch
mm-pagevec-remove-cold-parameter-for-pagevecs.patch
mm-remove-cold-parameter-for-release_pages.patch
mm-remove-cold-parameter-from-free_hot_cold_page.patch
mm-remove-__gfp_cold.patch


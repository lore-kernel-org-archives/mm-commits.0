From: akpm@linux-foundation.org
Subject: + mm-pagevec-rename-pagevec-drained-field.patch added to -mm tree
Date: Thu, 19 Oct 2017 12:18:25 -0700
Message-ID: <59e8fa81.9ihpFiKGx7qfdlpo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751823AbdJSTS1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2017 15:18:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, pagevec: rename pagevec drained field
has been added to the -mm tree.  Its filename is
     mm-pagevec-rename-pagevec-drained-field.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pagevec-rename-pagevec-drained-field.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pagevec-rename-pagevec-drained-field.patch

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
Subject: mm, pagevec: rename pagevec drained field

According to Vlastimil Babka, the drained field in pagevec is potentially
misleading because it might be interpreted as draining this pagevec
instead of the percpu lru pagevecs.  Rename the field for clarity.

Link: http://lkml.kernel.org/r/20171019093346.ylahzdpzmoriyf4v@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    4 ++--
 mm/swap.c               |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/pagevec.h~mm-pagevec-rename-pagevec-drained-field include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-pagevec-rename-pagevec-drained-field
+++ a/include/linux/pagevec.h
@@ -16,7 +16,7 @@ struct address_space;
 
 struct pagevec {
 	unsigned long nr;
-	bool drained;
+	bool percpu_pvec_drained;
 	struct page *pages[PAGEVEC_SIZE];
 };
 
@@ -52,7 +52,7 @@ static inline unsigned pagevec_lookup_ta
 static inline void pagevec_init(struct pagevec *pvec)
 {
 	pvec->nr = 0;
-	pvec->drained = false;
+	pvec->percpu_pvec_drained = false;
 }
 
 static inline void pagevec_reinit(struct pagevec *pvec)
diff -puN mm/swap.c~mm-pagevec-rename-pagevec-drained-field mm/swap.c
--- a/mm/swap.c~mm-pagevec-rename-pagevec-drained-field
+++ a/mm/swap.c
@@ -833,9 +833,9 @@ EXPORT_SYMBOL(release_pages);
  */
 void __pagevec_release(struct pagevec *pvec)
 {
-	if (!pvec->drained) {
+	if (!pvec->percpu_pvec_drained) {
 		lru_add_drain();
-		pvec->drained = true;
+		pvec->percpu_pvec_drained = true;
 	}
 	release_pages(pvec->pages, pagevec_count(pvec));
 	pagevec_reinit(pvec);
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
mm-pagevec-rename-pagevec-drained-field.patch


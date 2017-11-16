From: akpm@linux-foundation.org
Subject: [merged] mm-pagevec-rename-pagevec-drained-field.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:04:37 -0800
Message-ID: <20171116200437.n6B1R-8rO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47414 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933284AbdKPUEi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:04:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, mgorman@techsingularity.net, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm, pagevec: rename pagevec drained field
has been removed from the -mm tree.  Its filename was
     mm-pagevec-rename-pagevec-drained-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -17,7 +17,7 @@ struct address_space;
 
 struct pagevec {
 	unsigned long nr;
-	bool drained;
+	bool percpu_pvec_drained;
 	struct page *pages[PAGEVEC_SIZE];
 };
 
@@ -53,7 +53,7 @@ static inline unsigned pagevec_lookup_ta
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



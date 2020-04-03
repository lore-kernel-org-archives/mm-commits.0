From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-rename-nr-as-nr_pinned-in-get_user_pages_fast.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:36:59 -0700
Message-ID: <20200403203659.fOKnMN3y5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUhA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, hch@infradead.org, ira.weiny@intel.com, jgg@ziepe.ca, jhubbard@nvidia.com, kernelfans@gmail.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com, shuah@kernel.org, willy@infradead.org


The patch titled
     Subject: mm/gup: rename nr as nr_pinned in get_user_pages_fast()
has been removed from the -mm tree.  Its filename was
     mm-gup-rename-nr-as-nr_pinned-in-get_user_pages_fast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pingfan Liu <kernelfans@gmail.com>
Subject: mm/gup: rename nr as nr_pinned in get_user_pages_fast()

To better reflect the held state of pages and make code self-explaining,
rename nr as nr_pinned.

Link: http://lkml.kernel.org/r/1584876733-17405-2-git-send-email-kernelfans@gmail.com
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/mm/gup.c~mm-gup-rename-nr-as-nr_pinned-in-get_user_pages_fast
+++ a/mm/gup.c
@@ -2637,7 +2637,7 @@ int __get_user_pages_fast(unsigned long
 {
 	unsigned long len, end;
 	unsigned long flags;
-	int nr = 0;
+	int nr_pinned = 0;
 	/*
 	 * Internally (within mm/gup.c), gup fast variants must set FOLL_GET,
 	 * because gup fast is always a "pin with a +1 page refcount" request.
@@ -2671,11 +2671,11 @@ int __get_user_pages_fast(unsigned long
 	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP) &&
 	    gup_fast_permitted(start, end)) {
 		local_irq_save(flags);
-		gup_pgd_range(start, end, gup_flags, pages, &nr);
+		gup_pgd_range(start, end, gup_flags, pages, &nr_pinned);
 		local_irq_restore(flags);
 	}
 
-	return nr;
+	return nr_pinned;
 }
 EXPORT_SYMBOL_GPL(__get_user_pages_fast);
 
@@ -2707,7 +2707,7 @@ static int internal_get_user_pages_fast(
 					struct page **pages)
 {
 	unsigned long addr, len, end;
-	int nr = 0, ret = 0;
+	int nr_pinned = 0, ret = 0;
 
 	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
 				       FOLL_FORCE | FOLL_PIN | FOLL_GET)))
@@ -2726,25 +2726,25 @@ static int internal_get_user_pages_fast(
 	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP) &&
 	    gup_fast_permitted(start, end)) {
 		local_irq_disable();
-		gup_pgd_range(addr, end, gup_flags, pages, &nr);
+		gup_pgd_range(addr, end, gup_flags, pages, &nr_pinned);
 		local_irq_enable();
-		ret = nr;
+		ret = nr_pinned;
 	}
 
-	if (nr < nr_pages) {
+	if (nr_pinned < nr_pages) {
 		/* Try to get the remaining pages with get_user_pages */
-		start += nr << PAGE_SHIFT;
-		pages += nr;
+		start += nr_pinned << PAGE_SHIFT;
+		pages += nr_pinned;
 
-		ret = __gup_longterm_unlocked(start, nr_pages - nr,
+		ret = __gup_longterm_unlocked(start, nr_pages - nr_pinned,
 					      gup_flags, pages);
 
 		/* Have to be a bit careful with return values */
-		if (nr > 0) {
+		if (nr_pinned > 0) {
 			if (ret < 0)
-				ret = nr;
+				ret = nr_pinned;
 			else
-				ret += nr;
+				ret += nr_pinned;
 		}
 	}
 
_

Patches currently in -mm which might be from kernelfans@gmail.com are

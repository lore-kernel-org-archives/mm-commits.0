From: akpm@linux-foundation.org
Subject: [patch 038/126] mm/mlock.c: use page_zone() instead of
 page_zone_id()
Date: Fri, 08 Sep 2017 16:12:59 -0700
Message-ID: <20170908231259.byS8zM4cD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757173AbdIHXNA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:13:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/mlock.c: use page_zone() instead of page_zone_id()

page_zone_id() is a specialized function to compare the zone for the pages
that are within the section range.  If the section of the pages are
different, page_zone_id() can be different even if their zone is the same.
This wrong usage doesn't cause any actual problem since
__munlock_pagevec_fill() would be called again with failed index. 
However, it's better to use more appropriate function here.

Link: http://lkml.kernel.org/r/1503559211-10259-1-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/mlock.c~mm-mlock-use-page_zone-instead-of-page_zone_id mm/mlock.c
--- a/mm/mlock.c~mm-mlock-use-page_zone-instead-of-page_zone_id
+++ a/mm/mlock.c
@@ -365,8 +365,8 @@ static void __munlock_pagevec(struct pag
  * @start + PAGE_SIZE when no page could be added by the pte walk.
  */
 static unsigned long __munlock_pagevec_fill(struct pagevec *pvec,
-		struct vm_area_struct *vma, int zoneid,	unsigned long start,
-		unsigned long end)
+			struct vm_area_struct *vma, struct zone *zone,
+			unsigned long start, unsigned long end)
 {
 	pte_t *pte;
 	spinlock_t *ptl;
@@ -394,7 +394,7 @@ static unsigned long __munlock_pagevec_f
 		 * Break if page could not be obtained or the page's node+zone does not
 		 * match
 		 */
-		if (!page || page_zone_id(page) != zoneid)
+		if (!page || page_zone(page) != zone)
 			break;
 
 		/*
@@ -446,7 +446,6 @@ void munlock_vma_pages_range(struct vm_a
 		unsigned long page_increm;
 		struct pagevec pvec;
 		struct zone *zone;
-		int zoneid;
 
 		pagevec_init(&pvec, 0);
 		/*
@@ -481,7 +480,6 @@ void munlock_vma_pages_range(struct vm_a
 				 */
 				pagevec_add(&pvec, page);
 				zone = page_zone(page);
-				zoneid = page_zone_id(page);
 
 				/*
 				 * Try to fill the rest of pagevec using fast
@@ -490,7 +488,7 @@ void munlock_vma_pages_range(struct vm_a
 				 * pagevec.
 				 */
 				start = __munlock_pagevec_fill(&pvec, vma,
-						zoneid, start, end);
+						zone, start, end);
 				__munlock_pagevec(&pvec, zone);
 				goto next;
 			}
_

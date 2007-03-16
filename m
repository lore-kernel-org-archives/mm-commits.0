From: akpm@linux-foundation.org
Subject: + lumpy-only-count-taken-pages-as-scanned.patch added to -mm tree
Date: Thu, 15 Mar 2007 19:18:56 -0800
Message-ID: <200703160318.l2G3IuKR001382@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51420 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbXCPDTE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 23:19:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, mel@csn.ul.ie


The patch titled
     lumpy: only count taken pages as scanned
has been added to the -mm tree.  Its filename is
     lumpy-only-count-taken-pages-as-scanned.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lumpy: only count taken pages as scanned
From: Andy Whitcroft <apw@shadowen.org>

When scanning the order sized area around the tag page we pull all pages of
the matching active state; the non-matching pages are not otherwise affected. 
We currently count these as scanned increasing the apparent scan rates. 
Previously we would only count a page scanned if it was actually removed from
the LRU, either then being reclaimed or rotated back onto the head of the LRU.

The effect of this is to cause reclaim to terminate artificially early when
the scan count is reached, reducing effectivness.  Move to counting only those
pages we actually remove from the LRU as scanned.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~lumpy-only-count-taken-pages-as-scanned mm/vmscan.c
--- a/mm/vmscan.c~lumpy-only-count-taken-pages-as-scanned
+++ a/mm/vmscan.c
@@ -727,11 +727,11 @@ static unsigned long isolate_lru_pages(u
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
-			scan++;
 			switch (__isolate_lru_page(cursor_page, active)) {
 			case 0:
 				list_move(&cursor_page->lru, dst);
 				nr_taken++;
+				scan++;
 				break;
 
 			case -EBUSY:
_

Patches currently in -mm which might be from apw@shadowen.org are

pci-device-ensure-sysdata-initialised-v2.patch
move-free-pages-between-lists-on-steal-fix.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
lumpy-reclaim-v4.patch
lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch
lumpy-only-count-taken-pages-as-scanned.patch

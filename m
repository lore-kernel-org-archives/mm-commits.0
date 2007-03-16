From: akpm@linux-foundation.org
Subject: + lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch added to -mm tree
Date: Thu, 15 Mar 2007 19:18:53 -0800
Message-ID: <200703160318.l2G3Irus001379@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51418 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXCPDTD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 23:19:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, mel@csn.ul.ie


The patch titled
     lumpy: back out removal of active check in isolate_lru_pages
has been added to the -mm tree.  Its filename is
     lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lumpy: back out removal of active check in isolate_lru_pages
From: Andy Whitcroft <apw@shadowen.org>

As pointed out by Christop Lameter it should not be possible for a page to
change its active/inactive state without taking the lru_lock.  Reinstate this
safety net.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~lumpy-back-out-removal-of-active-check-in-isolate_lru_pages mm/vmscan.c
--- a/mm/vmscan.c~lumpy-back-out-removal-of-active-check-in-isolate_lru_pages
+++ a/mm/vmscan.c
@@ -686,10 +686,13 @@ static unsigned long isolate_lru_pages(u
 			nr_taken++;
 			break;
 
-		default:
-			/* page is being freed, or is a missmatch */
+		case -EBUSY:
+			/* else it is being freed elsewhere */
 			list_move(&page->lru, src);
 			continue;
+
+		default:
+			BUG();
 		}
 
 		if (!order)
_

Patches currently in -mm which might be from apw@shadowen.org are

pci-device-ensure-sysdata-initialised-v2.patch
move-free-pages-between-lists-on-steal-fix.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
lumpy-reclaim-v4.patch
lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch
lumpy-only-count-taken-pages-as-scanned.patch

From: akpm@osdl.org
Subject: + lumpy-cleanup-a-missplaced-comment-and-simplify-some-code.patch added to -mm tree
Date: Mon, 11 Dec 2006 14:42:36 -0800
Message-ID: <200612112242.kBBMgaGo010961@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:45276 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937699AbWLKWnN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 17:43:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, a.p.zijlstra@chello.nl


The patch titled
     lumpy cleanup a missplaced comment and simplify some code
has been added to the -mm tree.  Its filename is
     lumpy-cleanup-a-missplaced-comment-and-simplify-some-code.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lumpy cleanup a missplaced comment and simplify some code
From: Andy Whitcroft <apw@shadowen.org>

Move the comment for isolate_lru_pages() back to its function and comment the
new function.  Add some running commentry on the area scan.  Cleanup the
indentation on switch to match the majority view in mm/*.  Finally, clarify
the boundary pfn calculations.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/vmscan.c |   86 +++++++++++++++++++++++++++++---------------------
 1 files changed, 50 insertions(+), 36 deletions(-)

diff -puN mm/vmscan.c~lumpy-cleanup-a-missplaced-comment-and-simplify-some-code mm/vmscan.c
--- a/mm/vmscan.c~lumpy-cleanup-a-missplaced-comment-and-simplify-some-code
+++ a/mm/vmscan.c
@@ -605,21 +605,14 @@ keep:
 }
 
 /*
- * zone->lru_lock is heavily contended.  Some of the functions that
- * shrink the lists perform better by taking out a batch of pages
- * and working on them outside the LRU lock.
- *
- * For pagecache intensive workloads, this function is the hottest
- * spot in the kernel (apart from copy_*_user functions).
+ * Attempt to remove the specified page from its LRU.  Only take this
+ * page if it is of the appropriate PageActive status.  Pages which
+ * are being freed elsewhere are also ignored.
  *
- * Appropriate locks must be held before calling this function.
- *
- * @nr_to_scan:	The number of pages to look through on the list.
- * @src:	The LRU list to pull pages off.
- * @dst:	The temp list to put pages on to.
- * @scanned:	The number of pages that were scanned.
+ * @page:	page to consider
+ * @active:	active/inactive flag only take pages of this type
  *
- * returns how many pages were moved onto *@dst.
+ * returns 0 on success, -ve errno on failure.
  */
 int __isolate_lru_page(struct page *page, int active)
 {
@@ -641,6 +634,23 @@ int __isolate_lru_page(struct page *page
 	return ret;
 }
 
+/*
+ * zone->lru_lock is heavily contended.  Some of the functions that
+ * shrink the lists perform better by taking out a batch of pages
+ * and working on them outside the LRU lock.
+ *
+ * For pagecache intensive workloads, this function is the hottest
+ * spot in the kernel (apart from copy_*_user functions).
+ *
+ * Appropriate locks must be held before calling this function.
+ *
+ * @nr_to_scan:	The number of pages to look through on the list.
+ * @src:	The LRU list to pull pages off.
+ * @dst:	The temp list to put pages on to.
+ * @scanned:	The number of pages that were scanned.
+ *
+ * returns how many pages were moved onto *@dst.
+ */
 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		struct list_head *src, struct list_head *dst,
 		unsigned long *scanned, int order)
@@ -658,26 +668,31 @@ static unsigned long isolate_lru_pages(u
 
 		active = PageActive(page);
 		switch (__isolate_lru_page(page, active)) {
-			case 0:
-				list_move(&page->lru, dst);
-				nr_taken++;
-				break;
+		case 0:
+			list_move(&page->lru, dst);
+			nr_taken++;
+			break;
 
-			case -EBUSY:
-				/* else it is being freed elsewhere */
-				list_move(&page->lru, src);
-				continue;
+		case -EBUSY:
+			/* else it is being freed elsewhere */
+			list_move(&page->lru, src);
+			continue;
 
-			default:
-				BUG();
+		default:
+			BUG();
 		}
 
 		if (!order)
 			continue;
 
-		page_pfn = pfn = __page_to_pfn(page);
-		end_pfn = pfn &= ~((1 << order) - 1);
-		end_pfn += 1 << order;
+		/*
+		 * Attempt to take all pages in the order aligned region
+		 * surrounding the tag page.  Only take those pages of
+		 * the same active state as that tag page.
+		 */
+		page_pfn = __page_to_pfn(page);
+		pfn = page_pfn & ~((1 << order) - 1);
+		end_pfn = pfn + (1 << order);
 		for (; pfn < end_pfn; pfn++) {
 			if (unlikely(pfn == page_pfn))
 				continue;
@@ -687,17 +702,16 @@ static unsigned long isolate_lru_pages(u
 			scan++;
 			tmp = __pfn_to_page(pfn);
 			switch (__isolate_lru_page(tmp, active)) {
-				case 0:
-					list_move(&tmp->lru, dst);
-					nr_taken++;
-					continue;
-
-				case -EBUSY:
-					/* else it is being freed elsewhere */
-					list_move(&tmp->lru, src);
-				default:
-					break;
+			case 0:
+				list_move(&tmp->lru, dst);
+				nr_taken++;
+				continue;
 
+			case -EBUSY:
+				/* else it is being freed elsewhere */
+				list_move(&tmp->lru, src);
+			default:
+				break;
 			}
 			break;
 		}
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
git-acpi.patch
pci-device-ensure-sysdata-initialised-v2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
virtual-memmap-on-sparsemem-v3-generic-virtual.patch
virtual-memmap-on-sparsemem-v3-generic-virtual-fix.patch
virtual-memmap-on-sparsemem-v3-static-virtual.patch
virtual-memmap-on-sparsemem-v3-static-virtual-update.patch
virtual-memmap-on-sparsemem-v3-ia64-support.patch
virtual-memmap-on-sparsemem-v3-ia64-support-update.patch
lumpy-reclaim-v2.patch
lumpy-cleanup-a-missplaced-comment-and-simplify-some-code.patch
lumpy-ensure-we-respect-zone-boundaries.patch
lumpy-take-the-other-active-inactive-pages-in-the-area.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
optional-zone_dma-in-the-vm.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch


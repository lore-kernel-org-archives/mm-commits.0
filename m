From: akpm@linux-foundation.org
Subject: + mm-fix-page-allocation-for-larger-i-o-segments.patch added to -mm tree
Date: Fri, 14 Dec 2007 14:37:00 -0800
Message-ID: <200712142237.lBEMb08A018674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757338AbXLNWhv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Dec 2007 17:37:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, James.Bottomley@steeleye.com, jens.axboe@oracle.com, mlord@pobox.com


The patch titled
     mm: fix page allocation for larger I/O segments
has been added to the -mm tree.  Its filename is
     mm-fix-page-allocation-for-larger-i-o-segments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: fix page allocation for larger I/O segments
From: Mel Gorman <mel@csn.ul.ie>

In some cases the IO subsystem is able to merge requests if the pages are
adjacent in physical memory.  This was achieved in the allocator by having
expand() return pages in physically contiguous order in situations were a
large buddy was split.  However, list-based anti-fragmentation changed the
order pages were returned in to avoid searching in buffered_rmqueue() for a
page of the appropriate migrate type.

This patch restores behaviour of rmqueue_bulk() preserving the physical
order of pages returned by the allocator without incurring increased search
costs for anti-fragmentation.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark Lord <mlord@pobox.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/page_alloc.c~mm-fix-page-allocation-for-larger-i-o-segments mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-page-allocation-for-larger-i-o-segments
+++ a/mm/page_alloc.c
@@ -847,8 +847,19 @@ static int rmqueue_bulk(struct zone *zon
 		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
 			break;
+
+		/*
+		 * Split buddy pages returned by expand() are received here
+		 * in physical page order. The page is added to the callers and
+		 * list and the list head then moves forward. From the callers
+		 * perspective, the linked list is ordered by page number in
+		 * some conditions. This is useful for IO devices that can
+		 * merge IO requests if the physical pages are ordered
+		 * properly.
+		 */
 		list_add(&page->lru, list);
 		set_page_private(page, migratetype);
+		list = &page->lru;
 	}
 	spin_unlock(&zone->lock);
 	return i;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-fix-page-allocation-for-larger-i-o-segments.patch
fix-page_alloc-for-larger-i-o-segments.patch
fix-page_alloc-for-larger-i-o-segments-fix.patch
fix-build-failure-when-config_infiniband_ipoib_cm-is-not-defined.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

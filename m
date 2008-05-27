From: akpm@linux-foundation.org
Subject: - mm-dont-drop-a-partial-page-in-a-zones-memory-map-size.patch removed from -mm tree
Date: Tue, 27 May 2008 00:26:39 -0700
Message-ID: <200805270726.m4R7QdQg014687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757088AbYE0H1P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:27:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: don't drop a partial page in a zone's memory map size
has been removed from the -mm tree.  Its filename was
     mm-dont-drop-a-partial-page-in-a-zones-memory-map-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: don't drop a partial page in a zone's memory map size
From: Johannes Weiner <hannes@saeurebad.de>

In a zone's present pages number, account for all pages occupied by the
memory map, including a partial.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-dont-drop-a-partial-page-in-a-zones-memory-map-size mm/page_alloc.c
--- a/mm/page_alloc.c~mm-dont-drop-a-partial-page-in-a-zones-memory-map-size
+++ a/mm/page_alloc.c
@@ -3378,7 +3378,8 @@ static void __paginginit free_area_init_
 		 * is used by this zone for memmap. This affects the watermark
 		 * and per-cpu initialisations
 		 */
-		memmap_pages = (size * sizeof(struct page)) >> PAGE_SHIFT;
+		memmap_pages =
+			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
 		if (realsize >= memmap_pages) {
 			realsize -= memmap_pages;
 			printk(KERN_DEBUG
_

Patches currently in -mm which might be from hannes@saeurebad.de are

git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch


From: akpm@linux-foundation.org
Subject: + mm-dont-drop-a-partial-page-in-a-zones-memory-map-size.patch added to -mm tree
Date: Wed, 21 May 2008 13:59:00 -0700
Message-ID: <200805212059.m4LKx0il000523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474AbYEUU7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 16:59:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: don't drop a partial page in a zone's memory map size
has been added to the -mm tree.  Its filename is
     mm-dont-drop-a-partial-page-in-a-zones-memory-map-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mm-dont-drop-a-partial-page-in-a-zones-memory-map-size.patch
git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch


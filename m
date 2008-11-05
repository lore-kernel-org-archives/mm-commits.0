From: akpm@linux-foundation.org
Subject: + mm-print-out-memmap-number-only-it-is-not-zero.patch added to -mm tree
Date: Wed, 05 Nov 2008 12:39:35 -0800
Message-ID: <200811052039.mA5KdZjn010963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879AbYKEUju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 15:39:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, mel@csn.ul.ie


The patch titled
     mm: print out memmap number only if it is not zero
has been added to the -mm tree.  Its filename is
     mm-print-out-memmap-number-only-it-is-not-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: print out memmap number only if it is not zero
From: Yinghai Lu <yinghai@kernel.org>

Don't print the size of the zone's memmap array if it does not have one.

Impact: cleanup

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-print-out-memmap-number-only-it-is-not-zero mm/page_alloc.c
--- a/mm/page_alloc.c~mm-print-out-memmap-number-only-it-is-not-zero
+++ a/mm/page_alloc.c
@@ -3469,9 +3469,10 @@ static void __paginginit free_area_init_
 			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
 		if (realsize >= memmap_pages) {
 			realsize -= memmap_pages;
-			printk(KERN_DEBUG
-				"  %s zone: %lu pages used for memmap\n",
-				zone_names[j], memmap_pages);
+			if (memmap_pages)
+				printk(KERN_DEBUG
+				       "  %s zone: %lu pages used for memmap\n",
+				       zone_names[j], memmap_pages);
 		} else
 			printk(KERN_WARNING
 				"  %s zone: %lu pages exceeds realsize %lu\n",
_

Patches currently in -mm which might be from yinghai@kernel.org are

acpi-use-macro-to-replace-hard-number.patch
mm-print-out-memmap-number-only-it-is-not-zero.patch


From: akpm@linux-foundation.org
Subject: + slob-reduce-list-scanning.patch added to -mm tree
Date: Wed, 18 Jul 2007 20:01:10 -0700
Message-ID: <200707190301.l6J31ADe010678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39680 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758155AbXGSDB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 23:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, clameter@sgi.com


The patch titled
     slob: reduce list scanning
has been added to the -mm tree.  Its filename is
     slob-reduce-list-scanning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slob: reduce list scanning
From: Matt Mackall <mpm@selenic.com>

The version of SLOB in -mm always scans its free list from the beginning,
which results in small allocations and free segments clustering at the
beginning of the list over time.  This causes the average search to scan
over a large stretch at the beginning on each allocation.

By starting each page search where the last one left off, we evenly
distribute the allocations and greatly shorten the average search.

Without this patch, kernel compiles on a 1.5G machine take a large amount
of system time for list scanning.  With this patch, compiles are within a
few seconds of performance of a SLAB kernel with no notable change in
system time.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN mm/slob.c~slob-reduce-list-scanning mm/slob.c
--- a/mm/slob.c~slob-reduce-list-scanning
+++ a/mm/slob.c
@@ -293,6 +293,7 @@ static void *slob_page_alloc(struct slob
 static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
 {
 	struct slob_page *sp;
+	struct list_head *prev;
 	slob_t *b = NULL;
 	unsigned long flags;
 
@@ -307,12 +308,22 @@ static void *slob_alloc(size_t size, gfp
 		if (node != -1 && page_to_nid(&sp->page) != node)
 			continue;
 #endif
+		/* Enough room on this page? */
+		if (sp->units < SLOB_UNITS(size))
+			continue;
 
-		if (sp->units >= SLOB_UNITS(size)) {
-			b = slob_page_alloc(sp, size, align);
-			if (b)
-				break;
-		}
+		/* Attempt to alloc */
+		prev = sp->list.prev;
+		b = slob_page_alloc(sp, size, align);
+		if (!b)
+			continue;
+
+		/* Improve fragment distribution and reduce our average
+		 * search time by starting our next search here. (see
+		 * Knuth vol 1, sec 2.5, pg 449) */
+		if (free_slob_pages.next != prev->next)
+			list_move_tail(&free_slob_pages, prev->next);
+		break;
 	}
 	spin_unlock_irqrestore(&slob_lock, flags);
 
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
slob-reduce-list-scanning.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
hwrng-add-type-categories.patch

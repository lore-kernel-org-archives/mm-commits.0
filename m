From: akpm@linux-foundation.org
Subject: + mm-fix-page_vma_mapped_walk-for-ksm-pages.patch added to -mm
 tree
Date: Mon, 03 Apr 2017 15:00:33 -0700
Message-ID: <58e2c601.9NM+q1JWplbvzcVG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52488 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbdDCWAe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2017 18:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, dsmythies@telus.net, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix page_vma_mapped_walk() for ksm pages
has been added to the -mm tree.  Its filename is
     mm-fix-page_vma_mapped_walk-for-ksm-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-page_vma_mapped_walk-for-ksm-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-page_vma_mapped_walk-for-ksm-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix page_vma_mapped_walk() for ksm pages

Doug Smythies reports oops with KSM in this backtrace, I've been seeing
the same:

page_vma_mapped_walk+0xe6/0x5b0
page_referenced_one+0x91/0x1a0
rmap_walk_ksm+0x100/0x190
rmap_walk+0x4f/0x60
page_referenced+0x149/0x170
shrink_active_list+0x1c2/0x430
shrink_node_memcg+0x67a/0x7a0
shrink_node+0xe1/0x320
kswapd+0x34b/0x720

Just as 4b0ece6fa016 ("mm: migrate: fix remove_migration_pte() for ksm
pages") observed, you cannot use page->index calculations on ksm pages. 
page_vma_mapped_walk() is relying on __vma_address(), where a ksm page can
lead it off the end of the page table, and into whatever nonsense is in
the next page, ending as an oops inside check_pte()'s pte_page().

KSM tells page_vma_mapped_walk() exactly where to look for the page, it
does not need any page->index calculation: and that's so also for all the
normal and file and anon pages - just not for THPs and their subpages. 
Get out early in most cases: instead of a PageKsm test, move down the
earlier not-THP-page test, as suggested by Kirill.

I'm also slightly worried that this loop can stray into other vmas, so
added a vm_end test to prevent surprises; though I have not imagined
anything worse than a very contrived case, in which a page mlocked in the
next vma might be reclaimed because it is not mlocked in this vma.

Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1704031104400.1118@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Doug Smythies <dsmythies@telus.net>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/page_vma_mapped.c~mm-fix-page_vma_mapped_walk-for-ksm-pages mm/page_vma_mapped.c
--- a/mm/page_vma_mapped.c~mm-fix-page_vma_mapped_walk-for-ksm-pages
+++ a/mm/page_vma_mapped.c
@@ -111,12 +111,8 @@ bool page_vma_mapped_walk(struct page_vm
 	if (pvmw->pmd && !pvmw->pte)
 		return not_found(pvmw);
 
-	/* Only for THP, seek to next pte entry makes sense */
-	if (pvmw->pte) {
-		if (!PageTransHuge(pvmw->page) || PageHuge(pvmw->page))
-			return not_found(pvmw);
+	if (pvmw->pte)
 		goto next_pte;
-	}
 
 	if (unlikely(PageHuge(pvmw->page))) {
 		/* when pud is not present, pte will be NULL */
@@ -165,9 +161,14 @@ restart:
 	while (1) {
 		if (check_pte(pvmw))
 			return true;
-next_pte:	do {
+next_pte:
+		/* Seek to next pte only makes sense for THP */
+		if (!PageTransHuge(pvmw->page) || PageHuge(pvmw->page))
+			return not_found(pvmw);
+		do {
 			pvmw->address += PAGE_SIZE;
-			if (pvmw->address >=
+			if (pvmw->address >= pvmw->vma->vm_end ||
+			    pvmw->address >=
 					__vma_address(pvmw->page, pvmw->vma) +
 					hpage_nr_pages(pvmw->page) * PAGE_SIZE)
 				return not_found(pvmw);
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-page_vma_mapped_walk-for-ksm-pages.patch


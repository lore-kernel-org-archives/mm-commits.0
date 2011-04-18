From: akpm@linux-foundation.org
Subject: + mm-reuse-__free_pages_exact-in-__alloc_pages_exact.patch added to -mm tree
Date: Mon, 18 Apr 2011 11:49:33 -0700
Message-ID: <201104181849.p3IInXXY018651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756418Ab1DRSyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, ak@linux.intel.com, mel@csn.ul.ie, mina86@mina86.com, rientjes@google.com, timur@freescale.com


The patch titled
     mm: reuse __free_pages_exact() in __alloc_pages_exact()
has been added to the -mm tree.  Its filename is
     mm-reuse-__free_pages_exact-in-__alloc_pages_exact.patch

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
Subject: mm: reuse __free_pages_exact() in __alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>

Michal Nazarewicz noticed that __alloc_pages_exact()'s __free_page() loop
was really close to something he was using in one of his patches.  That
made me realize that it was actually very similar to __free_pages_exact().

This uses __free_pages_exact() in place of the loop that we had in
__alloc_pages_exact().  Since we had to change the temporary variables
around anyway, I gave them some better names to hopefully address some
other review comments.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Suggested-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Timur Tabi <timur@freescale.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-reuse-__free_pages_exact-in-__alloc_pages_exact mm/page_alloc.c
--- a/mm/page_alloc.c~mm-reuse-__free_pages_exact-in-__alloc_pages_exact
+++ a/mm/page_alloc.c
@@ -2339,14 +2339,11 @@ struct page *__alloc_pages_exact(gfp_t g
 
 	page = alloc_pages(gfp_mask, order);
 	if (page) {
-		struct page *alloc_end = page + (1 << order);
-		struct page *used = page + nr_pages;
+		struct page *unused_start = page + nr_pages;
+		unsigned long nr_unused = (1 << order) - nr_pages;
 
 		split_page(page, order);
-		while (used < alloc_end) {
-			__free_page(used);
-			used++;
-		}
+		__free_pages_exact(unused_start, nr_unused);
 	}
 
 	return page;
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

origin.patch
mm-increase-reclaim_distance-to-30.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
include-linux-gfph-work-around-apparent-sparse-confusion.patch
mm-rename-alloc_pages_exact.patch
mm-make-new-alloc_pages_exact.patch
mm-reuse-__free_pages_exact-in-__alloc_pages_exact.patch


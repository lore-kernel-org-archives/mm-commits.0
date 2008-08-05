From: akpm@linux-foundation.org
Subject: + hugetlb-call-arch_prepare_hugepage-for-surplus-pages.patch added to -mm tree
Date: Tue, 05 Aug 2008 13:29:26 -0700
Message-ID: <200808052029.m75KTQwm021893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764975AbYHEUbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 16:31:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerald.schaefer@de.ibm.com, agl@us.ibm.com, npiggin@suse.de, schwidefsky@de.ibm.com


The patch titled
     hugetlb: call arch_prepare_hugepage() for surplus pages
has been added to the -mm tree.  Its filename is
     hugetlb-call-arch_prepare_hugepage-for-surplus-pages.patch

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
Subject: hugetlb: call arch_prepare_hugepage() for surplus pages
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

The s390 software large page emulation implements shared page tables by
using page->index of the first tail page from a compound large page to
store page table information.  This is set up in arch_prepare_hugepage(),
which is called from alloc_fresh_huge_page_node().

A similar call to arch_prepare_hugepage() is missing for surplus large
pages that are allocated in alloc_buddy_huge_page(), which breaks the
software emulation mode for (surplus) large pages on s390.  This patch
adds the missing call to arch_prepare_hugepage().  It will have no effect
on other architectures where arch_prepare_hugepage() is a nop.

Also, use the correct order in the error path in alloc_fresh_huge_page_node().

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: Adam Litke <agl@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-call-arch_prepare_hugepage-for-surplus-pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-call-arch_prepare_hugepage-for-surplus-pages
+++ a/mm/hugetlb.c
@@ -565,7 +565,7 @@ static struct page *alloc_fresh_huge_pag
 		huge_page_order(h));
 	if (page) {
 		if (arch_prepare_hugepage(page)) {
-			__free_pages(page, HUGETLB_PAGE_ORDER);
+			__free_pages(page, huge_page_order(h));
 			return NULL;
 		}
 		prep_new_huge_page(h, page, nid);
@@ -665,6 +665,11 @@ static struct page *alloc_buddy_huge_pag
 					__GFP_REPEAT|__GFP_NOWARN,
 					huge_page_order(h));
 
+	if (page && arch_prepare_hugepage(page)) {
+		__free_pages(page, huge_page_order(h));
+		return NULL;
+	}
+
 	spin_lock(&hugetlb_lock);
 	if (page) {
 		/*
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

origin.patch
hugetlb-call-arch_prepare_hugepage-for-surplus-pages.patch


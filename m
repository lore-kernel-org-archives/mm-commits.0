From: akpm@linux-foundation.org
Subject: +
 thp-remove-unused-vma-parameter-from-khugepaged_alloc_page.patch added to
 -mm tree
Date: Wed, 04 Nov 2015 17:25:54 -0800
Message-ID: <563ab022.gUXRczVYyWfhR3ul%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340AbbKEBZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Nov 2015 20:25:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: atomlin@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: remove unused vma parameter from khugepaged_alloc_page
has been added to the -mm tree.  Its filename is
     thp-remove-unused-vma-parameter-from-khugepaged_alloc_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-remove-unused-vma-parameter-from-khugepaged_alloc_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-remove-unused-vma-parameter-from-khugepaged_alloc_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aaron Tomlin <atomlin@redhat.com>
Subject: thp: remove unused vma parameter from khugepaged_alloc_page

The "vma" parameter to khugepaged_alloc_page() is unused.  It has to
remain unused or the drop read lock 'map_sem' optimisation introduce by
commit 8b1645685acf ("mm, THP: don't hold mmap_sem in khugepaged when
allocating THP") wouldn't be safe.  So let's remove it.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/huge_memory.c~thp-remove-unused-vma-parameter-from-khugepaged_alloc_page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-remove-unused-vma-parameter-from-khugepaged_alloc_page
+++ a/mm/huge_memory.c
@@ -2494,8 +2494,7 @@ static bool khugepaged_prealloc_page(str
 
 static struct page *
 khugepaged_alloc_page(struct page **hpage, gfp_t gfp, struct mm_struct *mm,
-		       struct vm_area_struct *vma, unsigned long address,
-		       int node)
+		       unsigned long address, int node)
 {
 	VM_BUG_ON_PAGE(*hpage, *hpage);
 
@@ -2562,8 +2561,7 @@ static bool khugepaged_prealloc_page(str
 
 static struct page *
 khugepaged_alloc_page(struct page **hpage, gfp_t gfp, struct mm_struct *mm,
-		       struct vm_area_struct *vma, unsigned long address,
-		       int node)
+		       unsigned long address, int node)
 {
 	up_read(&mm->mmap_sem);
 	VM_BUG_ON(!*hpage);
@@ -2649,7 +2647,7 @@ static void collapse_huge_page(struct mm
 		__GFP_THISNODE;
 
 	/* release the mmap_sem read lock. */
-	new_page = khugepaged_alloc_page(hpage, gfp, mm, vma, address, node);
+	new_page = khugepaged_alloc_page(hpage, gfp, mm, address, node);
 	if (!new_page) {
 		result = SCAN_ALLOC_HUGE_PAGE_FAIL;
 		goto out_nolock;
_

Patches currently in -mm which might be from atomlin@redhat.com are

thp-remove-unused-vma-parameter-from-khugepaged_alloc_page.patch


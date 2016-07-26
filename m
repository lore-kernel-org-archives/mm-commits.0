From: akpm@linux-foundation.org
Subject: [patch 095/126] thp: handle file pages in split_huge_pmd()
Date: Tue, 26 Jul 2016 15:25:37 -0700
Message-ID: <5797e361.LK6yhVVeF6ZDsEXV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604AbcGZWZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: handle file pages in split_huge_pmd()

Splitting THP PMD is simple: just unmap it as in DAX case. This way we
can avoid memory overhead on page table allocation to deposit.

It's probably a good idea to try to allocation page table with
GFP_ATOMIC in __split_huge_pmd_locked() to avoid refaulting the area,
but clearing pmd should be good enough for now.

Unlike DAX, we also remove the page from rmap and drop reference.
pmd_young() is transfered to PageReferenced().

Link: http://lkml.kernel.org/r/1466021202-61880-15-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~thp-handle-file-pages-in-split_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-handle-file-pages-in-split_huge_pmd
+++ a/mm/huge_memory.c
@@ -2987,10 +2987,18 @@ static void __split_huge_pmd_locked(stru
 
 	count_vm_event(THP_SPLIT_PMD);
 
-	if (vma_is_dax(vma)) {
-		pmd_t _pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
+	if (!vma_is_anonymous(vma)) {
+		_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
 		if (is_huge_zero_pmd(_pmd))
 			put_huge_zero_page();
+		if (vma_is_dax(vma))
+			return;
+		page = pmd_page(_pmd);
+		if (!PageReferenced(page) && pmd_young(_pmd))
+			SetPageReferenced(page);
+		page_remove_rmap(page, true);
+		put_page(page);
+		add_mm_counter(mm, MM_FILEPAGES, -HPAGE_PMD_NR);
 		return;
 	} else if (is_huge_zero_pmd(*pmd)) {
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
_

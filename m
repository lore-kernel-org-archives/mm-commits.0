From: akpm@linux-foundation.org
Subject: [patch 15/19] mm: thp: avoid false positive VM_BUG_ON_PAGE in
 page_move_anon_rmap()
Date: Fri, 27 May 2016 14:27:38 -0700
Message-ID: <5748bbca.0JTc6QGpMgBeXOLn%akpm__2469.07632467828$1464384468$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbcE0V1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 17:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, aarcange@redhat.com, mika.westerberg@linux.intel.com, stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: thp: avoid false positive VM_BUG_ON_PAGE in page_move_anon_rmap()

If page_move_anon_rmap() is refiling a pmd-splitted THP mapped in a tail
page from a pte, the "address" must be THP aligned in order for the
page->index bugcheck to pass in the CONFIG_DEBUG_VM=y builds.

Link: http://lkml.kernel.org/r/1464253620-106404-1-git-send-email-kirill.shutemov@linux.intel.com
Fixes: 6d0a07edd17c ("mm: thp: calculate the mapcount correctly for THP pages during WP faults")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>        [4.5]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/rmap.c~mm-thp-avoid-false-positive-vm_bug_on_page-in-page_move_anon_rmap mm/rmap.c
--- a/mm/rmap.c~mm-thp-avoid-false-positive-vm_bug_on_page-in-page_move_anon_rmap
+++ a/mm/rmap.c
@@ -1098,6 +1098,8 @@ void page_move_anon_rmap(struct page *pa
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_VMA(!anon_vma, vma);
+	if (IS_ENABLED(CONFIG_DEBUG_VM) && PageTransHuge(page))
+		address &= HPAGE_PMD_MASK;
 	VM_BUG_ON_PAGE(page->index != linear_page_index(vma, address), page);
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
_

From: akpm@linux-foundation.org
Subject: +
 mm-thp-avoid-false-positive-vm_bug_on_page-in-page_move_anon_rmap.patch
 added to -mm tree
Date: Thu, 26 May 2016 14:06:23 -0700
Message-ID: <5747654f.mHR/mD+TxxvcCuKf%akpm__7632.85474754429$1464296800$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbcEZVGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 17:06:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mika.westerberg@linux.intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: avoid false positive VM_BUG_ON_PAGE in page_move_anon_rmap()
has been added to the -mm tree.  Its filename is
     mm-thp-avoid-false-positive-vm_bug_on_page-in-page_move_anon_rmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-avoid-false-positive-vm_bug_on_page-in-page_move_anon_rmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-avoid-false-positive-vm_bug_on_page-in-page_move_anon_rmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com
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

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-thp-avoid-false-positive-vm_bug_on_page-in-page_move_anon_rmap.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch


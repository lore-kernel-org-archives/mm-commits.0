From: akpm@linux-foundation.org
Subject: + mm-thp-split_huge_pmd_address-comment-improvement.patch added
 to -mm tree
Date: Fri, 06 May 2016 15:26:15 -0700
Message-ID: <572d1a07.12IyVXbtJ2A8M7I7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759201AbcEFW0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 18:26:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alex.williamson@redhat.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: split_huge_pmd_address() comment improvement
has been added to the -mm tree.  Its filename is
     mm-thp-split_huge_pmd_address-comment-improvement.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-split_huge_pmd_address-comment-improvement.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-split_huge_pmd_address-comment-improvement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: thp: split_huge_pmd_address() comment improvement

Comment is partly wrong, this improves it by including the case of
split_huge_pmd_address() called by try_to_unmap_one if TTU_SPLIT_HUGE_PMD
is set.

Link: http://lkml.kernel.org/r/1462547040-1737-4-git-send-email-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-split_huge_pmd_address-comment-improvement mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-split_huge_pmd_address-comment-improvement
+++ a/mm/huge_memory.c
@@ -3023,8 +3023,10 @@ void split_huge_pmd_address(struct vm_ar
 		return;
 
 	/*
-	 * Caller holds the mmap_sem write mode, so a huge pmd cannot
-	 * materialize from under us.
+	 * Caller holds the mmap_sem write mode or the anon_vma lock,
+	 * so a huge pmd cannot materialize from under us (khugepaged
+	 * holds both the mmap_sem write mode and the anon_vma lock
+	 * write mode).
 	 */
 	__split_huge_pmd(vma, pmd, address, freeze);
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults.patch
mm-thp-microoptimize-compound_mapcount.patch
mm-thp-split_huge_pmd_address-comment-improvement.patch


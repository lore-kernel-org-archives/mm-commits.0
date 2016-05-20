From: akpm@linux-foundation.org
Subject: [patch 042/162] mm: thp: split_huge_pmd_address() comment
 improvement
Date: Fri, 20 May 2016 16:58:27 -0700
Message-ID: <573fa4a3.rCbTjl6fgtXqMazw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbcETX62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:58:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, alex.williamson@redhat.com, kirill.shutemov@linux.intel.com

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

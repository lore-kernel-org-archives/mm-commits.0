From: akpm@linux-foundation.org
Subject: +
 mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range.patch added to -mm tree
Date: Thu, 23 Jul 2015 14:26:11 -0700
Message-ID: <55b15bf3.4vOPqfsQ4uN0MnuV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbbGWV0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 17:26:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aris@redhat.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: get rid of duplicated check for vma(VM_PFNMAP) in queue_pages_range()
has been added to the -mm tree.  Its filename is
     mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aristeu Rozanski <aris@redhat.com>
Subject: mm/mempolicy.c: get rid of duplicated check for vma(VM_PFNMAP) in queue_pages_range()

This check was introduced as part of
   6f4576e3687 ("mempolicy: apply page table walker on queue_pages_range()")
	
which got duplicated by
   48684a65b4e ("mm: pagewalk: fix misbehavior of walk_page_range for vma(VM_PFNMAP)")

by reintroducing it earlier on queue_page_test_walk()

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range
+++ a/mm/mempolicy.c
@@ -608,9 +608,6 @@ static int queue_pages_test_walk(unsigne
 
 	qp->prev = vma;
 
-	if (vma->vm_flags & VM_PFNMAP)
-		return 1;

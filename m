From: akpm@linux-foundation.org
Subject: + ksm-fix-ksm-swapin-time-optimization.patch added to -mm tree
Date: Tue, 22 Jun 2010 14:08:53 -0700
Message-ID: <201006222108.o5ML8r4W002149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755655Ab0FVVI6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jun 2010 17:08:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, avi@redhat.com, ieidus@yahoo.com, riel@redhat.com


The patch titled
     ksm: fix ksm swapin time optimization
has been added to the -mm tree.  Its filename is
     ksm-fix-ksm-swapin-time-optimization.patch

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
Subject: ksm: fix ksm swapin time optimization
From: Andrea Arcangeli <aarcange@redhat.com>

The new anon-vma code, was suboptimal and it lead to erratic invocation of
ksm_does_need_to_copy.  That leads to host hangs or guest vnc lockup, or
weird behavior.  It's unclear why ksm_does_need_to_copy is unstable but
the point is that when KSM is not in use, ksm_does_need_to_copy must never
run or we bounce pages for no good reason.  I suspect the same hangs will
happen with KVM swaps.  But this at least fixes the regression in the
new-anon-vma code and it only let KSM bugs triggers when KSM is in use.

The code in do_swap_page likely doesn't cope well with a not-swapcache,
especially the memcg code.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Izik Eidus <ieidus@yahoo.com>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/ksm.h~ksm-fix-ksm-swapin-time-optimization include/linux/ksm.h
--- a/include/linux/ksm.h~ksm-fix-ksm-swapin-time-optimization
+++ a/include/linux/ksm.h
@@ -78,7 +78,7 @@ static inline struct page *ksm_might_nee
 	struct anon_vma *anon_vma = page_anon_vma(page);
 
 	if (!anon_vma ||
-	    (anon_vma == vma->anon_vma &&
+	    (anon_vma->root == vma->anon_vma->root &&
 	     page->index == linear_page_index(vma, address)))
 		return page;
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
hugetlb-call-mmu-notifiers-on-hugepage-cow.patch
define-madv_hugepage.patch
mmap-remove-unnecessary-lock-from-__vma_link.patch
rmap-always-add-new-vmas-at-the-end.patch
ksm-fix-ksm-swapin-time-optimization.patch
rmap-always-use-anon_vma-root-pointer.patch
rmap-resurrect-page_address_in_vma-anon_vma-check.patch
add-anon_vma-bug-checks.patch


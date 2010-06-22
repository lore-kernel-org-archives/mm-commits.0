From: akpm@linux-foundation.org
Subject: + mmap-remove-unnecessary-lock-from-__vma_link.patch added to -mm tree
Date: Tue, 22 Jun 2010 14:08:49 -0700
Message-ID: <201006222108.o5ML8nMj002140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478Ab0FVVI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jun 2010 17:08:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, riel@redhat.com


The patch titled
     mmap: remove unnecessary lock from __vma_link
has been added to the -mm tree.  Its filename is
     mmap-remove-unnecessary-lock-from-__vma_link.patch

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
Subject: mmap: remove unnecessary lock from __vma_link
From: Andrea Arcangeli <aarcange@redhat.com>

There's no anon-vma related mangling happening inside __vma_link anymore
so no need of anon_vma locking there.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/mmap.c~mmap-remove-unnecessary-lock-from-__vma_link mm/mmap.c
--- a/mm/mmap.c~mmap-remove-unnecessary-lock-from-__vma_link
+++ a/mm/mmap.c
@@ -452,12 +452,10 @@ static void vma_link(struct mm_struct *m
 		spin_lock(&mapping->i_mmap_lock);
 		vma->vm_truncate_count = mapping->truncate_count;
 	}
-	vma_lock_anon_vma(vma);
 
 	__vma_link(mm, vma, prev, rb_link, rb_parent);
 	__vma_link_file(vma);
 
-	vma_unlock_anon_vma(vma);
 	if (mapping)
 		spin_unlock(&mapping->i_mmap_lock);
 
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


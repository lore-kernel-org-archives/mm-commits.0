From: akpm@linux-foundation.org
Subject: + rmap-always-add-new-vmas-at-the-end.patch added to -mm tree
Date: Tue, 22 Jun 2010 14:08:51 -0700
Message-ID: <201006222108.o5ML8pJj002146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755611Ab0FVVI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jun 2010 17:08:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, riel@redhat.com


The patch titled
     rmap: always add new vmas at the end
has been added to the -mm tree.  Its filename is
     rmap-always-add-new-vmas-at-the-end.patch

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
Subject: rmap: always add new vmas at the end
From: Andrea Arcangeli <aarcange@redhat.com>

Make sure to always add new VMAs at the end of the list.  This is
important so rmap_walk does not miss a VMA that was created during the
rmap_walk.

The old code got this right most of the time due to luck, but was buggy
when anon_vma_prepare reused a mergeable anon_vma.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~rmap-always-add-new-vmas-at-the-end mm/rmap.c
--- a/mm/rmap.c~rmap-always-add-new-vmas-at-the-end
+++ a/mm/rmap.c
@@ -148,7 +148,7 @@ int anon_vma_prepare(struct vm_area_stru
 			avc->anon_vma = anon_vma;
 			avc->vma = vma;
 			list_add(&avc->same_vma, &vma->anon_vma_chain);
-			list_add(&avc->same_anon_vma, &anon_vma->head);
+			list_add_tail(&avc->same_anon_vma, &anon_vma->head);
 			allocated = NULL;
 			avc = NULL;
 		}
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


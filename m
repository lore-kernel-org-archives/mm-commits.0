From: akpm@linux-foundation.org
Subject: + rmap-always-use-anon_vma-root-pointer.patch added to -mm tree
Date: Tue, 22 Jun 2010 14:08:55 -0700
Message-ID: <201006222108.o5ML8tTe002154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240Ab0FVVJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jun 2010 17:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, riel@redhat.com


The patch titled
     rmap: always use anon_vma root pointer
has been added to the -mm tree.  Its filename is
     rmap-always-use-anon_vma-root-pointer.patch

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
Subject: rmap: always use anon_vma root pointer
From: Andrea Arcangeli <aarcange@redhat.com>

Always use anon_vma->root pointer instead of anon_vma_chain.prev.

Also optimize the map-paths, if a mapping is already established no need
to overwrite it with root anon-vma list, we can keep the more finegrined
anon-vma and skip the overwrite: see the PageAnon check in !exclusive
case.  This is also the optimization that hidden the ksm bug as this tends
to make ksm_might_need_to_copy skip the copy, but only the proper fix to
ksm_might_need_to_copy guarantees not triggering the ksm bug unless ksm is
in use.  this is an optimization only...

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN mm/rmap.c~rmap-always-use-anon_vma-root-pointer mm/rmap.c
--- a/mm/rmap.c~rmap-always-use-anon_vma-root-pointer
+++ a/mm/rmap.c
@@ -777,15 +777,13 @@ static void __page_set_anon_rmap(struct 
 	 * If the page isn't exclusively mapped into this vma,
 	 * we must use the _oldest_ possible anon_vma for the
 	 * page mapping!
-	 *
-	 * So take the last AVC chain entry in the vma, which is
-	 * the deepest ancestor, and use the anon_vma from that.
 	 */
 	if (!exclusive) {
-		struct anon_vma_chain *avc;
-		avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
-		anon_vma = avc->anon_vma;
-	}
+		if (PageAnon(page))
+			return;
+		anon_vma = anon_vma->root;
+	} else
+		BUG_ON(PageAnon(page));
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	page->mapping = (struct address_space *) anon_vma;
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


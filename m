From: akpm@linux-foundation.org
Subject: + add-anon_vma-bug-checks.patch added to -mm tree
Date: Tue, 22 Jun 2010 14:08:59 -0700
Message-ID: <201006222108.o5ML8x0F002160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240Ab0FVVJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jun 2010 17:09:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, riel@redhat.com


The patch titled
     rmap: add anon_vma bug checks
has been added to the -mm tree.  Its filename is
     add-anon_vma-bug-checks.patch

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
Subject: rmap: add anon_vma bug checks
From: Andrea Arcangeli <aarcange@redhat.com>

Verify the refcounting doesn't go wrong, and resurrect the check in
__page_check_anon_rmap as in old anon-vma code.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/rmap.c~add-anon_vma-bug-checks mm/rmap.c
--- a/mm/rmap.c~add-anon_vma-bug-checks
+++ a/mm/rmap.c
@@ -813,6 +813,7 @@ static void __page_check_anon_rmap(struc
 	 * are initially only visible via the pagetables, and the pte is locked
 	 * over the call to page_add_new_anon_rmap.
 	 */
+	BUG_ON(page_anon_vma(page)->root != vma->anon_vma->root);
 	BUG_ON(page->index != linear_page_index(vma, address));
 #endif
 }
@@ -1416,6 +1417,7 @@ int try_to_munlock(struct page *page)
  */
 void drop_anon_vma(struct anon_vma *anon_vma)
 {
+	BUG_ON(atomic_read(&anon_vma->external_refcount) <= 0);
 	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->root->lock)) {
 		struct anon_vma *root = anon_vma->root;
 		int empty = list_empty(&anon_vma->head);
@@ -1427,6 +1429,7 @@ void drop_anon_vma(struct anon_vma *anon
 		 * the refcount on the root and check if we need to free it.
 		 */
 		if (empty && anon_vma != root) {
+			BUG_ON(atomic_read(&root->external_refcount) <= 0);
 			last_root_user = atomic_dec_and_test(&root->external_refcount);
 			root_empty = list_empty(&root->head);
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


From: akpm@linux-foundation.org
Subject: [merged]
 revert-mm-rmapc-reuse-mergeable-anon_vma-as-parent-when-fork.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 18:56:20 -0700
Message-ID: <20200408015620.9gjzFQzxE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgDHB4V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org, riel@redhat.com, willy@infradead.org


The patch titled
     Subject: Revert "mm/rmap.c: reuse mergeable anon_vma as parent when fork"
has been removed from the -mm tree.  Its filename was
     revert-mm-rmapc-reuse-mergeable-anon_vma-as-parent-when-fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: Revert "mm/rmap.c: reuse mergeable anon_vma as parent when fork"

This reverts commit 4e4a9eb921332b9d1 ("mm/rmap.c: reuse mergeable
anon_vma as parent when fork").

In dup_mmap(), anon_vma_fork() is called for attaching anon_vma and
parameter 'tmp' (i.e., the new vma of child) has same ->vm_next and
->vm_prev as its parent vma.  That causes the anon_vma used by parent been
mistakenly shared by child (In anon_vma_clone(), the code added by that
commit will do this reuse work).

Besides this issue, the design of reusing anon_vma from vma which has gone
through fork should be avoided ([1]).  So, this patch reverts that commit
and maintains the consistent logic of reusing anon_vma for
fork/split/merge vma.

Reusing anon_vma within the process is fine.  But if a vma has gone
through fork(), then that vma's anon_vma should not be shared with its
neighbor vma.  As explained in [1], when vma gone through fork(), the
check for list_is_singular(vma->anon_vma_chain) will be false, and
don't share anon_vma.

With current issue, one example can clarify more.  Parent process do
below two steps:

1. p_vma_1 is created and p_anon_vma_1 is prepared;

2. p_vma_2 is created and share p_anon_vma_1; (this is allowed,
   becaues p_vma_1 didn't gothrough fork()); parent process do fork():

3. c_vma_1 is dup from p_vma_1, and has its own c_anon_vma_1
   prepared; at this point, c_vma_1->anon_vma_chain has two items, one
   for p_anon_vma_1 and one for c_anon_vma_1;

4. c_vma_2 is dup from p_vma_2, it is not allowed to share
   c_anon_vma_1, because

c_vma_1->anon_vma_chain has two items.
[1] commit d0e9fe1758f2 ("Simplify and comment on anon_vma re-use for
    anon_vma_prepare()") explains the test of "list_is_singular()".

Link: http://lkml.kernel.org/r/1581150928-3214-3-git-send-email-lixinhai.lxh@gmail.com
Fixes: 4e4a9eb92133 ("mm/rmap.c: reuse mergeable anon_vma as parent when fork")
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/mm/rmap.c~revert-mm-rmapc-reuse-mergeable-anon_vma-as-parent-when-fork
+++ a/mm/rmap.c
@@ -275,19 +275,6 @@ int anon_vma_clone(struct vm_area_struct
 {
 	struct anon_vma_chain *avc, *pavc;
 	struct anon_vma *root = NULL;
-	struct vm_area_struct *prev = dst->vm_prev, *pprev = src->vm_prev;
-
-	/*
-	 * If parent share anon_vma with its vm_prev, keep this sharing in in
-	 * child.
-	 *
-	 * 1. Parent has vm_prev, which implies we have vm_prev.
-	 * 2. Parent and its vm_prev have the same anon_vma.
-	 */
-	if (!dst->anon_vma && src->anon_vma &&
-	    pprev && pprev->anon_vma == src->anon_vma)
-		dst->anon_vma = prev->anon_vma;

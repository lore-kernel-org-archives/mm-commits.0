From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 revert-mm-rmapc-reuse-mergeable-anon_vma-as-parent-when-fork.patch added to
 -mm tree
Date: Sun, 09 Feb 2020 16:55:34 -0800
Message-ID: <20200210005534.d9GIlYfvV%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgBJAzg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 19:55:36 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org, riel@redhat.com, willy@infradead.org


The patch titled
     Subject: Revert "mm/rmap.c: reuse mergeable anon_vma as parent when fork"
has been added to the -mm tree.  Its filename is
     revert-mm-rmapc-reuse-mergeable-anon_vma-as-parent-when-fork.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-mm-rmapc-reuse-mergeable-anon_vma-as-parent-when-fork.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-rmapc-reuse-mergeable-anon_vma-as-parent-when-fork.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -269,19 +269,6 @@ int anon_vma_clone(struct vm_area_struct
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

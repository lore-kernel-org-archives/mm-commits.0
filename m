From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 002/166] mm: don't prepare anon_vma if vma has
 VM_WIPEONFORK
Date: Mon, 06 Apr 2020 20:03:33 -0700
Message-ID: <20200407030333.lRZnlkrMc%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDDf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:03:35 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org, riel@redhat.com, torvalds@linux-foundation.org

From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm: don't prepare anon_vma if vma has VM_WIPEONFORK

Patch series "mm: Fix misuse of parent anon_vma in dup_mmap path".

This patchset fixes the misuse of parenet anon_vma, which mainly caused by
child vma's vm_next and vm_prev are left same as its parent after
duplicate vma.  Finally, code reached parent vma's neighbor by referring
pointer of child vma and executed wrong logic.

The first two patches fix relevant issues, and the third patch sets
vm_next and vm_prev to NULL when duplicate vma to prevent potential misuse
in future.  

Effects of the first bug is that causes rmap code to check both parent and
child's page table, although a page couldn't be mapped by both parent and
child, because child vma has WIPEONFORK so all pages mapped by child are
'new' and not relevant to parent.

Effects of the second bug is that the relationship of anon_vma of parent
and child are totallyconvoluted.  It would cause 'son', 'grandson', ...,
etc, to share 'parent' anon_vma, which disobey the design rule of reusing
anon_vma (the rule to be followed is that reusing should among vma of same
process, and vma should not gone through fork).

So, both issues should cause unnecessary rmap walking and have unexpected
complexity.

These two issues would not be directly visible, I used debugging code to
check the anon_vma pointers of parent and child when inspecting the
suspicious implementation of issue #2, then find the problem.


This patch (of 3):

In dup_mmap(), anon_vma_prepare() is called for vma has VM_WIPEONFORK, and
parameter 'tmp' (i.e., the new vma of child) has same ->vm_next and
->vm_prev as its parent vma.  That allows anon_vma used by parent been
mistakenly shared by child (find_mergeable_anon_vma() will do this reuse
work).

Besides this issue, call anon_vma_prepare() should be avoided because we
don't copy page for this vma.  Preparing anon_vma will be handled during
fault.

Link: http://lkml.kernel.org/r/1581150928-3214-2-git-send-email-lixinhai.lxh@gmail.com
Fixes: d2cd9ede6e19 ("mm,fork: introduce MADV_WIPEONFORK")
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/fork.c~mm-dont-prepare-anon_vma-if-vma-has-vm_wipeonfork
+++ a/kernel/fork.c
@@ -553,10 +553,12 @@ static __latent_entropy int dup_mmap(str
 		if (retval)
 			goto fail_nomem_anon_vma_fork;
 		if (tmp->vm_flags & VM_WIPEONFORK) {
-			/* VM_WIPEONFORK gets a clean slate in the child. */
+			/*
+			 * VM_WIPEONFORK gets a clean slate in the child.
+			 * Don't prepare anon_vma until fault since we don't
+			 * copy page for current vma.
+			 */
 			tmp->anon_vma = NULL;
-			if (anon_vma_prepare(tmp))
-				goto fail_nomem_anon_vma_fork;
 		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
 		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
_

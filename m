From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-prepare-anon_vma-if-vma-has-vm_wipeonfork.patch
 added to -mm tree
Date: Sun, 09 Feb 2020 16:55:31 -0800
Message-ID: <20200210005531.c4Hj2dl6a%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgBJAze (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 19:55:34 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org, riel@redhat.com, willy@infradead.org


The patch titled
     Subject: mm: don't prepare anon_vma if vma has VM_WIPEONFORK
has been added to the -mm tree.  Its filename is
     mm-dont-prepare-anon_vma-if-vma-has-vm_wipeonfork.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-prepare-anon_vma-if-vma-has-vm_wipeonfork.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-prepare-anon_vma-if-vma-has-vm_wipeonfork.patch

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
Subject: mm: don't prepare anon_vma if vma has VM_WIPEONFORK

Patch series "mm: Fix misuse of parent anon_vma in dup_mmap path".

This patchset fixes the misuse of parenet anon_vma, which mainly caused by
child vma's vm_next and vm_prev are left same as its parent after
duplicate vma.  Finally, code reached parent vma's neighbor by referring
pointer of child vma and executed wrong logic.

The first two patches fix relevant issues, and the third patch sets
vm_next and vm_prev to NULL when duplicate vma to prevent potential misuse
in future.  


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
Cc: Rik van Riel <riel@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/fork.c~mm-dont-prepare-anon_vma-if-vma-has-vm_wipeonfork
+++ a/kernel/fork.c
@@ -552,10 +552,12 @@ static __latent_entropy int dup_mmap(str
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

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-dont-prepare-anon_vma-if-vma-has-vm_wipeonfork.patch
revert-mm-rmapc-reuse-mergeable-anon_vma-as-parent-when-fork.patch
mm-set-vm_next-and-vm_prev-to-null-in-vm_area_dup.patch

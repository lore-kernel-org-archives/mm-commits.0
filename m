From: akpm@linux-foundation.org
Subject: + slub-partly-fix-freeze-in-__slab_free.patch added to -mm tree
Date: Mon, 11 Jul 2011 12:13:31 -0700
Message-ID: <201107111913.p6BJDXaw028858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165Ab1GKTOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jul 2011 15:14:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, cl@linux.com, penberg@cs.helsinki.fi


The patch titled
     slub: partly fix freeze in __slab_free
has been added to the -mm tree.  Its filename is
     slub-partly-fix-freeze-in-__slab_free.patch

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
Subject: slub: partly fix freeze in __slab_free
From: Hugh Dickins <hughd@google.com>

My load tests on PowerPC freeze within minutes in __slab_free().  I
happened to try PPC first, didn't try without this fix on x86.

It looks as if the author was interrupted while devising the new
cmpxchg_double_slab() version of __slab_free(): its decision to
spin_lock_irqsave() depends on several uninitialized fields, and fixing
that (by copying page to new) mostly fixes it.

But I didn't think about it very much, and this may well not be what the
author intends; and I have seen a couple of much rarer freezes in
__slab_free() on PPC (not yet on x86) even after applying this.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slub.c~slub-partly-fix-freeze-in-__slab_free mm/slub.c
--- a/mm/slub.c~slub-partly-fix-freeze-in-__slab_free
+++ a/mm/slub.c
@@ -2217,6 +2217,7 @@ static void __slab_free(struct kmem_cach
 		return;
 
 	do {
+		new = *page;
 		prior = page->freelist;
 		counters = page->counters;
 		set_freepointer(s, object, prior);
_

Patches currently in -mm which might be from hughd@google.com are

mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
linux-next.patch
slub-partly-fix-freeze-in-__slab_free.patch
tmpfs-clone-shmem_file_splice_read.patch
tmpfs-refine-shmem_file_splice_read.patch
tmpfs-pass-gfp-to-shmem_getpage_gfp.patch
tmpfs-remove_shmem_readpage.patch
tmpfs-simplify-prealloc_page.patch
tmpfs-simplify-filepage-swappage.patch
tmpfs-simplify-unuse-and-writepage.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
prio_tree-debugging-patch.patch


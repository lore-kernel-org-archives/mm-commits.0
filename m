From: akpm@linux-foundation.org
Subject: [withdrawn] slub-partly-fix-freeze-in-__slab_free.patch removed from -mm tree
Date: Thu, 28 Jul 2011 14:16:00 -0700
Message-ID: <201107282116.p6SLG0Lg009127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987Ab1G1VQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 17:16:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, cl@linux.com, penberg@cs.helsinki.fi, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     slub: partly fix freeze in __slab_free
has been removed from the -mm tree.  Its filename was
     slub-partly-fix-freeze-in-__slab_free.patch

This patch was dropped because it was withdrawn

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
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slub.c~slub-partly-fix-freeze-in-__slab_free mm/slub.c
--- a/mm/slub.c~slub-partly-fix-freeze-in-__slab_free
+++ a/mm/slub.c
@@ -2326,6 +2326,7 @@ static void __slab_free(struct kmem_cach
 		return;
 
 	do {
+		new = *page;
 		prior = page->freelist;
 		counters = page->counters;
 		set_freepointer(s, object, prior);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
radix_tree-clean-away-saw_unset_tag-leftovers.patch
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
tmpfs-radix_tree-locate_item-to-speed-up-swapoff.patch
mm-clarify-the-radix_tree-exceptional-cases.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
prio_tree-debugging-patch.patch


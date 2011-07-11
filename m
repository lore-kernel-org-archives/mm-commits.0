From: akpm@linux-foundation.org
Subject: + slab-fix-debug_slab-build.patch added to -mm tree
Date: Mon, 11 Jul 2011 14:01:47 -0700
Message-ID: <201107112101.p6BL1lX6003245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757624Ab1GKVCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jul 2011 17:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, cl@linux.com, penberg@cs.helsinki.fi


The patch titled
     slab: fix DEBUG_SLAB build
has been added to the -mm tree.  Its filename is
     slab-fix-debug_slab-build.patch

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
Subject: slab: fix DEBUG_SLAB build
From: Hugh Dickins <hughd@google.com>

Fix CONFIG_SLAB=y CONFIG_DEBUG_SLAB=y build error and warnings.

Now that ARCH_SLAB_MINALIGN defaults to __alignof__(unsigned long long),
it is always defined (when slab.h included), but cannot be used in #if:
mm/slab.c: In function `cache_alloc_debugcheck_after':
mm/slab.c:3156:5: warning: "__alignof__" is not defined
mm/slab.c:3156:5: error: missing binary operator before token "("
make[1]: *** [mm/slab.o] Error 1

So just remove the #if and #endif lines, but then 64-bit build warns:
mm/slab.c: In function `cache_alloc_debugcheck_after':
mm/slab.c:3156:6: warning: cast from pointer to integer of different size
mm/slab.c:3158:10: warning: format `%d' expects type `int', but argument
                            3 has type `long unsigned int'
Fix those with casts, whatever the actual type of ARCH_SLAB_MINALIGN.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~slab-fix-debug_slab-build mm/slab.c
--- a/mm/slab.c~slab-fix-debug_slab-build
+++ a/mm/slab.c
@@ -3153,12 +3153,10 @@ static void *cache_alloc_debugcheck_afte
 	objp += obj_offset(cachep);
 	if (cachep->ctor && cachep->flags & SLAB_POISON)
 		cachep->ctor(objp);
-#if ARCH_SLAB_MINALIGN
-	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
+	if ((unsigned long)objp & (ARCH_SLAB_MINALIGN-1)) {
 		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
-		       objp, ARCH_SLAB_MINALIGN);
+		       objp, (int)ARCH_SLAB_MINALIGN);
 	}
-#endif
 	return objp;
 }
 #else
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
slab-fix-debug_slab-build.patch
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


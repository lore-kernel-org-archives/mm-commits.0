From: akpm@linux-foundation.org
Subject: - mm-document-tree_lock-zonelock-lockorder.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:52:17 -0700
Message-ID: <200710180652.l9I6qHYT030274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48190 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932122AbXJRHhk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: document tree_lock->zone.lock lockorder
has been removed from the -mm tree.  Its filename was
     mm-document-tree_lock-zonelock-lockorder.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: document tree_lock->zone.lock lockorder
From: Nick Piggin <npiggin@suse.de>

zone->lock is quite an "inner" lock and mostly constrained to page alloc as
well, so like slab locks, it probably isn't something that is critically
important to document here.  However unlike slab locks, zone lock could be
used more widely in future, and page_alloc.c might possibly have more
business to do tricky things with pagecache than does slab.  So...  I don't
think it hurts to document it.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 +
 mm/rmap.c    |    1 +
 2 files changed, 2 insertions(+)

diff -puN mm/filemap.c~mm-document-tree_lock-zonelock-lockorder mm/filemap.c
--- a/mm/filemap.c~mm-document-tree_lock-zonelock-lockorder
+++ a/mm/filemap.c
@@ -63,6 +63,7 @@ generic_file_direct_IO(int rw, struct ki
  *    ->private_lock		(__free_pte->__set_page_dirty_buffers)
  *      ->swap_lock		(exclusive_swap_page, others)
  *        ->mapping->tree_lock
+ *          ->zone.lock
  *
  *  ->i_mutex
  *    ->i_mmap_lock		(truncate->unmap_mapping_range)
diff -puN mm/rmap.c~mm-document-tree_lock-zonelock-lockorder mm/rmap.c
--- a/mm/rmap.c~mm-document-tree_lock-zonelock-lockorder
+++ a/mm/rmap.c
@@ -36,6 +36,7 @@
  *                 mapping->tree_lock (widely used, in set_page_dirty,
  *                           in arch-dependent flush_dcache_mmap_lock,
  *                           within inode_lock in __sync_single_inode)
+ *                   zone->lock (within radix tree node alloc)
  */
 
 #include <linux/mm.h>
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch

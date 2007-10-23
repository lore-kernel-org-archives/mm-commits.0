From: akpm@linux-foundation.org
Subject: - slub-avoid-atomic-operation-for-slab_unlock.patch removed from -mm tree
Date: Tue, 23 Oct 2007 12:30:03 -0700
Message-ID: <200710231930.l9NJU3lS002795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59945 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178AbXJWTaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 15:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     SLUB: avoid atomic operation for slab_unlock
has been removed from the -mm tree.  Its filename was
     slub-avoid-atomic-operation-for-slab_unlock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: SLUB: avoid atomic operation for slab_unlock
From: Christoph Lameter <clameter@sgi.com>

Currently page flags are only modified in SLUB under page lock.  This means
that we do not need an atomic operation to release the lock since there is
nothing we can race against that is modifying page flags.  We can simply
clear the bit without the use of an atomic operation and make sure that
this change becomes visible after the other changes to slab metadata
through a memory barrier.

The performance of slab_free() increases 10-15% (SMP configuration doing
a long series of remote frees).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-avoid-atomic-operation-for-slab_unlock mm/slub.c
--- a/mm/slub.c~slub-avoid-atomic-operation-for-slab_unlock
+++ a/mm/slub.c
@@ -1181,9 +1181,22 @@ static __always_inline void slab_lock(st
 	bit_spin_lock(PG_locked, &page->flags);
 }
 
+/*
+ * Slab unlock version that avoids having to use atomic operations
+ * (echos some of the code of bit_spin_unlock!)
+ */
 static __always_inline void slab_unlock(struct page *page)
 {
-	bit_spin_unlock(PG_locked, &page->flags);
+#ifdef CONFIG_SMP
+	unsigned long flags;
+
+	flags = page->flags & ~(1 << PG_locked);
+
+	smp_wmb();
+	page->flags = flags;
+#endif
+	preempt_enable();
+	__release(bitlock);
 }
 
 static __always_inline int slab_trylock(struct page *page)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-unionfs.patch
git-x86.patch
slub-avoid-atomic-operation-for-slab_unlock.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

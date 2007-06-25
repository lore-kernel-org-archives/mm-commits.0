From: akpm@linux-foundation.org
Subject: + mm-kill-validate_anon_vma-to-avoid-mapcount-bug.patch added to -mm tree
Date: Mon, 25 Jun 2007 14:46:03 -0700
Message-ID: <200706252146.l5PLk3UX011534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327AbXFYVqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 17:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, andrea@suse.de, npiggin@suse.de, petr@vmware.com, stable@kernel.org


The patch titled
     mm: kill validate_anon_vma to avoid mapcount BUG
has been added to the -mm tree.  Its filename is
     mm-kill-validate_anon_vma-to-avoid-mapcount-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: kill validate_anon_vma to avoid mapcount BUG
From: Hugh Dickins <hugh@veritas.com>

validate_anon_vma gave a useful check on the integrity of the anon_vma list
when Andrea was developing obj rmap; but it was not enabled in SLES9
itself, nor in mainline, until Nick changed commented-out RMAP_DEBUG to
configurable CONFIG_DEBUG_VM in 2.6.17.  Now Petr Vandrovec reports that
its BUG_ON(mapcount > 100000) can easily crash a CONFIG_DEBUG_VM=y system.

That limit was just an arbitrary number to protect against an infinite
loop.  We could raise it to something enormous (depending on sizeof struct
vma and size of memory?); but I rather think validate_anon_vma has outlived
its usefulness, and is better just removed - which gives a magnificent
performance boost to anything like Petr's test program ;)

Of course, a very long anon_vma list is bad news for preemption latency,
and I believe there has been one recent report of such: let's not forget
that, but validate_anon_vma only makes it worse not better.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Petr Vandrovec <petr@vmware.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Andrea Arcangeli <andrea@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   24 +-----------------------
 1 files changed, 1 insertion(+), 23 deletions(-)

diff -puN mm/rmap.c~mm-kill-validate_anon_vma-to-avoid-mapcount-bug mm/rmap.c
--- a/mm/rmap.c~mm-kill-validate_anon_vma-to-avoid-mapcount-bug
+++ a/mm/rmap.c
@@ -53,24 +53,6 @@
 
 struct kmem_cache *anon_vma_cachep;
 
-static inline void validate_anon_vma(struct vm_area_struct *find_vma)
-{
-#ifdef CONFIG_DEBUG_VM
-	struct anon_vma *anon_vma = find_vma->anon_vma;
-	struct vm_area_struct *vma;
-	unsigned int mapcount = 0;
-	int found = 0;
-
-	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
-		mapcount++;
-		BUG_ON(mapcount > 100000);
-		if (vma == find_vma)
-			found = 1;
-	}
-	BUG_ON(!found);
-#endif
-}
-
 /* This must be called under the mmap_sem. */
 int anon_vma_prepare(struct vm_area_struct *vma)
 {
@@ -121,10 +103,8 @@ void __anon_vma_link(struct vm_area_stru
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 
-	if (anon_vma) {
+	if (anon_vma)
 		list_add_tail(&vma->anon_vma_node, &anon_vma->head);
-		validate_anon_vma(vma);
-	}
 }
 
 void anon_vma_link(struct vm_area_struct *vma)
@@ -134,7 +114,6 @@ void anon_vma_link(struct vm_area_struct
 	if (anon_vma) {
 		spin_lock(&anon_vma->lock);
 		list_add_tail(&vma->anon_vma_node, &anon_vma->head);
-		validate_anon_vma(vma);
 		spin_unlock(&anon_vma->lock);
 	}
 }
@@ -148,7 +127,6 @@ void anon_vma_unlink(struct vm_area_stru
 		return;
 
 	spin_lock(&anon_vma->lock);
-	validate_anon_vma(vma);
 	list_del(&vma->anon_vma_node);
 
 	/* We must garbage collect the anon_vma if it's empty */
_

Patches currently in -mm which might be from hugh@veritas.com are

mm-kill-validate_anon_vma-to-avoid-mapcount-bug.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
pa-risc-use-page-allocator-instead-of-slab-allocator-fix.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
hugetlbfs-use-lib-parser-fix-docs.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
prio_tree-debugging-patch.patch

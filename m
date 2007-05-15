From: akpm@linux-foundation.org
Subject: + prio_tree-debugging-patch.patch added to -mm tree
Date: Tue, 15 May 2007 14:35:55 -0700
Message-ID: <200705152135.l4FLZtu7018579@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbXEOViM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 17:38:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, jaysonsantos2003@yahoo.com.br


The patch titled
     prio_tree: debugging patch
has been added to the -mm tree.  Its filename is
     prio_tree-debugging-patch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: prio_tree: debugging patch
From: Hugh Dickins <hugh@veritas.com>

Jayson Santos has sighted mm/prio_tree.c:78,79 BUGs (kernel bugzilla 8446),
and one was sighted a couple of years ago.  No reason yet to suppose
they're prio_tree bugs, but we can't tell much about them without seeing
the vmas.

So dump vma and the one it's supposed to resemble: I had expected to use
print_hex_dump(), but that's designed for u8 dumps, whereas almost every
field of vm_area_struct is either a pointer or an unsigned long - which
look nonsense dumped as u8s.

Replace the two BUG_ONs by a single WARN_ON; and if it fires, just keep
this vma out of the tree (truncation and swapout won't be able to find it).
 How safe this is depends on what the error really is; but we hold a file's
i_mmap_lock here, so it may be impossible to recover from BUG_ON.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Jayson Santos <jaysonsantos2003@yahoo.com.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/prio_tree.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff -puN mm/prio_tree.c~prio_tree-debugging-patch mm/prio_tree.c
--- a/mm/prio_tree.c~prio_tree-debugging-patch
+++ a/mm/prio_tree.c
@@ -67,6 +67,20 @@
  * 	vma->shared.vm_set.head == NULL ==> a list node
  */
 
+static void dump_vma(struct vm_area_struct *vma)
+{
+	void **ptr = (void **) vma;
+	int i;
+
+	printk("vm_area_struct at %p:", ptr);
+	for (i = 0; i < sizeof(*vma)/sizeof(*ptr); i++, ptr++) {
+		if (!(i & 3))
+			printk("\n");
+		printk(" %p", *ptr);
+	}
+	printk("\n");
+}
+
 /*
  * Add a new vma known to map the same set of pages as the old vma:
  * useful for fork's dup_mmap as well as vma_prio_tree_insert below.
@@ -74,14 +88,23 @@
  */
 void vma_prio_tree_add(struct vm_area_struct *vma, struct vm_area_struct *old)
 {
-	/* Leave these BUG_ONs till prio_tree patch stabilizes */
-	BUG_ON(RADIX_INDEX(vma) != RADIX_INDEX(old));
-	BUG_ON(HEAP_INDEX(vma) != HEAP_INDEX(old));
-
 	vma->shared.vm_set.head = NULL;
 	vma->shared.vm_set.parent = NULL;
 
-	if (!old->shared.vm_set.parent)
+	if (WARN_ON(RADIX_INDEX(vma) != RADIX_INDEX(old) ||
+		    HEAP_INDEX(vma)  != HEAP_INDEX(old))) {
+		/*
+		 * This should never happen, yet it has been seen a few times:
+		 * we cannot say much about it without seeing the vma contents.
+		 */
+		dump_vma(vma);
+		dump_vma(old);
+		/*
+		 * Don't try to link this (corrupt?) vma into the (corrupt?)
+		 * prio_tree, but arrange for its removal to succeed later.
+		 */
+		INIT_LIST_HEAD(&vma->shared.vm_set.list);
+	} else if (!old->shared.vm_set.parent)
 		list_add(&vma->shared.vm_set.list,
 				&old->shared.vm_set.list);
 	else if (old->shared.vm_set.head)
_

Patches currently in -mm which might be from hugh@veritas.com are

slub-dont-confuse-ctor-and-dtor.patch
scsi-fix-config_scsi_wait_scan=m.patch
i386-dont-check_pgt_cache-in-flush_tlb_mm.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
mm-more-rmap-checking.patch
mm-more-rmap-checking-tidy.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
prio_tree-debugging-patch.patch

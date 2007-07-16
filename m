From: akpm@linux-foundation.org
Subject: - mspec_mmap-dont-set-vm_locked.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:49:48 -0700
Message-ID: <200707162049.l6GKnmSp001193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44717 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756209AbXGPVdu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:33:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, dmonakhov@sw.ru, jes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mspec_mmap: don't set VM_LOCKED
has been removed from the -mm tree.  Its filename was
     mspec_mmap-dont-set-vm_locked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mspec_mmap: don't set VM_LOCKED
From: Hugh Dickins <hugh@veritas.com>

mspec_mmap was setting VM_LOCKED (without adjusting locked_vm): don't do
that, it serves no purpose in 2.6, other than to mess up the locked_vm
accounting - mspec's pages won't get reclaimed anyway.  Thanks to Dmitry
Monakhov for raising the issue.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Jes Sorensen <jes@sgi.com>
Cc: Dmitry Monakhov <dmonakhov@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mspec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mspec.c~mspec_mmap-dont-set-vm_locked drivers/char/mspec.c
--- a/drivers/char/mspec.c~mspec_mmap-dont-set-vm_locked
+++ a/drivers/char/mspec.c
@@ -265,7 +265,7 @@ mspec_mmap(struct file *file, struct vm_
 	vdata->refcnt = ATOMIC_INIT(1);
 	vma->vm_private_data = vdata;
 
-	vma->vm_flags |= (VM_IO | VM_LOCKED | VM_RESERVED | VM_PFNMAP);
+	vma->vm_flags |= (VM_IO | VM_RESERVED | VM_PFNMAP);
 	if (vdata->type == MSPEC_FETCHOP || vdata->type == MSPEC_UNCACHED)
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_ops = &mspec_vm_ops;
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
mm-avoid-tlb-gather-restarts.patch
mm-remove-ptep_establish.patch
mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
mm-variable-length-argument-support.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
prio_tree-debugging-patch.patch

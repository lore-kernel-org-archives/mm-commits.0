From: akpm@linux-foundation.org
Subject: + mm-recheck-lock-rlim-after-f_op-mmap-method.patch added to -mm tree
Date: Wed, 11 Jul 2007 11:36:38 -0700
Message-ID: <200707111836.l6BIacND007889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35571 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954AbXGKShf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 14:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, dmonakhov@sw.ru, jes@sgi.com


The patch titled
     mm: recheck lock rlim after f_op->mmap() method
has been added to the -mm tree.  Its filename is
     mm-recheck-lock-rlim-after-f_op-mmap-method.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: recheck lock rlim after f_op->mmap() method
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
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mspec.c~mm-recheck-lock-rlim-after-f_op-mmap-method drivers/char/mspec.c
--- a/drivers/char/mspec.c~mm-recheck-lock-rlim-after-f_op-mmap-method
+++ a/drivers/char/mspec.c
@@ -274,7 +274,7 @@ mspec_mmap(struct file *file, struct vm_
 	vdata->refcnt = ATOMIC_INIT(1);
 	vma->vm_private_data = vdata;
 
-	vma->vm_flags |= (VM_IO | VM_LOCKED | VM_RESERVED | VM_PFNMAP);
+	vma->vm_flags |= (VM_IO | VM_RESERVED | VM_PFNMAP);
 	if (vdata->type == MSPEC_FETCHOP || vdata->type == MSPEC_UNCACHED)
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_ops = &mspec_vm_ops;
_

Patches currently in -mm which might be from hugh@veritas.com are

pa-risc-use-page-allocator-instead-of-slab-allocator.patch
git-block.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
mm-recheck-lock-rlim-after-f_op-mmap-method.patch
mm-avoid-tlb-gather-restarts.patch
mm-remove-ptep_establish.patch
mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
hugetlbfs-use-lib-parser-fix-docs.patch
ext2-reservations.patch
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

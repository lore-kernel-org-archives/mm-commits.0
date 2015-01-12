From: akpm@linux-foundation.org
Subject: + mm-fix-xip-fault-vs-truncate-race-fix.patch added to -mm tree
Date: Mon, 12 Jan 2015 15:10:36 -0800
Message-ID: <54b4546c.ja/rzBfO1Ldl0Etu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbbALXKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:10:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, matthew.r.wilcox@intel.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-xip-fault-vs-truncate-race-fix
has been added to the -mm tree.  Its filename is
     mm-fix-xip-fault-vs-truncate-race-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-xip-fault-vs-truncate-race-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-xip-fault-vs-truncate-race-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-xip-fault-vs-truncate-race-fix

switch to i_mmap_lock_read(), add comment in unmap_single_vma()

Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap_xip.c |   20 +++++++++++++-------
 mm/memory.c      |    5 +++++
 2 files changed, 18 insertions(+), 7 deletions(-)

diff -puN mm/filemap_xip.c~mm-fix-xip-fault-vs-truncate-race-fix mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-fix-xip-fault-vs-truncate-race-fix
+++ a/mm/filemap_xip.c
@@ -255,17 +255,20 @@ again:
 		__xip_unmap(mapping, vmf->pgoff);
 
 found:
-		/* We must recheck i_size under i_mmap_mutex */
-		mutex_lock(&mapping->i_mmap_mutex);
+		/*
+		 * We must recheck i_size under i_mmap_rwsem to prevent races
+		 * with truncation
+		 */
+		i_mmap_lock_read(mapping);
 		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
 							PAGE_CACHE_SHIFT;
 		if (unlikely(vmf->pgoff >= size)) {
-			mutex_unlock(&mapping->i_mmap_mutex);
+			i_mmap_unlock_read(mapping);
 			return VM_FAULT_SIGBUS;
 		}
 		err = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
 							xip_pfn);
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_read(mapping);
 		if (err == -ENOMEM)
 			return VM_FAULT_OOM;
 		/*
@@ -290,8 +293,11 @@ found:
 		if (error != -ENODATA)
 			goto out;
 
-		/* We must recheck i_size under i_mmap_mutex */
-		mutex_lock(&mapping->i_mmap_mutex);
+		/*
+		 * We must recheck i_size under i_mmap_rwsem to prevent races
+		 * with truncation
+		 */
+		i_mmap_lock_read(mapping);
 		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
 							PAGE_CACHE_SHIFT;
 		if (unlikely(vmf->pgoff >= size)) {
@@ -309,7 +315,7 @@ found:
 
 		ret = VM_FAULT_NOPAGE;
 unlock:
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_read(mapping);
 out:
 		write_seqcount_end(&xip_sparse_seq);
 		mutex_unlock(&xip_sparse_mutex);
diff -puN mm/memory.c~mm-fix-xip-fault-vs-truncate-race-fix mm/memory.c
--- a/mm/memory.c~mm-fix-xip-fault-vs-truncate-race-fix
+++ a/mm/memory.c
@@ -1327,6 +1327,11 @@ static void unmap_single_vma(struct mmu_
 			 * safe to do nothing in this case.
 			 */
 			if (vma->vm_file) {
+				/*
+				 * Note that DAX uses i_mmap_lock to serialise
+				 * against file truncate - truncate calls into
+				 * unmap_single_vma().
+				 */
 				i_mmap_lock_write(vma->vm_file->f_mapping);
 				__unmap_hugepage_range_final(tlb, vma, start, end, NULL);
 				i_mmap_unlock_write(vma->vm_file->f_mapping);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
dax-add-dax_zero_page_range-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


From: akpm@linux-foundation.org
Subject: +
 daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch added to -mm tree
Date: Mon, 12 Jan 2015 15:10:52 -0800
Message-ID: <54b4547c.60aogvkTZBJ6w3VF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbbALXKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:10:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, matthew.r.wilcox@intel.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix
has been added to the -mm tree.  Its filename is
     daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch

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
Subject: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix

Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/dax.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix fs/dax.c
--- a/fs/dax.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix
+++ a/fs/dax.c
@@ -279,7 +279,7 @@ static int dax_insert_mapping(struct ino
 	pgoff_t size;
 	int error;
 
-	mutex_lock(&mapping->i_mmap_mutex);
+	i_mmap_lock_read(mapping);
 
 	/*
 	 * Check truncate didn't happen while we were allocating a block.
@@ -308,7 +308,7 @@ static int dax_insert_mapping(struct ino
 	error = vm_insert_mixed(vma, vaddr, pfn);
 
  out:
-	mutex_unlock(&mapping->i_mmap_mutex);
+	i_mmap_unlock_read(mapping);
 
 	if (bh->b_end_io)
 		bh->b_end_io(bh, 1);
@@ -389,12 +389,12 @@ static int do_dax_fault(struct vm_area_s
 			goto unlock_page;
 		vmf->page = page;
 		if (!page) {
-			mutex_lock(&mapping->i_mmap_mutex);
+			i_mmap_lock_read(mapping);
 			/* Check we didn't race with truncate */
 			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
 								PAGE_SHIFT;
 			if (vmf->pgoff >= size) {
-				mutex_unlock(&mapping->i_mmap_mutex);
+				i_mmap_unlock_read(mapping);
 				error = -EIO;
 				goto out;
 			}
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


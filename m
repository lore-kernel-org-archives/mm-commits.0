From: akpm@linux-foundation.org
Subject: + mm-remap_file_pages-fixes.patch added to -mm tree
Date: Tue, 08 Jan 2013 15:42:24 -0800
Message-ID: <20130108234225.12E6720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:58465 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab3AHXm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 18:42:28 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so72222fav.0
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 15:42:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com


The patch titled
     Subject: mm: remap_file_pages() fixes
has been added to the -mm tree.  Its filename is
     mm-remap_file_pages-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: remap_file_pages() fixes

Assorted small fixes. The first two are quite small:

- Move check for vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR)
  within existing if (!(vma->vm_flags & VM_NONLINEAR)) block.
  Purely cosmetic.

- In the VM_LOCKED case, when dropping PG_Mlocked for the over-mapped
  range, make sure we own the mmap_sem write lock around the
  munlock_vma_pages_range call as this manipulates the vma's vm_flags.

Last fix requires a longer explanation. remap_file_pages() can do its work
either through VM_NONLINEAR manipulation or by creating extra vmas.
These two cases were inconsistent with each other (and ultimately, both wrong)
as to exactly when did they fault in the newly mapped file pages:

- In the VM_NONLINEAR case, new file pages would be populated if
  the MAP_NONBLOCK flag wasn't passed. If MAP_NONBLOCK was passed,
  new file pages wouldn't be populated even if the vma is already
  marked as VM_LOCKED.

- In the linear (emulated) case, the work is passed to the mmap_region()
  function which would populate the pages if the vma is marked as
  VM_LOCKED, and would not otherwise - regardless of the value of the
  MAP_NONBLOCK flag, because MAP_POPULATE wasn't being passed to
  mmap_region().

The desired behavior is that we want the pages to be populated and locked
if the vma is marked as VM_LOCKED, or to be populated if the MAP_NONBLOCK
flag is not passed to remap_file_pages().

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Ungerer <gregungerer@westnet.com.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN mm/fremap.c~mm-remap_file_pages-fixes mm/fremap.c
--- a/mm/fremap.c~mm-remap_file_pages-fixes
+++ a/mm/fremap.c
@@ -160,15 +160,11 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	/*
 	 * Make sure the vma is shared, that it supports prefaulting,
 	 * and that the remapped range is valid and fully within
-	 * the single existing vma.  vm_private_data is used as a
-	 * swapout cursor in a VM_NONLINEAR vma.
+	 * the single existing vma.
 	 */
 	if (!vma || !(vma->vm_flags & VM_SHARED))
 		goto out;
 
-	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
-		goto out;
-
 	if (!vma->vm_ops || !vma->vm_ops->remap_pages)
 		goto out;
 
@@ -177,6 +173,13 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 
 	/* Must set VM_NONLINEAR before any pages are populated. */
 	if (!(vma->vm_flags & VM_NONLINEAR)) {
+		/*
+		 * vm_private_data is used as a swapout cursor
+		 * in a VM_NONLINEAR vma.
+		 */
+		if (vma->vm_private_data)
+			goto out;
+
 		/* Don't need a nonlinear mapping, exit success */
 		if (pgoff == linear_page_index(vma, start)) {
 			err = 0;
@@ -184,6 +187,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 		}
 
 		if (!has_write_lock) {
+get_write_lock:
 			up_read(&mm->mmap_sem);
 			down_write(&mm->mmap_sem);
 			has_write_lock = 1;
@@ -199,7 +203,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 			unsigned long addr;
 			struct file *file = get_file(vma->vm_file);
 
-			flags &= MAP_NONBLOCK;
+			flags = (flags & MAP_NONBLOCK) | MAP_POPULATE;
 			addr = mmap_region(file, start, size,
 					flags, vma->vm_flags, pgoff);
 			fput(file);
@@ -225,6 +229,8 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 		 * drop PG_Mlocked flag for over-mapped range
 		 */
 		vm_flags_t saved_flags = vma->vm_flags;
+		if (!has_write_lock)
+			goto get_write_lock;
 		munlock_vma_pages_range(vma, start, start + size);
 		vma->vm_flags = saved_flags;
 	}
@@ -232,13 +238,13 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	mmu_notifier_invalidate_range_start(mm, start, start + size);
 	err = vma->vm_ops->remap_pages(vma, start, size, pgoff);
 	mmu_notifier_invalidate_range_end(mm, start, start + size);
-	if (!err && !(flags & MAP_NONBLOCK)) {
+	if (!err) {
 		if (vma->vm_flags & VM_LOCKED) {
 			/*
 			 * might be mapping previously unmapped range of file
 			 */
 			mlock_vma_pages_range(vma, start, start + size);
-		} else {
+		} else if (!(flags & MAP_NONBLOCK)) {
 			if (unlikely(has_write_lock)) {
 				downgrade_write(&mm->mmap_sem);
 				has_write_lock = 0;
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags.patch
mm-remap_file_pages-fixes.patch
mm-introduce-mm_populate-for-populating-new-vmas.patch
mm-use-mm_populate-for-blocking-remap_file_pages.patch
mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch
mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch
mm-remove-flags-argument-to-mmap_region.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch
mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch
mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch


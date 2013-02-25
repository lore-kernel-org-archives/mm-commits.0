From: akpm@linux-foundation.org
Subject: [merged] mm-remap_file_pages-fixes.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:49:05 -0800
Message-ID: <20130225204905.F419331C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:40100 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217Ab3BYUtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:07 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so346420ggn.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remap_file_pages() fixes
has been removed from the -mm tree.  Its filename was
     mm-remap_file_pages-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: remap_file_pages() fixes

We have many vma manipulation functions that are fast in the typical case,
but can optionally be instructed to populate an unbounded number of ptes
within the region they work on:

- mmap with MAP_POPULATE or MAP_LOCKED flags;
- remap_file_pages() with MAP_NONBLOCK not set or when working on a
  VM_LOCKED vma;
- mmap_region() and all its wrappers when mlock(MCL_FUTURE) is in effect;
- brk() when mlock(MCL_FUTURE) is in effect.

Current code handles these pte operations locally, while the sourrounding
code has to hold the mmap_sem write side since it's manipulating vmas. 
This means we're doing an unbounded amount of pte population work with
mmap_sem held, and this causes problems as Andy Lutomirski reported (we've
hit this at Google as well, though it's not entirely clear why people keep
trying to use mlock(MCL_FUTURE) in the first place).

I propose introducing a new mm_populate() function to do this pte
population work after the mmap_sem has been released.  mm_populate() does
need to acquire the mmap_sem read side, but critically, it doesn't need to
hold it continuously for the entire duration of the operation - it can
drop it whenever things take too long (such as when hitting disk for a
file read) and re-acquire it later on.

The following patches are included

- Patches 1 fixes some issues I noticed while working on the existing code.
  If needed, they could potentially go in before the rest of the patches.

- Patch 2 introduces the new mm_populate() function and changes
  mmap_region() call sites to use it after they drop mmap_sem. This is
  inspired from Andy Lutomirski's proposal and is built as an extension
  of the work I had previously done for mlock() and mlockall() around
  v2.6.38-rc1. I had tried doing something similar at the time but had
  given up as there were so many do_mmap() call sites; the recent cleanups
  by Linus and Viro are a tremendous help here.

- Patches 3-5 convert some of the less-obvious places doing unbounded
  pte populates to the new mm_populate() mechanism.

- Patches 6-7 are code cleanups that are made possible by the
  mm_populate() work. In particular, they remove more code than the
  entire patch series added, which should be a good thing :)

- Patch 8 is optional to this entire series. It only helps to deal more
  nicely with racy userspace programs that might modify their mappings
  while we're trying to populate them. It adds a new VM_POPULATE flag
  on the mappings we do want to populate, so that if userspace replaces
  them with mappings it doesn't want populated, mm_populate() won't
  populate those replacement mappings.



This patch:

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

origin.patch
linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-remove-free_area_cache.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch


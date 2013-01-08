From: akpm@linux-foundation.org
Subject: + mm-use-mm_populate-for-blocking-remap_file_pages.patch added to -mm tree
Date: Tue, 08 Jan 2013 15:42:33 -0800
Message-ID: <20130108234234.CE00720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:56350 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab3AHXmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 18:42:37 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so72506wgb.0
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 15:42:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com


The patch titled
     Subject: mm: use mm_populate() for blocking remap_file_pages()
has been added to the -mm tree.  Its filename is
     mm-use-mm_populate-for-blocking-remap_file_pages.patch

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
Subject: mm: use mm_populate() for blocking remap_file_pages()

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Ungerer <gregungerer@westnet.com.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff -puN mm/fremap.c~mm-use-mm_populate-for-blocking-remap_file_pages mm/fremap.c
--- a/mm/fremap.c~mm-use-mm_populate-for-blocking-remap_file_pages
+++ a/mm/fremap.c
@@ -129,6 +129,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	struct vm_area_struct *vma;
 	int err = -EINVAL;
 	int has_write_lock = 0;
+	vm_flags_t vm_flags;
 
 	if (prot)
 		return err;
@@ -228,30 +229,16 @@ get_write_lock:
 		/*
 		 * drop PG_Mlocked flag for over-mapped range
 		 */
-		vm_flags_t saved_flags = vma->vm_flags;
 		if (!has_write_lock)
 			goto get_write_lock;
+		vm_flags = vma->vm_flags;
 		munlock_vma_pages_range(vma, start, start + size);
-		vma->vm_flags = saved_flags;
+		vma->vm_flags = vm_flags;
 	}
 
 	mmu_notifier_invalidate_range_start(mm, start, start + size);
 	err = vma->vm_ops->remap_pages(vma, start, size, pgoff);
 	mmu_notifier_invalidate_range_end(mm, start, start + size);
-	if (!err) {
-		if (vma->vm_flags & VM_LOCKED) {
-			/*
-			 * might be mapping previously unmapped range of file
-			 */
-			mlock_vma_pages_range(vma, start, start + size);
-		} else if (!(flags & MAP_NONBLOCK)) {
-			if (unlikely(has_write_lock)) {
-				downgrade_write(&mm->mmap_sem);
-				has_write_lock = 0;
-			}
-			make_pages_present(start, start+size);
-		}
-	}
 
 	/*
 	 * We can't clear VM_NONLINEAR because we'd have to do
@@ -260,10 +247,13 @@ get_write_lock:
 	 */
 
 out:
+	vm_flags = vma->vm_flags;
 	if (likely(!has_write_lock))
 		up_read(&mm->mmap_sem);
 	else
 		up_write(&mm->mmap_sem);
+	if (!err && ((vm_flags & VM_LOCKED) || !(flags & MAP_NONBLOCK)))
+		mm_populate(start, size);
 
 	return err;
 }
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


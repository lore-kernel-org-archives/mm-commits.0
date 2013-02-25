From: akpm@linux-foundation.org
Subject: [merged] mm-use-mm_populate-for-blocking-remap_file_pages.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:49:11 -0800
Message-ID: <20130225204911.B543231C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:59459 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab3BYUtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:15 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so361289qah.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use mm_populate() for blocking remap_file_pages()
has been removed from the -mm tree.  Its filename was
     mm-use-mm_populate-for-blocking-remap_file_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


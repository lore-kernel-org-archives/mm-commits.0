From: akpm@linux-foundation.org
Subject: + mm-drop-unused-argument-of-zap_page_range.patch added to -mm
 tree
Date: Wed, 18 Jan 2017 14:09:30 -0800
Message-ID: <587fe79a.BThf8mjlI706YMBf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41056 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753064AbdARWJb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 17:09:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, peterz@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop unused argument of zap_page_range()
has been added to the -mm tree.  Its filename is
     mm-drop-unused-argument-of-zap_page_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-unused-argument-of-zap_page_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-unused-argument-of-zap_page_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop unused argument of zap_page_range()

There's no users of zap_page_range() who wants non-NULL 'details'.  Let's
drop it.

Link: http://lkml.kernel.org/r/20170118122429.43661-3-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/gmap.c               |    2 +-
 arch/x86/mm/mpx.c                 |    2 +-
 drivers/android/binder.c          |    2 +-
 drivers/staging/android/ion/ion.c |    3 +--
 include/linux/mm.h                |    2 +-
 mm/madvise.c                      |    2 +-
 mm/memory.c                       |    5 ++---
 7 files changed, 8 insertions(+), 10 deletions(-)

diff -puN arch/s390/mm/gmap.c~mm-drop-unused-argument-of-zap_page_range arch/s390/mm/gmap.c
--- a/arch/s390/mm/gmap.c~mm-drop-unused-argument-of-zap_page_range
+++ a/arch/s390/mm/gmap.c
@@ -687,7 +687,7 @@ void gmap_discard(struct gmap *gmap, uns
 		/* Find vma in the parent mm */
 		vma = find_vma(gmap->mm, vmaddr);
 		size = min(to - gaddr, PMD_SIZE - (gaddr & ~PMD_MASK));
-		zap_page_range(vma, vmaddr, size, NULL);
+		zap_page_range(vma, vmaddr, size);
 	}
 	up_read(&gmap->mm->mmap_sem);
 }
diff -puN arch/x86/mm/mpx.c~mm-drop-unused-argument-of-zap_page_range arch/x86/mm/mpx.c
--- a/arch/x86/mm/mpx.c~mm-drop-unused-argument-of-zap_page_range
+++ a/arch/x86/mm/mpx.c
@@ -796,7 +796,7 @@ static noinline int zap_bt_entries_mappi
 			return -EINVAL;
 
 		len = min(vma->vm_end, end) - addr;
-		zap_page_range(vma, addr, len, NULL);
+		zap_page_range(vma, addr, len);
 		trace_mpx_unmap_zap(addr, addr+len);
 
 		vma = vma->vm_next;
diff -puN drivers/android/binder.c~mm-drop-unused-argument-of-zap_page_range drivers/android/binder.c
--- a/drivers/android/binder.c~mm-drop-unused-argument-of-zap_page_range
+++ a/drivers/android/binder.c
@@ -629,7 +629,7 @@ free_range:
 		page = &proc->pages[(page_addr - proc->buffer) / PAGE_SIZE];
 		if (vma)
 			zap_page_range(vma, (uintptr_t)page_addr +
-				proc->user_buffer_offset, PAGE_SIZE, NULL);
+				proc->user_buffer_offset, PAGE_SIZE);
 err_vm_insert_page_failed:
 		unmap_kernel_range((unsigned long)page_addr, PAGE_SIZE);
 err_map_kernel_failed:
diff -puN drivers/staging/android/ion/ion.c~mm-drop-unused-argument-of-zap_page_range drivers/staging/android/ion/ion.c
--- a/drivers/staging/android/ion/ion.c~mm-drop-unused-argument-of-zap_page_range
+++ a/drivers/staging/android/ion/ion.c
@@ -865,8 +865,7 @@ static void ion_buffer_sync_for_device(s
 	list_for_each_entry(vma_list, &buffer->vmas, list) {
 		struct vm_area_struct *vma = vma_list->vma;
 
-		zap_page_range(vma, vma->vm_start, vma->vm_end - vma->vm_start,
-			       NULL);
+		zap_page_range(vma, vma->vm_start, vma->vm_end - vma->vm_start);
 	}
 	mutex_unlock(&buffer->lock);
 }
diff -puN include/linux/mm.h~mm-drop-unused-argument-of-zap_page_range include/linux/mm.h
--- a/include/linux/mm.h~mm-drop-unused-argument-of-zap_page_range
+++ a/include/linux/mm.h
@@ -1181,7 +1181,7 @@ struct page *vm_normal_page_pmd(struct v
 int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size);
 void zap_page_range(struct vm_area_struct *vma, unsigned long address,
-		unsigned long size, struct zap_details *);
+		unsigned long size);
 void unmap_vmas(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long start, unsigned long end);
 
diff -puN mm/madvise.c~mm-drop-unused-argument-of-zap_page_range mm/madvise.c
--- a/mm/madvise.c~mm-drop-unused-argument-of-zap_page_range
+++ a/mm/madvise.c
@@ -478,7 +478,7 @@ static long madvise_dontneed(struct vm_a
 		return -EINVAL;
 
 	madvise_userfault_dontneed(vma, prev, start, end);
-	zap_page_range(vma, start, end - start, NULL);
+	zap_page_range(vma, start, end - start);
 	return 0;
 }
 
diff -puN mm/memory.c~mm-drop-unused-argument-of-zap_page_range mm/memory.c
--- a/mm/memory.c~mm-drop-unused-argument-of-zap_page_range
+++ a/mm/memory.c
@@ -1370,12 +1370,11 @@ void unmap_vmas(struct mmu_gather *tlb,
  * @vma: vm_area_struct holding the applicable pages
  * @start: starting address of pages to zap
  * @size: number of bytes to zap
- * @details: details of shared cache invalidation
  *
  * Caller must protect the VMA list
  */
 void zap_page_range(struct vm_area_struct *vma, unsigned long start,
-		unsigned long size, struct zap_details *details)
+		unsigned long size)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_gather tlb;
@@ -1386,7 +1385,7 @@ void zap_page_range(struct vm_area_struc
 	update_hiwater_rss(mm);
 	mmu_notifier_invalidate_range_start(mm, start, end);
 	for ( ; vma && vma->vm_start < end; vma = vma->vm_next)
-		unmap_single_vma(&tlb, vma, start, end, details);
+		unmap_single_vma(&tlb, vma, start, end, NULL);
 	mmu_notifier_invalidate_range_end(mm, start, end);
 	tlb_finish_mmu(&tlb, start, end);
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-drop-zap_details-ignore_dirty.patch
mm-drop-zap_details-check_swap_entries.patch
mm-drop-unused-argument-of-zap_page_range.patch
oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma.patch


From: akpm@linux-foundation.org
Subject: + mm-use-vm_unmapped_area-on-ia64-architecture.patch added to -mm tree
Date: Thu, 31 Jan 2013 13:55:42 -0800
Message-ID: <20130131215543.2CFB131C1B2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:54410 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab3AaVzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jan 2013 16:55:44 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so238136ves.5
        for <mm-commits@vger.kernel.org>; Thu, 31 Jan 2013 13:55:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, riel@redhat.com, tony.luck@intel.com


The patch titled
     Subject: mm: use vm_unmapped_area() on ia64 architecture
has been added to the -mm tree.  Its filename is
     mm-use-vm_unmapped_area-on-ia64-architecture.patch

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
Subject: mm: use vm_unmapped_area() on ia64 architecture

Update the ia64 arch_get_unmapped_area function to make use of
vm_unmapped_area() instead of implementing a brute force search.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/sys_ia64.c |   35 ++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff -puN arch/ia64/kernel/sys_ia64.c~mm-use-vm_unmapped_area-on-ia64-architecture arch/ia64/kernel/sys_ia64.c
--- a/arch/ia64/kernel/sys_ia64.c~mm-use-vm_unmapped_area-on-ia64-architecture
+++ a/arch/ia64/kernel/sys_ia64.c
@@ -25,9 +25,9 @@ arch_get_unmapped_area (struct file *fil
 			unsigned long pgoff, unsigned long flags)
 {
 	long map_shared = (flags & MAP_SHARED);
-	unsigned long start_addr, align_mask = PAGE_SIZE - 1;
+	unsigned long align_mask = 0;
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
+	struct vm_unmapped_area_info info;
 
 	if (len > RGN_MAP_LIMIT)
 		return -ENOMEM;
@@ -44,7 +44,7 @@ arch_get_unmapped_area (struct file *fil
 		addr = 0;
 #endif
 	if (!addr)
-		addr = mm->free_area_cache;
+		addr = TASK_UNMAPPED_BASE;
 
 	if (map_shared && (TASK_SIZE > 0xfffffffful))
 		/*
@@ -53,28 +53,15 @@ arch_get_unmapped_area (struct file *fil
 		 * tasks, we prefer to avoid exhausting the address space too quickly by
 		 * limiting alignment to a single page.
 		 */
-		align_mask = SHMLBA - 1;
+		align_mask = PAGE_MASK & (SHMLBA - 1);
 
-  full_search:
-	start_addr = addr = (addr + align_mask) & ~align_mask;
-
-	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
-		/* At this point:  (!vma || addr < vma->vm_end). */
-		if (TASK_SIZE - len < addr || RGN_MAP_LIMIT - len < REGION_OFFSET(addr)) {
-			if (start_addr != TASK_UNMAPPED_BASE) {
-				/* Start a new search --- just in case we missed some holes.  */
-				addr = TASK_UNMAPPED_BASE;
-				goto full_search;
-			}
-			return -ENOMEM;
-		}
-		if (!vma || addr + len <= vma->vm_start) {
-			/* Remember the address where we stopped this search:  */
-			mm->free_area_cache = addr + len;
-			return addr;
-		}
-		addr = (vma->vm_end + align_mask) & ~align_mask;
-	}
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = addr;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = align_mask;
+	info.align_offset = 0;
+	return vm_unmapped_area(&info);
 }
 
 asmlinkage long
_

Patches currently in -mm which might be from walken@google.com are

thp-avoid-dumping-huge-zero-page.patch
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
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-use-vm_unmapped_area-on-alpha-architecture.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-remove-free_area_cache.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch


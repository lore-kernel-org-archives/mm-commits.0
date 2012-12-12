From: akpm@linux-foundation.org
Subject: [merged] mm-use-vm_unmapped_area-in-hugetlbfs.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:59:31 -0800
Message-ID: <20121212195932.046EE82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:57687 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2LLT7d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:59:33 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so118029vcd.3
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:59:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vm_unmapped_area() in hugetlbfs
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-in-hugetlbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use vm_unmapped_area() in hugetlbfs

Update the hugetlb_get_unmapped_area function to make use of
vm_unmapped_area() instead of implementing a brute force search.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   42 +++++++----------------------------------
 1 file changed, 8 insertions(+), 34 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-use-vm_unmapped_area-in-hugetlbfs fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-use-vm_unmapped_area-in-hugetlbfs
+++ a/fs/hugetlbfs/inode.c
@@ -151,8 +151,8 @@ hugetlb_get_unmapped_area(struct file *f
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long start_addr;
 	struct hstate *h = hstate_file(file);
+	struct vm_unmapped_area_info info;
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
@@ -173,39 +173,13 @@ hugetlb_get_unmapped_area(struct file *f
 			return addr;
 	}
 
-	if (len > mm->cached_hole_size)
-		start_addr = mm->free_area_cache;
-	else {
-		start_addr = TASK_UNMAPPED_BASE;
-		mm->cached_hole_size = 0;
-	}
-
-full_search:
-	addr = ALIGN(start_addr, huge_page_size(h));
-
-	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
-		/* At this point:  (!vma || addr < vma->vm_end). */
-		if (TASK_SIZE - len < addr) {
-			/*
-			 * Start a new search - just in case we missed
-			 * some holes.
-			 */
-			if (start_addr != TASK_UNMAPPED_BASE) {
-				start_addr = TASK_UNMAPPED_BASE;
-				mm->cached_hole_size = 0;
-				goto full_search;
-			}
-			return -ENOMEM;
-		}
-
-		if (!vma || addr + len <= vma->vm_start) {
-			mm->free_area_cache = addr + len;
-			return addr;
-		}
-		if (addr + mm->cached_hole_size < vma->vm_start)
-			mm->cached_hole_size = vma->vm_start - addr;
-		addr = ALIGN(vma->vm_end, huge_page_size(h));
-	}
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = TASK_UNMAPPED_BASE;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
+	info.align_offset = 0;
+	return vm_unmapped_area(&info);
 }
 #endif
 
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
mm-protect-against-concurrent-vma-expansion.patch
linux-next.patch
lib-rbtree_testc-fix-uninitialized-variable-warning.patch
random32-rename-random32-to-prandom.patch
prandom-introduce-prandom_bytes-and-prandom_bytes_state.patch
bnx2x-use-prandom_bytes.patch
mtd-nandsim-use-prandom_bytes.patch
ubifs-use-prandom_bytes.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch


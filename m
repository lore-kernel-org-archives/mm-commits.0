From: akpm@linux-foundation.org
Subject: [merged] mm-search-from-free_area_cache-for-the-bigger-size.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:58 -0700
Message-ID: <20120322201758.89CF4A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:45890 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2CVUSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:01 -0400
Received: by eaaq10 with SMTP id q10so134174eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mingo@redhat.com, riel@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: search from free_area_cache for the bigger size
has been removed from the -mm tree.  Its filename was
     mm-search-from-free_area_cache-for-the-bigger-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: mm: search from free_area_cache for the bigger size

If the required size is bigger than cached_hole_size it is better to
search from free_area_cache - it is easier to get a free region,
specifically for the 64 bit process whose address space is large enough

Do it just as hugetlb_get_unmapped_area_topdown() in arch/x86/mm/hugetlbpage.c

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/sys_x86_64.c |   34 +++++++++++++++----------------
 mm/mmap.c                    |   36 +++++++++++++++++++--------------
 2 files changed, 38 insertions(+), 32 deletions(-)

diff -puN arch/x86/kernel/sys_x86_64.c~mm-search-from-free_area_cache-for-the-bigger-size arch/x86/kernel/sys_x86_64.c
--- a/arch/x86/kernel/sys_x86_64.c~mm-search-from-free_area_cache-for-the-bigger-size
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -195,7 +195,7 @@ arch_get_unmapped_area_topdown(struct fi
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
-	unsigned long addr = addr0;
+	unsigned long addr = addr0, start_addr;
 
 	/* requested length too big for entire address space */
 	if (len > TASK_SIZE)
@@ -223,25 +223,14 @@ arch_get_unmapped_area_topdown(struct fi
 		mm->free_area_cache = mm->mmap_base;
 	}
 
+try_again:
 	/* either no address requested or can't fit in requested address hole */
-	addr = mm->free_area_cache;
+	start_addr = addr = mm->free_area_cache;
 
-	/* make sure it can fit in the remaining address space */
-	if (addr > len) {
-		unsigned long tmp_addr = align_addr(addr - len, filp,
-						    ALIGN_TOPDOWN);
-
-		vma = find_vma(mm, tmp_addr);
-		if (!vma || tmp_addr + len <= vma->vm_start)
-			/* remember the address as a hint for next time */
-			return mm->free_area_cache = tmp_addr;
-	}
-
-	if (mm->mmap_base < len)
-		goto bottomup;
-
-	addr = mm->mmap_base-len;
+	if (addr < len)
+		goto fail;
 
+	addr -= len;
 	do {
 		addr = align_addr(addr, filp, ALIGN_TOPDOWN);
 
@@ -263,6 +252,17 @@ arch_get_unmapped_area_topdown(struct fi
 		addr = vma->vm_start-len;
 	} while (len < vma->vm_start);
 
+fail:
+	/*
+	 * if hint left us with no space for the requested
+	 * mapping then try again:
+	 */
+	if (start_addr != mm->mmap_base) {
+		mm->free_area_cache = mm->mmap_base;
+		mm->cached_hole_size = 0;
+		goto try_again;
+	}
+
 bottomup:
 	/*
 	 * A failed mmap() very likely causes application failure,
diff -puN mm/mmap.c~mm-search-from-free_area_cache-for-the-bigger-size mm/mmap.c
--- a/mm/mmap.c~mm-search-from-free_area_cache-for-the-bigger-size
+++ a/mm/mmap.c
@@ -1442,7 +1442,7 @@ arch_get_unmapped_area_topdown(struct fi
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
-	unsigned long addr = addr0;
+	unsigned long addr = addr0, start_addr;
 
 	/* requested length too big for entire address space */
 	if (len > TASK_SIZE)
@@ -1466,22 +1466,14 @@ arch_get_unmapped_area_topdown(struct fi
  		mm->free_area_cache = mm->mmap_base;
  	}
 
+try_again:
 	/* either no address requested or can't fit in requested address hole */
-	addr = mm->free_area_cache;
+	start_addr = addr = mm->free_area_cache;
 
-	/* make sure it can fit in the remaining address space */
-	if (addr > len) {
-		vma = find_vma(mm, addr-len);
-		if (!vma || addr <= vma->vm_start)
-			/* remember the address as a hint for next time */
-			return (mm->free_area_cache = addr-len);
-	}
-
-	if (mm->mmap_base < len)
-		goto bottomup;
-
-	addr = mm->mmap_base-len;
+	if (addr < len)
+		goto fail;
 
+	addr -= len;
 	do {
 		/*
 		 * Lookup failure means no vma is above this address,
@@ -1501,7 +1493,21 @@ arch_get_unmapped_area_topdown(struct fi
 		addr = vma->vm_start-len;
 	} while (len < vma->vm_start);
 
-bottomup:
+fail:
+	/*
+	 * if hint left us with no space for the requested
+	 * mapping then try again:
+	 *
+	 * Note: this is different with the case of bottomup
+	 * which does the fully line-search, but we use find_vma
+	 * here that causes some holes skipped.
+	 */
+	if (start_addr != mm->mmap_base) {
+		mm->free_area_cache = mm->mmap_base;
+		mm->cached_hole_size = 0;
+		goto try_again;
+	}
+
 	/*
 	 * A failed mmap() very likely causes application failure,
 	 * so fall back to the bottom-up function here. This scenario
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch
prio_tree-remove-unnecessary-code-in-prio_tree_replace.patch
prio_tree-cleanup-prio_tree_left-prio_tree_right.patch
prio_tree-simplify-prio_tree_expand.patch
prio_tree-introduce-prio_set_parent.patch


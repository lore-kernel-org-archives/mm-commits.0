From: akpm@linux-foundation.org
Subject: + mm-search-from-free_area_cache-for-the-bigger-size.patch added to -mm tree
Date: Wed, 01 Feb 2012 14:45:52 -0800
Message-ID: <20120201224552.DE81EA03A7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:49105 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab2BAWpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 17:45:54 -0500
Received: by mail-ww0-f74.google.com with SMTP id ds12so60680wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 14:45:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: mm: search from free_area_cache for the bigger size
has been added to the -mm tree.  Its filename is
     mm-search-from-free_area_cache-for-the-bigger-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1462,7 +1462,7 @@ arch_get_unmapped_area_topdown(struct fi
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
-	unsigned long addr = addr0;
+	unsigned long addr = addr0, start_addr;
 
 	/* requested length too big for entire address space */
 	if (len > TASK_SIZE)
@@ -1486,22 +1486,14 @@ arch_get_unmapped_area_topdown(struct fi
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
@@ -1521,7 +1513,21 @@ arch_get_unmapped_area_topdown(struct fi
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
Subject: Subject: mm: search from free_area_cache for the bigger size

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch


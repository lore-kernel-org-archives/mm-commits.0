From: akpm@osdl.org
Subject: - pass-vma-argument-to-copy_user_highpage.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:20:56 -0800
Message-ID: <200612140620.kBE6KtuH002413@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52919 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbWLNGVS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:21:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Pass vma argument to copy_user_highpage().
has been removed from the -mm tree.  Its filename was
     pass-vma-argument-to-copy_user_highpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Pass vma argument to copy_user_highpage().
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

To allow a more effective copy_user_highpage() on certain architectures,
a vma argument is added to the function and cow_user_page() allowing
the implementation of these functions to check for the VM_EXEC bit.

The main part of this patch was originally written by Ralf Baechle;
Atushi Nemoto did the the debugging.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/highmem.h |    3 ++-
 mm/hugetlb.c            |    6 +++---
 mm/memory.c             |   10 +++++-----
 3 files changed, 10 insertions(+), 9 deletions(-)

diff -puN include/linux/highmem.h~pass-vma-argument-to-copy_user_highpage include/linux/highmem.h
--- a/include/linux/highmem.h~pass-vma-argument-to-copy_user_highpage
+++ a/include/linux/highmem.h
@@ -98,7 +98,8 @@ static inline void memclear_highpage_flu
 
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
 
-static inline void copy_user_highpage(struct page *to, struct page *from, unsigned long vaddr)
+static inline void copy_user_highpage(struct page *to, struct page *from,
+	unsigned long vaddr, struct vm_area_struct *vma)
 {
 	char *vfrom, *vto;
 
diff -puN mm/hugetlb.c~pass-vma-argument-to-copy_user_highpage mm/hugetlb.c
--- a/mm/hugetlb.c~pass-vma-argument-to-copy_user_highpage
+++ a/mm/hugetlb.c
@@ -44,14 +44,14 @@ static void clear_huge_page(struct page 
 }
 
 static void copy_huge_page(struct page *dst, struct page *src,
-			   unsigned long addr)
+			   unsigned long addr, struct vm_area_struct *vma)
 {
 	int i;
 
 	might_sleep();
 	for (i = 0; i < HPAGE_SIZE/PAGE_SIZE; i++) {
 		cond_resched();
-		copy_user_highpage(dst + i, src + i, addr + i*PAGE_SIZE);
+		copy_user_highpage(dst + i, src + i, addr + i*PAGE_SIZE, vma);
 	}
 }
 
@@ -442,7 +442,7 @@ static int hugetlb_cow(struct mm_struct 
 	}
 
 	spin_unlock(&mm->page_table_lock);
-	copy_huge_page(new_page, old_page, address);
+	copy_huge_page(new_page, old_page, address, vma);
 	spin_lock(&mm->page_table_lock);
 
 	ptep = huge_pte_offset(mm, address & HPAGE_MASK);
diff -puN mm/memory.c~pass-vma-argument-to-copy_user_highpage mm/memory.c
--- a/mm/memory.c~pass-vma-argument-to-copy_user_highpage
+++ a/mm/memory.c
@@ -1449,7 +1449,7 @@ static inline pte_t maybe_mkwrite(pte_t 
 	return pte;
 }
 
-static inline void cow_user_page(struct page *dst, struct page *src, unsigned long va)
+static inline void cow_user_page(struct page *dst, struct page *src, unsigned long va, struct vm_area_struct *vma)
 {
 	/*
 	 * If the source page was a PFN mapping, we don't have
@@ -1472,9 +1472,9 @@ static inline void cow_user_page(struct 
 		kunmap_atomic(kaddr, KM_USER0);
 		flush_dcache_page(dst);
 		return;
-		
+
 	}
-	copy_user_highpage(dst, src, va);
+	copy_user_highpage(dst, src, va, vma);
 }
 
 /*
@@ -1585,7 +1585,7 @@ gotten:
 		new_page = alloc_page_vma(GFP_HIGHUSER, vma, address);
 		if (!new_page)
 			goto oom;
-		cow_user_page(new_page, old_page, address);
+		cow_user_page(new_page, old_page, address, vma);
 	}
 
 	/*
@@ -2208,7 +2208,7 @@ retry:
 			page = alloc_page_vma(GFP_HIGHUSER, vma, address);
 			if (!page)
 				goto oom;
-			copy_user_highpage(page, new_page, address);
+			copy_user_highpage(page, new_page, address, vma);
 			page_cache_release(new_page);
 			new_page = page;
 			anon = 1;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are



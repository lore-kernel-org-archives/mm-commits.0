Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AF013B284
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854778; cv=none; b=BJ/cD1+f41VH6+xy02xl3JLedsXd7+9WuyGZ/gU3YWuZOJKk0EauxQEUhAYFGRDov+W5Tg6jm4U85PIKhYBa4KqL15PSPSt8ZbcdnnrK2m9VLrKh8nyX1bIBfLUS+mod6DMsaoIBG56C9SLGgUgQAdJbiyPxxG4PZSqHNkSZ+x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854778; c=relaxed/simple;
	bh=P66iqrC75/oERFII38xPYTdETtk430e4AN03D2Qx4bc=;
	h=Date:To:From:Subject:Message-Id; b=VI/7WQFei7sLN2hVf8/8r4BXzX9myj8n2WWbG05/2wib1dDNNeiaAwsjEpx0uV89u77nUO07JrkBoEFyWH1Tk5HzXGmzAm0RRycrRksvkNQ3HWklV6t2IQruTHedSCyw8sSmPxIkW1NtRFnEIU4tqe5sbdgtAFy6jfHEDCRls7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sm5wGJCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sm5wGJCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EECC4CECF;
	Wed,  6 Nov 2024 00:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854778;
	bh=P66iqrC75/oERFII38xPYTdETtk430e4AN03D2Qx4bc=;
	h=Date:To:From:Subject:From;
	b=sm5wGJCCdTVSYWXSZmbTV2GGlMoObvTbLTeZ3ydEXSh6gLcgEau+k02AI6ryHhlma
	 lPMH+tm//0jomisDAvBcDPHxEfttkXqO9IZ8Y42pYkwPuBYo+Iim6uT+fYnkdWR3aX
	 ampuoQuajdwxhn4xGMPuGVZb0smPYkP89kw+eIlc=
Date: Tue, 05 Nov 2024 16:59:37 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-hugetlb_get_unmapped_area_-functions.patch removed from -mm tree
Message-Id: <20241106005938.68EECC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop hugetlb_get_unmapped_area{_*} functions
has been removed from the -mm tree.  Its filename was
     mm-drop-hugetlb_get_unmapped_area_-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm: drop hugetlb_get_unmapped_area{_*} functions
Date: Mon, 7 Oct 2024 09:50:35 +0200

Hugetlb mappings are now handled through normal channels just like any
other mapping, so we no longer need hugetlb_get_unmapped_area* specific
functions.

Link: https://lkml.kernel.org/r/20241007075037.267650-8-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/mm/hugetlbpage.c     |   21 -----
 arch/powerpc/mm/book3s64/slice.c |   10 --
 arch/s390/mm/hugetlbpage.c       |   85 ----------------------
 arch/sparc/mm/hugetlbpage.c      |  108 -----------------------------
 arch/x86/mm/hugetlbpage.c        |  101 ---------------------------
 fs/hugetlbfs/inode.c             |   96 +------------------------
 include/linux/hugetlb.h          |    7 -
 7 files changed, 6 insertions(+), 422 deletions(-)

--- a/arch/parisc/mm/hugetlbpage.c~mm-drop-hugetlb_get_unmapped_area_-functions
+++ a/arch/parisc/mm/hugetlbpage.c
@@ -21,27 +21,6 @@
 #include <asm/mmu_context.h>
 
 
-unsigned long
-hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
-{
-	struct hstate *h = hstate_file(file);
-
-	if (len & ~huge_page_mask(h))
-		return -EINVAL;
-	if (len > TASK_SIZE)
-		return -ENOMEM;
-
-	if (flags & MAP_FIXED)
-		if (prepare_hugepage_range(file, addr, len))
-			return -EINVAL;
-
-	if (addr)
-		addr = ALIGN(addr, huge_page_size(h));
-
-	/* we need to make sure the colouring is OK */
-	return arch_get_unmapped_area(file, addr, len, pgoff, flags, 0);
-}
 
 
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
--- a/arch/powerpc/mm/book3s64/slice.c~mm-drop-hugetlb_get_unmapped_area_-functions
+++ a/arch/powerpc/mm/book3s64/slice.c
@@ -814,14 +814,4 @@ unsigned long vma_mmu_pagesize(struct vm
 
 	return 1UL << mmu_psize_to_shift(get_slice_psize(vma->vm_mm, vma->vm_start));
 }
-
-unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-					unsigned long len, unsigned long pgoff,
-					unsigned long flags)
-{
-	if (radix_enabled())
-		return generic_hugetlb_get_unmapped_area(file, addr, len, pgoff, flags);
-
-	return slice_get_unmapped_area(addr, len, flags, file_to_psize(file), 1);
-}
 #endif
--- a/arch/s390/mm/hugetlbpage.c~mm-drop-hugetlb_get_unmapped_area_-functions
+++ a/arch/s390/mm/hugetlbpage.c
@@ -242,88 +242,3 @@ bool __init arch_hugetlb_valid_size(unsi
 	else
 		return false;
 }
-
-static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
-		unsigned long addr, unsigned long len,
-		unsigned long pgoff, unsigned long flags)
-{
-	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info = {};
-
-	info.length = len;
-	info.low_limit = current->mm->mmap_base;
-	info.high_limit = TASK_SIZE;
-	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	return vm_unmapped_area(&info);
-}
-
-static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
-		unsigned long addr0, unsigned long len,
-		unsigned long pgoff, unsigned long flags)
-{
-	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info = {};
-	unsigned long addr;
-
-	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
-	info.length = len;
-	info.low_limit = PAGE_SIZE;
-	info.high_limit = current->mm->mmap_base;
-	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	addr = vm_unmapped_area(&info);
-
-	/*
-	 * A failed mmap() very likely causes application failure,
-	 * so fall back to the bottom-up function here. This scenario
-	 * can happen with large stack limits and large mmap()
-	 * allocations.
-	 */
-	if (addr & ~PAGE_MASK) {
-		VM_BUG_ON(addr != -ENOMEM);
-		info.flags = 0;
-		info.low_limit = TASK_UNMAPPED_BASE;
-		info.high_limit = TASK_SIZE;
-		addr = vm_unmapped_area(&info);
-	}
-
-	return addr;
-}
-
-unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
-{
-	struct hstate *h = hstate_file(file);
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-
-	if (len & ~huge_page_mask(h))
-		return -EINVAL;
-	if (len > TASK_SIZE - mmap_min_addr)
-		return -ENOMEM;
-
-	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(file, addr, len))
-			return -EINVAL;
-		goto check_asce_limit;
-	}
-
-	if (addr) {
-		addr = ALIGN(addr, huge_page_size(h));
-		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
-		    (!vma || addr + len <= vm_start_gap(vma)))
-			goto check_asce_limit;
-	}
-
-	if (!test_bit(MMF_TOPDOWN, &mm->flags))
-		addr = hugetlb_get_unmapped_area_bottomup(file, addr, len,
-				pgoff, flags);
-	else
-		addr = hugetlb_get_unmapped_area_topdown(file, addr, len,
-				pgoff, flags);
-	if (offset_in_page(addr))
-		return addr;
-
-check_asce_limit:
-	return check_asce_limit(mm, addr, len);
-}
--- a/arch/sparc/mm/hugetlbpage.c~mm-drop-hugetlb_get_unmapped_area_-functions
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -19,114 +19,6 @@
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
 
-/* Slightly simplified from the non-hugepage variant because by
- * definition we don't have to worry about any page coloring stuff
- */
-
-static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *filp,
-							unsigned long addr,
-							unsigned long len,
-							unsigned long pgoff,
-							unsigned long flags)
-{
-	struct hstate *h = hstate_file(filp);
-	unsigned long task_size = TASK_SIZE;
-	struct vm_unmapped_area_info info = {};
-
-	if (test_thread_flag(TIF_32BIT))
-		task_size = STACK_TOP32;
-
-	info.length = len;
-	info.low_limit = TASK_UNMAPPED_BASE;
-	info.high_limit = min(task_size, VA_EXCLUDE_START);
-	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	addr = vm_unmapped_area(&info);
-
-	if ((addr & ~PAGE_MASK) && task_size > VA_EXCLUDE_END) {
-		VM_BUG_ON(addr != -ENOMEM);
-		info.low_limit = VA_EXCLUDE_END;
-		info.high_limit = task_size;
-		addr = vm_unmapped_area(&info);
-	}
-
-	return addr;
-}
-
-static unsigned long
-hugetlb_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
-				  const unsigned long len,
-				  const unsigned long pgoff,
-				  const unsigned long flags)
-{
-	struct hstate *h = hstate_file(filp);
-	struct mm_struct *mm = current->mm;
-	unsigned long addr = addr0;
-	struct vm_unmapped_area_info info = {};
-
-	/* This should only ever run for 32-bit processes.  */
-	BUG_ON(!test_thread_flag(TIF_32BIT));
-
-	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
-	info.length = len;
-	info.low_limit = PAGE_SIZE;
-	info.high_limit = mm->mmap_base;
-	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	addr = vm_unmapped_area(&info);
-
-	/*
-	 * A failed mmap() very likely causes application failure,
-	 * so fall back to the bottom-up function here. This scenario
-	 * can happen with large stack limits and large mmap()
-	 * allocations.
-	 */
-	if (addr & ~PAGE_MASK) {
-		VM_BUG_ON(addr != -ENOMEM);
-		info.flags = 0;
-		info.low_limit = TASK_UNMAPPED_BASE;
-		info.high_limit = STACK_TOP32;
-		addr = vm_unmapped_area(&info);
-	}
-
-	return addr;
-}
-
-unsigned long
-hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
-{
-	struct hstate *h = hstate_file(file);
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	unsigned long task_size = TASK_SIZE;
-
-	if (test_thread_flag(TIF_32BIT))
-		task_size = STACK_TOP32;
-
-	if (len & ~huge_page_mask(h))
-		return -EINVAL;
-	if (len > task_size)
-		return -ENOMEM;
-
-	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(file, addr, len))
-			return -EINVAL;
-		return addr;
-	}
-
-	if (addr) {
-		addr = ALIGN(addr, huge_page_size(h));
-		vma = find_vma(mm, addr);
-		if (task_size - len >= addr &&
-		    (!vma || addr + len <= vm_start_gap(vma)))
-			return addr;
-	}
-	if (!test_bit(MMF_TOPDOWN, &mm->flags))
-		return hugetlb_get_unmapped_area_bottomup(file, addr, len,
-				pgoff, flags);
-	else
-		return hugetlb_get_unmapped_area_topdown(file, addr, len,
-				pgoff, flags);
-}
 
 static pte_t sun4u_hugepage_shift_to_tte(pte_t entry, unsigned int shift)
 {
--- a/arch/x86/mm/hugetlbpage.c~mm-drop-hugetlb_get_unmapped_area_-functions
+++ a/arch/x86/mm/hugetlbpage.c
@@ -19,107 +19,6 @@
 #include <asm/tlbflush.h>
 #include <asm/elf.h>
 
-#ifdef CONFIG_HUGETLB_PAGE
-static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
-		unsigned long addr, unsigned long len,
-		unsigned long pgoff, unsigned long flags)
-{
-	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info = {};
-
-	info.length = len;
-	info.low_limit = get_mmap_base(1);
-
-	/*
-	 * If hint address is above DEFAULT_MAP_WINDOW, look for unmapped area
-	 * in the full address space.
-	 */
-	info.high_limit = in_32bit_syscall() ?
-		task_size_32bit() : task_size_64bit(addr > DEFAULT_MAP_WINDOW);
-
-	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	return vm_unmapped_area(&info);
-}
-
-static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
-		unsigned long addr, unsigned long len,
-		unsigned long pgoff, unsigned long flags)
-{
-	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info = {};
-
-	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
-	info.length = len;
-	info.low_limit = PAGE_SIZE;
-	info.high_limit = get_mmap_base(0);
-
-	/*
-	 * If hint address is above DEFAULT_MAP_WINDOW, look for unmapped area
-	 * in the full address space.
-	 */
-	if (addr > DEFAULT_MAP_WINDOW && !in_32bit_syscall())
-		info.high_limit += TASK_SIZE_MAX - DEFAULT_MAP_WINDOW;
-
-	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	addr = vm_unmapped_area(&info);
-
-	/*
-	 * A failed mmap() very likely causes application failure,
-	 * so fall back to the bottom-up function here. This scenario
-	 * can happen with large stack limits and large mmap()
-	 * allocations.
-	 */
-	if (addr & ~PAGE_MASK) {
-		VM_BUG_ON(addr != -ENOMEM);
-		info.flags = 0;
-		info.low_limit = TASK_UNMAPPED_BASE;
-		info.high_limit = TASK_SIZE_LOW;
-		addr = vm_unmapped_area(&info);
-	}
-
-	return addr;
-}
-
-unsigned long
-hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
-{
-	struct hstate *h = hstate_file(file);
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-
-	if (len & ~huge_page_mask(h))
-		return -EINVAL;
-
-	if (len > TASK_SIZE)
-		return -ENOMEM;
-
-	/* No address checking. See comment at mmap_address_hint_valid() */
-	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(file, addr, len))
-			return -EINVAL;
-		return addr;
-	}
-
-	if (addr) {
-		addr &= huge_page_mask(h);
-		if (!mmap_address_hint_valid(addr, len))
-			goto get_unmapped_area;
-
-		vma = find_vma(mm, addr);
-		if (!vma || addr + len <= vm_start_gap(vma))
-			return addr;
-	}
-
-get_unmapped_area:
-	if (!test_bit(MMF_TOPDOWN, &mm->flags))
-		return hugetlb_get_unmapped_area_bottomup(file, addr, len,
-				pgoff, flags);
-	else
-		return hugetlb_get_unmapped_area_topdown(file, addr, len,
-				pgoff, flags);
-}
-#endif /* CONFIG_HUGETLB_PAGE */
 
 #ifdef CONFIG_X86_64
 bool __init arch_hugetlb_valid_size(unsigned long size)
--- a/fs/hugetlbfs/inode.c~mm-drop-hugetlb_get_unmapped_area_-functions
+++ a/fs/hugetlbfs/inode.c
@@ -171,96 +171,10 @@ out:
  * Called under mmap_write_lock(mm).
  */
 
-static unsigned long
-hugetlb_get_unmapped_area_bottomup(struct file *file, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
-{
-	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info = {};
-
-	info.length = len;
-	info.low_limit = current->mm->mmap_base;
-	info.high_limit = arch_get_mmap_end(addr, len, flags);
-	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	return vm_unmapped_area(&info);
-}
-
-static unsigned long
-hugetlb_get_unmapped_area_topdown(struct file *file, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
-{
-	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info = {};
-
-	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
-	info.length = len;
-	info.low_limit = PAGE_SIZE;
-	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
-	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	addr = vm_unmapped_area(&info);
-
-	/*
-	 * A failed mmap() very likely causes application failure,
-	 * so fall back to the bottom-up function here. This scenario
-	 * can happen with large stack limits and large mmap()
-	 * allocations.
-	 */
-	if (unlikely(offset_in_page(addr))) {
-		VM_BUG_ON(addr != -ENOMEM);
-		info.flags = 0;
-		info.low_limit = current->mm->mmap_base;
-		info.high_limit = arch_get_mmap_end(addr, len, flags);
-		addr = vm_unmapped_area(&info);
-	}
-
-	return addr;
-}
-
-unsigned long
-generic_hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-				  unsigned long len, unsigned long pgoff,
-				  unsigned long flags)
-{
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma, *prev;
-	struct hstate *h = hstate_file(file);
-	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
-
-	if (len & ~huge_page_mask(h))
-		return -EINVAL;
-	if (len > mmap_end - mmap_min_addr)
-		return -ENOMEM;
-
-	if (flags & MAP_FIXED) {
-		if (prepare_hugepage_range(file, addr, len))
-			return -EINVAL;
-		return addr;
-	}
-
-	if (addr) {
-		addr = ALIGN(addr, huge_page_size(h));
-		vma = find_vma_prev(mm, addr, &prev);
-		if (mmap_end - len >= addr && addr >= mmap_min_addr &&
-		    (!vma || addr + len <= vm_start_gap(vma)) &&
-		    (!prev || addr >= vm_end_gap(prev)))
-			return addr;
-	}
-
-	/*
-	 * Use MMF_TOPDOWN flag as a hint to use topdown routine.
-	 * If architectures have special needs, they should define their own
-	 * version of hugetlb_get_unmapped_area.
-	 */
-	if (test_bit(MMF_TOPDOWN, &mm->flags))
-		return hugetlb_get_unmapped_area_topdown(file, addr, len,
-				pgoff, flags);
-	return hugetlb_get_unmapped_area_bottomup(file, addr, len,
-			pgoff, flags);
-}
-
 unsigned long
-__hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-			    unsigned long len, unsigned long flags)
+hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
+			    unsigned long len, unsigned long pgoff,
+			    unsigned long flags)
 {
 	unsigned long addr0 = 0;
 	struct hstate *h = hstate_file(file);
@@ -272,7 +186,7 @@ __hugetlb_get_unmapped_area(struct file
 	if (addr)
 		addr0 = ALIGN(addr, huge_page_size(h));
 
-	return mm_get_unmapped_area_vmflags(current->mm, file, addr, len, pgoff,
+	return mm_get_unmapped_area_vmflags(current->mm, file, addr0, len, pgoff,
 					    flags, 0);
 }
 
@@ -1308,7 +1222,7 @@ static const struct file_operations huge
 	.read_iter		= hugetlbfs_read_iter,
 	.mmap			= hugetlbfs_file_mmap,
 	.fsync			= noop_fsync,
-	.get_unmapped_area	= __hugetlb_get_unmapped_area,
+	.get_unmapped_area	= hugetlb_get_unmapped_area,
 	.llseek			= default_llseek,
 	.fallocate		= hugetlbfs_fallocate,
 	.fop_flags		= FOP_HUGE_PAGES,
--- a/include/linux/hugetlb.h~mm-drop-hugetlb_get_unmapped_area_-functions
+++ a/include/linux/hugetlb.h
@@ -547,15 +547,10 @@ static inline struct hstate *hstate_inod
 #endif /* !CONFIG_HUGETLBFS */
 
 unsigned long
-__generic_hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
+hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 				    unsigned long len, unsigned long pgoff,
 				    unsigned long flags);
 
-unsigned long
-generic_hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-				  unsigned long len, unsigned long pgoff,
-				  unsigned long flags);
-
 /*
  * huegtlb page specific state flags.  These flags are located in page.private
  * of the hugetlb head page.  Functions created via the below macros should be
_

Patches currently in -mm which might be from osalvador@suse.de are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9A420B212
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343104; cv=none; b=XBb/FEN2agQvGZyxpXRKRIhCTTTPRr43oJwiXH3t4jyEWUNcStZTBsYC2BfYnyCVpnwK56Z46usKzJBCndVuEzov+P7ExkzrPriGxnq+Fw+3okg4GaGRII5D0FvGrTmIqkoN7HvIUGwfu4ikeTjTaKmc5WyOhzO04W11L2w7Kv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343104; c=relaxed/simple;
	bh=KhP3NHDfymo+3AUIGGmy/vCucdChvRHwbv4foPkmdx4=;
	h=Date:To:From:Subject:Message-Id; b=a06iVhRHLVQz93baXXVgP7HvNyCiptU375Xveobmcx0mULwR6pLtu4oDc8vBCjULxY9xulpMsuDIdiXkvZ5jC2gZt/bKqWZ3YBV3Hjf99D5RBnhHJ07+wLGs2cd5E4ceySNkHiXtGVNuoHd91mvxjHggiU/WH0kGaqJA2oxRsdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AOQmNCKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AOQmNCKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF6BC4CEF5;
	Mon, 17 Nov 2025 01:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343104;
	bh=KhP3NHDfymo+3AUIGGmy/vCucdChvRHwbv4foPkmdx4=;
	h=Date:To:From:Subject:From;
	b=AOQmNCKCFDP/v1N7yR7wvVt5PoA2KRSyGo8/nQroVgTOFV/m68SoGEEMSdoew01DR
	 pMt1npg426K3lx4lkfbQyz8NSuhVBgsPpw6Kp1Il1vW8CUPOGP19hzwM5RMiW3bW0k
	 6zteRrWiXdRYHdCqrfqB1zZja4CdJMDDL5G24ocA=
Date: Sun, 16 Nov 2025 17:31:43 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-consistently-use-current-mm-in-mm_get_unmapped_area.patch removed from -mm tree
Message-Id: <20251117013144.6EF6BC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: consistently use current->mm in mm_get_unmapped_area()
has been removed from the -mm tree.  Its filename was
     mm-consistently-use-current-mm-in-mm_get_unmapped_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: consistently use current->mm in mm_get_unmapped_area()
Date: Fri, 3 Oct 2025 16:53:04 +0100

mm_get_unmapped_area() is a wrapper around arch_get_unmapped_area() /
arch_get_unmapped_area_topdown(), both of which search current->mm for
some free space.  Neither take an mm_struct - they implicitly operate on
current->mm.

But the wrapper takes an mm_struct and uses it to decide whether to search
bottom up or top down.  All callers pass in current->mm for this, so
everything is working consistently.  But it feels like an accident waiting
to happen; eventually someone will call that function with a different mm,
expecting to find free space in it, but what gets returned is free space
in the current mm.

So let's simplify by removing the parameter and have the wrapper use
current->mm to decide which end to start at.  Now everything is consistent
and self-documenting.

Link: https://lkml.kernel.org/r/20251003155306.2147572-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/sys_sparc_64.c |    6 +++---
 arch/x86/kernel/cpu/sgx/driver.c |    2 +-
 drivers/char/mem.c               |    2 +-
 drivers/dax/device.c             |    5 ++---
 fs/hugetlbfs/inode.c             |    3 +--
 fs/proc/inode.c                  |    2 +-
 fs/ramfs/file-mmu.c              |    2 +-
 include/linux/sched/mm.h         |    9 ++++-----
 io_uring/memmap.c                |    2 +-
 kernel/bpf/arena.c               |    2 +-
 kernel/bpf/syscall.c             |    2 +-
 mm/huge_memory.c                 |    4 ++--
 mm/mmap.c                        |   17 +++++++----------
 mm/shmem.c                       |    8 +++-----
 14 files changed, 29 insertions(+), 37 deletions(-)

--- a/arch/sparc/kernel/sys_sparc_64.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -241,7 +241,7 @@ unsigned long get_fb_unmapped_area(struc
 
 	if (flags & MAP_FIXED) {
 		/* Ok, don't mess with it. */
-		return mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff, flags);
+		return mm_get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
 	}
 	flags &= ~MAP_SHARED;
 
@@ -254,7 +254,7 @@ unsigned long get_fb_unmapped_area(struc
 		align_goal = (64UL * 1024);
 
 	do {
-		addr = mm_get_unmapped_area(current->mm, NULL, orig_addr,
+		addr = mm_get_unmapped_area(NULL, orig_addr,
 					    len + (align_goal - PAGE_SIZE), pgoff, flags);
 		if (!(addr & ~PAGE_MASK)) {
 			addr = (addr + (align_goal - 1UL)) & ~(align_goal - 1UL);
@@ -273,7 +273,7 @@ unsigned long get_fb_unmapped_area(struc
 	 * be obtained.
 	 */
 	if (addr & ~PAGE_MASK)
-		addr = mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff, flags);
+		addr = mm_get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
 
 	return addr;
 }
--- a/arch/x86/kernel/cpu/sgx/driver.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/arch/x86/kernel/cpu/sgx/driver.c
@@ -113,7 +113,7 @@ static unsigned long sgx_get_unmapped_ar
 	if (flags & MAP_FIXED)
 		return addr;
 
-	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
 }
 
 #ifdef CONFIG_COMPAT
--- a/drivers/char/mem.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/drivers/char/mem.c
@@ -542,7 +542,7 @@ static unsigned long get_unmapped_area_z
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	return thp_get_unmapped_area(file, addr, len, pgoff, flags);
 #else
-	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
 #endif
 }
 #endif /* CONFIG_MMU */
--- a/drivers/dax/device.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/drivers/dax/device.c
@@ -330,14 +330,13 @@ static unsigned long dax_get_unmapped_ar
 	if ((off + len_align) < off)
 		goto out;
 
-	addr_align = mm_get_unmapped_area(current->mm, filp, addr, len_align,
-					  pgoff, flags);
+	addr_align = mm_get_unmapped_area(filp, addr, len_align, pgoff, flags);
 	if (!IS_ERR_VALUE(addr_align)) {
 		addr_align += (off - addr_align) & (align - 1);
 		return addr_align;
 	}
  out:
-	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(filp, addr, len, pgoff, flags);
 }
 
 static const struct address_space_operations dev_dax_aops = {
--- a/fs/hugetlbfs/inode.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/fs/hugetlbfs/inode.c
@@ -184,8 +184,7 @@ hugetlb_get_unmapped_area(struct file *f
 	if (addr)
 		addr0 = ALIGN(addr, huge_page_size(h));
 
-	return mm_get_unmapped_area_vmflags(current->mm, file, addr0, len, pgoff,
-					    flags, 0);
+	return mm_get_unmapped_area_vmflags(file, addr0, len, pgoff, flags, 0);
 }
 
 /*
--- a/fs/proc/inode.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/fs/proc/inode.c
@@ -443,7 +443,7 @@ pde_get_unmapped_area(struct proc_dir_en
 		return pde->proc_ops->proc_get_unmapped_area(file, orig_addr, len, pgoff, flags);
 
 #ifdef CONFIG_MMU
-	return mm_get_unmapped_area(current->mm, file, orig_addr, len, pgoff, flags);
+	return mm_get_unmapped_area(file, orig_addr, len, pgoff, flags);
 #endif
 
 	return orig_addr;
--- a/fs/ramfs/file-mmu.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/fs/ramfs/file-mmu.c
@@ -35,7 +35,7 @@ static unsigned long ramfs_mmu_get_unmap
 		unsigned long addr, unsigned long len, unsigned long pgoff,
 		unsigned long flags)
 {
-	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
 }
 
 const struct file_operations ramfs_file_operations = {
--- a/include/linux/sched/mm.h~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/include/linux/sched/mm.h
@@ -189,12 +189,11 @@ arch_get_unmapped_area_topdown(struct fi
 			       unsigned long len, unsigned long pgoff,
 			       unsigned long flags, vm_flags_t);
 
-unsigned long mm_get_unmapped_area(struct mm_struct *mm, struct file *filp,
-				   unsigned long addr, unsigned long len,
-				   unsigned long pgoff, unsigned long flags);
+unsigned long mm_get_unmapped_area(struct file *filp, unsigned long addr,
+				   unsigned long len, unsigned long pgoff,
+				   unsigned long flags);
 
-unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm,
-					   struct file *filp,
+unsigned long mm_get_unmapped_area_vmflags(struct file *filp,
 					   unsigned long addr,
 					   unsigned long len,
 					   unsigned long pgoff,
--- a/io_uring/memmap.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/io_uring/memmap.c
@@ -387,7 +387,7 @@ unsigned long io_uring_get_unmapped_area
 #else
 	addr = 0UL;
 #endif
-	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(filp, addr, len, pgoff, flags);
 }
 
 #else /* !CONFIG_MMU */
--- a/kernel/bpf/arena.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/kernel/bpf/arena.c
@@ -334,7 +334,7 @@ static unsigned long arena_get_unmapped_
 			return -EINVAL;
 	}
 
-	ret = mm_get_unmapped_area(current->mm, filp, addr, len * 2, 0, flags);
+	ret = mm_get_unmapped_area(filp, addr, len * 2, 0, flags);
 	if (IS_ERR_VALUE(ret))
 		return ret;
 	if ((ret >> 32) == ((ret + len - 1) >> 32))
--- a/kernel/bpf/syscall.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/kernel/bpf/syscall.c
@@ -1162,7 +1162,7 @@ static unsigned long bpf_get_unmapped_ar
 	if (map->ops->map_get_unmapped_area)
 		return map->ops->map_get_unmapped_area(filp, addr, len, pgoff, flags);
 #ifdef CONFIG_MMU
-	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(filp, addr, len, pgoff, flags);
 #else
 	return addr;
 #endif
--- a/mm/huge_memory.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/mm/huge_memory.c
@@ -1127,7 +1127,7 @@ static unsigned long __thp_get_unmapped_
 	if (len_pad < len || (off + len_pad) < off)
 		return 0;
 
-	ret = mm_get_unmapped_area_vmflags(current->mm, filp, addr, len_pad,
+	ret = mm_get_unmapped_area_vmflags(filp, addr, len_pad,
 					   off >> PAGE_SHIFT, flags, vm_flags);
 
 	/*
@@ -1164,7 +1164,7 @@ unsigned long thp_get_unmapped_area_vmfl
 	if (ret)
 		return ret;
 
-	return mm_get_unmapped_area_vmflags(current->mm, filp, addr, len, pgoff, flags,
+	return mm_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags,
 					    vm_flags);
 }
 
--- a/mm/mmap.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/mm/mmap.c
@@ -797,12 +797,11 @@ arch_get_unmapped_area_topdown(struct fi
 }
 #endif
 
-unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm, struct file *filp,
-					   unsigned long addr, unsigned long len,
-					   unsigned long pgoff, unsigned long flags,
-					   vm_flags_t vm_flags)
+unsigned long mm_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
+					   unsigned long len, unsigned long pgoff,
+					   unsigned long flags, vm_flags_t vm_flags)
 {
-	if (mm_flags_test(MMF_TOPDOWN, mm))
+	if (mm_flags_test(MMF_TOPDOWN, current->mm))
 		return arch_get_unmapped_area_topdown(filp, addr, len, pgoff,
 						      flags, vm_flags);
 	return arch_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
@@ -848,7 +847,7 @@ __get_unmapped_area(struct file *file, u
 		addr = thp_get_unmapped_area_vmflags(file, addr, len,
 						     pgoff, flags, vm_flags);
 	} else {
-		addr = mm_get_unmapped_area_vmflags(current->mm, file, addr, len,
+		addr = mm_get_unmapped_area_vmflags(file, addr, len,
 						    pgoff, flags, vm_flags);
 	}
 	if (IS_ERR_VALUE(addr))
@@ -864,12 +863,10 @@ __get_unmapped_area(struct file *file, u
 }
 
 unsigned long
-mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
-		     unsigned long addr, unsigned long len,
+mm_get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		     unsigned long pgoff, unsigned long flags)
 {
-	return mm_get_unmapped_area_vmflags(mm, file, addr, len,
-					    pgoff, flags, 0);
+	return mm_get_unmapped_area_vmflags(file, addr, len, pgoff, flags, 0);
 }
 EXPORT_SYMBOL(mm_get_unmapped_area);
 
--- a/mm/shmem.c~mm-consistently-use-current-mm-in-mm_get_unmapped_area
+++ a/mm/shmem.c
@@ -2759,8 +2759,7 @@ unsigned long shmem_get_unmapped_area(st
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
-	addr = mm_get_unmapped_area(current->mm, file, uaddr, len, pgoff,
-				    flags);
+	addr = mm_get_unmapped_area(file, uaddr, len, pgoff, flags);
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return addr;
@@ -2838,8 +2837,7 @@ unsigned long shmem_get_unmapped_area(st
 	if (inflated_len < len)
 		return addr;
 
-	inflated_addr = mm_get_unmapped_area(current->mm, NULL, uaddr,
-					     inflated_len, 0, flags);
+	inflated_addr = mm_get_unmapped_area(NULL, uaddr, inflated_len, 0, flags);
 	if (IS_ERR_VALUE(inflated_addr))
 		return addr;
 	if (inflated_addr & ~PAGE_MASK)
@@ -5775,7 +5773,7 @@ unsigned long shmem_get_unmapped_area(st
 				      unsigned long addr, unsigned long len,
 				      unsigned long pgoff, unsigned long flags)
 {
-	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
 }
 #endif
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are



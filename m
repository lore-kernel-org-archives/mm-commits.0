Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F9C1F92E
	for <mm-commits@vger.kernel.org>; Wed,  8 Oct 2025 00:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759883837; cv=none; b=IfY9tPpHfG1UboPE6uSp46gmS0ulDrZhzhlzbGMBhvMxc7UsHXdZMpmyKeyV/AAdnqIscO+jQc9385wcWg+GmjnjH3mza6KNSjUgDt/oIsAN4BwoK60Wvaql6Sm/RMv5TMW4OIdDmoHt5ky+MSdJD+efGSGtorYOl2UWTlgYfbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759883837; c=relaxed/simple;
	bh=jcXlbDTD+zYhmHlmqMQGm+PZUCh/7FmnvvniSmDb0sk=;
	h=Date:To:From:Subject:Message-Id; b=EQuXmHdFxzLuohPy5IpcCzETxRXUhasI4Lp2PFX4PQOb0rK595cZXGthdLCph3MwwFdUqkcqPFLtkQ60wgQRN97Jzk5AdzZ4lszFJfVlk6CeZ6G73S3hNbWONOVgaXqfJZpU7t9lT/gSyRjUomywQMYu6f1Ch2SnVCEF5/cIenE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eOjN/f1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eOjN/f1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EADCC4CEF1;
	Wed,  8 Oct 2025 00:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759883836;
	bh=jcXlbDTD+zYhmHlmqMQGm+PZUCh/7FmnvvniSmDb0sk=;
	h=Date:To:From:Subject:From;
	b=eOjN/f1qnlGcMuBx2LRGz6mRHA1Dua2R3qu9NegynZ6QWVBtraqP+6/2h6HbrhWXz
	 rfXW56uw83M5Z5sL43ESVdXAUHCWXGRefxV1lJNO9fhZKCzp/bcoXI840KG7e8zbYs
	 jkT4K4cGZN0vCl8zyhQXy4+w3DADAzAQBmUdwNWE=
Date: Tue, 07 Oct 2025 17:37:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-consistently-use-current-mm-in-mm_get_unmapped_area.patch added to mm-new branch
Message-Id: <20251008003716.6EADCC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: consistently use current->mm in mm_get_unmapped_area()
has been added to the -mm mm-new branch.  Its filename is
     mm-consistently-use-current-mm-in-mm_get_unmapped_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-consistently-use-current-mm-in-mm_get_unmapped_area.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
@@ -558,7 +558,7 @@ static unsigned long get_unmapped_area_z
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
@@ -340,14 +340,13 @@ static unsigned long dax_get_unmapped_ar
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
@@ -194,8 +194,7 @@ hugetlb_get_unmapped_area(struct file *f
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
@@ -1147,7 +1147,7 @@ static unsigned long bpf_get_unmapped_ar
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
@@ -1211,7 +1211,7 @@ static unsigned long __thp_get_unmapped_
 	if (len_pad < len || (off + len_pad) < off)
 		return 0;
 
-	ret = mm_get_unmapped_area_vmflags(current->mm, filp, addr, len_pad,
+	ret = mm_get_unmapped_area_vmflags(filp, addr, len_pad,
 					   off >> PAGE_SHIFT, flags, vm_flags);
 
 	/*
@@ -1248,7 +1248,7 @@ unsigned long thp_get_unmapped_area_vmfl
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
@@ -2756,8 +2756,7 @@ unsigned long shmem_get_unmapped_area(st
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
-	addr = mm_get_unmapped_area(current->mm, file, uaddr, len, pgoff,
-				    flags);
+	addr = mm_get_unmapped_area(file, uaddr, len, pgoff, flags);
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return addr;
@@ -2835,8 +2834,7 @@ unsigned long shmem_get_unmapped_area(st
 	if (inflated_len < len)
 		return addr;
 
-	inflated_addr = mm_get_unmapped_area(current->mm, NULL, uaddr,
-					     inflated_len, 0, flags);
+	inflated_addr = mm_get_unmapped_area(NULL, uaddr, inflated_len, 0, flags);
 	if (IS_ERR_VALUE(inflated_addr))
 		return addr;
 	if (inflated_addr & ~PAGE_MASK)
@@ -5773,7 +5771,7 @@ unsigned long shmem_get_unmapped_area(st
 				      unsigned long addr, unsigned long len,
 				      unsigned long pgoff, unsigned long flags)
 {
-	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(file, addr, len, pgoff, flags);
 }
 #endif
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-consistently-use-current-mm-in-mm_get_unmapped_area.patch


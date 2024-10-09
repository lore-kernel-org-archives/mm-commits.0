Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D9B14A0AB
	for <mm-commits@vger.kernel.org>; Wed,  9 Oct 2024 21:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728507692; cv=none; b=rgewBEGnjpccZDF7ikhm2xAMv0f6diXI9CeWXQQUV3GwvKDBLzJNqvDXQH63q2917A2ja8hzN5tSAB9tTMfVsucV/tioMT6S+0cBq81cVzNS85itQu9l8W4+SvL+KC+FMX0DKXI5ob7ON32oCqUjIH8aA7ys3mbv/LAIanJmiR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728507692; c=relaxed/simple;
	bh=fbixoP8lakL0nHb4diqyW7CQWkiCUgP/HkgqDA2kLrU=;
	h=Date:To:From:Subject:Message-Id; b=ckavTcu84EbSFvLqnOTecIPO7VeG1VuSYvjwzrpv5aNEkQ1oJ+a85JGG4kzKILkQxHdWaqb3+qhj2ru+OBXtKAlpZ+dvwAu+L3tGzFrOuyZrCzQGiROom9lRqGALEX5zEl0ZI7VkvpTBlu6FuN/U4GB9KJ9uoI+ZaB+o3hIgOeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ex8GvJHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ex8GvJHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A814C4CEC3;
	Wed,  9 Oct 2024 21:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728507692;
	bh=fbixoP8lakL0nHb4diqyW7CQWkiCUgP/HkgqDA2kLrU=;
	h=Date:To:From:Subject:From;
	b=ex8GvJHDNfnPWaWPzfT26v0ub4Axw+g1HsG+YclevuVsQKIoNWt7Sqjdrs7dW69Sk
	 CH49Vn7Kh0PhirK3qeyrrRCC94LbfC+IhWdnRnczmqy/hXVhZ1sOUHX1fwaR1iMxE+
	 vmv+IE8kFkdn3vYqSBPfxA6Dh5tprkDyVBLVf+oc=
Date: Wed, 09 Oct 2024 14:01:31 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,jniethe@nvidia.com,david@redhat.com,apopple@nvidia.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch added to mm-unstable branch
Message-Id: <20241009210132.0A814C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kaslr: rename physmem_end and PHYSMEM_END to direct_map_physmem_end
has been added to the -mm mm-unstable branch.  Its filename is
     kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: kaslr: rename physmem_end and PHYSMEM_END to direct_map_physmem_end
Date: Tue, 8 Oct 2024 19:50:24 -0700

For clarity.  It's increasingly hard to reason about the code, when KASLR
is moving around the boundaries.  In this case where KASLR is randomizing
the location of the kernel image within physical memory, the maximum
number of address bits for physical memory has not changed.

What has changed is the ending address of memory that is allowed to be
directly mapped by the kernel.

Let's name the variable, and the associated macro accordingly.

Also, enhance the comment above the direct_map_physmem_end definition,
to further clarify how this all works.

Link: https://lkml.kernel.org/r/20241009025024.89813-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jordan Niethe <jniethe@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/memory.h         |    2 +-
 arch/x86/include/asm/page_64.h          |    2 +-
 arch/x86/include/asm/pgtable_64_types.h |    2 +-
 arch/x86/mm/init_64.c                   |    2 +-
 arch/x86/mm/kaslr.c                     |   14 +++++++++-----
 include/linux/mm.h                      |    6 +++---
 kernel/resource.c                       |    4 ++--
 mm/memory_hotplug.c                     |    2 +-
 mm/sparse.c                             |    2 +-
 9 files changed, 20 insertions(+), 16 deletions(-)

--- a/arch/arm64/include/asm/memory.h~kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end
+++ a/arch/arm64/include/asm/memory.h
@@ -110,7 +110,7 @@
 #define PAGE_END		(_PAGE_END(VA_BITS_MIN))
 #endif /* CONFIG_KASAN */
 
-#define PHYSMEM_END		__pa(PAGE_END - 1)
+#define DIRECT_MAP_PHYSMEM_END	__pa(PAGE_END - 1)
 
 #define MIN_THREAD_SHIFT	(14 + KASAN_THREAD_SHIFT)
 
--- a/arch/x86/include/asm/page_64.h~kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end
+++ a/arch/x86/include/asm/page_64.h
@@ -17,7 +17,7 @@ extern unsigned long phys_base;
 extern unsigned long page_offset_base;
 extern unsigned long vmalloc_base;
 extern unsigned long vmemmap_base;
-extern unsigned long physmem_end;
+extern unsigned long direct_map_physmem_end;
 
 static __always_inline unsigned long __phys_addr_nodebug(unsigned long x)
 {
--- a/arch/x86/include/asm/pgtable_64_types.h~kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end
+++ a/arch/x86/include/asm/pgtable_64_types.h
@@ -141,7 +141,7 @@ extern unsigned int ptrs_per_p4d;
 #endif /* CONFIG_DYNAMIC_MEMORY_LAYOUT */
 
 #ifdef CONFIG_RANDOMIZE_MEMORY
-# define PHYSMEM_END		physmem_end
+# define DIRECT_MAP_PHYSMEM_END	direct_map_physmem_end
 #endif
 
 /*
--- a/arch/x86/mm/init_64.c~kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end
+++ a/arch/x86/mm/init_64.c
@@ -961,7 +961,7 @@ int add_pages(int nid, unsigned long sta
 	unsigned long end = ((start_pfn + nr_pages) << PAGE_SHIFT) - 1;
 	int ret;
 
-	if (WARN_ON_ONCE(end > PHYSMEM_END))
+	if (WARN_ON_ONCE(end > DIRECT_MAP_PHYSMEM_END))
 		return -ERANGE;
 
 	ret = __add_pages(nid, start_pfn, nr_pages, params);
--- a/arch/x86/mm/kaslr.c~kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end
+++ a/arch/x86/mm/kaslr.c
@@ -52,7 +52,7 @@ static __initdata struct kaslr_memory_re
 } kaslr_regions[] = {
 	{
 		.base	= &page_offset_base,
-		.end	= &physmem_end,
+		.end	= &direct_map_physmem_end,
 	},
 	{
 		.base	= &vmalloc_base,
@@ -62,8 +62,12 @@ static __initdata struct kaslr_memory_re
 	},
 };
 
-/* The end of the possible address space for physical memory */
-unsigned long physmem_end __ro_after_init;
+/*
+ * The end of the physical address space that can be mapped directly by the
+ * kernel. This starts out at (1<<MAX_PHYSMEM_BITS) - 1), but KASLR may reduce
+ * that in order to increase the available entropy for mapping other regions.
+ */
+unsigned long direct_map_physmem_end __ro_after_init;
 
 /* Get size in bytes used by the memory region */
 static inline unsigned long get_padding(struct kaslr_memory_region *region)
@@ -94,7 +98,7 @@ void __init kernel_randomize_memory(void
 	BUILD_BUG_ON(vaddr_end > __START_KERNEL_map);
 
 	/* Preset the end of the possible address space for physical memory */
-	physmem_end = ((1ULL << MAX_PHYSMEM_BITS) - 1);
+	direct_map_physmem_end = ((1ULL << MAX_PHYSMEM_BITS) - 1);
 	if (!kaslr_memory_enabled())
 		return;
 
@@ -145,7 +149,7 @@ void __init kernel_randomize_memory(void
 		vaddr += get_padding(&kaslr_regions[i]);
 		/*
 		 * KASLR trims the maximum possible size of the
-		 * direct-map. Update the physmem_end boundary.
+		 * direct-map. Update the direct_map_physmem_end boundary.
 		 * No rounding required as the region starts
 		 * PUD aligned and size is in units of TB.
 		 */
--- a/include/linux/mm.h~kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end
+++ a/include/linux/mm.h
@@ -97,11 +97,11 @@ extern const int mmap_rnd_compat_bits_ma
 extern int mmap_rnd_compat_bits __read_mostly;
 #endif
 
-#ifndef PHYSMEM_END
+#ifndef DIRECT_MAP_PHYSMEM_END
 # ifdef MAX_PHYSMEM_BITS
-# define PHYSMEM_END	((1ULL << MAX_PHYSMEM_BITS) - 1)
+# define DIRECT_MAP_PHYSMEM_END	((1ULL << MAX_PHYSMEM_BITS) - 1)
 # else
-# define PHYSMEM_END	(((phys_addr_t)-1)&~(1ULL<<63))
+# define DIRECT_MAP_PHYSMEM_END	(((phys_addr_t)-1)&~(1ULL<<63))
 # endif
 #endif
 
--- a/kernel/resource.c~kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end
+++ a/kernel/resource.c
@@ -1871,7 +1871,7 @@ static resource_size_t gfr_start(struct
 	if (flags & GFR_DESCENDING) {
 		resource_size_t end;
 
-		end = min_t(resource_size_t, base->end, PHYSMEM_END);
+		end = min_t(resource_size_t, base->end, DIRECT_MAP_PHYSMEM_END);
 		return end - size + 1;
 	}
 
@@ -1888,7 +1888,7 @@ static bool gfr_continue(struct resource
 	 * @size did not wrap 0.
 	 */
 	return addr > addr - size &&
-	       addr <= min_t(resource_size_t, base->end, PHYSMEM_END);
+	       addr <= min_t(resource_size_t, base->end, DIRECT_MAP_PHYSMEM_END);
 }
 
 static resource_size_t gfr_next(resource_size_t addr, resource_size_t size,
--- a/mm/memory_hotplug.c~kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end
+++ a/mm/memory_hotplug.c
@@ -1681,7 +1681,7 @@ struct range __weak arch_get_mappable_ra
 
 struct range mhp_get_pluggable_range(bool need_mapping)
 {
-	const u64 max_phys = PHYSMEM_END;
+	const u64 max_phys = DIRECT_MAP_PHYSMEM_END;
 	struct range mhp_range;
 
 	if (need_mapping) {
--- a/mm/sparse.c~kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end
+++ a/mm/sparse.c
@@ -129,7 +129,7 @@ static inline int sparse_early_nid(struc
 static void __meminit mminit_validate_memmodel_limits(unsigned long *start_pfn,
 						unsigned long *end_pfn)
 {
-	unsigned long max_sparsemem_pfn = (PHYSMEM_END + 1) >> PAGE_SHIFT;
+	unsigned long max_sparsemem_pfn = (DIRECT_MAP_PHYSMEM_END + 1) >> PAGE_SHIFT;
 
 	/*
 	 * Sanity checks - do not allow an architecture to pass
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch


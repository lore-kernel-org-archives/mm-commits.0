Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE063128B8
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 02:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788660356; cv=none; b=F1/pBy5cmPCu09Aly8lDTeT68MxYwm3J9ihp+jsEUggGMnVxYnSyzVB6Jlak7RHBXC+X5zGolJniBa00KOOj3yzVfU/ELF3gu+oALe+9oYFrCO7NmpL0jfU8/HMzP4X4A+qB8uH9vwjrp/ByQBCiJcZ4U1CcXJs3vlrc++R7yoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788660356; c=relaxed/simple;
	bh=tJIpRkPFojllS4EDop1+64H6gF6h/Ir3hLqovIyw6CM=;
	h=Date:To:From:Subject:Message-Id; b=qVGKeUdXBgfqiizK43DCGk41Uhnz92OGHFYwiybmxRh81KsMQj3GdleRbt/vv+jn7fvDJhrwjuAf8hVN2UaiwvyrTGSQNUZo9iZS5WJFOJ/8objGnPcfgKKuyKTIUmjTixzIiysJB4zggQ3vnHltVNnl8n4DOuCtld0I/rjHqfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nQE8tVPI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nQE8tVPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42941F00A3A;
	Sun,  6 Sep 2026 02:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788660355;
	bh=+sNiIqycDwt3vwwYJSw5+BHcMmcETtDaPqgttZsuMWw=;
	h=Date:To:From:Subject;
	b=nQE8tVPIV0ycbESH+tE38VRoRujqsb3uzZ/+JgmJNaD6vn07CxFLkpDiJ5/vYbYKF
	 ypzrLPdYVh7JqqOlccFleq14Xceite/S9pMpfyjcp4XeFnMkJ1pW2SIH+6RF4d4kNN
	 ShSzd5bWi74hc1Ef4LJp8gvsgYcYmITt1C3qOxFI=
Date: Sat, 05 Sep 2026 19:05:54 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,mcgrof@kernel.org,jikos@kernel.org,bentiss@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch added to mm-new branch
Message-Id: <20260906020554.E42941F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/execmem: make sure ROX cache always contains multiples of PMD_SIZE
has been added to the -mm mm-new branch.  Its filename is
     mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/execmem: make sure ROX cache always contains multiples of PMD_SIZE
Date: Thu, 03 Sep 2026 18:50:00 +0300

The ROX cache relies on its chunks being PMD mapped.  For a PMD mapped
chunk, set_memory_rox() updates the direct map alias one PMD at a time and
the large mappings there survive.

When execmem refills the cache, it rounds up the requested allocation size
to PMD_SIZE and tries to allocate that with vmalloc(VM_ALLOW_HUGE_VMAP). 
If that allocation fails, execmem falls back to vmalloc() of the original
size.

There are two issues with this approach:
* If huge pages are not available, __vmalloc_node_range() silently falls
  back to base pages. The area execmem gets is virtually contiguous, but it
  is backed by 512 scattered base pages.

  Permission updates on such areas split large mappings in the direct map
  that contain those base pages, up to 512 PMD splits in the worst case.

* execmem's own fallback adds a small base page mapped area to the cache.
  This adds the overhead of cache management to these allocations with no
  benefit of reducing fragmentation either in the vmalloc/modules address
  space or in the direct map.

  Worse, these areas are never freed from the cache, because
  execmem_cache_clean() releases only chunks that are a multiple of
  PMD_SIZE and aligned to PMD_SIZE, exactly to minimize the number of base
  page mappings.

Add VM_REQUIRE_HUGE_VMAP option to vmalloc that fails if the allocation of
huge pages fails or if such an allocation is not possible because huge
page allocations in vmalloc were disabled or the architecture does not
support them.

Use this option when populating the ROX cache.  If
vmalloc(VM_REQUIRE_HUGE_VMAP) fails or vmalloc of huge pages is
unavailable, handle the memory allocation outside the ROX cache with plain
vmalloc().

Since the fallback allocation has to return ROX memory, add an
execmem_alloc_rox() helper and use it for both populating the ROX cache
and dealing with a fallback allocation in a ROX execmem_range.

With that, the cache only ever contains PMD aligned chunks sized as a
multiple of PMD_SIZE, and the PMD checks in execmem_cache_clean() become a
VM_WARN_ON_ONCE() to ensure that the PMD mapping invariant does not
change.

Assisted-by: copilot:claude-opus-5
Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-3-11beb2a3d249@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 
 mm/execmem.c            |   76 +++++++++++++++++++++++---------------
 mm/vmalloc.c            |   15 +++++++
 3 files changed, 62 insertions(+), 30 deletions(-)

--- a/include/linux/vmalloc.h~mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size
+++ a/include/linux/vmalloc.h
@@ -38,6 +38,7 @@ struct iov_iter;		/* in uio.h */
 #define VM_DEFER_KMEMLEAK	0
 #endif
 #define VM_SPARSE		0x00001000	/* sparse vm_area. not all pages are present. */
+#define VM_REQUIRE_HUGE_VMAP	0x00002000	/* huge page mapping or nothing */
 
 /* bits [20..32] reserved for arch specific ioremap internals */
 
--- a/mm/execmem.c~mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size
+++ a/mm/execmem.c
@@ -51,7 +51,8 @@ static void *execmem_vmalloc(struct exec
 	}
 
 	if (!p) {
-		pr_warn_ratelimited("unable to allocate memory\n");
+		if (!(vm_flags & VM_REQUIRE_HUGE_VMAP))
+			pr_warn_ratelimited("unable to allocate memory\n");
 		return NULL;
 	}
 
@@ -146,9 +147,10 @@ static void execmem_cache_clean(struct w
 		struct vm_struct *vm = find_vm_area(area);
 		size_t size = mas_range_len(&mas);
 
-		if (vm && get_vm_area_size(vm) == size &&
-		    IS_ALIGNED(size, PMD_SIZE) &&
-		    IS_ALIGNED(mas.index, PMD_SIZE)) {
+		if (vm && get_vm_area_size(vm) == size) {
+			VM_WARN_ON_ONCE(!IS_ALIGNED(mas.index, PMD_SIZE) ||
+					!IS_ALIGNED(size, PMD_SIZE));
+
 			/*
 			 * Preallocate to ensure mas_store does not fail
 			 * If there is no memory for the tree update, bail out,
@@ -264,38 +266,41 @@ static void *__execmem_cache_alloc(struc
 	return execmem_cache_alloc_locked(range, size);
 }
 
-static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
+static void *execmem_vmalloc_rox(struct execmem_range *range, size_t size,
+				 unsigned long vm_flags)
 {
-	unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
-	struct mutex *mutex = &execmem_cache.mutex;
-	struct vm_struct *vm;
-	size_t alloc_size;
-	int err = -ENOMEM;
-	void *p;
-
-	alloc_size = round_up(size, PMD_SIZE);
-	p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
-	if (!p) {
-		alloc_size = size;
-		p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
-	}
+	void *p = execmem_vmalloc(range, size, PAGE_KERNEL, vm_flags);
+	int err;
 
 	if (!p)
 		return NULL;
 
-	vm = find_vm_area(p);
-	if (!vm)
-		goto err_free_mem;
-
 	/* fill memory with instructions that will trap */
-	execmem_fill_trapping_insns(p, alloc_size);
-
+	execmem_fill_trapping_insns(p, size);
 	set_vm_flush_reset_perms(p);
-
-	err = set_memory_rox((unsigned long)p, vm->nr_pages);
+	err = set_memory_rox((unsigned long)p, size >> PAGE_SHIFT);
 	if (err)
 		goto err_free_mem;
 
+	return p;
+
+err_free_mem:
+	vfree(p);
+	return NULL;
+}
+
+static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
+{
+	unsigned long vm_flags = VM_REQUIRE_HUGE_VMAP;
+	size_t alloc_size = round_up(size, PMD_SIZE);
+	struct mutex *mutex = &execmem_cache.mutex;
+	int err;
+	void *p;
+
+	p = execmem_vmalloc_rox(range, alloc_size, vm_flags);
+	if (!p)
+		return NULL;
+
 	/*
 	 * New memory blocks must be allocated and added to the cache
 	 * as an atomic operation, otherwise they may be consumed
@@ -317,6 +322,11 @@ err_free_mem:
 	return NULL;
 }
 
+static void *execmem_alloc_rox(struct execmem_range *range, size_t size)
+{
+	return execmem_vmalloc_rox(range, size, 0);
+}
+
 static void *execmem_cache_alloc(struct execmem_range *range, size_t size)
 {
 	void *p;
@@ -444,6 +454,11 @@ static void *execmem_cache_alloc(struct
 	return NULL;
 }
 
+static void *execmem_alloc_rox(struct execmem_range *range, size_t size)
+{
+	return NULL;
+}
+
 static bool execmem_cache_free(void *ptr)
 {
 	return false;
@@ -453,17 +468,20 @@ static bool execmem_cache_free(void *ptr
 void *execmem_alloc(enum execmem_type type, size_t size)
 {
 	struct execmem_range *range = &execmem_info->ranges[type];
-	bool use_cache = range->flags & EXECMEM_ROX_CACHE;
+	bool use_rox_cache = range->flags & EXECMEM_ROX_CACHE;
 	unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
 	pgprot_t pgprot = range->pgprot;
 	void *p = NULL;
 
 	size = PAGE_ALIGN(size);
 
-	if (use_cache)
+	if (use_rox_cache) {
 		p = execmem_cache_alloc(range, size);
-	else
+		if (!p)
+			p = execmem_alloc_rox(range, size);
+	} else {
 		p = execmem_vmalloc(range, size, pgprot, vm_flags);
+	}
 
 	return kasan_reset_tag(p);
 }
--- a/mm/vmalloc.c~mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size
+++ a/mm/vmalloc.c
@@ -4035,6 +4035,12 @@ static gfp_t vmalloc_fix_flags(gfp_t fla
  * %__GFP_SKIP_KASAN can be used to skip unpoisoning of mapped pages
  * (when prot=%PAGE_KERNEL).
  *
+ * %VM_ALLOW_HUGE_VMAP allocates huge pages when possible and falls back to
+ * base pages if huge page allocation fails.
+ *
+ * %VM_REQUIRE_HUGE_VMAP implies %VM_ALLOW_HUGE_VMAP and fails instead of
+ * silently falling back to base pages.
+ *
  * Can not be called from interrupt nor NMI contexts.
  * Return: the address of the area or %NULL on failure
  */
@@ -4060,6 +4066,10 @@ void *__vmalloc_node_range_noprof(unsign
 		return NULL;
 	}
 
+	/* VM_REQUIRE_HUGE_VMAP implies VM_ALLOW_HUGE_VMAP */
+	if (vm_flags & VM_REQUIRE_HUGE_VMAP)
+		vm_flags |= VM_ALLOW_HUGE_VMAP;
+
 	if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
 		/*
 		 * Try huge pages. Only try for PAGE_KERNEL allocations,
@@ -4076,6 +4086,9 @@ void *__vmalloc_node_range_noprof(unsign
 		align = max(original_align, 1UL << shift);
 	}
 
+	if ((vm_flags & VM_REQUIRE_HUGE_VMAP) && shift == PAGE_SHIFT)
+		return NULL;
+
 again:
 	area = __get_vm_area_node(size, align, shift, VM_ALLOC |
 				  VM_UNINITIALIZED | vm_flags, start, end, node,
@@ -4150,7 +4163,7 @@ again:
 	return area->addr;
 
 fail:
-	if (shift > PAGE_SHIFT) {
+	if (shift > PAGE_SHIFT && !(vm_flags & VM_REQUIRE_HUGE_VMAP)) {
 		shift = PAGE_SHIFT;
 		align = original_align;
 		goto again;
_

Patches currently in -mm which might be from rppt@kernel.org are

set_memory-add-number-of-pages-parameter-to-set_direct_map-apis.patch
mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch
mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch
mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch
mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch
revert-arch-introduce-set_direct_map_valid_noflush.patch
docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch
maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch
mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch
mm-execmem-handle-potential-allocation-errors-in-the-maple-tree.patch
mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch
mm-vmalloc-add-define_free-for-vfree.patch
mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch


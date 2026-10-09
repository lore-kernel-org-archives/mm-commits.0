Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ECD3FE37A
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525432; cv=none; b=XtepxBB6gq9QylksXF69kfYOVPX7PQN4iQ/O6O4q2uVVlHtviiRc232cIZbVOTh8Uamqrgu4KKHnVqm2gLij3LBRAaMA/MYye9l1bw8UASLGf77UewM/jI+tp8nJhF+I8AFB4LXKUbLS/hiTpv+3ow237Wwswk/ub8Y5xJwg6DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525432; c=relaxed/simple;
	bh=yAJ9RSrW9asLpr+X+51XRbXcH9cylkhZGJFrzVTgDZ8=;
	h=Date:To:From:Subject:Message-Id; b=QLxAC3ReUOelm+NAOVKlLuMPTquYeYm1R66i8DjsJaJ8zNBFxKXoBn8rOGoVtsG0c22A2ksRzrizSeOoLp8qv+Ef2/w5/0cDSKOhm8jj52zGvcxQskGe79eypDrEX8OoRrEQhcUwmcFNlNnsjNaDwGS9e/N71bbDxkTc4xdoEWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kWbK6awy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kWbK6awy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1951F000FF;
	Fri,  9 Oct 2026 05:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525430;
	bh=aDsGvy7i39KMVXsTAhBy00gCr4WAuRjsy6qGFahzIsU=;
	h=Date:To:From:Subject;
	b=kWbK6awy/ch9J+UGTAMPAZcIcIWvFa1FGOZ6OQew53gditIkGXVnBYQnR6kDmH2wl
	 GQo47QPZtoSeWQpKQKztxuMvBEFx2rgvsJUJCpMXSKtydPyJCIdl5akf8LZO6JV+Nj
	 VmLPaYr+jk8cLmG3RqckPZWRdHLoU+cc604U87rs=
Date: Thu, 08 Oct 2026 22:57:10 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,mcgrof@kernel.org,jikos@kernel.org,bentiss@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch removed from -mm tree
Message-Id: <20261009055710.BF1951F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/execmem: make sure ROX cache always contains multiples of PMD_SIZE
has been removed from the -mm tree.  Its filename was
     mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-3-11beb2a3d249@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: copilot:claude-opus-5
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
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
@@ -4021,6 +4021,12 @@ static gfp_t vmalloc_fix_flags(gfp_t fla
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
@@ -4046,6 +4052,10 @@ void *__vmalloc_node_range_noprof(unsign
 		return NULL;
 	}
 
+	/* VM_REQUIRE_HUGE_VMAP implies VM_ALLOW_HUGE_VMAP */
+	if (vm_flags & VM_REQUIRE_HUGE_VMAP)
+		vm_flags |= VM_ALLOW_HUGE_VMAP;
+
 	if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
 		/*
 		 * Try huge pages. Only try for PAGE_KERNEL allocations,
@@ -4062,6 +4072,9 @@ void *__vmalloc_node_range_noprof(unsign
 		align = max(original_align, 1UL << shift);
 	}
 
+	if ((vm_flags & VM_REQUIRE_HUGE_VMAP) && shift == PAGE_SHIFT)
+		return NULL;
+
 again:
 	area = __get_vm_area_node(size, align, shift, VM_ALLOC |
 				  VM_UNINITIALIZED | vm_flags, start, end, node,
@@ -4136,7 +4149,7 @@ again:
 	return area->addr;
 
 fail:
-	if (shift > PAGE_SHIFT) {
+	if (shift > PAGE_SHIFT && !(vm_flags & VM_REQUIRE_HUGE_VMAP)) {
 		shift = PAGE_SHIFT;
 		align = original_align;
 		goto again;
_

Patches currently in -mm which might be from rppt@kernel.org are

docs-mm-describe-set_memory-and-set_direct_map-apis.patch
docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch
arch-mm-promote-debug_wx-to-check_wx.patch
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


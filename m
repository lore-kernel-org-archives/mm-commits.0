Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C373C0A1A
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896777; cv=none; b=nUj74/2T5uQkslRrnb9e1Y/OVXyLKH0MulnuiQW4XvL+8amlCS23PjphSDlWF5EYH8zYhNBNbs0sFtJfcZwxNK4UBeDSIzvfuVA+p9Z+QZ2BmwzIQjWldmTmXO85THTqFioxyTawxj/vqOPWKFBkhUolX41nHUShpI3rx9Naezs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896777; c=relaxed/simple;
	bh=E/GYlpVQQlS7/Kr9ONZ3usl3Yhr9fusLJAywCGOlZMM=;
	h=Date:To:From:Subject:Message-Id; b=tpCd7nJMJGfUAARP/fwTzXs8R3W4UI24tlWm2/9PfZUVR2ZkjpfcacV7V16HcZ2lMOwXn+fE0u4tHfggPEG+HvpgLFtXOfuIcRKWNPP+xoXxeqrzJrkO4gYnn6m/vH7M+llAYu8AAnA2WbX1GjpJBNO4HvfzPngZLVjDIEVb0QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DHkAbySQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DHkAbySQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4900B1F000E9;
	Wed,  5 Aug 2026 02:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896775;
	bh=lSImgiSQ1kK317/5e4hTqWLrGdEsIV7X++9OmXapG0o=;
	h=Date:To:From:Subject;
	b=DHkAbySQEjRDJCcpETFyhDf4TsHZo2+L67HMNHD9CmXR5o6G/KwQpdF9/PEdmlXNz
	 QH0FONzwR4bve/83uWhAget3D2nj8CKIzQKKz6oZhFS02PpM0tFEefZxgTTnZRYHX5
	 2G8QOoEaMsB6Akcj17pQJ5edhSRqziEDWYzLjtbc=
Date: Tue, 04 Aug 2026 19:26:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch removed from -mm tree
Message-Id: <20260805022615.4900B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: prefer vma_[start,end]_pgoff() to vma->vm_pgoff in kernel/
has been removed from the -mm tree.  Its filename was
     mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm: prefer vma_[start,end]_pgoff() to vma->vm_pgoff in kernel/
Date: Fri, 10 Jul 2026 21:17:00 +0100

Be consistent in using vma_start_pgoff() and vma_end_pgoff(), which clearly
indicates which part of the VMA the page offset refers to and aids
greppability.

This is part of a broader series laying the ground to provide a virtual
page offset for MAP_PRIVATE-file backed anon folios.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-19-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com> # for kernel/dma
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/coherent.c      |    7 ++++---
 kernel/dma/direct.c        |    6 ++++--
 kernel/dma/mapping.c       |    8 +++++---
 kernel/dma/ops_helpers.c   |    4 ++--
 kernel/events/core.c       |   20 +++++++++++---------
 kernel/events/uprobes.c    |   11 +++++++----
 kernel/kcov.c              |    2 +-
 kernel/trace/ring_buffer.c |    3 ++-
 8 files changed, 36 insertions(+), 25 deletions(-)

--- a/kernel/dma/coherent.c~mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel
+++ a/kernel/dma/coherent.c
@@ -236,14 +236,15 @@ static int __dma_mmap_from_coherent(stru
 {
 	if (mem && vaddr >= mem->virt_base && vaddr + size <=
 		   (mem->virt_base + ((dma_addr_t)mem->size << PAGE_SHIFT))) {
-		unsigned long off = vma->vm_pgoff;
+		const pgoff_t pgoff_start = vma_start_pgoff(vma);
+		const pgoff_t pgoff_end = vma_end_pgoff(vma);
 		int start = (vaddr - mem->virt_base) >> PAGE_SHIFT;
 		unsigned long user_count = vma_pages(vma);
 		int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
 		*ret = -ENXIO;
-		if (off < count && user_count <= count - off) {
-			unsigned long pfn = mem->pfn_base + start + off;
+		if (pgoff_start < count && pgoff_end <= count) {
+			unsigned long pfn = mem->pfn_base + start + pgoff_start;
 			*ret = remap_pfn_range(vma, vma->vm_start, pfn,
 					       user_count << PAGE_SHIFT,
 					       vma->vm_page_prot);
--- a/kernel/dma/direct.c~mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel
+++ a/kernel/dma/direct.c
@@ -534,6 +534,8 @@ int dma_direct_mmap(struct device *dev,
 	unsigned long user_count = vma_pages(vma);
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	unsigned long pfn = PHYS_PFN(dma_to_phys(dev, dma_addr));
+	const pgoff_t pgoff_start = vma_start_pgoff(vma);
+	const pgoff_t pgoff_end = vma_end_pgoff(vma);
 	int ret = -ENXIO;
 
 	vma->vm_page_prot = dma_pgprot(dev, vma->vm_page_prot, attrs);
@@ -545,9 +547,9 @@ int dma_direct_mmap(struct device *dev,
 	if (dma_mmap_from_global_coherent(vma, cpu_addr, size, &ret))
 		return ret;
 
-	if (vma->vm_pgoff >= count || user_count > count - vma->vm_pgoff)
+	if (pgoff_start >= count || pgoff_end > count)
 		return -ENXIO;
-	return remap_pfn_range(vma, vma->vm_start, pfn + vma->vm_pgoff,
+	return remap_pfn_range(vma, vma->vm_start, pfn + pgoff_start,
 			user_count << PAGE_SHIFT, vma->vm_page_prot);
 }
 
--- a/kernel/dma/mapping.c~mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel
+++ a/kernel/dma/mapping.c
@@ -761,12 +761,14 @@ EXPORT_SYMBOL_GPL(dma_free_pages);
 int dma_mmap_pages(struct device *dev, struct vm_area_struct *vma,
 		size_t size, struct page *page)
 {
-	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	const pgoff_t pgoff_start = vma_start_pgoff(vma);
+	const pgoff_t pgoff_end = vma_end_pgoff(vma);
+	const unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
-	if (vma->vm_pgoff >= count || vma_pages(vma) > count - vma->vm_pgoff)
+	if (pgoff_start >= count || pgoff_end > count)
 		return -ENXIO;
 	return remap_pfn_range(vma, vma->vm_start,
-			       page_to_pfn(page) + vma->vm_pgoff,
+			       page_to_pfn(page) + pgoff_start,
 			       vma_pages(vma) << PAGE_SHIFT, vma->vm_page_prot);
 }
 EXPORT_SYMBOL_GPL(dma_mmap_pages);
--- a/kernel/dma/ops_helpers.c~mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel
+++ a/kernel/dma/ops_helpers.c
@@ -39,7 +39,7 @@ int dma_common_mmap(struct device *dev,
 #ifdef CONFIG_MMU
 	unsigned long user_count = vma_pages(vma);
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	unsigned long off = vma->vm_pgoff;
+	unsigned long off = vma_start_pgoff(vma);
 	struct page *page = dma_common_vaddr_to_page(cpu_addr);
 	int ret = -ENXIO;
 
@@ -52,7 +52,7 @@ int dma_common_mmap(struct device *dev,
 		return -ENXIO;
 
 	return remap_pfn_range(vma, vma->vm_start,
-			page_to_pfn(page) + vma->vm_pgoff,
+			page_to_pfn(page) + vma_start_pgoff(vma),
 			user_count << PAGE_SHIFT, vma->vm_page_prot);
 #else
 	return -ENXIO;
--- a/kernel/events/core.c~mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel
+++ a/kernel/events/core.c
@@ -6998,7 +6998,7 @@ static void perf_mmap_open(struct vm_are
 	refcount_inc(&event->mmap_count);
 	refcount_inc(&event->rb->mmap_count);
 
-	if (vma->vm_pgoff)
+	if (vma_start_pgoff(vma))
 		refcount_inc(&event->rb->aux_mmap_count);
 
 	if (mapped)
@@ -7032,7 +7032,7 @@ static void perf_mmap_close(struct vm_ar
 	 * The AUX buffer is strictly a sub-buffer, serialize using aux_mutex
 	 * to avoid complications.
 	 */
-	if (rb_has_aux(rb) && vma->vm_pgoff == rb->aux_pgoff &&
+	if (rb_has_aux(rb) && vma_start_pgoff(vma) == rb->aux_pgoff &&
 	    refcount_dec_and_mutex_lock(&rb->aux_mmap_count, &rb->aux_mutex)) {
 		/*
 		 * Stop all AUX events that are writing to this buffer,
@@ -7192,7 +7192,8 @@ static int map_range(struct perf_buffer
 	 */
 	for (pagenum = 0; pagenum < nr_pages; pagenum++) {
 		unsigned long va = vma->vm_start + PAGE_SIZE * pagenum;
-		struct page *page = perf_mmap_to_page(rb, vma->vm_pgoff + pagenum);
+		struct page *page = perf_mmap_to_page(rb,
+				vma_start_pgoff(vma) + pagenum);
 
 		if (page == NULL) {
 			err = -EINVAL;
@@ -7346,6 +7347,7 @@ static int perf_mmap_rb(struct vm_area_s
 static int perf_mmap_aux(struct vm_area_struct *vma, struct perf_event *event,
 			 unsigned long nr_pages)
 {
+	const pgoff_t pgoff_start = vma_start_pgoff(vma);
 	long extra = 0, user_extra = nr_pages;
 	u64 aux_offset, aux_size;
 	struct perf_buffer *rb;
@@ -7368,11 +7370,11 @@ static int perf_mmap_aux(struct vm_area_
 	if (aux_offset < perf_data_size(rb) + PAGE_SIZE)
 		return -EINVAL;
 
-	if (aux_offset != vma->vm_pgoff << PAGE_SHIFT)
+	if (aux_offset != pgoff_start << PAGE_SHIFT)
 		return -EINVAL;
 
 	/* already mapped with a different offset */
-	if (rb_has_aux(rb) && rb->aux_pgoff != vma->vm_pgoff)
+	if (rb_has_aux(rb) && rb->aux_pgoff != pgoff_start)
 		return -EINVAL;
 
 	if (aux_size != nr_pages * PAGE_SIZE)
@@ -7402,7 +7404,7 @@ static int perf_mmap_aux(struct vm_area_
 		if (vma->vm_flags & VM_WRITE)
 			rb_flags |= RING_BUFFER_WRITABLE;
 
-		ret = rb_alloc_aux(rb, event, vma->vm_pgoff, nr_pages,
+		ret = rb_alloc_aux(rb, event, pgoff_start, nr_pages,
 				   event->attr.aux_watermark, rb_flags);
 		if (ret) {
 			refcount_dec(&rb->mmap_count);
@@ -7459,7 +7461,7 @@ static int perf_mmap(struct file *file,
 		if (event->state <= PERF_EVENT_STATE_REVOKED)
 			return -ENODEV;
 
-		if (vma->vm_pgoff == 0)
+		if (!vma_start_pgoff(vma))
 			ret = perf_mmap_rb(vma, event, nr_pages);
 		else
 			ret = perf_mmap_aux(vma, event, nr_pages);
@@ -9886,7 +9888,7 @@ static bool perf_addr_filter_vma_adjust(
 					struct perf_addr_filter_range *fr)
 {
 	unsigned long vma_size = vma->vm_end - vma->vm_start;
-	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long off = vma_start_pgoff(vma) << PAGE_SHIFT;
 	struct file *file = vma->vm_file;
 
 	if (!perf_addr_filter_match(filter, file, off, vma_size))
@@ -9976,7 +9978,7 @@ void perf_event_mmap(struct vm_area_stru
 			/* .tid */
 			.start  = vma->vm_start,
 			.len    = vma->vm_end - vma->vm_start,
-			.pgoff  = (u64)vma->vm_pgoff << PAGE_SHIFT,
+			.pgoff  = (u64)vma_start_pgoff(vma) << PAGE_SHIFT,
 		},
 		/* .maj (attr_mmap2 only) */
 		/* .min (attr_mmap2 only) */
--- a/kernel/events/uprobes.c~mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel
+++ a/kernel/events/uprobes.c
@@ -144,12 +144,14 @@ static bool valid_vma(struct vm_area_str
 
 static unsigned long offset_to_vaddr(struct vm_area_struct *vma, loff_t offset)
 {
-	return vma->vm_start + offset - ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
+	return vma->vm_start + offset -
+		((loff_t)vma_start_pgoff(vma) << PAGE_SHIFT);
 }
 
 static loff_t vaddr_to_offset(struct vm_area_struct *vma, unsigned long vaddr)
 {
-	return ((loff_t)vma->vm_pgoff << PAGE_SHIFT) + (vaddr - vma->vm_start);
+	return ((loff_t)vma_start_pgoff(vma) << PAGE_SHIFT) +
+		(vaddr - vma->vm_start);
 }
 
 /**
@@ -1482,7 +1484,7 @@ static int unapply_uprobe(struct uprobe
 		    file_inode(vma->vm_file) != uprobe->inode)
 			continue;
 
-		offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
+		offset = (loff_t)vma_start_pgoff(vma) << PAGE_SHIFT;
 		if (uprobe->offset <  offset ||
 		    uprobe->offset >= offset + vma->vm_end - vma->vm_start)
 			continue;
@@ -2453,7 +2455,8 @@ static struct uprobe *find_active_uprobe
 	if (!vm_file)
 		return NULL;
 
-	offset = (loff_t)(vma->vm_pgoff << PAGE_SHIFT) + (bp_vaddr - vma->vm_start);
+	offset = (loff_t)(vma_start_pgoff(vma) << PAGE_SHIFT) +
+		(bp_vaddr - vma->vm_start);
 	uprobe = find_uprobe_rcu(vm_file->f_inode, offset);
 	if (!uprobe)
 		return NULL;
--- a/kernel/kcov.c~mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel
+++ a/kernel/kcov.c
@@ -512,7 +512,7 @@ static int kcov_mmap(struct file *filep,
 
 	spin_lock_irqsave(&kcov->lock, flags);
 	size = kcov->size * sizeof(unsigned long);
-	if (kcov->area == NULL || vma->vm_pgoff != 0 ||
+	if (kcov->area == NULL || vma_start_pgoff(vma) ||
 	    vma->vm_end - vma->vm_start != size) {
 		res = -EINVAL;
 		goto exit;
--- a/kernel/trace/ring_buffer.c~mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel
+++ a/kernel/trace/ring_buffer.c
@@ -7611,7 +7611,8 @@ static int __rb_inc_dec_mapped(struct ri
 static int __rb_map_vma(struct ring_buffer_per_cpu *cpu_buffer,
 			struct vm_area_struct *vma)
 {
-	unsigned long nr_subbufs, nr_pages, nr_vma_pages, pgoff = vma->vm_pgoff;
+	unsigned long nr_subbufs, nr_pages, nr_vma_pages;
+	pgoff_t pgoff = vma_start_pgoff(vma);
 	unsigned int subbuf_pages, subbuf_order;
 	struct page **pages __free(kfree) = NULL;
 	int p = 0, s = 0;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-huge_memory-fix-huge_zero_pfn-race.patch
mm-huge_memory-separate-out-config_persistent_huge_zero_folio-logic.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch


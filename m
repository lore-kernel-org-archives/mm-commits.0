Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4927F27A935
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 21:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758143771; cv=none; b=O4KzjWEphcMBRvIsI41uqtf33/KRlFL3W47IoghVqVwXMEmUOQ1h+awft5SGrNqY+wVmFVbYJ44OIWIQUL4ZO/dUwAz5ykoFJddOOnGlwv+4Capxz7WKJMrcjMXTjtBCf+x6IO5lxuBVHfGg74flDMyaAhxt05SnkU70CD2ArtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758143771; c=relaxed/simple;
	bh=6WiXncv9Tz4gcNJP7s+u5+qby6iQKL7ZP2PoXEk8zzM=;
	h=Date:To:From:Subject:Message-Id; b=QPRxlPOSb4SmKh3Xm522o6pXo3gF8SaIlme2IV5jqbeFkV/nMb4mAZHRYzokDPz4X7pJ+xgCjMJ14taQz0049TnPB0rWy60jmR+fMdcg/LLtTM2YUNR8wMzNING93SswNjO5y1uH1qVILUjxIEzBgJcT+NG+NSKxjQuJTO9LMj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vWxbh+bi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vWxbh+bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98E3C4CEE7;
	Wed, 17 Sep 2025 21:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758143770;
	bh=6WiXncv9Tz4gcNJP7s+u5+qby6iQKL7ZP2PoXEk8zzM=;
	h=Date:To:From:Subject:From;
	b=vWxbh+bisvL/FTwyIjignUSt0Oj0avVCDNNMkxs2YjByfn7FGVnIWONpq5HjLLBli
	 OLA7KPoAgd9LhPZdeWjdrqi2GkuZYHGdX34DriX0GIQQuY3tz3eorbc7Yz3TH4HKcZ
	 SGiiYMZkbLkkwMafvAYKqbWBq8O/BBjiDvRXQS0A=
Date: Wed, 17 Sep 2025 14:16:10 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,pratyush@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,chrisl@kernel.org,changyuanl@google.com,bhe@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-add-support-for-preserving-vmalloc-allocations.patch added to mm-new branch
Message-Id: <20250917211610.B98E3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: add support for preserving vmalloc allocations
has been added to the -mm mm-new branch.  Its filename is
     kho-add-support-for-preserving-vmalloc-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-add-support-for-preserving-vmalloc-allocations.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: add support for preserving vmalloc allocations
Date: Wed, 17 Sep 2025 20:40:32 +0300

A vmalloc allocation is preserved using binary structure similar to global
KHO memory tracker.  It's a linked list of pages where each page is an
array of physical address of pages in vmalloc area.

kho_preserve_vmalloc() hands out the physical address of the head page to
the caller.  This address is used as the argument to kho_vmalloc_restore()
to restore the mapping in the vmalloc address space and populate it with
the preserved pages.

Link: https://lkml.kernel.org/r/20250917174033.3810435-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h |   21 ++
 kernel/kexec_handover.c        |  244 +++++++++++++++++++++++++++++++
 2 files changed, 265 insertions(+)

--- a/include/linux/kexec_handover.h~kho-add-support-for-preserving-vmalloc-allocations
+++ a/include/linux/kexec_handover.h
@@ -39,12 +39,22 @@ struct page;
 
 struct kho_serialization;
 
+struct kho_vmalloc_chunk;
+struct kho_vmalloc {
+        DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
+        unsigned int total_pages;
+        unsigned short flags;
+        unsigned short order;
+};
+
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
 
 int kho_preserve_folio(struct folio *folio);
 int kho_preserve_pages(struct page *page, unsigned int nr_pages);
+int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
 struct folio *kho_restore_folio(phys_addr_t phys);
+void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
@@ -71,10 +81,21 @@ static inline int kho_preserve_pages(str
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_preserve_vmalloc(void *ptr,
+				       struct kho_vmalloc *preservation)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {
 	return NULL;
 }
+
+static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
+{
+	return NULL;
+}
 
 static inline int kho_add_subtree(struct kho_serialization *ser,
 				  const char *name, void *fdt)
--- a/kernel/kexec_handover.c~kho-add-support-for-preserving-vmalloc-allocations
+++ a/kernel/kexec_handover.c
@@ -18,6 +18,7 @@
 #include <linux/memblock.h>
 #include <linux/notifier.h>
 #include <linux/page-isolation.h>
+#include <linux/vmalloc.h>
 
 #include <asm/early_ioremap.h>
 
@@ -736,6 +737,249 @@ int kho_preserve_pages(struct page *page
 }
 EXPORT_SYMBOL_GPL(kho_preserve_pages);
 
+struct kho_vmalloc_hdr {
+	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
+};
+
+#define KHO_VMALLOC_SIZE				\
+	((PAGE_SIZE - sizeof(struct kho_vmalloc_hdr)) / \
+	 sizeof(phys_addr_t))
+
+struct kho_vmalloc_chunk {
+	struct kho_vmalloc_hdr hdr;
+	phys_addr_t phys[KHO_VMALLOC_SIZE];
+};
+
+static_assert(sizeof(struct kho_vmalloc_chunk) == PAGE_SIZE);
+
+/* vmalloc flags KHO supports */
+#define KHO_VMALLOC_SUPPORTED_FLAGS	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
+
+/* KHO internal flags for vmalloc preservations */
+#define KHO_VMALLOC_ALLOC	0x0001
+#define KHO_VMALLOC_HUGE_VMAP	0x0002
+
+static unsigned short vmalloc_flags_to_kho(unsigned int vm_flags)
+{
+	unsigned short kho_flags = 0;
+
+	if (vm_flags & VM_ALLOC)
+		kho_flags |= KHO_VMALLOC_ALLOC;
+	if (vm_flags & VM_ALLOW_HUGE_VMAP)
+		kho_flags |= KHO_VMALLOC_HUGE_VMAP;
+
+	return kho_flags;
+}
+
+static unsigned int kho_flags_to_vmalloc(unsigned short kho_flags)
+{
+	unsigned int vm_flags = 0;
+
+	if (kho_flags & KHO_VMALLOC_ALLOC)
+		vm_flags |= VM_ALLOC;
+	if (kho_flags & KHO_VMALLOC_HUGE_VMAP)
+		vm_flags |= VM_ALLOW_HUGE_VMAP;
+
+	return vm_flags;
+}
+
+static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur)
+{
+	struct kho_vmalloc_chunk *chunk;
+	int err;
+
+	chunk = (struct kho_vmalloc_chunk *)get_zeroed_page(GFP_KERNEL);
+	if (!chunk)
+		return NULL;
+
+	err = kho_preserve_pages(virt_to_page(chunk), 1);
+	if (err)
+		goto err_free;
+	if (cur)
+		KHOSER_STORE_PTR(cur->hdr.next, chunk);
+	return chunk;
+
+err_free:
+	free_page((unsigned long)chunk);
+	return NULL;
+}
+
+static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk)
+{
+	struct kho_mem_track *track = &kho_out.ser.track;
+	unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
+
+	__kho_unpreserve(track, pfn, pfn + 1);
+
+	for (int i = 0; chunk->phys[i]; i++) {
+		pfn = PHYS_PFN(chunk->phys[i]);
+		__kho_unpreserve(track, pfn, pfn + 1);
+	}
+}
+
+static void kho_vmalloc_free_chunks(struct kho_vmalloc *kho_vmalloc)
+{
+	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(kho_vmalloc->first);
+
+	while (chunk) {
+		struct kho_vmalloc_chunk *tmp = chunk;
+
+		kho_vmalloc_unpreserve_chunk(chunk);
+
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+		kfree(tmp);
+	}
+}
+
+/**
+ * kho_preserve_vmalloc - preserve memory allocated with vmalloc() across kexec
+ * @ptr: pointer to the area in vmalloc address space
+ * @preservation: placeholder for preservation metadata
+ *
+ * Instructs KHO to preserve the area in vmalloc address space at @ptr. The
+ * physical pages mapped at @ptr will be preserved and on successful return
+ * @preservation will hold the physical address of a structure that describes
+ * the preservation.
+ *
+ * NOTE: The memory allocated with vmalloc_node() variants cannot be reliably
+ * restored on the same node
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
+{
+	struct kho_vmalloc_chunk *chunk;
+	struct vm_struct *vm = find_vm_area(ptr);
+	unsigned int order, flags, nr_contig_pages;
+	unsigned int idx = 0;
+	int err;
+
+	if (!vm)
+		return -EINVAL;
+
+	if (vm->flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
+		return -EOPNOTSUPP;
+
+	flags = vmalloc_flags_to_kho(vm->flags);
+	order = get_vm_area_page_order(vm);
+
+	chunk = new_vmalloc_chunk(NULL);
+	if (!chunk)
+		return -ENOMEM;
+	KHOSER_STORE_PTR(preservation->first, chunk);
+
+	nr_contig_pages = (1 << order);
+	for (int i = 0; i < vm->nr_pages; i += nr_contig_pages) {
+		phys_addr_t phys = page_to_phys(vm->pages[i]);
+
+		err = kho_preserve_pages(vm->pages[i], nr_contig_pages);
+		if (err)
+			goto err_free;
+
+		chunk->phys[idx++] = phys;
+		if (idx == ARRAY_SIZE(chunk->phys)) {
+			chunk = new_vmalloc_chunk(chunk);
+			if (!chunk)
+				goto err_free;
+			idx = 0;
+		}
+	}
+
+	preservation->total_pages = vm->nr_pages;
+	preservation->flags = flags;
+	preservation->order = order;
+
+	return 0;
+
+err_free:
+	kho_vmalloc_free_chunks(preservation);
+	return err;
+}
+EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
+
+/**
+ * kho_restore_vmalloc - recreates and populates an area in vmalloc address
+ * space from the preserved memory.
+ * @preservation: preservation metadata.
+ *
+ * Recreates an area in vmalloc address space and populates it with memory that
+ * was preserved using kho_preserve_vmalloc().
+ *
+ * Return: pointer to the area in the vmalloc address space, NULL on failure.
+ */
+void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
+{
+	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
+	unsigned int align, order, shift, vm_flags;
+	unsigned int idx = 0, nr;
+	unsigned long addr, size;
+	struct vm_struct *area;
+	struct page **pages;
+	int err;
+
+	vm_flags = kho_flags_to_vmalloc(preservation->flags);
+	if (vm_flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
+		return NULL;
+
+	nr = preservation->total_pages;
+	pages = kvmalloc_array(nr, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return NULL;
+	order = preservation->order;
+	shift = PAGE_SHIFT + order;
+	align = 1 << shift;
+
+	while (chunk) {
+		struct page *page;
+
+		for (int i = 0; chunk->phys[i]; i++) {
+			phys_addr_t phys = chunk->phys[i];
+
+			if (idx + (1 << order) > nr)
+				goto err_free_pages_array;
+
+			for (int j = 0; j < (1 << order); j++) {
+				page = phys_to_page(phys);
+				kho_restore_page(page, 0);
+				pages[idx++] = page;
+				phys += PAGE_SIZE;
+			}
+		}
+
+		page = virt_to_page(chunk);
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+		kho_restore_page(page, 0);
+		__free_page(page);
+	}
+
+	if (idx != nr)
+		goto err_free_pages_array;
+
+	area = __get_vm_area_node(nr * PAGE_SIZE, align, shift, vm_flags,
+				  VMALLOC_START, VMALLOC_END, NUMA_NO_NODE,
+				  GFP_KERNEL, __builtin_return_address(0));
+	if (!area)
+		goto err_free_pages_array;
+
+	addr = (unsigned long)area->addr;
+	size = get_vm_area_size(area);
+	err = vmap_pages_range(addr, addr + size, PAGE_KERNEL, pages, shift);
+	if (err)
+		goto err_free_vm_area;
+
+	area->pages = pages;
+	area->nr_pages = nr;
+
+	return area->addr;
+
+err_free_vm_area:
+	free_vm_area(area);
+err_free_pages_array:
+	kvfree(pages);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
+
 /* Handling for debug/kho/out */
 
 static struct dentry *debugfs_root;
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-check-if-kho-is-finalized-in-__kho_preserve_order.patch
kho-replace-kho_preserve_phys-with-kho_preserve_pages.patch
kho-add-support-for-preserving-vmalloc-allocations.patch
lib-test_kho-use-kho_preserve_vmalloc-instead-of-storing-addresses-in-fdt.patch


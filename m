Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01E57BAEC
	for <mm-commits@vger.kernel.org>; Sat, 10 May 2025 00:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746837440; cv=none; b=Th7XABNWRe0ybdsVyTCu08gkAyZldNMwrcnuKUe2XjbfzTxreuP4t3YxLA2mdxyFNM3NUxZdE9MLor924GkM3SO58BpdJ9ZGIr1lbypS4z2tUWL2TyE6CFBfFKd/kmoM8QZi7kQVYrwvrrk3oMut2VwklSWCLMgUDLFfDGFD8K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746837440; c=relaxed/simple;
	bh=8Ecj+kZPGvdVAqmJPBOfKQDrFQeEBpQJwBdSUw8dSy0=;
	h=Date:To:From:Subject:Message-Id; b=i0OcUnAEgfRGJxnW2u3Qfw8p2ijcjplq7uhN6gLzekoC4LO5fCH28MEi8hskxnfWy6EYCJptVnqiSylW6M43f0Z+qrWFVfixFgCVINwuruR6syzsDKnWbgy4TrYwi1v3JZ/5YNt11f60eqIS2R7xeVvglJDvUfG4cpHStAlbjOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZQI8GFRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZQI8GFRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F240FC4CEE4;
	Sat, 10 May 2025 00:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746837437;
	bh=8Ecj+kZPGvdVAqmJPBOfKQDrFQeEBpQJwBdSUw8dSy0=;
	h=Date:To:From:Subject:From;
	b=ZQI8GFRHEwio4zoi/qdvkM3kiGOpGr2OtEWpMJs5PESYqbEHF2BeAFiHVVRDg+Akl
	 vGxi74Wm8njiLcWskVb/9++sZHj7S9HtLsdPRm7q7iCvUyjeQGRRusAefeLilD1MKo
	 eXL2mW+2OX4xcQ8XX9jRVcu1xOltECi2/B662Wls=
Date: Fri, 09 May 2025 17:37:16 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rostedt@goodmis.org,robh@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,jgg@nvidia.com,hpa@zytor.com,graf@amazon.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,changyuanl@google.com,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-enable-kho-support-for-memory-preservation.patch added to mm-unstable branch
Message-Id: <20250510003716.F240FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: enable KHO support for memory preservation
has been added to the -mm mm-unstable branch.  Its filename is
     kexec-enable-kho-support-for-memory-preservation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-enable-kho-support-for-memory-preservation.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kexec: enable KHO support for memory preservation
Date: Fri, 9 May 2025 00:46:24 -0700

Introduce APIs allowing KHO users to preserve memory across kexec and get
access to that memory after boot of the kexeced kernel

kho_preserve_folio() - record a folio to be preserved over kexec
kho_restore_folio() - recreates the folio from the preserved memory
kho_preserve_phys() - record physically contiguous range to be
preserved over kexec.

The memory preservations are tracked by two levels of xarrays to manage
chunks of per-order 512 byte bitmaps.  For instance if PAGE_SIZE = 4096,
the entire 1G order of a 1TB x86 system would fit inside a single 512 byte
bitmap.  For order 0 allocations each bitmap will cover 16M of address
space.  Thus, for 16G of memory at most 512K of bitmap memory will be
needed for order 0.

At serialization time all bitmaps are recorded in a linked list of pages
for the next kernel to process and the physical address of the list is
recorded in KHO FDT.

The next kernel then processes that list, reserves the memory ranges and
later, when a user requests a folio or a physical range, KHO restores
corresponding memory map entries.

Link: https://lkml.kernel.org/r/20250509074635.3187114-7-changyuanl@google.com
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h |   36 ++
 kernel/kexec_handover.c        |  411 +++++++++++++++++++++++++++++++
 2 files changed, 447 insertions(+)

--- a/include/linux/kexec_handover.h~kexec-enable-kho-support-for-memory-preservation
+++ a/include/linux/kexec_handover.h
@@ -16,13 +16,34 @@ enum kho_event {
 	KEXEC_KHO_ABORT = 1,
 };
 
+struct folio;
 struct notifier_block;
 
+#define DECLARE_KHOSER_PTR(name, type) \
+	union {                        \
+		phys_addr_t phys;      \
+		type ptr;              \
+	} name
+#define KHOSER_STORE_PTR(dest, val)               \
+	({                                        \
+		typeof(val) v = val;              \
+		typecheck(typeof((dest).ptr), v); \
+		(dest).phys = virt_to_phys(v);    \
+	})
+#define KHOSER_LOAD_PTR(src)                                                 \
+	({                                                                   \
+		typeof(src) s = src;                                         \
+		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
+	})
+
 struct kho_serialization;
 
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
 
+int kho_preserve_folio(struct folio *folio);
+int kho_preserve_phys(phys_addr_t phys, size_t size);
+struct folio *kho_restore_folio(phys_addr_t phys);
 int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
@@ -39,6 +60,21 @@ static inline bool kho_is_enabled(void)
 	return false;
 }
 
+static inline int kho_preserve_folio(struct folio *folio)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int kho_preserve_phys(phys_addr_t phys, size_t size)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline struct folio *kho_restore_folio(phys_addr_t phys)
+{
+	return NULL;
+}
+
 static inline int kho_add_subtree(struct kho_serialization *ser,
 				  const char *name, void *fdt)
 {
--- a/kernel/kexec_handover.c~kexec-enable-kho-support-for-memory-preservation
+++ a/kernel/kexec_handover.c
@@ -9,6 +9,7 @@
 #define pr_fmt(fmt) "KHO: " fmt
 
 #include <linux/cma.h>
+#include <linux/count_zeros.h>
 #include <linux/debugfs.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
@@ -44,12 +45,307 @@ static int __init kho_parse_enable(char
 }
 early_param("kho", kho_parse_enable);
 
+/*
+ * Keep track of memory that is to be preserved across KHO.
+ *
+ * The serializing side uses two levels of xarrays to manage chunks of per-order
+ * 512 byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order of a
+ * 1TB system would fit inside a single 512 byte bitmap. For order 0 allocations
+ * each bitmap will cover 16M of address space. Thus, for 16G of memory at most
+ * 512K of bitmap memory will be needed for order 0.
+ *
+ * This approach is fully incremental, as the serialization progresses folios
+ * can continue be aggregated to the tracker. The final step, immediately prior
+ * to kexec would serialize the xarray information into a linked list for the
+ * successor kernel to parse.
+ */
+
+#define PRESERVE_BITS (512 * 8)
+
+struct kho_mem_phys_bits {
+	DECLARE_BITMAP(preserve, PRESERVE_BITS);
+};
+
+struct kho_mem_phys {
+	/*
+	 * Points to kho_mem_phys_bits, a sparse bitmap array. Each bit is sized
+	 * to order.
+	 */
+	struct xarray phys_bits;
+};
+
+struct kho_mem_track {
+	/* Points to kho_mem_phys, each order gets its own bitmap tree */
+	struct xarray orders;
+};
+
+struct khoser_mem_chunk;
+
 struct kho_serialization {
 	struct page *fdt;
 	struct list_head fdt_list;
 	struct dentry *sub_fdt_dir;
+	struct kho_mem_track track;
+	/* First chunk of serialized preserved memory map */
+	struct khoser_mem_chunk *preserved_mem_map;
+};
+
+static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
+{
+	void *elm, *res;
+
+	elm = xa_load(xa, index);
+	if (elm)
+		return elm;
+
+	elm = kzalloc(sz, GFP_KERNEL);
+	if (!elm)
+		return ERR_PTR(-ENOMEM);
+
+	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
+	if (xa_is_err(res))
+		res = ERR_PTR(xa_err(res));
+
+	if (res) {
+		kfree(elm);
+		return res;
+	}
+
+	return elm;
+}
+
+static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
+			     unsigned long end_pfn)
+{
+	struct kho_mem_phys_bits *bits;
+	struct kho_mem_phys *physxa;
+
+	while (pfn < end_pfn) {
+		const unsigned int order =
+			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
+		const unsigned long pfn_high = pfn >> order;
+
+		physxa = xa_load(&track->orders, order);
+		if (!physxa)
+			continue;
+
+		bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
+		if (!bits)
+			continue;
+
+		clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
+
+		pfn += 1 << order;
+	}
+}
+
+static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
+				unsigned int order)
+{
+	struct kho_mem_phys_bits *bits;
+	struct kho_mem_phys *physxa;
+	const unsigned long pfn_high = pfn >> order;
+
+	might_sleep();
+
+	physxa = xa_load_or_alloc(&track->orders, order, sizeof(*physxa));
+	if (IS_ERR(physxa))
+		return PTR_ERR(physxa);
+
+	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS,
+				sizeof(*bits));
+	if (IS_ERR(bits))
+		return PTR_ERR(bits);
+
+	set_bit(pfn_high % PRESERVE_BITS, bits->preserve);
+
+	return 0;
+}
+
+/* almost as free_reserved_page(), just don't free the page */
+static void kho_restore_page(struct page *page)
+{
+	ClearPageReserved(page);
+	init_page_count(page);
+	adjust_managed_page_count(page, 1);
+}
+
+/**
+ * kho_restore_folio - recreates the folio from the preserved memory.
+ * @phys: physical address of the folio.
+ *
+ * Return: pointer to the struct folio on success, NULL on failure.
+ */
+struct folio *kho_restore_folio(phys_addr_t phys)
+{
+	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
+	unsigned long order;
+
+	if (!page)
+		return NULL;
+
+	order = page->private;
+	if (order) {
+		if (order > MAX_PAGE_ORDER)
+			return NULL;
+
+		prep_compound_page(page, order);
+	} else {
+		kho_restore_page(page);
+	}
+
+	return page_folio(page);
+}
+EXPORT_SYMBOL_GPL(kho_restore_folio);
+
+/* Serialize and deserialize struct kho_mem_phys across kexec
+ *
+ * Record all the bitmaps in a linked list of pages for the next kernel to
+ * process. Each chunk holds bitmaps of the same order and each block of bitmaps
+ * starts at a given physical address. This allows the bitmaps to be sparse. The
+ * xarray is used to store them in a tree while building up the data structure,
+ * but the KHO successor kernel only needs to process them once in order.
+ *
+ * All of this memory is normal kmalloc() memory and is not marked for
+ * preservation. The successor kernel will remain isolated to the scratch space
+ * until it completes processing this list. Once processed all the memory
+ * storing these ranges will be marked as free.
+ */
+
+struct khoser_mem_bitmap_ptr {
+	phys_addr_t phys_start;
+	DECLARE_KHOSER_PTR(bitmap, struct kho_mem_phys_bits *);
 };
 
+struct khoser_mem_chunk_hdr {
+	DECLARE_KHOSER_PTR(next, struct khoser_mem_chunk *);
+	unsigned int order;
+	unsigned int num_elms;
+};
+
+#define KHOSER_BITMAP_SIZE                                   \
+	((PAGE_SIZE - sizeof(struct khoser_mem_chunk_hdr)) / \
+	 sizeof(struct khoser_mem_bitmap_ptr))
+
+struct khoser_mem_chunk {
+	struct khoser_mem_chunk_hdr hdr;
+	struct khoser_mem_bitmap_ptr bitmaps[KHOSER_BITMAP_SIZE];
+};
+
+static_assert(sizeof(struct khoser_mem_chunk) == PAGE_SIZE);
+
+static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
+					  unsigned long order)
+{
+	struct khoser_mem_chunk *chunk;
+
+	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!chunk)
+		return NULL;
+	chunk->hdr.order = order;
+	if (cur_chunk)
+		KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
+	return chunk;
+}
+
+static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
+{
+	struct khoser_mem_chunk *chunk = first_chunk;
+
+	while (chunk) {
+		struct khoser_mem_chunk *tmp = chunk;
+
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+		kfree(tmp);
+	}
+}
+
+static int kho_mem_serialize(struct kho_serialization *ser)
+{
+	struct khoser_mem_chunk *first_chunk = NULL;
+	struct khoser_mem_chunk *chunk = NULL;
+	struct kho_mem_phys *physxa;
+	unsigned long order;
+
+	xa_for_each(&ser->track.orders, order, physxa) {
+		struct kho_mem_phys_bits *bits;
+		unsigned long phys;
+
+		chunk = new_chunk(chunk, order);
+		if (!chunk)
+			goto err_free;
+
+		if (!first_chunk)
+			first_chunk = chunk;
+
+		xa_for_each(&physxa->phys_bits, phys, bits) {
+			struct khoser_mem_bitmap_ptr *elm;
+
+			if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->bitmaps)) {
+				chunk = new_chunk(chunk, order);
+				if (!chunk)
+					goto err_free;
+			}
+
+			elm = &chunk->bitmaps[chunk->hdr.num_elms];
+			chunk->hdr.num_elms++;
+			elm->phys_start = (phys * PRESERVE_BITS)
+					  << (order + PAGE_SHIFT);
+			KHOSER_STORE_PTR(elm->bitmap, bits);
+		}
+	}
+
+	ser->preserved_mem_map = first_chunk;
+
+	return 0;
+
+err_free:
+	kho_mem_ser_free(first_chunk);
+	return -ENOMEM;
+}
+
+static void deserialize_bitmap(unsigned int order,
+			       struct khoser_mem_bitmap_ptr *elm)
+{
+	struct kho_mem_phys_bits *bitmap = KHOSER_LOAD_PTR(elm->bitmap);
+	unsigned long bit;
+
+	for_each_set_bit(bit, bitmap->preserve, PRESERVE_BITS) {
+		int sz = 1 << (order + PAGE_SHIFT);
+		phys_addr_t phys =
+			elm->phys_start + (bit << (order + PAGE_SHIFT));
+		struct page *page = phys_to_page(phys);
+
+		memblock_reserve(phys, sz);
+		memblock_reserved_mark_noinit(phys, sz);
+		page->private = order;
+	}
+}
+
+static void __init kho_mem_deserialize(const void *fdt)
+{
+	struct khoser_mem_chunk *chunk;
+	const phys_addr_t *mem;
+	int len;
+
+	mem = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
+
+	if (!mem || len != sizeof(*mem)) {
+		pr_err("failed to get preserved memory bitmaps\n");
+		return;
+	}
+
+	chunk = *mem ? phys_to_virt(*mem) : NULL;
+	while (chunk) {
+		unsigned int i;
+
+		for (i = 0; i != chunk->hdr.num_elms; i++)
+			deserialize_bitmap(chunk->hdr.order,
+					   &chunk->bitmaps[i]);
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+	}
+}
+
 /*
  * With KHO enabled, memory can become fragmented because KHO regions may
  * be anywhere in physical address space. The scratch regions give us a
@@ -324,6 +620,9 @@ static struct kho_out kho_out = {
 	.lock = __MUTEX_INITIALIZER(kho_out.lock),
 	.ser = {
 		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
+		.track = {
+			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
+		},
 	},
 	.finalized = false,
 };
@@ -340,6 +639,73 @@ int unregister_kho_notifier(struct notif
 }
 EXPORT_SYMBOL_GPL(unregister_kho_notifier);
 
+/**
+ * kho_preserve_folio - preserve a folio across kexec.
+ * @folio: folio to preserve.
+ *
+ * Instructs KHO to preserve the whole folio across kexec. The order
+ * will be preserved as well.
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_preserve_folio(struct folio *folio)
+{
+	const unsigned long pfn = folio_pfn(folio);
+	const unsigned int order = folio_order(folio);
+	struct kho_mem_track *track = &kho_out.ser.track;
+
+	if (kho_out.finalized)
+		return -EBUSY;
+
+	return __kho_preserve_order(track, pfn, order);
+}
+EXPORT_SYMBOL_GPL(kho_preserve_folio);
+
+/**
+ * kho_preserve_phys - preserve a physically contiguous range across kexec.
+ * @phys: physical address of the range.
+ * @size: size of the range.
+ *
+ * Instructs KHO to preserve the memory range from @phys to @phys + @size
+ * across kexec.
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_preserve_phys(phys_addr_t phys, size_t size)
+{
+	unsigned long pfn = PHYS_PFN(phys);
+	unsigned long failed_pfn = 0;
+	const unsigned long start_pfn = pfn;
+	const unsigned long end_pfn = PHYS_PFN(phys + size);
+	int err = 0;
+	struct kho_mem_track *track = &kho_out.ser.track;
+
+	if (kho_out.finalized)
+		return -EBUSY;
+
+	if (!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size))
+		return -EINVAL;
+
+	while (pfn < end_pfn) {
+		const unsigned int order =
+			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
+
+		err = __kho_preserve_order(track, pfn, order);
+		if (err) {
+			failed_pfn = pfn;
+			break;
+		}
+
+		pfn += 1 << order;
+	}
+
+	if (err)
+		__kho_unpreserve(track, start_pfn, failed_pfn);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(kho_preserve_phys);
+
 /* Handling for debug/kho/out */
 
 static struct dentry *debugfs_root;
@@ -366,6 +732,25 @@ static int kho_out_update_debugfs_fdt(vo
 static int kho_abort(void)
 {
 	int err;
+	unsigned long order;
+	struct kho_mem_phys *physxa;
+
+	xa_for_each(&kho_out.ser.track.orders, order, physxa) {
+		struct kho_mem_phys_bits *bits;
+		unsigned long phys;
+
+		xa_for_each(&physxa->phys_bits, phys, bits)
+			kfree(bits);
+
+		xa_destroy(&physxa->phys_bits);
+		kfree(physxa);
+	}
+	xa_destroy(&kho_out.ser.track.orders);
+
+	if (kho_out.ser.preserved_mem_map) {
+		kho_mem_ser_free(kho_out.ser.preserved_mem_map);
+		kho_out.ser.preserved_mem_map = NULL;
+	}
 
 	err = blocking_notifier_call_chain(&kho_out.chain_head, KEXEC_KHO_ABORT,
 					   NULL);
@@ -380,12 +765,25 @@ static int kho_abort(void)
 static int kho_finalize(void)
 {
 	int err = 0;
+	u64 *preserved_mem_map;
 	void *fdt = page_to_virt(kho_out.ser.fdt);
 
 	err |= fdt_create(fdt, PAGE_SIZE);
 	err |= fdt_finish_reservemap(fdt);
 	err |= fdt_begin_node(fdt, "");
 	err |= fdt_property_string(fdt, "compatible", KHO_FDT_COMPATIBLE);
+	/**
+	 * Reserve the preserved-memory-map property in the root FDT, so
+	 * that all property definitions will precede subnodes created by
+	 * KHO callers.
+	 */
+	err |= fdt_property_placeholder(fdt, PROP_PRESERVED_MEMORY_MAP,
+					sizeof(*preserved_mem_map),
+					(void **)&preserved_mem_map);
+	if (err)
+		goto abort;
+
+	err = kho_preserve_folio(page_folio(kho_out.ser.fdt));
 	if (err)
 		goto abort;
 
@@ -395,6 +793,12 @@ static int kho_finalize(void)
 	if (err)
 		goto abort;
 
+	err = kho_mem_serialize(&kho_out.ser);
+	if (err)
+		goto abort;
+
+	*preserved_mem_map = (u64)virt_to_phys(kho_out.ser.preserved_mem_map);
+
 	err |= fdt_end_node(fdt);
 	err |= fdt_finish(fdt);
 
@@ -697,9 +1101,16 @@ static void __init kho_release_scratch(v
 
 void __init kho_memory_init(void)
 {
+	struct folio *folio;
+
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
+
+		kho_mem_deserialize(kho_get_fdt());
+		folio = kho_restore_folio(kho_in.fdt_phys);
+		if (!folio)
+			pr_warn("failed to restore folio for KHO fdt\n");
 	} else {
 		kho_reserve_scratch();
 	}
_

Patches currently in -mm which might be from rppt@kernel.org are

execmem-enforce-allocation-size-aligment-to-page_size.patch
memblock-add-memblock_rsrv_kern-flag.patch
memblock-introduce-memmap_init_kho_scratch.patch
kexec-enable-kho-support-for-memory-preservation.patch
x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch
documentation-kho-add-memblock-bindings.patch


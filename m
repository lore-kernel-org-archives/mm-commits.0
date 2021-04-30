Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7128BC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5453D6147D
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhD3F7n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhD3F7m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:59:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FF1961480;
        Fri, 30 Apr 2021 05:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762333;
        bh=aKLmHMv40826pKm1V9jFaB2DR7NPT6pdoQN5NDS62hI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UIUbONKckvgv4VZzvc5UNvj5dbrODArYElyEz66C5p9n7Dd1RU6cL4F7SlQIQwtEL
         jODdHxkppc7o8rvqk5ViBSoX8uE8DUiOxGPcU6tx9wM29tk1OGx0eKznphxwKwmK3Y
         iXFAEFOb+k0MuPwHwXnQaIxXji9thqS2sn4gzOYs=
Date:   Thu, 29 Apr 2021 22:58:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, clg@kaod.org, hch@lst.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, npiggin@gmail.com,
        torvalds@linux-foundation.org, urezki@gmail.com
Subject:  [patch 110/178] mm/vmalloc: remove map_kernel_range
Message-ID: <20210430055853.7KvE_JLE6%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Nicholas Piggin <npiggin@gmail.com>
Subject: mm/vmalloc: remove map_kernel_range

Patch series "mm/vmalloc: cleanup after hugepage series", v2.

Christoph pointed out some overdue cleanups required after the huge
vmalloc series, and I had another failure error message improvement as
well.


This patch (of 5):

This is a shim around vmap_pages_range, get rid of it.

Move the main API comment from the _noflush variant to the normal variant,
and make _noflush internal to mm/.

Link: https://lkml.kernel.org/r/20210322021806.892164-1-npiggin@gmail.com
Link: https://lkml.kernel.org/r/20210322021806.892164-2-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: C=C3=A9dric Le Goater <clg@kaod.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/cachetlb.rst |    2=20
 include/linux/vmalloc.h             |   11 ----
 mm/internal.h                       |    6 ++
 mm/percpu-vm.c                      |    5 +-
 mm/vmalloc.c                        |   65 +++++++++++---------------
 5 files changed, 38 insertions(+), 51 deletions(-)

--- a/Documentation/core-api/cachetlb.rst~mm-vmalloc-remove-map_kernel_range
+++ a/Documentation/core-api/cachetlb.rst
@@ -213,7 +213,7 @@ Here are the routines, one by one:
 	there will be no entries in the cache for the kernel address
 	space for virtual addresses in the range 'start' to 'end-1'.
=20
-	The first of these two routines is invoked after map_kernel_range()
+	The first of these two routines is invoked after vmap_range()
 	has installed the page table entries.  The second is invoked
 	before unmap_kernel_range() deletes the page table entries.
=20
--- a/include/linux/vmalloc.h~mm-vmalloc-remove-map_kernel_range
+++ a/include/linux/vmalloc.h
@@ -212,10 +212,6 @@ static inline bool is_vm_area_hugepages(
 int vmap_range(unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift);
-extern int map_kernel_range_noflush(unsigned long start, unsigned long siz=
e,
-				    pgprot_t prot, struct page **pages);
-int map_kernel_range(unsigned long start, unsigned long size, pgprot_t pro=
t,
-		struct page **pages);
 extern void unmap_kernel_range_noflush(unsigned long addr, unsigned long s=
ize);
 extern void unmap_kernel_range(unsigned long addr, unsigned long size);
 static inline void set_vm_flush_reset_perms(void *addr)
@@ -227,13 +223,6 @@ static inline void set_vm_flush_reset_pe
 }
=20
 #else
-static inline int
-map_kernel_range_noflush(unsigned long start, unsigned long size,
-			pgprot_t prot, struct page **pages)
-{
-	return size >> PAGE_SHIFT;
-}
-#define map_kernel_range map_kernel_range_noflush
 static inline void
 unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
 {
--- a/mm/internal.h~mm-vmalloc-remove-map_kernel_range
+++ a/mm/internal.h
@@ -637,4 +637,10 @@ struct migration_target_control {
 	gfp_t gfp_mask;
 };
=20
+/*
+ * mm/vmalloc.c
+ */
+int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+                pgprot_t prot, struct page **pages, unsigned int page_shif=
t);
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/percpu-vm.c~mm-vmalloc-remove-map_kernel_range
+++ a/mm/percpu-vm.c
@@ -8,6 +8,7 @@
  * Chunks are mapped into vmalloc areas and populated page by page.
  * This is the default chunk allocator.
  */
+#include "internal.h"
=20
 static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
 				    unsigned int cpu, int page_idx)
@@ -192,8 +193,8 @@ static void pcpu_post_unmap_tlb_flush(st
 static int __pcpu_map_pages(unsigned long addr, struct page **pages,
 			    int nr_pages)
 {
-	return map_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT,
-					PAGE_KERNEL, pages);
+	return vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
+					PAGE_KERNEL, pages, PAGE_SHIFT);
 }
=20
 /**
--- a/mm/vmalloc.c~mm-vmalloc-remove-map_kernel_range
+++ a/mm/vmalloc.c
@@ -523,7 +523,16 @@ static int vmap_small_pages_range_noflus
 	return 0;
 }
=20
-static int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+/*
+ * vmap_pages_range_noflush is similar to vmap_pages_range, but does not
+ * flush caches.
+ *
+ * The caller is responsible for calling flush_cache_vmap() after this
+ * function returns successfully and before the addresses are accessed.
+ *
+ * This is an internal function only. Do not use outside mm/.
+ */
+int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
 	unsigned int i, nr =3D (end - addr) >> PAGE_SHIFT;
@@ -549,48 +558,26 @@ static int vmap_pages_range_noflush(unsi
 	return 0;
 }
=20
-static int vmap_pages_range(unsigned long addr, unsigned long end,
-		pgprot_t prot, struct page **pages, unsigned int page_shift)
-{
-	int err;
-
-	err =3D vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
-	flush_cache_vmap(addr, end);
-	return err;
-}
-
 /**
- * map_kernel_range_noflush - map kernel VM area with the specified pages
+ * vmap_pages_range - map pages to a kernel virtual address
  * @addr: start of the VM area to map
- * @size: size of the VM area to map
+ * @end: end of the VM area to map (non-inclusive)
  * @prot: page protection flags to use
- * @pages: pages to map
- *
- * Map PFN_UP(@size) pages at @addr.  The VM area @addr and @size specify =
should
- * have been allocated using get_vm_area() and its friends.
- *
- * NOTE:
- * This function does NOT do any cache flushing.  The caller is responsibl=
e for
- * calling flush_cache_vmap() on to-be-mapped areas before calling this
- * function.
+ * @pages: pages to map (always PAGE_SIZE pages)
+ * @page_shift: maximum shift that the pages may be mapped with, @pages mu=
st
+ * be aligned and contiguous up to at least this shift.
  *
  * RETURNS:
  * 0 on success, -errno on failure.
  */
-int map_kernel_range_noflush(unsigned long addr, unsigned long size,
-			     pgprot_t prot, struct page **pages)
-{
-	return vmap_pages_range_noflush(addr, addr + size, prot, pages, PAGE_SHIF=
T);
-}
-
-int map_kernel_range(unsigned long start, unsigned long size, pgprot_t pro=
t,
-		struct page **pages)
+static int vmap_pages_range(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	int ret;
+	int err;
=20
-	ret =3D map_kernel_range_noflush(start, size, prot, pages);
-	flush_cache_vmap(start, start + size);
-	return ret;
+	err =3D vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+	flush_cache_vmap(addr, end);
+	return err;
 }
=20
 int is_vmalloc_or_module_addr(const void *x)
@@ -2156,10 +2143,12 @@ void *vm_map_ram(struct page **pages, un
=20
 	kasan_unpoison_vmalloc(mem, size);
=20
-	if (map_kernel_range(addr, size, PAGE_KERNEL, pages) < 0) {
+	if (vmap_pages_range(addr, addr + size, PAGE_KERNEL,
+				pages, PAGE_SHIFT) < 0) {
 		vm_unmap_ram(mem, count);
 		return NULL;
 	}
+
 	return mem;
 }
 EXPORT_SYMBOL(vm_map_ram);
@@ -2703,6 +2692,7 @@ void *vmap(struct page **pages, unsigned
 	   unsigned long flags, pgprot_t prot)
 {
 	struct vm_struct *area;
+	unsigned long addr;
 	unsigned long size;		/* In bytes */
=20
 	might_sleep();
@@ -2715,8 +2705,9 @@ void *vmap(struct page **pages, unsigned
 	if (!area)
 		return NULL;
=20
-	if (map_kernel_range((unsigned long)area->addr, size, pgprot_nx(prot),
-			pages) < 0) {
+	addr =3D (unsigned long)area->addr;
+	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
+				pages, PAGE_SHIFT) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
_

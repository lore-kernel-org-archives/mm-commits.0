Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AB53BED7A
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896689; cv=none; b=bI2e4sTNNu9vS41NtwgVu4f+SrpK0OKrBslabDKt2odGGfHmhf42/fRE0FbBwU8N7UTQLiw9WaM5QZ5Dt7elc+0YTSpZVL4nvuYja4EUOkTKUgTEZxvNsGpfA5fTt9hfZcGgQr7HwZdxH4YaZhgZdKIbnaFlh6XdLaxlcfPFuDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896689; c=relaxed/simple;
	bh=avCehgGA/1ixpdALs5ilgJz9Uf0whAGIJf12f+aRocw=;
	h=Date:To:From:Subject:Message-Id; b=Dg0pPs22GjQv2jEATMHhSTkSUbpoqVJc0dUTI4vCG4f9w/Z9v696i+nqWEJV6S7qg41t7jL2Q5xpINtLmUgeRDhaXWFxnCTaVNlTijvonVHQML6Nz0IGOuSoXWEnHVM8eltzF64IjFDkfwpuxmd1RkayybOBzKpmWYirpMI2Ji8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U7pRuxmx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U7pRuxmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07351F00A3A;
	Wed,  5 Aug 2026 02:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896687;
	bh=050pq1fPZv5beNyLlVGd2bCNOv+4ohnV1apLpBFJitc=;
	h=Date:To:From:Subject;
	b=U7pRuxmxL2C7R3AxHLPlyY7yT5PnQIcAX/vKydJeaVtevCOqIE8rafMwvp836GYKw
	 WUE0k2PHIN/LEr8Uxn5M6kVqvbYRD0l86Ckf2n8NFCmHPnWBGzyLh8hrKP+sukuygu
	 4XeB6GfJpnPnip/b4u+QdchTkatE3xQU5xHG0KFE=
Date: Tue, 04 Aug 2026 19:24:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,urezki@gmail.com,tj@kernel.org,surenb@google.com,sj@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,graf@amazon.com,glider@google.com,elver@google.com,dvyukov@google.com,dennis@kernel.org,david@kernel.org,brendan.jackman@linux.dev,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-split-out-vmalloc-declarations-from-internalh.patch removed from -mm tree
Message-Id: <20260805022446.E07351F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: split out vmalloc declarations from internal.h
has been removed from the -mm tree.  Its filename was
     mm-split-out-vmalloc-declarations-from-internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: split out vmalloc declarations from internal.h
Date: Thu, 09 Jul 2026 13:00:05 +0300

mm/internal.h becomes more and more bloated.

Move declarations related to vmalloc to a new mm/vmalloc.h header.

No functional changes.

Link: https://lore.kernel.org/20260709-internal-h-v2-3-695631425968@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Acked-by: SJ Park <sj@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                        |    1 
 kernel/liveupdate/kexec_handover.c |    2 -
 mm/execmem.c                       |    1 
 mm/internal.h                      |   40 -----------------------
 mm/kmsan/hooks.c                   |    1 
 mm/kmsan/shadow.c                  |    1 
 mm/mm_init.c                       |    1 
 mm/percpu-vm.c                     |    1 
 mm/vmalloc.c                       |    1 
 mm/vmalloc.h                       |   46 +++++++++++++++++++++++++++
 10 files changed, 54 insertions(+), 41 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~mm-split-out-vmalloc-declarations-from-internalh
+++ a/kernel/liveupdate/kexec_handover.c
@@ -34,8 +34,8 @@
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
  */
-#include "../../mm/internal.h"
 #include "../../mm/mm_init.h"
+#include "../../mm/vmalloc.h"
 #include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
--- a/MAINTAINERS~mm-split-out-vmalloc-declarations-from-internalh
+++ a/MAINTAINERS
@@ -28818,6 +28818,7 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/vmalloc.h
 F:	mm/vmalloc.c
+F:	mm/vmalloc.h
 F:	lib/test_vmalloc.c
 
 VME SUBSYSTEM
--- a/mm/execmem.c~mm-split-out-vmalloc-declarations-from-internalh
+++ a/mm/execmem.c
@@ -20,6 +20,7 @@
 #include <asm/tlbflush.h>
 
 #include "internal.h"
+#include "vmalloc.h"
 
 static struct execmem_info *execmem_info __ro_after_init;
 static struct execmem_info default_execmem_info __ro_after_init;
--- a/mm/internal.h~mm-split-out-vmalloc-declarations-from-internalh
+++ a/mm/internal.h
@@ -1092,9 +1092,6 @@ static inline void mlock_new_folio(struc
 static inline bool need_mlock_drain(int cpu) { return false; }
 static inline void mlock_drain_local(void) { }
 static inline void mlock_drain_remote(int cpu) { }
-static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
-{
-}
 #endif /* !CONFIG_MMU */
 
 #define NODE_RECLAIM_NOSCAN	-2
@@ -1209,37 +1206,6 @@ struct migration_target_control {
 size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 			      struct folio *folio, loff_t fpos, size_t size);
 
-/*
- * mm/vmalloc.c
- */
-#ifdef CONFIG_MMU
-void __init vmalloc_init(void);
-int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-	pgprot_t prot, struct page **pages, unsigned int page_shift, gfp_t gfp_mask);
-unsigned int get_vm_area_page_order(struct vm_struct *vm);
-#else
-static inline void vmalloc_init(void)
-{
-}
-
-static inline
-int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-	pgprot_t prot, struct page **pages, unsigned int page_shift, gfp_t gfp_mask)
-{
-	return -EINVAL;
-}
-#endif
-
-void clear_vm_uninitialized_flag(struct vm_struct *vm);
-
-int __must_check __vmap_pages_range_noflush(unsigned long addr,
-			       unsigned long end, pgprot_t prot,
-			       struct page **pages, unsigned int page_shift);
-
-void vunmap_range_noflush(unsigned long start, unsigned long end);
-
-void __vunmap_range_noflush(unsigned long start, unsigned long end);
-
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & VM_SHARED)
@@ -1267,12 +1233,6 @@ int numa_migrate_check(struct folio *fol
 void free_zone_device_folio(struct folio *folio);
 int migrate_device_coherent_folio(struct folio *folio);
 
-struct vm_struct *__get_vm_area_node(unsigned long size,
-				     unsigned long align, unsigned long shift,
-				     unsigned long vm_flags, unsigned long start,
-				     unsigned long end, int node, gfp_t gfp_mask,
-				     const void *caller);
-
 /*
  * mm/gup.c
  */
--- a/mm/kmsan/hooks.c~mm-split-out-vmalloc-declarations-from-internalh
+++ a/mm/kmsan/hooks.c
@@ -21,6 +21,7 @@
 #include <linux/usb.h>
 
 #include "../internal.h"
+#include "../vmalloc.h"
 #include "../slab.h"
 #include "kmsan.h"
 
--- a/mm/kmsan/shadow.c~mm-split-out-vmalloc-declarations-from-internalh
+++ a/mm/kmsan/shadow.c
@@ -17,6 +17,7 @@
 #include <linux/stddef.h>
 
 #include "../internal.h"
+#include "../vmalloc.h"
 #include "kmsan.h"
 
 #define shadow_page_for(page) ((page)->kmsan_shadow)
--- a/mm/mm_init.c~mm-split-out-vmalloc-declarations-from-internalh
+++ a/mm/mm_init.c
@@ -38,6 +38,7 @@
 #include "sparse.h"
 #include "slab.h"
 #include "shuffle.h"
+#include "vmalloc.h"
 
 #include <asm/setup.h>
 
--- a/mm/percpu-vm.c~mm-split-out-vmalloc-declarations-from-internalh
+++ a/mm/percpu-vm.c
@@ -9,6 +9,7 @@
  * This is the default chunk allocator.
  */
 #include "internal.h"
+#include "vmalloc.h"
 
 static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
 				    unsigned int cpu, int page_idx)
--- a/mm/vmalloc.c~mm-split-out-vmalloc-declarations-from-internalh
+++ a/mm/vmalloc.c
@@ -49,6 +49,7 @@
 
 #include "internal.h"
 #include "pgalloc-track.h"
+#include "vmalloc.h"
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 static unsigned int __ro_after_init ioremap_max_page_shift = BITS_PER_LONG - 1;
diff --git a/mm/vmalloc.h a/mm/vmalloc.h
new file mode 100644
--- /dev/null
+++ a/mm/vmalloc.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * mm-internal APIs for vmalloc
+ */
+#ifndef __MM_VMALLOC_H
+#define __MM_VMALLOC_H
+
+#ifdef CONFIG_MMU
+void __init vmalloc_init(void);
+int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages,
+		unsigned int page_shift, gfp_t gfp_mask);
+unsigned int get_vm_area_page_order(struct vm_struct *vm);
+#else
+static inline void vmalloc_init(void) {}
+
+static inline
+int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages,
+		unsigned int page_shift, gfp_t gfp_mask)
+{
+	return -EINVAL;
+}
+
+static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
+{
+}
+#endif
+
+struct vm_struct *__get_vm_area_node(unsigned long size,
+		unsigned long align, unsigned long shift,
+		unsigned long vm_flags, unsigned long start,
+		unsigned long end, int node, gfp_t gfp_mask,
+		const void *caller);
+
+void clear_vm_uninitialized_flag(struct vm_struct *vm);
+
+int __must_check __vmap_pages_range_noflush(unsigned long addr,
+		unsigned long end, pgprot_t prot,
+		struct page **pages, unsigned int page_shift);
+
+void vunmap_range_noflush(unsigned long start, unsigned long end);
+
+void __vunmap_range_noflush(unsigned long start, unsigned long end);
+
+#endif /* __MM_VMALLOC_H */
_

Patches currently in -mm which might be from rppt@kernel.org are

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


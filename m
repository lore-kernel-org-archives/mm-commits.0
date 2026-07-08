Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B863F6C33
	for <mm-commits@vger.kernel.org>; Wed,  8 Jul 2026 21:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783545941; cv=none; b=TZaoTY2gxEF/wo1wSzqp2yU9TJIa9a/3GLviY/h5xkkHnT4MPN6KfUBwxUkhamdGzYmTz3OZrOs0tKoV7Wuv8gL5yPWZO4mnXENjclAsKBPQkof33YFHFvI//S+bEg8TA+jsvIuUU5/QMP2PB8aCG225EJ31uDq8Vd4uFUxzKRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783545941; c=relaxed/simple;
	bh=eOWpdVviRFFsSTajnz/qB537d3VZy1L89puhudBxX58=;
	h=Date:To:From:Subject:Message-Id; b=o+rGR/SG3ZMDJRMqgabeOzW52cByEaLZOPsxPXN46gQ2eb/wsHfudKM8SHQ+8U1Fm/dc3q/EnWwbowXXSUuCtVXOBPNleGt4NJu+d0wiYzp3sfKn3u1mK7ATnH1Qw4RBs3zGQqPSYctfWP5AbOgUPp3T3O+NuxWH9bb9tvPydic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bUi6h+cu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bUi6h+cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFE31F00A3A;
	Wed,  8 Jul 2026 21:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783545939;
	bh=/O5pw9ErdsORFaaSnL82ytIkqDJ8TH1YVfqhplhyM8Y=;
	h=Date:To:From:Subject;
	b=bUi6h+cudhIRutsi0sQ4QM5BbWSJFAnF4FPc/bR/UThzqLutEqR1B2g1TY9B7i1x1
	 NqVKz9eWMtUz51PSYdqvFAg4HRJDYn+RC30VQtuGEGRLu/4ylCT1xSuHYMuSgb0vcO
	 /EMyPYEfLFBzYuekDTRi9aCCqSAD9dpl+RfdcmgY=
Date: Wed, 08 Jul 2026 14:25:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hpa@zytor.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,bp@alien8.de,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bootmem_info-remove-config_have_bootmem_info_node.patch added to mm-new branch
Message-Id: <20260708212539.4BFE31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/bootmem_info: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
has been added to the -mm mm-new branch.  Its filename is
     mm-bootmem_info-remove-config_have_bootmem_info_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bootmem_info-remove-config_have_bootmem_info_node.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/bootmem_info: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
Date: Wed, 08 Jul 2026 16:11:05 +0200

The whole infrastructure is unused now.  Let's remove the config option
along with mm/bootmem_info.  + include/linux/bootmem_info.h.

Link: https://lore.kernel.org/20260708-bootmem_info_part2-v1-10-156ce4986598@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                  |    1 
 include/linux/bootmem_info.h |   89 ---------------------------------
 mm/Kconfig                   |    7 --
 mm/Makefile                  |    1 
 mm/bootmem_info.c            |   72 --------------------------
 5 files changed, 170 deletions(-)

diff --git a/include/linux/bootmem_info.h a/include/linux/bootmem_info.h
deleted file mode 100644
--- a/include/linux/bootmem_info.h
+++ /dev/null
@@ -1,89 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_BOOTMEM_INFO_H
-#define __LINUX_BOOTMEM_INFO_H
-
-#include <linux/mm.h>
-#include <linux/kmemleak.h>
-
-/*
- * Types for free bootmem stored in the low bits of page->private.
- */
-enum bootmem_type {
-	MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE = 1,
-	SECTION_INFO = MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE,
-	MIX_SECTION_INFO,
-	NODE_INFO,
-	MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE = NODE_INFO,
-};
-
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
-void __init register_page_bootmem_info_node(struct pglist_data *pgdat);
-void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
-				  unsigned long nr_pages);
-
-void get_page_bootmem(unsigned long info, struct page *page,
-		enum bootmem_type type);
-void put_page_bootmem(struct page *page);
-
-static inline enum bootmem_type bootmem_type(const struct page *page)
-{
-	return (unsigned long)page->private & 0xf;
-}
-
-static inline unsigned long bootmem_info(const struct page *page)
-{
-	return (unsigned long)page->private >> 4;
-}
-
-/*
- * Any memory allocated via the memblock allocator and not via the
- * buddy will be marked reserved already in the memmap. For those
- * pages, we can call this function to free it to buddy allocator.
- */
-static inline void free_bootmem_page(struct page *page)
-{
-	enum bootmem_type type = bootmem_type(page);
-
-	if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
-		VM_WARN_ON_PAGE(page_ref_count(page) != 2, page);
-		put_page_bootmem(page);
-	} else {
-		free_reserved_page(page);
-	}
-}
-#else
-static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
-{
-}
-
-static inline void register_page_bootmem_memmap(unsigned long section_nr,
-		struct page *map, unsigned long nr_pages)
-{
-}
-
-static inline void put_page_bootmem(struct page *page)
-{
-}
-
-static inline enum bootmem_type bootmem_type(const struct page *page)
-{
-	return SECTION_INFO;
-}
-
-static inline unsigned long bootmem_info(const struct page *page)
-{
-	return 0;
-}
-
-static inline void get_page_bootmem(unsigned long info, struct page *page,
-				    enum bootmem_type type)
-{
-}
-
-static inline void free_bootmem_page(struct page *page)
-{
-	free_reserved_page(page);
-}
-#endif
-
-#endif /* __LINUX_BOOTMEM_INFO_H */
--- a/MAINTAINERS~mm-bootmem_info-remove-config_have_bootmem_info_node
+++ a/MAINTAINERS
@@ -16877,7 +16877,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 F:	Documentation/core-api/boot-time-mm.rst
 F:	include/linux/kho/abi/memblock.h
 F:	include/linux/memblock.h
-F:	mm/bootmem_info.c
 F:	mm/memblock.c
 F:	mm/memtest.c
 F:	mm/mm_init.c
diff --git a/mm/bootmem_info.c a/mm/bootmem_info.c
deleted file mode 100644
--- a/mm/bootmem_info.c
+++ /dev/null
@@ -1,72 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Bootmem core functions.
- *
- * Copyright (c) 2020, Bytedance.
- *
- *     Author: Muchun Song <songmuchun@bytedance.com>
- *
- */
-#include <linux/mm.h>
-#include <linux/compiler.h>
-#include <linux/memblock.h>
-#include <linux/bootmem_info.h>
-#include <linux/memory_hotplug.h>
-#include <linux/kmemleak.h>
-
-void get_page_bootmem(unsigned long info, struct page *page,
-		enum bootmem_type type)
-{
-	BUG_ON(type > 0xf);
-	BUG_ON(info > (ULONG_MAX >> 4));
-	set_page_private(page, info << 4 | type);
-	page_ref_inc(page);
-}
-
-void put_page_bootmem(struct page *page)
-{
-	enum bootmem_type type = bootmem_type(page);
-
-	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
-	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
-
-	if (page_ref_dec_return(page) == 1) {
-		set_page_private(page, 0);
-		free_reserved_page(page);
-	}
-}
-
-static void __init register_page_bootmem_info_section(unsigned long start_pfn)
-{
-	unsigned long section_nr;
-	struct mem_section *ms;
-
-	start_pfn = SECTION_ALIGN_DOWN(start_pfn);
-	section_nr = pfn_to_section_nr(start_pfn);
-	ms = __nr_to_section(section_nr);
-
-	if (!preinited_vmemmap_section(ms))
-		register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
-					     PAGES_PER_SECTION);
-}
-
-void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
-{
-	unsigned long pfn, end_pfn;
-	int node = pgdat->node_id;
-
-	pfn = pgdat->node_start_pfn;
-	end_pfn = pgdat_end_pfn(pgdat);
-
-	/* register section info */
-	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-		/*
-		 * Some platforms can assign the same pfn to multiple nodes - on
-		 * node0 as well as nodeN.  To avoid registering a pfn against
-		 * multiple nodes we check that this pfn does not already
-		 * reside in some other nodes.
-		 */
-		if (pfn_valid(pfn) && (early_pfn_to_nid(pfn) == node))
-			register_page_bootmem_info_section(pfn);
-	}
-}
--- a/mm/Kconfig~mm-bootmem_info-remove-config_have_bootmem_info_node
+++ a/mm/Kconfig
@@ -509,13 +509,6 @@ config EXCLUSIVE_SYSTEM_RAM
 	def_bool y
 	depends on !DEVMEM || STRICT_DEVMEM
 
-#
-# Only be set on architectures that have completely implemented memory hotplug
-# feature. If you are not sure, don't touch it.
-#
-config HAVE_BOOTMEM_INFO_NODE
-	def_bool n
-
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	bool
 
--- a/mm/Makefile~mm-bootmem_info-remove-config_have_bootmem_info_node
+++ a/mm/Makefile
@@ -141,7 +141,6 @@ obj-$(CONFIG_MEMFD_CREATE) += memfd.o
 obj-$(CONFIG_MAPPING_DIRTY_HELPERS) += mapping_dirty_helpers.o
 obj-$(CONFIG_PTDUMP) += ptdump.o
 obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
-obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) += bootmem_info.o
 obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
 obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch
x86-mm-drop-order-parameter-from-free_pagetable.patch
mm-provide-free_reserved_pages-removing-x86-variant.patch
s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch


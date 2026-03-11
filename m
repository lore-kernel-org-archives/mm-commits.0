Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078021FC110
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 16:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773247589; cv=none; b=s8nxtcyfw+rxmBbge86XcfGkKCY8o8OQjaKOv/s6Pn92cmfUmtiQmKd88wYK9URqVXD9SH8R/0NJOyl5PU04rN5UPMjhImsyXo6PwD9Mqo9Tljjn1oA8SMOwq6P5HoOiUzw09n3xwLaAKtDMEMfWFZOolxI0F2urleGj1gY7lI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773247589; c=relaxed/simple;
	bh=PBNQE4dgqHQMQgitAHSkC2bJENNhHQZ/57eMgS50KQo=;
	h=Date:To:From:Subject:Message-Id; b=A428SN5bCayEG14wvC0HpDxPfhFR9FqPE6poNt3vKDIy3BfokLgew+cvTFXTHLmRqg2WopoLU8l7gV7z1CeuCb1c2pdFLz4zv6iTasiDvVR5ghn4OIIOwSoKXxFviIA1ppq2f9q+zbvJGRFGdGGHgkYfVM36NdwevJaSLSQ2DHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZfXRYgtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZfXRYgtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EAAC4CEF7;
	Wed, 11 Mar 2026 16:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773247588;
	bh=PBNQE4dgqHQMQgitAHSkC2bJENNhHQZ/57eMgS50KQo=;
	h=Date:To:From:Subject:From;
	b=ZfXRYgtbH4sz2fsOGh5JUHlW1FMMGu5uCG2bNES8Mnwppi0yzi7/RQ4NjQ3NVC+aU
	 OHL1ox/NMdVCIeHXHBlqtvvwhNPN7Py0PrGYq7pGgVUHKxiVAlNl8bbVtIJUnkfUxW
	 rDDjMZgGId0mLJwbzDHypxe7CDhl7KMAgF5hEs5M=
Date: Wed, 11 Mar 2026 09:46:27 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,epetron@amazon.de,mclapinski@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-deferred-init-of-kho-scratch.patch added to mm-unstable branch
Message-Id: <20260311164628.94EAAC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix deferred init of kho scratch
has been added to the -mm mm-unstable branch.  Its filename is
     kho-fix-deferred-init-of-kho-scratch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-deferred-init-of-kho-scratch.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Michal Clapinski <mclapinski@google.com>
Subject: kho: fix deferred init of kho scratch
Date: Wed, 11 Mar 2026 13:55:38 +0100

Patch series "kho: add support for deferred struct page init", v6.

When CONFIG_DEFERRED_STRUCT_PAGE_INIT (hereinafter DEFERRED) is enabled,
struct page initialization is deferred to parallel kthreads that run later
in the boot process.

Currently, KHO is incompatible with DEFERRED.  This series fixes that
incompatibility.


This patch (of 2):

Currently, if DEFERRED is enabled, kho_release_scratch will initialize the
struct pages and set migratetype of kho scratch.  Unless the whole scratch
fit below first_deferred_pfn, some of that will be overwritten either by
deferred_init_pages or memmap_init_reserved_pages.

To fix it, I initialize kho scratch early and modify every other path to
leave the scratch alone.

In detail:

1. Modify deferred_init_memmap_chunk to not initialize kho scratch,
   since we already did that.  Then, modify deferred_free_pages to not set
   the migratetype.  Also modify reserve_bootmem_region to skip
   initializing kho scratch.

2. Since kho scratch is now not initialized by any other code, we have
   to initialize it ourselves also on cold boot.  On cold boot memblock
   doesn't mark scratch as scratch, so we also have to modify the
   initialization function to not use memblock regions.

Link: https://lkml.kernel.org/r/20260311125539.4123672-1-mclapinski@google.com
Link: https://lkml.kernel.org/r/20260311125539.4123672-2-mclapinski@google.com
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h     |    6 ++++
 include/linux/memblock.h           |    2 -
 kernel/liveupdate/kexec_handover.c |   35 ++++++++++++++++++++++++++-
 mm/memblock.c                      |   22 ----------------
 mm/mm_init.c                       |   17 +++++++++----
 5 files changed, 52 insertions(+), 30 deletions(-)

--- a/include/linux/kexec_handover.h~kho-fix-deferred-init-of-kho-scratch
+++ a/include/linux/kexec_handover.h
@@ -35,6 +35,7 @@ void *kho_restore_vmalloc(const struct k
 int kho_add_subtree(const char *name, void *fdt);
 void kho_remove_subtree(void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
+bool pfn_is_kho_scratch(unsigned long pfn);
 
 void kho_memory_init(void);
 
@@ -109,6 +110,11 @@ static inline int kho_retrieve_subtree(c
 	return -EOPNOTSUPP;
 }
 
+static inline bool pfn_is_kho_scratch(unsigned long pfn)
+{
+	return false;
+}
+
 static inline void kho_memory_init(void) { }
 
 static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
--- a/include/linux/memblock.h~kho-fix-deferred-init-of-kho-scratch
+++ a/include/linux/memblock.h
@@ -614,11 +614,9 @@ static inline void memtest_report_meminf
 #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
-void memmap_init_kho_scratch_pages(void);
 #else
 static inline void memblock_set_kho_scratch_only(void) { }
 static inline void memblock_clear_kho_scratch_only(void) { }
-static inline void memmap_init_kho_scratch_pages(void) {}
 #endif
 
 #endif /* _LINUX_MEMBLOCK_H */
--- a/kernel/liveupdate/kexec_handover.c~kho-fix-deferred-init-of-kho-scratch
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1309,6 +1309,23 @@ int kho_retrieve_subtree(const char *nam
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
+bool pfn_is_kho_scratch(unsigned long pfn)
+{
+	unsigned int i;
+	phys_addr_t scratch_start, scratch_end, phys = __pfn_to_phys(pfn);
+
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		scratch_start = kho_scratch[i].addr;
+		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
+
+		if (scratch_start <= phys && phys < scratch_end)
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(pfn_is_kho_scratch);
+
 static int __init kho_mem_retrieve(const void *fdt)
 {
 	struct kho_radix_tree tree;
@@ -1435,12 +1452,27 @@ err_free_scratch:
 }
 fs_initcall(kho_init);
 
+static void __init kho_init_scratch_pages(void)
+{
+	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
+		return;
+
+	for (int i = 0; i < kho_scratch_cnt; i++) {
+		unsigned long pfn = PFN_DOWN(kho_scratch[i].addr);
+		unsigned long end_pfn = PFN_UP(kho_scratch[i].addr + kho_scratch[i].size);
+		int nid = early_pfn_to_nid(pfn);
+
+		for (; pfn < end_pfn; pfn++)
+			init_deferred_page(pfn, nid);
+	}
+}
+
 static void __init kho_release_scratch(void)
 {
 	phys_addr_t start, end;
 	u64 i;
 
-	memmap_init_kho_scratch_pages();
+	kho_init_scratch_pages();
 
 	/*
 	 * Mark scratch mem as CMA before we return it. That way we
@@ -1469,6 +1501,7 @@ void __init kho_memory_init(void)
 			kho_in.fdt_phys = 0;
 	} else {
 		kho_reserve_scratch();
+		kho_init_scratch_pages();
 	}
 }
 
--- a/mm/memblock.c~kho-fix-deferred-init-of-kho-scratch
+++ a/mm/memblock.c
@@ -959,28 +959,6 @@ __init void memblock_clear_kho_scratch_o
 {
 	kho_scratch_only = false;
 }
-
-__init void memmap_init_kho_scratch_pages(void)
-{
-	phys_addr_t start, end;
-	unsigned long pfn;
-	int nid;
-	u64 i;
-
-	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
-		return;
-
-	/*
-	 * Initialize struct pages for free scratch memory.
-	 * The struct pages for reserved scratch memory will be set up in
-	 * reserve_bootmem_region()
-	 */
-	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
-		for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
-			init_deferred_page(pfn, nid);
-	}
-}
 #endif
 
 /**
--- a/mm/mm_init.c~kho-fix-deferred-init-of-kho-scratch
+++ a/mm/mm_init.c
@@ -797,7 +797,8 @@ void __meminit reserve_bootmem_region(ph
 	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_deferred_page(pfn, nid);
+		if (!pfn_is_kho_scratch(pfn))
+			__init_deferred_page(pfn, nid);
 
 		/*
 		 * no need for atomic set_bit because the struct
@@ -2007,9 +2008,12 @@ static void __init deferred_free_pages(u
 
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
-		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
+		for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
+			if (pfn_is_kho_scratch(page_to_pfn(page + i)))
+				continue;
 			init_pageblock_migratetype(page + i, MIGRATE_MOVABLE,
 					false);
+		}
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -2018,7 +2022,7 @@ static void __init deferred_free_pages(u
 	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
 
 	for (i = 0; i < nr_pages; i++, page++, pfn++) {
-		if (pageblock_aligned(pfn))
+		if (pageblock_aligned(pfn) && !pfn_is_kho_scratch(pfn))
 			init_pageblock_migratetype(page, MIGRATE_MOVABLE,
 					false);
 		__free_pages_core(page, 0, MEMINIT_EARLY);
@@ -2089,9 +2093,11 @@ deferred_init_memmap_chunk(unsigned long
 			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
 			unsigned long chunk_end = min(mo_pfn, epfn);
 
-			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
-			deferred_free_pages(spfn, chunk_end - spfn);
+			// KHO scratch is MAX_ORDER_NR_PAGES aligned.
+			if (!pfn_is_kho_scratch(spfn))
+				deferred_init_pages(zone, spfn, chunk_end);
 
+			deferred_free_pages(spfn, chunk_end - spfn);
 			spfn = chunk_end;
 
 			if (can_resched)
@@ -2099,6 +2105,7 @@ deferred_init_memmap_chunk(unsigned long
 			else
 				touch_nmi_watchdog();
 		}
+		nr_pages += epfn - spfn;
 	}
 
 	return nr_pages;
_

Patches currently in -mm which might be from mclapinski@google.com are

kho-fix-deferred-init-of-kho-scratch.patch


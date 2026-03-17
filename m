Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FBA337B81
	for <mm-commits@vger.kernel.org>; Tue, 17 Mar 2026 17:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773769599; cv=none; b=mUzm813Jd0ynQQNWYre/X8I70e/n+84a8slFmlTKVzkW4jKNz7AhyFngdlOkkRLYC9BOEHe0roW1xaw6BV/KSON+uCYLK6GF18HhmwoOtCKDULjzVgf9OpITuDbbw22oiJxu7GOCebmyMNFfPnio2dpDltPtzqS+13YDbkAtuYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773769599; c=relaxed/simple;
	bh=045VsvZQPtccsqqeVXnkfxy4cQ2eQsPPRA8fq4TmHvs=;
	h=Date:To:From:Subject:Message-Id; b=H1nskNrj0sU2QVEtkY8xFsYSPBM2D7YtRGTEBBL/fX8PvDGN93qku6uQPXSECmLFeAVq52Pff4raFA56wkkWWXHBHGnLArWrCCd1dW5kbjaSDmuoFnzjvpCQv/MF+PFUgkFgDvkWJ2rtRzihe9AQJAU3Pe9UPuQm8dQBtuSnJ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LM1tc7ef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LM1tc7ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3D8C4CEF7;
	Tue, 17 Mar 2026 17:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773769598;
	bh=045VsvZQPtccsqqeVXnkfxy4cQ2eQsPPRA8fq4TmHvs=;
	h=Date:To:From:Subject:From;
	b=LM1tc7ef/jX7NQetid4EChDA8cht6vV4L3P7LPpNrh+EUN5KxIgBp9xLpgF5qmRNd
	 5h/4H/9myTc58RjAKuXS6rya5hfu9Wj4Kc96DRfOrtHhEL/OsHfQNkBHf44q7MAtxb
	 3XIrcIgwsDs6WsBvlblUTJZzH4Tc19lbjj6qeBYU=
Date: Tue, 17 Mar 2026 10:46:38 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,epetron@amazon.de,mclapinski@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-deferred-init-of-kho-scratch.patch added to mm-new branch
Message-Id: <20260317174638.9F3D8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix deferred init of kho scratch
has been added to the -mm mm-new branch.  Its filename is
     kho-fix-deferred-init-of-kho-scratch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-deferred-init-of-kho-scratch.patch

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
From: Michal Clapinski <mclapinski@google.com>
Subject: kho: fix deferred init of kho scratch
Date: Tue, 17 Mar 2026 15:15:33 +0100

Currently, if DEFERRED is enabled, kho_release_scratch will initialize the
struct pages and set migratetype of kho scratch.  Unless the whole scratch
fit below first_deferred_pfn, some of that will be overwritten either by
deferred_init_pages or memmap_init_reserved_pages.

To fix it, I modified kho_release_scratch to only set the migratetype on
already initialized pages.  Then, modified init_pageblock_migratetype to
set the migratetype to CMA if the page is located inside scratch.

Link: https://lkml.kernel.org/r/20260317141534.815634-3-mclapinski@google.com
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h           |    2 --
 kernel/liveupdate/kexec_handover.c |   10 ++++++----
 mm/memblock.c                      |   22 ----------------------
 mm/page_alloc.c                    |    7 +++++++
 4 files changed, 13 insertions(+), 28 deletions(-)

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
@@ -1477,8 +1477,7 @@ static void __init kho_release_scratch(v
 {
 	phys_addr_t start, end;
 	u64 i;
-
-	memmap_init_kho_scratch_pages();
+	int nid;
 
 	/*
 	 * Mark scratch mem as CMA before we return it. That way we
@@ -1486,10 +1485,13 @@ static void __init kho_release_scratch(v
 	 * we can reuse it as scratch memory again later.
 	 */
 	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
+			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
 		ulong start_pfn = pageblock_start_pfn(PFN_DOWN(start));
 		ulong end_pfn = pageblock_align(PFN_UP(end));
 		ulong pfn;
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+		end_pfn = min(end_pfn, NODE_DATA(nid)->first_deferred_pfn);
+#endif
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages)
 			init_pageblock_migratetype(pfn_to_page(pfn),
@@ -1500,8 +1502,8 @@ static void __init kho_release_scratch(v
 void __init kho_memory_init(void)
 {
 	if (kho_in.scratch_phys) {
-		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
+		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 
 		if (kho_mem_retrieve(kho_get_fdt()))
 			kho_in.fdt_phys = 0;
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
--- a/mm/page_alloc.c~kho-fix-deferred-init-of-kho-scratch
+++ a/mm/page_alloc.c
@@ -55,6 +55,7 @@
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/mmzone_lock.h>
+#include <linux/kexec_handover.h>
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
@@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetyp
 		     migratetype < MIGRATE_PCPTYPES))
 		migratetype = MIGRATE_UNMOVABLE;
 
+	/*
+	 * Mark KHO scratch as CMA so no unmovable allocations are made there.
+	 */
+	if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
+		migratetype = MIGRATE_CMA;
+
 	flags = migratetype;
 
 #ifdef CONFIG_MEMORY_ISOLATION
_

Patches currently in -mm which might be from mclapinski@google.com are

kho-make-kho_scratch_overlap-usable-outside-debugging.patch
kho-fix-deferred-init-of-kho-scratch.patch


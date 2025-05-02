Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ED23234
	for <mm-commits@vger.kernel.org>; Fri,  2 May 2025 00:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746146600; cv=none; b=YTnnloNGnidmoV5orgBrG6VNK56gMYqctyJzGMyshlbUhAAETfzL75siXwV9jyPEMC/yKhROtD3/w58mr8xAFFN6CMqWh7oMzaN8hp4JqSbMQhzxsgTuJPPojPCHHo1vqSnqo0ZuUKrI2sKzJZMrk3Rl9xSluJeZN7cbbWnaros=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746146600; c=relaxed/simple;
	bh=uXqSaxAMg90hkrhi3ZZhDjazS61m2Yt/3VpniiPGLQw=;
	h=Date:To:From:Subject:Message-Id; b=fOyBJcnSQ92TT0EsyMp7yBVHlyun4GgnGA64rC8boNEtBmOmoxkb6iWa1mcK4UqSMk2uj5xw4DGyfgywEr8328DhOkHZrR6NSdANfedSO0JjQGJtsNpIOVPO/OEkcUC7EgCMVw2WbLio5k2ii+Jg3H6KYcJVgLTjGhPxTIs5TX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=szD7LMkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="szD7LMkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70B6C4CEE3;
	Fri,  2 May 2025 00:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746146596;
	bh=uXqSaxAMg90hkrhi3ZZhDjazS61m2Yt/3VpniiPGLQw=;
	h=Date:To:From:Subject:From;
	b=szD7LMknl9FNeRakpmhUpRMaCrpzoDefxwLjoYK1iqz7NjPuXcJzuFyIWAHS/rib1
	 2oCCiUU3zZq9udCHzQibZmPmZjVfozU3zzHNyGn5tdUateHcN01D+cukwne8TFbF7K
	 0qDMi5ucwFh85pSuRBEWpnqE0PzCMLv9HEy8oAeM=
Date: Thu, 01 May 2025 17:43:16 -0700
To: mm-commits@vger.kernel.org,changyuanl@google.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-introduce-memmap_init_kho_scratch.patch added to mm-unstable branch
Message-Id: <20250502004316.C70B6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memblock: introduce memmap_init_kho_scratch()
has been added to the -mm mm-unstable branch.  Its filename is
     memblock-introduce-memmap_init_kho_scratch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-introduce-memmap_init_kho_scratch.patch

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
Subject: memblock: introduce memmap_init_kho_scratch()
Date: Thu, 1 May 2025 15:54:10 -0700

With deferred initialization of struct page it will be necessary to
initialize memory map for KHO scratch regions early.

Add memmap_init_kho_scratch() method that will allow such initialization
in upcoming patches.

Link: https://lkml.kernel.org/r/20250501225425.635167-4-changyuanl@google.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    2 ++
 mm/internal.h            |    2 ++
 mm/memblock.c            |   22 ++++++++++++++++++++++
 mm/mm_init.c             |   11 ++++++++---
 4 files changed, 34 insertions(+), 3 deletions(-)

--- a/include/linux/memblock.h~memblock-introduce-memmap_init_kho_scratch
+++ a/include/linux/memblock.h
@@ -635,9 +635,11 @@ static inline void memtest_report_meminf
 #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
+void memmap_init_kho_scratch_pages(void);
 #else
 static inline void memblock_set_kho_scratch_only(void) { }
 static inline void memblock_clear_kho_scratch_only(void) { }
+static inline void memmap_init_kho_scratch_pages(void) {}
 #endif
 
 #endif /* _LINUX_MEMBLOCK_H */
--- a/mm/internal.h~memblock-introduce-memmap_init_kho_scratch
+++ a/mm/internal.h
@@ -1124,6 +1124,8 @@ DECLARE_STATIC_KEY_TRUE(deferred_pages);
 bool __init deferred_grow_zone(struct zone *zone, unsigned int order);
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
+void init_deferred_page(unsigned long pfn, int nid);
+
 enum mminit_level {
 	MMINIT_WARNING,
 	MMINIT_VERIFY,
--- a/mm/memblock.c~memblock-introduce-memmap_init_kho_scratch
+++ a/mm/memblock.c
@@ -946,6 +946,28 @@ __init void memblock_clear_kho_scratch_o
 {
 	kho_scratch_only = false;
 }
+
+__init void memmap_init_kho_scratch_pages(void)
+{
+	phys_addr_t start, end;
+	unsigned long pfn;
+	int nid;
+	u64 i;
+
+	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
+		return;
+
+	/*
+	 * Initialize struct pages for free scratch memory.
+	 * The struct pages for reserved scratch memory will be set up in
+	 * reserve_bootmem_region()
+	 */
+	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
+			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
+		for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
+			init_deferred_page(pfn, nid);
+	}
+}
 #endif
 
 /**
--- a/mm/mm_init.c~memblock-introduce-memmap_init_kho_scratch
+++ a/mm/mm_init.c
@@ -743,7 +743,7 @@ defer_init(int nid, unsigned long pfn, u
 	return false;
 }
 
-static void __meminit init_deferred_page(unsigned long pfn, int nid)
+static void __meminit __init_deferred_page(unsigned long pfn, int nid)
 {
 	if (early_page_initialised(pfn, nid))
 		return;
@@ -763,11 +763,16 @@ static inline bool defer_init(int nid, u
 	return false;
 }
 
-static inline void init_deferred_page(unsigned long pfn, int nid)
+static inline void __init_deferred_page(unsigned long pfn, int nid)
 {
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
+void __meminit init_deferred_page(unsigned long pfn, int nid)
+{
+	__init_deferred_page(pfn, nid);
+}
+
 /*
  * Initialised pages do not have PageReserved set. This function is
  * called for each range allocated by the bootmem allocator and
@@ -784,7 +789,7 @@ void __meminit reserve_bootmem_region(ph
 		if (pfn_valid(start_pfn)) {
 			struct page *page = pfn_to_page(start_pfn);
 
-			init_deferred_page(start_pfn, nid);
+			__init_deferred_page(start_pfn, nid);
 
 			/*
 			 * no need for atomic set_bit because the struct
_

Patches currently in -mm which might be from rppt@kernel.org are

memblock-add-memblock_rsrv_kern-flag.patch
memblock-introduce-memmap_init_kho_scratch.patch
kexec-enable-kho-support-for-memory-preservation.patch
x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch
documentation-kho-add-memblock-bindings.patch
execmem-enforce-allocation-size-aligment-to-page_size.patch


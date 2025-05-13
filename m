Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5331EDA1E
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119252; cv=none; b=DomDL31AZ1j7pvvweS9u3lAuBP8QQP2SbJDg+vOLATdf6cnq5p6TB2yDGd8IWF5McH9ecfvKRPBNS8vCcIQGy97C1Ga6hm18iFZy4f/lJadviHF/UyZn/BZKQqxASfb0auZB7jq3h7dlOOxrNcee7nsTTCeHWcreQ1ro0xYUUxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119252; c=relaxed/simple;
	bh=XRD+tl2bJlLv/jSzApZNJCtjm4PkEa4Y/Glk7x5Lgs4=;
	h=Date:To:From:Subject:Message-Id; b=R/hx155p3p/++ReMmGqfxaWMCiqfZElkty+W8tIpsaIPR3EnrPX/m9ybwS2Vek890s/AKzhxorPnvj8zqbcCRi72GxrWu2G0bK67/Zg8k29PJOAxKEzbaHt5iU2nwDNETJqf/YvIgd6wj5QF+e2em58aCW7t7Y/8fUJ3wf3h068=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jtdvr+Pv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jtdvr+Pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0A2C4CEE4;
	Tue, 13 May 2025 06:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119252;
	bh=XRD+tl2bJlLv/jSzApZNJCtjm4PkEa4Y/Glk7x5Lgs4=;
	h=Date:To:From:Subject:From;
	b=jtdvr+Pv/tVXza7qHMDWYztQR1t4N5i/QSXxS2AOwgXjhjTRaia9hCI5faQTgmSm3
	 iqQITBZ9dszY4taDbLlBFvknDxFMexrKohcWOL3HngFXKHOV090JfvO/XcMAU4JJX5
	 ZlZqQJ3geojibQ1j6UCIl8qCeS2D453yW3S6lCXs=
Date: Mon, 12 May 2025 23:54:11 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rostedt@goodmis.org,robh@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,jgg@nvidia.com,hpa@zytor.com,graf@amazon.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,changyuanl@google.com,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memblock-introduce-memmap_init_kho_scratch.patch removed from -mm tree
Message-Id: <20250513065412.3E0A2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memblock: introduce memmap_init_kho_scratch()
has been removed from the -mm tree.  Its filename was
     memblock-introduce-memmap_init_kho_scratch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: memblock: introduce memmap_init_kho_scratch()
Date: Fri, 9 May 2025 00:46:21 -0700

With deferred initialization of struct page it will be necessary to
initialize memory map for KHO scratch regions early.

Add memmap_init_kho_scratch() method that will allow such initialization
in upcoming patches.

Link: https://lkml.kernel.org/r/20250509074635.3187114-4-changyuanl@google.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
Cc: Jason Gunthorpe <jgg@nvidia.com>
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
@@ -1119,6 +1119,8 @@ DECLARE_STATIC_KEY_TRUE(deferred_pages);
 bool __init deferred_grow_zone(struct zone *zone, unsigned int order);
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
+void init_deferred_page(unsigned long pfn, int nid);
+
 enum mminit_level {
 	MMINIT_WARNING,
 	MMINIT_VERIFY,
--- a/mm/memblock.c~memblock-introduce-memmap_init_kho_scratch
+++ a/mm/memblock.c
@@ -953,6 +953,28 @@ __init void memblock_clear_kho_scratch_o
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



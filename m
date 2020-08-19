Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E6EC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CEF22173E
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597865308;
	bh=fcJJCLC+7byZR/eIiFMytCFHmQ2Tbxqyw5FydiGoCls=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mDD2bq50gJP4ZkLhp3+K5ZZleUdEccj1llxfXbiryBJjh4gomffL5U/fuPIuFP2YP
	 0iw0m8VuDWyLt+9WB9etjy+B1fxomG7MAWL7wdIrkajYI4IEt9TeTG/xo4KIdwqOvm
	 lthW5Ug5QZzIz2nNykc9V3x6IOLpGCi620KcvW18=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgHST21 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 15:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgHST20 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 15:28:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ACAD214F1;
        Wed, 19 Aug 2020 19:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597865304;
        bh=fcJJCLC+7byZR/eIiFMytCFHmQ2Tbxqyw5FydiGoCls=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OGNktaNdDcC15OEczlDl1zaP/Amttp59B4b+w0bCN5aoH5X8Q+nBSkPi0PnOsyOAH
         1lvwQ0rKnNXagi2RaJ248+Z86X/d77i5LW8G7qZCYmGe8u5a8n3YjltZEtXcbzC3yi
         H5pCbArBOH+s+lmlp9yqvrkyaTzsLjihfX3GbnIA=
Date:   Wed, 19 Aug 2020 12:28:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     benh@kernel.crashing.org, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dave.hansen@linux.intel.com,
        dja@axtens.net, hbathini@linux.ibm.com, hch@lst.de,
        jcmvbkbc@gmail.com, Jonathan.Cameron@huawei.com, kernel@esmil.dk,
        linux@armlinux.org.uk, luto@kernel.org, m.szyprowski@samsung.com,
        miguel.ojeda.sandonis@gmail.com, mingo@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, peterz@infradead.org, rppt@linux.ibm.com,
        shorne@gmail.com, tglx@linutronix.de, tsbogend@alpha.franken.de,
        will@kernel.org, ysato@users.sourceforge.jp
Subject:  +
 memblock-use-separate-iterators-for-memory-and-reserved-regions.patch added
 to -mm tree
Message-ID: <20200819192822.NW4S2ZFsE%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: use separate iterators for memory and reserved regions
has been added to the -mm tree.  Its filename is
     memblock-use-separate-iterators-for-memory-and-reserved-regions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memblock-use-separate-iterators-for-memory-and-reserved-regions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memblock-use-separate-iterators-for-memory-and-reserved-regions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memblock: use separate iterators for memory and reserved regions

for_each_memblock() is used to iterate over memblock.memory in a few
places that use data from memblock_region rather than the memory ranges.

Introduce separate for_each_mem_region() and
for_each_reserved_mem_region() to improve encapsulation of memblock
internals from its users.

Link: https://lkml.kernel.org/r/20200818151634.14343-18-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>			[x86]
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>	[MIPS]
Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>	[.clang-format]
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Emil Renner Berthing <kernel@esmil.dk>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .clang-format                  |    3 ++-
 arch/arm64/kernel/setup.c      |    2 +-
 arch/arm64/mm/numa.c           |    2 +-
 arch/mips/netlogic/xlp/setup.c |    2 +-
 arch/riscv/mm/init.c           |    2 +-
 arch/x86/mm/numa.c             |    2 +-
 include/linux/memblock.h       |   19 ++++++++++++++++---
 mm/memblock.c                  |    4 ++--
 mm/page_alloc.c                |    8 ++++----
 9 files changed, 29 insertions(+), 15 deletions(-)

--- a/arch/arm64/kernel/setup.c~memblock-use-separate-iterators-for-memory-and-reserved-regions
+++ a/arch/arm64/kernel/setup.c
@@ -217,7 +217,7 @@ static void __init request_standard_reso
 	if (!standard_resources)
 		panic("%s: Failed to allocate %zu bytes\n", __func__, res_size);
 
-	for_each_memblock(memory, region) {
+	for_each_mem_region(region) {
 		res = &standard_resources[i++];
 		if (memblock_is_nomap(region)) {
 			res->name  = "reserved";
--- a/arch/arm64/mm/numa.c~memblock-use-separate-iterators-for-memory-and-reserved-regions
+++ a/arch/arm64/mm/numa.c
@@ -350,7 +350,7 @@ static int __init numa_register_nodes(vo
 	struct memblock_region *mblk;
 
 	/* Check that valid nid is set to memblks */
-	for_each_memblock(memory, mblk) {
+	for_each_mem_region(mblk) {
 		int mblk_nid = memblock_get_region_node(mblk);
 
 		if (mblk_nid == NUMA_NO_NODE || mblk_nid >= MAX_NUMNODES) {
--- a/arch/mips/netlogic/xlp/setup.c~memblock-use-separate-iterators-for-memory-and-reserved-regions
+++ a/arch/mips/netlogic/xlp/setup.c
@@ -70,7 +70,7 @@ static void nlm_fixup_mem(void)
 	const int pref_backup = 512;
 	struct memblock_region *mem;
 
-	for_each_memblock(memory, mem) {
+	for_each_mem_region(mem) {
 		memblock_remove(mem->base + mem->size - pref_backup,
 			pref_backup);
 	}
--- a/arch/riscv/mm/init.c~memblock-use-separate-iterators-for-memory-and-reserved-regions
+++ a/arch/riscv/mm/init.c
@@ -531,7 +531,7 @@ static void __init resource_init(void)
 {
 	struct memblock_region *region;
 
-	for_each_memblock(memory, region) {
+	for_each_mem_region(region) {
 		struct resource *res;
 
 		res = memblock_alloc(sizeof(struct resource), SMP_CACHE_BYTES);
--- a/arch/x86/mm/numa.c~memblock-use-separate-iterators-for-memory-and-reserved-regions
+++ a/arch/x86/mm/numa.c
@@ -516,7 +516,7 @@ static void __init numa_clear_kernel_nod
 	 *   memory ranges, because quirks such as trim_snb_memory()
 	 *   reserve specific pages for Sandy Bridge graphics. ]
 	 */
-	for_each_memblock(reserved, mb_region) {
+	for_each_reserved_mem_region(mb_region) {
 		int nid = memblock_get_region_node(mb_region);
 
 		if (nid != MAX_NUMNODES)
--- a/.clang-format~memblock-use-separate-iterators-for-memory-and-reserved-regions
+++ a/.clang-format
@@ -201,7 +201,7 @@ ForEachMacros:
   - 'for_each_matching_node'
   - 'for_each_matching_node_and_match'
   - 'for_each_member'
-  - 'for_each_memblock'
+  - 'for_each_mem_region'
   - 'for_each_memblock_type'
   - 'for_each_memcg_cache_index'
   - 'for_each_mem_pfn_range'
@@ -268,6 +268,7 @@ ForEachMacros:
   - 'for_each_property_of_node'
   - 'for_each_registered_fb'
   - 'for_each_reserved_mem_range'
+  - 'for_each_reserved_mem_region'
   - 'for_each_rtd_codec_dais'
   - 'for_each_rtd_codec_dais_rollback'
   - 'for_each_rtd_components'
--- a/include/linux/memblock.h~memblock-use-separate-iterators-for-memory-and-reserved-regions
+++ a/include/linux/memblock.h
@@ -553,9 +553,22 @@ static inline unsigned long memblock_reg
 	return PFN_UP(reg->base + reg->size);
 }
 
-#define for_each_memblock(memblock_type, region)					\
-	for (region = memblock.memblock_type.regions;					\
-	     region < (memblock.memblock_type.regions + memblock.memblock_type.cnt);	\
+/**
+ * for_each_mem_region - itereate over memory regions
+ * @region: loop variable
+ */
+#define for_each_mem_region(region)					\
+	for (region = memblock.memory.regions;				\
+	     region < (memblock.memory.regions + memblock.memory.cnt);	\
+	     region++)
+
+/**
+ * for_each_reserved_mem_region - itereate over reserved memory regions
+ * @region: loop variable
+ */
+#define for_each_reserved_mem_region(region)				\
+	for (region = memblock.reserved.regions;			\
+	     region < (memblock.reserved.regions + memblock.reserved.cnt); \
 	     region++)
 
 extern void *alloc_large_system_hash(const char *tablename,
--- a/mm/memblock.c~memblock-use-separate-iterators-for-memory-and-reserved-regions
+++ a/mm/memblock.c
@@ -1667,7 +1667,7 @@ static phys_addr_t __init_memblock __fin
 	 * the memory memblock regions, if the @limit exceeds the total size
 	 * of those regions, max_addr will keep original value PHYS_ADDR_MAX
 	 */
-	for_each_memblock(memory, r) {
+	for_each_mem_region(r) {
 		if (limit <= r->size) {
 			max_addr = r->base + limit;
 			break;
@@ -1837,7 +1837,7 @@ void __init_memblock memblock_trim_memor
 	phys_addr_t start, end, orig_start, orig_end;
 	struct memblock_region *r;
 
-	for_each_memblock(memory, r) {
+	for_each_mem_region(r) {
 		orig_start = r->base;
 		orig_end = r->base + r->size;
 		start = round_up(orig_start, align);
--- a/mm/page_alloc.c~memblock-use-separate-iterators-for-memory-and-reserved-regions
+++ a/mm/page_alloc.c
@@ -5955,7 +5955,7 @@ overlap_memmap_init(unsigned long zone,
 
 	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
 		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
-			for_each_memblock(memory, r) {
+			for_each_mem_region(r) {
 				if (*pfn < memblock_region_memory_end_pfn(r))
 					break;
 			}
@@ -6540,7 +6540,7 @@ static unsigned long __init zone_absent_
 		unsigned long start_pfn, end_pfn;
 		struct memblock_region *r;
 
-		for_each_memblock(memory, r) {
+		for_each_mem_region(r) {
 			start_pfn = clamp(memblock_region_memory_base_pfn(r),
 					  zone_start_pfn, zone_end_pfn);
 			end_pfn = clamp(memblock_region_memory_end_pfn(r),
@@ -7134,7 +7134,7 @@ static void __init find_zone_movable_pfn
 	 * options.
 	 */
 	if (movable_node_is_enabled()) {
-		for_each_memblock(memory, r) {
+		for_each_mem_region(r) {
 			if (!memblock_is_hotpluggable(r))
 				continue;
 
@@ -7155,7 +7155,7 @@ static void __init find_zone_movable_pfn
 	if (mirrored_kernelcore) {
 		bool mem_below_4gb_not_mirrored = false;
 
-		for_each_memblock(memory, r) {
+		for_each_mem_region(r) {
 			if (memblock_is_mirror(r))
 				continue;
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

kvm-ppc-book3s-hv-simplify-kvm_cma_reserve.patch
dma-contiguous-simplify-cma_early_percent_memory.patch
arm-xtensa-simplify-initialization-of-high-memory-pages.patch
arm64-numa-simplify-dummy_numa_init.patch
h8300-nds32-openrisc-simplify-detection-of-memory-extents.patch
riscv-drop-unneeded-node-initialization.patch
mircoblaze-drop-unneeded-numa-and-sparsemem-initializations.patch
memblock-make-for_each_memblock_type-iterator-private.patch
memblock-make-memblock_debug-and-related-functionality-private.patch
memblock-reduce-number-of-parameters-in-for_each_mem_range.patch
arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range.patch
x86-setup-simplify-initrd-relocation-and-reservation.patch
x86-setup-simplify-reserve_crashkernel.patch
memblock-remove-unused-memblock_mem_size.patch
memblock-implement-for_each_reserved_mem_region-using-__next_mem_region.patch
memblock-use-separate-iterators-for-memory-and-reserved-regions.patch


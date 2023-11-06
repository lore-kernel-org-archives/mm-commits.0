Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9D5C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 18:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjKFSfB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 13:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbjKFSfA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 13:35:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1864793
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 10:34:57 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB8BC433C7;
        Mon,  6 Nov 2023 18:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699295696;
        bh=1hYoLcp5yrQ/HDubalLtF4LkC9RM+NE64wLi3cy23y8=;
        h=Date:To:From:Subject:From;
        b=DBn8gsHCJ7V1hDv6CGaTSvIEEmn000xTjLIquHz/8xjYgItxiOeuM78+K13X+zhzZ
         TFAYLFEBzl2sIRbCmH0ALdXL1Qgh9QSqXsrUEh6gBWxUyHdHwR10IDRlgBFF0P3VTj
         S50SmSLnLrwUt/7eKgEaheQS5+7IsoYPSfhL6K78=
Date:   Mon, 06 Nov 2023 10:34:56 -0800
To:     mm-commits@vger.kernel.org, zhoubinbin@loongson.cn,
        tglx@linutronix.de, rppt@kernel.org, peterz@infradead.org,
        mingo@redhat.com, maobibo@loongson.cn, luto@kernel.org,
        kernel@xen0n.name, hpa@zytor.com, dave.hansen@linux.intel.com,
        chenhuacai@kernel.org, chenfeiyang@loongson.cn, bp@alien8.de,
        zhiguangni01@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + numa-optimize-detection-of-memory-with-no-node-id-assigned-by-firmware.patch added to mm-unstable branch
Message-Id: <20231106183456.9EB8BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: NUMA: optimize detection of memory with no node id assigned by firmware
has been added to the -mm mm-unstable branch.  Its filename is
     numa-optimize-detection-of-memory-with-no-node-id-assigned-by-firmware.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/numa-optimize-detection-of-memory-with-no-node-id-assigned-by-firmware.patch

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
From: Liam Ni <zhiguangni01@gmail.com>
Subject: NUMA: optimize detection of memory with no node id assigned by firmware
Date: Thu, 26 Oct 2023 10:03:29 +0800

Sanity check that makes sure the nodes cover all memory loops over
numa_meminfo to count the pages that have node id assigned by the
firmware, then loops again over memblock.memory to find the total amount
of memory and in the end checks that the difference between the total
memory and memory that covered by nodes is less than some threshold. 
Worse, the loop over numa_meminfo calls __absent_pages_in_range() that
also partially traverses memblock.memory.

It's much simpler and more efficient to have a single traversal of
memblock.memory that verifies that amount of memory not covered by nodes
is less than a threshold.

Introduce memblock_validate_numa_coverage() that does exactly that and use
it instead of numa_meminfo_cover_memory().

Link: https://lkml.kernel.org/r/20231026020329.327329-1-zhiguangni01@gmail.com
Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Binbin Zhou <zhoubinbin@loongson.cn>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Feiyang Chen <chenfeiyang@loongson.cn>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/kernel/numa.c |   28 ---------------------------
 arch/x86/mm/numa.c           |   34 +--------------------------------
 include/linux/memblock.h     |    1 
 mm/memblock.c                |   34 +++++++++++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 59 deletions(-)

--- a/arch/loongarch/kernel/numa.c~numa-optimize-detection-of-memory-with-no-node-id-assigned-by-firmware
+++ a/arch/loongarch/kernel/numa.c
@@ -226,32 +226,6 @@ static void __init node_mem_init(unsigne
 
 #ifdef CONFIG_ACPI_NUMA
 
-/*
- * Sanity check to catch more bad NUMA configurations (they are amazingly
- * common).  Make sure the nodes cover all memory.
- */
-static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
-{
-	int i;
-	u64 numaram, biosram;
-
-	numaram = 0;
-	for (i = 0; i < mi->nr_blks; i++) {
-		u64 s = mi->blk[i].start >> PAGE_SHIFT;
-		u64 e = mi->blk[i].end >> PAGE_SHIFT;
-
-		numaram += e - s;
-		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
-		if ((s64)numaram < 0)
-			numaram = 0;
-	}
-	max_pfn = max_low_pfn;
-	biosram = max_pfn - absent_pages_in_range(0, max_pfn);
-
-	BUG_ON((s64)(biosram - numaram) >= (1 << (20 - PAGE_SHIFT)));
-	return true;
-}
-
 static void __init add_node_intersection(u32 node, u64 start, u64 size, u32 type)
 {
 	static unsigned long num_physpages;
@@ -396,7 +370,7 @@ int __init init_numa_memory(void)
 		return -EINVAL;
 
 	init_node_memblock();
-	if (numa_meminfo_cover_memory(&numa_meminfo) == false)
+	if (!memblock_validate_numa_coverage(SZ_1M))
 		return -EINVAL;
 
 	for_each_node_mask(node, node_possible_map) {
--- a/arch/x86/mm/numa.c~numa-optimize-detection-of-memory-with-no-node-id-assigned-by-firmware
+++ a/arch/x86/mm/numa.c
@@ -450,37 +450,6 @@ int __node_distance(int from, int to)
 EXPORT_SYMBOL(__node_distance);
 
 /*
- * Sanity check to catch more bad NUMA configurations (they are amazingly
- * common).  Make sure the nodes cover all memory.
- */
-static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
-{
-	u64 numaram, e820ram;
-	int i;
-
-	numaram = 0;
-	for (i = 0; i < mi->nr_blks; i++) {
-		u64 s = mi->blk[i].start >> PAGE_SHIFT;
-		u64 e = mi->blk[i].end >> PAGE_SHIFT;
-		numaram += e - s;
-		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
-		if ((s64)numaram < 0)
-			numaram = 0;
-	}
-
-	e820ram = max_pfn - absent_pages_in_range(0, max_pfn);
-
-	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
-	if ((s64)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
-		printk(KERN_ERR "NUMA: nodes only cover %LuMB of your %LuMB e820 RAM. Not used.\n",
-		       (numaram << PAGE_SHIFT) >> 20,
-		       (e820ram << PAGE_SHIFT) >> 20);
-		return false;
-	}
-	return true;
-}
-
-/*
  * Mark all currently memblock-reserved physical memory (which covers the
  * kernel's own memory ranges) as hot-unswappable.
  */
@@ -585,7 +554,8 @@ static int __init numa_register_memblks(
 			return -EINVAL;
 		}
 	}
-	if (!numa_meminfo_cover_memory(mi))
+
+	if (!memblock_validate_numa_coverage(SZ_1M))
 		return -EINVAL;
 
 	/* Finally register nodes. */
--- a/include/linux/memblock.h~numa-optimize-detection-of-memory-with-no-node-id-assigned-by-firmware
+++ a/include/linux/memblock.h
@@ -123,6 +123,7 @@ int memblock_physmem_add(phys_addr_t bas
 void memblock_trim_memory(phys_addr_t align);
 bool memblock_overlaps_region(struct memblock_type *type,
 			      phys_addr_t base, phys_addr_t size);
+bool memblock_validate_numa_coverage(unsigned long threshold_bytes);
 int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
 int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
 int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
--- a/mm/memblock.c~numa-optimize-detection-of-memory-with-no-node-id-assigned-by-firmware
+++ a/mm/memblock.c
@@ -735,6 +735,40 @@ int __init_memblock memblock_add(phys_ad
 }
 
 /**
+ * memblock_validate_numa_coverage - check if amount of memory with
+ * no node ID assigned is less than a threshold
+ * @threshold_bytes: maximal number of pages that can have unassigned node
+ * ID (in bytes).
+ *
+ * A buggy firmware may report memory that does not belong to any node.
+ * Check if amount of such memory is below @threshold_bytes.
+ *
+ * Return: true on success, false on failure.
+ */
+bool __init_memblock memblock_validate_numa_coverage(unsigned long threshold_bytes)
+{
+	unsigned long nr_pages = 0;
+	unsigned long start_pfn, end_pfn, mem_size_mb;
+	int nid, i;
+
+	/* calculate lose page */
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		if (nid == NUMA_NO_NODE)
+			nr_pages += end_pfn - start_pfn;
+	}
+
+	if ((nr_pages << PAGE_SHIFT) >= threshold_bytes) {
+		mem_size_mb = memblock_phys_mem_size() >> 20;
+		pr_err("NUMA: no nodes coverage for %luMB of %luMB RAM\n",
+		       (nr_pages << PAGE_SHIFT) >> 20, mem_size_mb);
+		return false;
+	}
+
+	return true;
+}
+
+
+/**
  * memblock_isolate_range - isolate given range into disjoint memblocks
  * @type: memblock type to isolate range for
  * @base: base of range to isolate
_

Patches currently in -mm which might be from zhiguangni01@gmail.com are

numa-optimize-detection-of-memory-with-no-node-id-assigned-by-firmware.patch
numa-improve-the-efficiency-of-calculating-pages-loss.patch


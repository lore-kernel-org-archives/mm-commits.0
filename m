Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2915CD68E0
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 00:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379279AbjJJAxP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 20:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379217AbjJJAxP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 20:53:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CC89E
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 17:53:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E1CC433C7;
        Tue, 10 Oct 2023 00:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696899191;
        bh=C4zRzsHvYSp3vQzC4bR6y2gFN89W1qeHG/Lm2UmSKuA=;
        h=Date:To:From:Subject:From;
        b=BzDugspsHKG498qiTtialzIVW1losX5uLj9usEBERMHPwpl+iteAqCzhP76XFWEXD
         Su3DSDzFgILkv4KUeln/HlV1iXvuxEOiW6r5TCsJ7rnDfEpbUUMCGYgId/8u3nI4Kr
         AbgkxU8iS7rhfYEGj5LmhlEvjMjsvi9aedvGTbfE=
Date:   Mon, 09 Oct 2023 17:52:59 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, rppt@kernel.org,
        peterz@infradead.org, mingo@redhat.com, luto@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, bp@alien8.de,
        zhiguangni01@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + numa-improve-the-efficiency-of-calculating-pages-loss.patch added to mm-unstable branch
Message-Id: <20231010005309.79E1CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: NUMA: improve the efficiency of calculating pages loss
has been added to the -mm mm-unstable branch.  Its filename is
     numa-improve-the-efficiency-of-calculating-pages-loss.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/numa-improve-the-efficiency-of-calculating-pages-loss.patch

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
Subject: NUMA: improve the efficiency of calculating pages loss
Date: Mon, 11 Sep 2023 21:38:52 +0800

Optimize the way of calculating missing pages.

In the previous implementation, We calculate missing pages as follows:

1.  calculate numaram by traverse all the numa_meminfo's and for each
   of them traverse all the regions in memblock.memory to prepare for
   counting missing pages.

2. Traverse all the regions in memblock.memory again to get e820ram.

3. the missing page is (e820ram - numaram )

But it's enough to count memory in `memblock.memory' that doesn't have the
node assigned.

Link: https://lkml.kernel.org/r/20230911133852.2545-1-zhiguangni01@gmail.com
Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c       |   33 +--------------------------------
 include/linux/memblock.h |    1 +
 mm/memblock.c            |   21 +++++++++++++++++++++
 3 files changed, 23 insertions(+), 32 deletions(-)

--- a/arch/x86/mm/numa.c~numa-improve-the-efficiency-of-calculating-pages-loss
+++ a/arch/x86/mm/numa.c
@@ -448,37 +448,6 @@ int __node_distance(int from, int to)
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
@@ -583,7 +552,7 @@ static int __init numa_register_memblks(
 			return -EINVAL;
 		}
 	}
-	if (!numa_meminfo_cover_memory(mi))
+	if (!memblock_validate_numa_coverage(SZ_1M))
 		return -EINVAL;
 
 	/* Finally register nodes. */
--- a/include/linux/memblock.h~numa-improve-the-efficiency-of-calculating-pages-loss
+++ a/include/linux/memblock.h
@@ -123,6 +123,7 @@ int memblock_physmem_add(phys_addr_t bas
 void memblock_trim_memory(phys_addr_t align);
 bool memblock_overlaps_region(struct memblock_type *type,
 			      phys_addr_t base, phys_addr_t size);
+bool memblock_validate_numa_coverage(const u64 limit);
 int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
 int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
 int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
--- a/mm/memblock.c~numa-improve-the-efficiency-of-calculating-pages-loss
+++ a/mm/memblock.c
@@ -734,6 +734,27 @@ int __init_memblock memblock_add(phys_ad
 	return memblock_add_range(&memblock.memory, base, size, MAX_NUMNODES, 0);
 }
 
+bool __init_memblock memblock_validate_numa_coverage(const u64 limit)
+{
+	unsigned long lose_pg = 0;
+	unsigned long start_pfn, end_pfn;
+	int nid, i;
+
+	/* calculate lose page */
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		if (nid == NUMA_NO_NODE)
+			lose_pg += end_pfn - start_pfn;
+	}
+
+	if (lose_pg >= limit) {
+		pr_err("NUMA: We lost %ld pages.\n", lose_pg);
+		return false;
+	}
+
+	return true;
+}
+
+
 /**
  * memblock_isolate_range - isolate given range into disjoint memblocks
  * @type: memblock type to isolate range for
_

Patches currently in -mm which might be from zhiguangni01@gmail.com are

numa-improve-the-efficiency-of-calculating-pages-loss.patch


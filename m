Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6646DC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 22:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C29320674
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 22:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594419609;
	bh=OshPab3sJBsATPKhCE4/VBeDi4ccq0ZtOhFO6/wG8pU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0jA2cZA4050tmnL3VR4XiybAta3RoYa6NuX3JptJkJXyQYcpyDU8tXlLIAnXCUxmT
	 54CUEgjXyFQDaFnkY3fNsIAVPaAKo5tYjOyhjQVIakvk+r+9rbbMQye7A51uTKnb4c
	 u9Z8wCv0aF1kUFR1laT8+l206doa4ZXIemq6PJSs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgGJWUI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 18:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgGJWUI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 18:20:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE2EA2068F;
        Fri, 10 Jul 2020 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594419608;
        bh=OshPab3sJBsATPKhCE4/VBeDi4ccq0ZtOhFO6/wG8pU=;
        h=Date:From:To:Subject:From;
        b=bbqPVQghipbUsGIsHCF19g3eObyzFiK2DJt7/WyFsSWFZzxLj/ngevL/7GUE2L+tu
         egRZBc0/dtd01L/90OR7zA98JDdJNMzyuQfwV9brYrwSZpOxHBsSK/8l0+sUh7KAVB
         5ZdqGdgqXfJ6HigDz7b3qwiUI3NEY9EaXgjK779I=
Date:   Fri, 10 Jul 2020 15:20:07 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, bp@alien8.de, catalin.marinas@arm.com,
        guro@fb.com, hpa@zytor.com, jonathan.cameron@huawei.com,
        mike.kravetz@oracle.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        song.bao.hua@hisilicon.com, tglx@linutronix.de, will@kernel.org
Subject:  + mm-hugetlb-split-hugetlb_cma-in-nodes-with-memory.patch
 added to -mm tree
Message-ID: <20200710222007.o8QGtEAaG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: split hugetlb_cma in nodes with memory
has been added to the -mm tree.  Its filename is
     mm-hugetlb-split-hugetlb_cma-in-nodes-with-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-split-hugetlb_cma-in-nodes-with-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-split-hugetlb_cma-in-nodes-with-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/hugetlb: split hugetlb_cma in nodes with memory

Online nodes are not necessarily memory containing nodes.  Splitting
huge_cma in online nodes can lead to inconsistent hugetlb_cma size with
user setting.  For example, for one system with 4 numa nodes and only one
of them has memory, if users set hugetlb_cma to 4GB, it will split into
four 1GB.  So only the node with memory will get 1GB CMA.  All other three
nodes get nothing.  That means the whole system gets only 1GB CMA while
users ask for 4GB.

Thus, it is more sensible to split hugetlb_cma in nodes with memory.  For
the above case, the only node with memory will reserve 4GB cma which is
same with user setting in bootargs.  In order to split cma in nodes with
memory, hugetlb_cma_reserve() should scan over those nodes with N_MEMORY
state rather than N_ONLINE state.  That means the function should be
called only after arch code has finished setting the N_MEMORY state of
nodes.

The problem is always there if N_ONLINE != N_MEMORY.  It is a general
problem to all platforms.  But there is some trivial difference among
different architectures.  For example, for ARM64, before
hugetlb_cma_reserve() is called, all nodes have got N_ONLINE state.  So
hugetlb will get inconsistent cma size when some online nodes have no
memory.  For x86 case, the problem is hidden because X86 happens to just
set N_ONLINE on the nodes with memory when hugetlb_cma_reserve() is
called.

Anyway, this patch moves to scan N_MEMORY in hugetlb_cma_reserve() and
lets both x86 and ARM64 call the function after N_MEMORY state is ready. 
It also documents the requirement in the definition of
hugetlb_cma_reserve().

Link: http://lkml.kernel.org/r/20200710120950.37716-1-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/init.c    |   19 ++++++++++---------
 arch/x86/kernel/setup.c |   12 +++++++++---
 mm/hugetlb.c            |   11 +++++++++--
 3 files changed, 28 insertions(+), 14 deletions(-)

--- a/arch/arm64/mm/init.c~mm-hugetlb-split-hugetlb_cma-in-nodes-with-memory
+++ a/arch/arm64/mm/init.c
@@ -421,15 +421,6 @@ void __init bootmem_init(void)
 	arm64_numa_init();
 
 	/*
-	 * must be done after arm64_numa_init() which calls numa_init() to
-	 * initialize node_online_map that gets used in hugetlb_cma_reserve()
-	 * while allocating required CMA size across online nodes.
-	 */
-#ifdef CONFIG_ARM64_4K_PAGES
-	hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
-#endif
-
-	/*
 	 * Sparsemem tries to allocate bootmem in memory_present(), so must be
 	 * done after the fixed reservations.
 	 */
@@ -438,6 +429,16 @@ void __init bootmem_init(void)
 	sparse_init();
 	zone_sizes_init(min, max);
 
+	/*
+	 * must be done after zone_sizes_init() which calls free_area_init()
+	 * that calls node_set_state() to initialize node_states[N_MEMORY]
+	 * because hugetlb_cma_reserve() will scan over nodes with N_MEMORY
+	 * state
+	 */
+#ifdef CONFIG_ARM64_4K_PAGES
+	hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
+#endif
+
 	memblock_dump_all();
 }
 
--- a/arch/x86/kernel/setup.c~mm-hugetlb-split-hugetlb_cma-in-nodes-with-memory
+++ a/arch/x86/kernel/setup.c
@@ -1164,9 +1164,6 @@ void __init setup_arch(char **cmdline_p)
 	initmem_init();
 	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
 
-	if (boot_cpu_has(X86_FEATURE_GBPAGES))
-		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
-
 	/*
 	 * Reserve memory for crash kernel after SRAT is parsed so that it
 	 * won't consume hotpluggable memory.
@@ -1180,6 +1177,15 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.paging.pagetable_init();
 
+	/*
+	 * must be done after zone_sizes_init() which calls free_area_init()
+	 * that calls node_set_state() to initialize node_states[N_MEMORY]
+	 * because hugetlb_cma_reserve() will scan over nodes with N_MEMORY
+	 * state
+	 */
+	if (boot_cpu_has(X86_FEATURE_GBPAGES))
+		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
+
 	kasan_init();
 
 	/*
--- a/mm/hugetlb.c~mm-hugetlb-split-hugetlb_cma-in-nodes-with-memory
+++ a/mm/hugetlb.c
@@ -5680,6 +5680,13 @@ static int __init cmdline_parse_hugetlb_
 
 early_param("hugetlb_cma", cmdline_parse_hugetlb_cma);
 
+/*
+ * hugetlb_cma_reserve() - reserve CMA for gigantic pages on nodes with memory
+ *
+ * must be called after free_area_init() that updates N_MEMORY via node_set_state().
+ * hugetlb_cma_reserve() scans over N_MEMORY nodemask and hence expects the platforms
+ * to have initialized N_MEMORY state.
+ */
 void __init hugetlb_cma_reserve(int order)
 {
 	unsigned long size, reserved, per_node;
@@ -5700,12 +5707,12 @@ void __init hugetlb_cma_reserve(int orde
 	 * If 3 GB area is requested on a machine with 4 numa nodes,
 	 * let's allocate 1 GB on first three nodes and ignore the last one.
 	 */
-	per_node = DIV_ROUND_UP(hugetlb_cma_size, nr_online_nodes);
+	per_node = DIV_ROUND_UP(hugetlb_cma_size, num_node_state(N_MEMORY));
 	pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
 		hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 
 	reserved = 0;
-	for_each_node_state(nid, N_ONLINE) {
+	for_each_node_state(nid, N_MEMORY) {
 		int res;
 
 		size = min(per_node, hugetlb_cma_size - reserved);
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enable.patch
mm-hugetlb-split-hugetlb_cma-in-nodes-with-memory.patch
mm-cma-fix-the-name-of-cma-areas.patch
mm-hugetlb-fix-the-name-of-hugetlb-cma.patch


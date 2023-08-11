Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8BDC41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbjHKW6p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbjHKW6o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A292D61
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C1266699C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83295C433C8;
        Fri, 11 Aug 2023 22:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794716;
        bh=Zf+y+Col3RgG2AxfREtpE84KmuNoNKPVMchzx6pD54A=;
        h=Date:To:From:Subject:From;
        b=OxhhyRqpFSqjwjImwfRBfPRi7G3K0seNoo/wtHyXqD36eU4w/hkMntK++rVIW1gHA
         1XP5iJBaxNWWikpMfk5vUxmD4mKk3l52ywFa5NWh1qmCBPLFX/4iWx1ND2kyx+q52c
         FPSKpIbyBSDFx3L8mXxGdspU+PwPv7xyW03kKPT8=
Date:   Fri, 11 Aug 2023 15:58:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, npiggin@gmail.com,
        mpe@ellerman.id.au, gregkh@linuxfoundation.org,
        christophe.leroy@csgroup.eu, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-show_free_areas-static.patch removed from -mm tree
Message-Id: <20230811225836.83295C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: make show_free_areas() static
has been removed from the -mm tree.  Its filename was
     mm-make-show_free_areas-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: make show_free_areas() static
Date: Fri, 30 Jun 2023 14:22:53 +0800

All callers of show_free_areas() pass 0 and NULL, so we can directly use
show_mem() instead of show_free_areas(0, NULL), which could make
show_free_areas() a static function.

Link: https://lkml.kernel.org/r/20230630062253.189440-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/setup_32.c |    2 +-
 include/linux/mm.h           |   12 ------------
 mm/internal.h                |    6 ++++++
 mm/nommu.c                   |    8 ++++----
 mm/show_mem.c                |    4 ++--
 5 files changed, 13 insertions(+), 19 deletions(-)

--- a/arch/sparc/kernel/setup_32.c~mm-make-show_free_areas-static
+++ a/arch/sparc/kernel/setup_32.c
@@ -83,7 +83,7 @@ static void prom_sync_me(void)
 			     "nop\n\t" : : "r" (&trapbase));
 
 	prom_printf("PROM SYNC COMMAND...\n");
-	show_free_areas(0, NULL);
+	show_mem();
 	if (!is_idle_task(current)) {
 		local_irq_enable();
 		ksys_sync();
--- a/include/linux/mm.h~mm-make-show_free_areas-static
+++ a/include/linux/mm.h
@@ -2237,18 +2237,6 @@ extern void pagefault_out_of_memory(void
 #define offset_in_folio(folio, p) ((unsigned long)(p) & (folio_size(folio) - 1))
 
 /*
- * Flags passed to show_mem() and show_free_areas() to suppress output in
- * various contexts.
- */
-#define SHOW_MEM_FILTER_NODES		(0x0001u)	/* disallowed nodes */
-
-extern void __show_free_areas(unsigned int flags, nodemask_t *nodemask, int max_zone_idx);
-static void __maybe_unused show_free_areas(unsigned int flags, nodemask_t *nodemask)
-{
-	__show_free_areas(flags, nodemask, MAX_NR_ZONES - 1);
-}
-
-/*
  * Parameter block passed down to zap_pte_range in exceptional cases.
  */
 struct zap_details {
--- a/mm/internal.h~mm-make-show_free_areas-static
+++ a/mm/internal.h
@@ -62,6 +62,12 @@ void page_writeback_init(void);
 #define FOLIO_PAGES_MAPPED	(COMPOUND_MAPPED - 1)
 
 /*
+ * Flags passed to __show_mem() and show_free_areas() to suppress output in
+ * various contexts.
+ */
+#define SHOW_MEM_FILTER_NODES		(0x0001u)	/* disallowed nodes */
+
+/*
  * How many individual pages have an elevated _mapcount.  Excludes
  * the folio's entire_mapcount.
  */
--- a/mm/nommu.c~mm-make-show_free_areas-static
+++ a/mm/nommu.c
@@ -1003,7 +1003,7 @@ error_free:
 enomem:
 	pr_err("Allocation of length %lu from process %d (%s) failed\n",
 	       len, current->pid, current->comm);
-	show_free_areas(0, NULL);
+	show_mem();
 	return -ENOMEM;
 }
 
@@ -1236,20 +1236,20 @@ error_getting_vma:
 	kmem_cache_free(vm_region_jar, region);
 	pr_warn("Allocation of vma for %lu byte allocation from process %d failed\n",
 			len, current->pid);
-	show_free_areas(0, NULL);
+	show_mem();
 	return -ENOMEM;
 
 error_getting_region:
 	pr_warn("Allocation of vm region for %lu byte allocation from process %d failed\n",
 			len, current->pid);
-	show_free_areas(0, NULL);
+	show_mem();
 	return -ENOMEM;
 
 error_vma_iter_prealloc:
 	kmem_cache_free(vm_region_jar, region);
 	vm_area_free(vma);
 	pr_warn("Allocation of vma tree for process %d failed\n", current->pid);
-	show_free_areas(0, NULL);
+	show_mem();
 	return -ENOMEM;
 
 }
--- a/mm/show_mem.c~mm-make-show_free_areas-static
+++ a/mm/show_mem.c
@@ -186,7 +186,7 @@ static bool node_has_managed_zones(pg_da
  * SHOW_MEM_FILTER_NODES: suppress nodes that are not allowed by current's
  *   cpuset.
  */
-void __show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
+static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 {
 	unsigned long free_pcp = 0;
 	int cpu, nid;
@@ -406,7 +406,7 @@ void __show_mem(unsigned int filter, nod
 	struct zone *zone;
 
 	printk("Mem-Info:\n");
-	__show_free_areas(filter, nodemask, max_zone_idx);
+	show_free_areas(filter, nodemask, max_zone_idx);
 
 	for_each_populated_zone(zone) {
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-factor-out-vma-stack-and-heap-checks.patch
drm-amdkfd-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
selinux-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
mm-hugetlb-use-flush_hugetlb_tlb_range-in-move_hugetlb_page_tables.patch
arm64-hugetlb-enable-__have_arch_flush_hugetlb_tlb_range.patch
mm-memtest-convert-to-memtest_report_meminfo.patch


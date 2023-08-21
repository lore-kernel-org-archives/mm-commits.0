Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DC8EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjHUUjB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjHUUjA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAE0136
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2224D64AFB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727E8C433CA;
        Mon, 21 Aug 2023 20:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650336;
        bh=gbU+zC7YNb08fagkLL7Wfnt4eDq6dfWBXo1N24DejVg=;
        h=Date:To:From:Subject:From;
        b=VNveILbzo29IqCLnbS1t5wMpHuOn92fN2Opu/4TAdjgKchdowXaGCxizFMXOaDkTr
         nEpKPz5BRtHIE0lic8Aalb6u7cvxDRzVpdUMFQQ//I5KLuAhdRUVcJzA8RvqvjcYI5
         2h5BVx2jc4CObuYDoaN1fjetZsyO8I/c3hsrwiNo=
Date:   Mon, 21 Aug 2023 13:38:55 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, nphamcs@gmail.com, hch@infradead.org,
        hannes@cmpxchg.org, cerasuolodomenico@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch removed from -mm tree
Message-Id: <20230821203856.727E8C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: convert get_obj_cgroup_from_page to get_obj_cgroup_from_folio
has been removed from the -mm tree.  Its filename was
     memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memcg: convert get_obj_cgroup_from_page to get_obj_cgroup_from_folio
Date: Sat, 15 Jul 2023 05:23:41 +0100

As the one caller now has a folio, pass it in and use it.  Removes three
calls to compound_head().

Link: https://lkml.kernel.org/r/20230715042343.434588-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |    8 ++++----
 mm/zswap.c                 |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/memcontrol.h~memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio
+++ a/include/linux/memcontrol.h
@@ -1759,7 +1759,7 @@ int __memcg_kmem_charge_page(struct page
 void __memcg_kmem_uncharge_page(struct page *page, int order);
 
 struct obj_cgroup *get_obj_cgroup_from_current(void);
-struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
+struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio);
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
@@ -1843,7 +1843,7 @@ static inline void __memcg_kmem_uncharge
 {
 }
 
-static inline struct obj_cgroup *get_obj_cgroup_from_page(struct page *page)
+static inline struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
 {
 	return NULL;
 }
--- a/mm/memcontrol.c~memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio
+++ a/mm/memcontrol.c
@@ -3036,21 +3036,21 @@ __always_inline struct obj_cgroup *get_o
 	return objcg;
 }
 
-struct obj_cgroup *get_obj_cgroup_from_page(struct page *page)
+struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
 {
 	struct obj_cgroup *objcg;
 
 	if (!memcg_kmem_online())
 		return NULL;
 
-	if (PageMemcgKmem(page)) {
-		objcg = __folio_objcg(page_folio(page));
+	if (folio_memcg_kmem(folio)) {
+		objcg = __folio_objcg(folio);
 		obj_cgroup_get(objcg);
 	} else {
 		struct mem_cgroup *memcg;
 
 		rcu_read_lock();
-		memcg = __folio_memcg(page_folio(page));
+		memcg = __folio_memcg(folio);
 		if (memcg)
 			objcg = __get_obj_cgroup_from_memcg(memcg);
 		else
--- a/mm/zswap.c~memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio
+++ a/mm/zswap.c
@@ -1258,7 +1258,7 @@ bool zswap_store(struct folio *folio)
 	 * cgroup-aware entry LRU, we will push out entries system-wide based on
 	 * local cgroup limits.
 	 */
-	objcg = get_obj_cgroup_from_page(page);
+	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg))
 		goto reject;
 
_

Patches currently in -mm which might be from willy@infradead.org are

io_uring-stop-calling-free_compound_page.patch
mm-call-free_huge_page-directly.patch
mm-convert-free_huge_page-to-free_huge_folio.patch
mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable.patch
mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable.patch
mm-remove-free_compound_page-and-the-compound_page_dtors-array.patch
mm-remove-hugetlb_page_dtor.patch
mm-add-large_rmappable-page-flag.patch
mm-rearrange-page-flags.patch
mm-free-up-a-word-in-the-first-tail-page.patch
mm-remove-folio_test_transhuge.patch
mm-add-tail-private-fields-to-struct-folio.patch
mm-convert-split_huge_pages_pid-to-use-a-folio.patch
mm-memoryc-fix-mismerge.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch
mm-swap-use-dedicated-entry-for-swap-in-folio.patch
mm-remove-checks-for-pte_index.patch
mm-move-pmd_order-to-pgtableh.patch
mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch
mm-remove-enum-page_entry_size.patch
mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch
mm-fix-get_mctgt_type-kernel-doc.patch
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch


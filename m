Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142C3C04A6A
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 15:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjG0PdK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 11:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbjG0Pc6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 11:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38A726BA
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 08:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D1C61EC0
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 15:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4CFC433C8;
        Thu, 27 Jul 2023 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690471975;
        bh=03kez0viQuOVvdJHWlPijukoPkOdYktUL6F20iD5+oU=;
        h=Date:To:From:Subject:From;
        b=yDmFY2t2djA9lnwt7qTMKjL3xXiuSECR9Qsc1TC52kjT5iG50YWmFWPxbj3A2dpY6
         30i8VEXEFuxmQRq6Y7q2RQXua0sN6BjEOcLd5VGHomdk5PW6Tea0opZ2PxsnuXxW3+
         DXSV5fI1cfIWNKKMktKXWnfiqyfb6yilms4f5aSU=
Date:   Thu, 27 Jul 2023 08:32:52 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, shy828301@gmail.com,
        fengwei.yin@intel.com, david@redhat.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-batch-zap-large-anonymous-folio-pte-mappings.patch removed from -mm tree
Message-Id: <20230727153254.DD4CFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: batch-zap large anonymous folio PTE mappings
has been removed from the -mm tree.  Its filename was
     mm-batch-zap-large-anonymous-folio-pte-mappings.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: batch-zap large anonymous folio PTE mappings
Date: Thu, 20 Jul 2023 12:29:55 +0100

This allows batching the rmap removal with folio_remove_rmap_range(),
which means we avoid spuriously adding a partially unmapped folio to the
deferred split queue in the common case, which reduces split queue lock
contention.

Previously each page was removed from the rmap individually with
page_remove_rmap().  If the first page belonged to a large folio, this
would cause page_remove_rmap() to conclude that the folio was now
partially mapped and add the folio to the deferred split queue.  But
subsequent calls would cause the folio to become fully unmapped, meaning
there is no value to adding it to the split queue.

Link: https://lkml.kernel.org/r/20230720112955.643283-4-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |  120 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

--- a/mm/memory.c~mm-batch-zap-large-anonymous-folio-pte-mappings
+++ a/mm/memory.c
@@ -1394,6 +1394,94 @@ zap_install_uffd_wp_if_needed(struct vm_
 	pte_install_uffd_wp_if_needed(vma, addr, pte, pteval);
 }
 
+static inline unsigned long page_cont_mapped_vaddr(struct page *page,
+				struct page *anchor, unsigned long anchor_vaddr)
+{
+	unsigned long offset;
+	unsigned long vaddr;
+
+	offset = (page_to_pfn(page) - page_to_pfn(anchor)) << PAGE_SHIFT;
+	vaddr = anchor_vaddr + offset;
+
+	if (anchor > page) {
+		if (vaddr > anchor_vaddr)
+			return 0;
+	} else {
+		if (vaddr < anchor_vaddr)
+			return ULONG_MAX;
+	}
+
+	return vaddr;
+}
+
+static int folio_nr_pages_cont_mapped(struct folio *folio,
+				      struct page *page, pte_t *pte,
+				      unsigned long addr, unsigned long end)
+{
+	pte_t ptent;
+	int floops;
+	int i;
+	unsigned long pfn;
+	struct page *folio_end;
+
+	if (!folio_test_large(folio))
+		return 1;
+
+	folio_end = &folio->page + folio_nr_pages(folio);
+	end = min(page_cont_mapped_vaddr(folio_end, page, addr), end);
+	floops = (end - addr) >> PAGE_SHIFT;
+	pfn = page_to_pfn(page);
+	pfn++;
+	pte++;
+
+	for (i = 1; i < floops; i++) {
+		ptent = ptep_get(pte);
+
+		if (!pte_present(ptent) || pte_pfn(ptent) != pfn)
+			break;
+
+		pfn++;
+		pte++;
+	}
+
+	return i;
+}
+
+static unsigned long try_zap_anon_pte_range(struct mmu_gather *tlb,
+					    struct vm_area_struct *vma,
+					    struct folio *folio,
+					    struct page *page, pte_t *pte,
+					    unsigned long addr, int nr_pages,
+					    struct zap_details *details)
+{
+	struct mm_struct *mm = tlb->mm;
+	pte_t ptent;
+	bool full;
+	int i;
+
+	for (i = 0; i < nr_pages;) {
+		ptent = ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
+		tlb_remove_tlb_entry(tlb, pte, addr);
+		zap_install_uffd_wp_if_needed(vma, addr, pte, details, ptent);
+		full = __tlb_remove_page(tlb, page, 0);
+
+		if (unlikely(page_mapcount(page) < 1))
+			print_bad_pte(vma, addr, ptent, page);
+
+		i++;
+		page++;
+		pte++;
+		addr += PAGE_SIZE;
+
+		if (unlikely(full))
+			break;
+	}
+
+	folio_remove_rmap_range(folio, page - i, i, vma);
+
+	return i;
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -1431,6 +1519,38 @@ static unsigned long zap_pte_range(struc
 			page = vm_normal_page(vma, addr, ptent);
 			if (unlikely(!should_zap_page(details, page)))
 				continue;
+
+			/*
+			 * Batch zap large anonymous folio mappings. This allows
+			 * batching the rmap removal, which means we avoid
+			 * spuriously adding a partially unmapped folio to the
+			 * deferrred split queue in the common case, which
+			 * reduces split queue lock contention.
+			 */
+			if (page && PageAnon(page)) {
+				struct folio *folio = page_folio(page);
+				int nr_pages_req, nr_pages;
+
+				nr_pages_req = folio_nr_pages_cont_mapped(
+						folio, page, pte, addr, end);
+
+				nr_pages = try_zap_anon_pte_range(tlb, vma,
+						folio, page, pte, addr,
+						nr_pages_req, details);
+
+				rss[mm_counter(page)] -= nr_pages;
+				nr_pages--;
+				pte += nr_pages;
+				addr += nr_pages << PAGE_SHIFT;
+
+				if (unlikely(nr_pages < nr_pages_req)) {
+					force_flush = 1;
+					addr += PAGE_SIZE;
+					break;
+				}
+				continue;
+			}
+
 			ptent = ptep_get_and_clear_full(mm, addr, pte,
 							tlb->fullmm);
 			tlb_remove_tlb_entry(tlb, pte, addr);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-line-buffer-test-programs-stdout.patch
selftests-line-buffer-test-programs-stdout-fix.patch
selftests-mm-skip-soft-dirty-tests-on-arm64.patch
selftests-mm-enable-mrelease_test-for-arm64.patch
selftests-mm-fix-thuge-gen-test-bugs.patch
selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch
selftests-mm-make-migration-test-robust-to-failure.patch
selftests-mm-optionally-pass-duration-to-transhuge-stress.patch
selftests-mm-run-all-tests-from-run_vmtestssh.patch


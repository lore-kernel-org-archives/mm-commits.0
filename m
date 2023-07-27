Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9732C001DC
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 16:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjG0QjF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 12:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjG0QjB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 12:39:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9FE272C
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 09:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BCBD61ED4
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 16:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF44AC433C8;
        Thu, 27 Jul 2023 16:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690475939;
        bh=mu3dCnaXDLH/Z90T99hEPk6chBwEF4WxlHH6Ap3NiZo=;
        h=Date:To:From:Subject:From;
        b=pAFvWqmAQqIvRvR2sPx1Rz3KQ1ERskuh5x0inh3IlJR4E33ZzOXH2A00WDbAw3moi
         QdZzbIenuIj6iML2vzBNNsTUCMmKiW9mMpYYSbY1Dg36QT1ewkXZ3oMMOToZ+UGj/V
         88U+IIpyJYItA6PDeKOg1y0XkL69CfPQp8U0ZEm8=
Date:   Thu, 27 Jul 2023 09:38:58 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, shy828301@gmail.com,
        nathan@kernel.org, gerald.schaefer@linux.ibm.com,
        fengwei.yin@intel.com, david@redhat.com, agordeev@linux.ibm.com,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-batch-zap-large-anonymous-folio-pte-mappings.patch added to mm-unstable branch
Message-Id: <20230727163858.DF44AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: batch-zap large anonymous folio PTE mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-batch-zap-large-anonymous-folio-pte-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-batch-zap-large-anonymous-folio-pte-mappings.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: batch-zap large anonymous folio PTE mappings
Date: Thu, 27 Jul 2023 15:18:37 +0100

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

A complicating factor is that for platforms where MMU_GATHER_NO_GATHER is
enabled (e.g.  s390), __tlb_remove_page() drops a reference to the page. 
This means that the folio reference count could drop to zero while still
in use (i.e.  before folio_remove_rmap_range() is called).  This does not
happen on other platforms because the actual page freeing is deferred.

Solve this by appropriately getting/putting the folio to guarrantee it
does not get freed early.  Given the need to get/put the folio in the
batch path, we stick to the non-batched path if the folio is not large. 
While the batched path is functionally correct for a folio with 1 page, it
is unlikely to be as efficient as the existing non-batched path in this
case.

Link: https://lkml.kernel.org/r/20230727141837.3386072-4-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |  132 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)

--- a/mm/memory.c~mm-batch-zap-large-anonymous-folio-pte-mappings
+++ a/mm/memory.c
@@ -1391,6 +1391,99 @@ zap_install_uffd_wp_if_needed(struct vm_
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
+	/* __tlb_remove_page may drop a ref; prevent going to 0 while in use. */
+	folio_get(folio);
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
+	folio_put(folio);
+
+	return i;
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -1428,6 +1521,45 @@ static unsigned long zap_pte_range(struc
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
+
+				if (folio_test_large(folio)) {
+					int nr_pages_req, nr_pages;
+					int counter = mm_counter(page);
+
+					nr_pages_req = folio_nr_pages_cont_mapped(
+							folio, page, pte, addr,
+							end);
+
+					/* folio may be freed on return. */
+					nr_pages = try_zap_anon_pte_range(
+							tlb, vma, folio, page,
+							pte, addr, nr_pages_req,
+							details);
+
+					rss[counter] -= nr_pages;
+					nr_pages--;
+					pte += nr_pages;
+					addr += nr_pages << PAGE_SHIFT;
+
+					if (unlikely(nr_pages < nr_pages_req)) {
+						force_flush = 1;
+						addr += PAGE_SIZE;
+						break;
+					}
+					continue;
+				}
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
mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch
mm-implement-folio_remove_rmap_range.patch
mm-batch-zap-large-anonymous-folio-pte-mappings.patch


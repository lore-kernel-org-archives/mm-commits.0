Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582D6C43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D7C421531
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599937894;
	bh=lzSTnPPApjKmmS16rgO4tdyRGknHpVZpPvoi1rS5h8k=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=kLav3URyJ5i3AO1JGuiPc5m54wfxhHK71OKOG61rgXUjVA4zcX7Xe0p1Gp1l/hHFq
	 EGoFmB0pm7ZS5AufSsue2n2pvT03tZ2mkiq60uQSCCpOoC61T4OIQzMWdtSoeB0iyI
	 GLx1LisNOOr518HW9hraaT6+FsUjt4NWIihHjZJY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgILTLd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILTLc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:11:32 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8C8721531;
        Sat, 12 Sep 2020 19:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599937891;
        bh=lzSTnPPApjKmmS16rgO4tdyRGknHpVZpPvoi1rS5h8k=;
        h=Date:From:To:Subject:From;
        b=W72cFNzFJkstWgvNR0bfW2zXo7VCvf2wTvtmbphey9pjP7GrCTlvrghSxK+2E2PEI
         WqT2HRbqTAH4LphVR3tBsBXlfuz78TyXOxAg47q2AMRWVwuxA3NlmkfT7afNQVCod8
         e2KLwYRG0qdM/nu0yRVeAfARj0RKZxf0L8AB2zOw=
Date:   Sat, 12 Sep 2020 12:11:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        kirill.shutemov@linux.intel.com, willy@infradead.org
Subject:  +
 mm-memory-remove-page-fault-assumption-of-compound-page-size.patch added to
 -mm tree
Message-ID: <20200912191131.hWKQM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: remove page fault assumption of compound page size
has been added to the -mm tree.  Its filename is
     mm-memory-remove-page-fault-assumption-of-compound-page-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-remove-page-fault-assumption-of-compound-page-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory: remove page fault assumption of compound page size

A compound page in the page cache will not necessarily be of PMD size,
so check explicitly.

Link: https://lkml.kernel.org/r/20200908195539.25896-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-memory-remove-page-fault-assumption-of-compound-page-size
+++ a/mm/memory.c
@@ -3549,13 +3549,14 @@ static vm_fault_t do_set_pmd(struct vm_f
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	pmd_t entry;
 	int i;
-	vm_fault_t ret;
+	vm_fault_t ret = VM_FAULT_FALLBACK;
 
 	if (!transhuge_vma_suitable(vma, haddr))
-		return VM_FAULT_FALLBACK;
+		return ret;
 
-	ret = VM_FAULT_FALLBACK;
 	page = compound_head(page);
+	if (page_order(page) != HPAGE_PMD_ORDER)
+		return ret;
 
 	/*
 	 * Archs like ppc64 need additonal space to store information
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
harden-autofs-ioctl-table.patch


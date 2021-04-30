Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2ADC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A521F611ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhD3F13 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhD3F13 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:27:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C1756101B;
        Fri, 30 Apr 2021 05:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760400;
        bh=+U6g5Bueg9JhUuCOmCy2sU/CTyBHmS78nKK2RA/cyYk=;
        h=Date:From:To:Subject:From;
        b=py2nrOhYPMCw5hkUhbPssInaHzzi9SoUwjhKd68pMfr4qVdjLjla8Z2bBx+UxHzHB
         IhgwvFvbUQgTUEC1WAGyT/ZpMIE9+ybkCkuU3BPeyE4kk2wMG8m+7jGdBfeqQpQUN3
         pksN2i82QI4CyjgtbqCaVwCqZP9tsRhLuKupK8c8=
Date:   Thu, 29 Apr 2021 22:26:39 -0700
From:   akpm@linux-foundation.org
To:     davem@davemloft.net, mm-commits@vger.kernel.org, npiggin@gmail.com,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-vmalloc-fix-huge=5Fvmap-regression-by-enabling-huge-pa?=
 =?US-ASCII?Q?ges-in-vmalloc=5Fto=5Fpage-fix.patch?= removed from -mm tree
Message-ID: <20210430052639.EF9HFb9p1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparc32: add stub pud_page define for walking huge vmalloc page tables
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page-fix.patch

This patch was dropped because it was folded into mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page.patch

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: sparc32: add stub pud_page define for walking huge vmalloc page tables

Similarly to the stub p4d_page in sparc64, add a stub pud_page, this
is needed for hugepages in the vmap page tables to be walked without
ifdefs, which should be no functional change for sparc32.

Link: https://lkml.kernel.org/r/20210324232825.1157363-1-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_32.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/sparc/include/asm/pgtable_32.h~mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page-fix
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -321,6 +321,9 @@ static inline pte_t pte_modify(pte_t pte
 		pgprot_val(newprot));
 }
 
+/* only used by the huge vmap code, should never be called */
+#define pud_page(pud)			NULL
+
 struct seq_file;
 void mmu_info(struct seq_file *m);
 
_

Patches currently in -mm which might be from npiggin@gmail.com are

arm-mm-add-missing-pud_page-define-to-2-level-page-tables.patch
mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page.patch
mm-apply_to_pte_range-warn-and-fail-if-a-large-pte-is-encountered.patch
mm-vmalloc-rename-vmap__range-vmap_pages__range.patch
mm-ioremap-rename-ioremap__range-to-vmap__range.patch
mm-huge_vmap-arch-support-cleanup.patch
powerpc-inline-huge-vmap-supported-functions.patch
arm64-inline-huge-vmap-supported-functions.patch
x86-inline-huge-vmap-supported-functions.patch
mm-vmalloc-provide-fallback-arch-huge-vmap-support-functions.patch
mm-move-vmap_range-from-mm-ioremapc-to-mm-vmallocc.patch
mm-vmalloc-add-vmap_range_noflush-variant.patch
mm-vmalloc-hugepage-vmalloc-mappings.patch
mm-vmalloc-remove-map_kernel_range.patch
kernel-dma-remove-unnecessary-unmap_kernel_range.patch
powerpc-xive-remove-unnecessary-unmap_kernel_range.patch
mm-vmalloc-remove-unmap_kernel_range.patch
mm-vmalloc-remove-unmap_kernel_range-fix.patch
mm-vmalloc-remove-map_kernel_range-fix-2.patch
mm-vmalloc-improve-allocation-failure-error-messages.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDDCC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41043610D1
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhDBAPl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Apr 2021 20:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhDBAPl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 1 Apr 2021 20:15:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A267A610CF;
        Fri,  2 Apr 2021 00:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617322539;
        bh=Cq4DLmZU1sf92BCU8eEShwb76LdU8qvDuwKsLLLL7HU=;
        h=Date:From:To:Subject:From;
        b=om4i2XF2Dx0/D9xcsPU+a6CohL6mAdHZ0SBA3OfVXPQn7nZ1N3VyGIDvEOlB2d//Q
         ZuYAMMKYbFC1OigKTnLrjhHnV3/ZS2Uyy4DxV6pPG9R5EJIo97lSAUg3nTsc0aeK2K
         RoQH+5fl65w4q4D6dyqf8oUlUMDchGbjZoqPFEc0=
Date:   Thu, 01 Apr 2021 17:15:39 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, npiggin@gmail.com,
        sfr@canb.auug.org.au
Subject:  + mm-vmalloc-remove-map_kernel_range-fix-2.patch added to
 -mm tree
Message-ID: <20210402001539.gVAnz9ZkV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-remove-map_kernel_range-fix-2
has been added to the -mm tree.  Its filename is
     mm-vmalloc-remove-map_kernel_range-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-remove-map_kernel_range-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-remove-map_kernel_range-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: mm-vmalloc-remove-map_kernel_range-fix-2

This requires a fix for nommu builds.

Link: https://lkml.kernel.org/r/1617292497.o1uhq5ipxp.astroid@bobo.none
Cc: Christoph Hellwig <hch@lst.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/internal.h~mm-vmalloc-remove-map_kernel_range-fix-2
+++ a/mm/internal.h
@@ -644,8 +644,18 @@ struct migration_target_control {
 /*
  * mm/vmalloc.c
  */
+#ifdef CONFIG_MMU
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
                 pgprot_t prot, struct page **pages, unsigned int page_shift);
+#else
+static inline
+int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+                pgprot_t prot, struct page **pages, unsigned int page_shift)
+{
+	return -EINVAL;
+}
+#endif
+
 void vunmap_range_noflush(unsigned long start, unsigned long end);
 
 #endif	/* __MM_INTERNAL_H */
_

Patches currently in -mm which might be from npiggin@gmail.com are

arm-mm-add-missing-pud_page-define-to-2-level-page-tables.patch
mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page.patch
mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page-fix.patch
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
powerpc-64s-radix-enable-huge-vmalloc-mappings.patch
mm-vmalloc-remove-map_kernel_range.patch
kernel-dma-remove-unnecessary-unmap_kernel_range.patch
powerpc-xive-remove-unnecessary-unmap_kernel_range.patch
mm-vmalloc-remove-unmap_kernel_range.patch
mm-vmalloc-remove-unmap_kernel_range-fix.patch
mm-vmalloc-remove-map_kernel_range-fix-2.patch
mm-vmalloc-improve-allocation-failure-error-messages.patch


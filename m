Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548DBC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F95E61108
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbhDBANe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Apr 2021 20:13:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235296AbhDBANe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 1 Apr 2021 20:13:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFE1F610CF;
        Fri,  2 Apr 2021 00:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617322413;
        bh=jOgmbrZsEDFFF42Q9h3cyF/OhROVoQfpoZlaJYqA3nY=;
        h=Date:From:To:Subject:From;
        b=qnzyGvDBGAc6rZ4gk/Lferm+dvn5x5hSawu77kcf7Xy1vNjB3IZgn1UJmsZKgKEoI
         Grs2vcngZpNLMMSsZzI0T2rN4kxGOgY3EhQttBs1fI5bC+N40p6IiVCz5AZ90+9rHz
         c18bvH51eoi09UNNyC2KOZRhmyyblbqBYt9QMOFE=
Date:   Thu, 01 Apr 2021 17:13:33 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, npiggin@gmail.com,
        sfr@canb.auug.org.au
Subject:  + mm-vmalloc-remove-unmap_kernel_range-fix.patch added to
 -mm tree
Message-ID: <20210402001333.Io1WjLZV7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-remove-unmap_kernel_range-fix
has been added to the -mm tree.  Its filename is
     mm-vmalloc-remove-unmap_kernel_range-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-remove-unmap_kernel_range-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-remove-unmap_kernel_range-fix.patch

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
Subject: mm-vmalloc-remove-unmap_kernel_range-fix

This requires a fix for nommu builds and a comment bug that sfr noticed.

Link: https://lkml.kernel.org/r/1617292598.m6g0knx24s.astroid@bobo.none
Cc: Christoph Hellwig <hch@lst.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +++
 mm/vmalloc.c  |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/mm/internal.h~mm-vmalloc-remove-unmap_kernel_range-fix
+++ a/mm/internal.h
@@ -541,6 +541,9 @@ static inline int node_reclaim(struct pg
 {
 	return NODE_RECLAIM_NOSCAN;
 }
+static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
+{
+}
 #endif
 
 extern int hwpoison_filter(struct page *p);
--- a/mm/vmalloc.c~mm-vmalloc-remove-unmap_kernel_range-fix
+++ a/mm/vmalloc.c
@@ -413,7 +413,7 @@ void vunmap_range_noflush(unsigned long
 }
 
 /**
- * vunmap_range_noflush - unmap kernel virtual addresses
+ * vunmap_range - unmap kernel virtual addresses
  * @addr: start of the VM area to unmap
  * @end: end of the VM area to unmap (non-inclusive)
  *
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
mm-vmalloc-improve-allocation-failure-error-messages.patch


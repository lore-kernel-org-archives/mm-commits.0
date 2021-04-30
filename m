Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F7BFC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3750F61445
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhD3F3a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3F32 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5812613FA;
        Fri, 30 Apr 2021 05:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760514;
        bh=hXutZUELvXAxJtphZuJqnXyLAaINnfAWKQ3QtqVSKa0=;
        h=Date:From:To:Subject:From;
        b=c80NlZXaBw1KTnEzG/EnHVJjrHNZr9Rh40UnJLMLL9B0FKs1hUzRuD/6/JyL147uT
         oh+j/qNXc5j/u5OTsE1NktJfcmParzl4VwsR4X8Zp0ZlPMQAZzR0qGw+yzYQb4SzR+
         2xAy459rZo1hKJp+Fsk93LIHg7UGC/Ytxc8lMrpk=
Date:   Thu, 29 Apr 2021 22:28:34 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, npiggin@gmail.com,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-vmalloc-remove-unmap_kernel_range-fix.patch removed from -mm tree
Message-ID: <20210430052834.StwQBw2OD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-remove-unmap_kernel_range-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-unmap_kernel_range-fix.patch

This patch was dropped because it was folded into mm-vmalloc-remove-unmap_kernel_range.patch

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
mm-vmalloc-remove-map_kernel_range-fix-2.patch
mm-vmalloc-improve-allocation-failure-error-messages.patch


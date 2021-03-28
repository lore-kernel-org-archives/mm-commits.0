Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8676C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75FFB6195D
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhC1WFu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhC1WFT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D619F6195F;
        Sun, 28 Mar 2021 22:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616969118;
        bh=URHAgUfnAHrTx2lsiUQ7TjTNU8ibf05157T9pK/EZgQ=;
        h=Date:From:To:Subject:From;
        b=C8qA85EJrBh7ITxgXpwH25TtCIPbxPISnN7mz75/1Z6K35gpDaq+tZHvLwW8OC70u
         B58htai5xVw2Rihn9EIy1Ci8Ak3Y5/4dDjpIaMxcbIYLISeJpXl2JoU/uo1DZtLVKO
         9bBiWD1eZISKqV7MdA0zPk4XW2VAOLcF1NCoOZBU=
Date:   Sun, 28 Mar 2021 15:05:17 -0700
From:   akpm@linux-foundation.org
To:     clg@kaod.org, hch@lst.de, mm-commits@vger.kernel.org,
        npiggin@gmail.com, urezki@gmail.com
Subject:  + kernel-dma-remove-unnecessary-unmap_kernel_range.patch
 added to -mm tree
Message-ID: <20210328220517.J31wwUmBY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/dma: remove unnecessary unmap_kernel_range
has been added to the -mm tree.  Its filename is
     kernel-dma-remove-unnecessary-unmap_kernel_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-dma-remove-unnecessary=
-unmap_kernel_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-dma-remove-unnecessary=
-unmap_kernel_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Nicholas Piggin <npiggin@gmail.com>
Subject: kernel/dma: remove unnecessary unmap_kernel_range

vunmap will remove ptes.

Link: https://lkml.kernel.org/r/20210322021806.892164-3-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: C=C3=A9dric Le Goater <clg@kaod.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/remap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/dma/remap.c~kernel-dma-remove-unnecessary-unmap_kernel_range
+++ a/kernel/dma/remap.c
@@ -66,6 +66,5 @@ void dma_common_free_remap(void *cpu_add
 		return;
 	}
=20
-	unmap_kernel_range((unsigned long)cpu_addr, PAGE_ALIGN(size));
 	vunmap(cpu_addr);
 }
_

Patches currently in -mm which might be from npiggin@gmail.com are

arm-mm-add-missing-pud_page-define-to-2-level-page-tables.patch
mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_pa=
ge.patch
mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_pa=
ge-fix.patch
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
mm-vmalloc-improve-allocation-failure-error-messages.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EAAC433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F7E66195F
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhC1WFu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231565AbhC1WFV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:05:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4A6161968;
        Sun, 28 Mar 2021 22:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616969121;
        bh=1ddGdEjVnwghWJGOkgncnSIehDb6yYUu0FK/gwZenUs=;
        h=Date:From:To:Subject:From;
        b=o/Ev5CgGE550X/cHps/SvPsn8Fm0j2Qn3AuUAzi+YcTvukccVsQ3xnwrkSGYB8Zpy
         B8Ma4LIjnOVZyzuGI1EbDcGQ3Ki9TJTnOaIww2Nz4putocp1MNTtr7IZuNDYQ//q34
         3qGafK05CCMGrqNO1MT/ZWbIQqz9zOAZZSvhLLMc=
Date:   Sun, 28 Mar 2021 15:05:20 -0700
From:   akpm@linux-foundation.org
To:     clg@kaod.org, hch@lst.de, mm-commits@vger.kernel.org,
        npiggin@gmail.com, urezki@gmail.com
Subject:  +
 powerpc-xive-remove-unnecessary-unmap_kernel_range.patch added to -mm tree
Message-ID: <20210328220520.AFDXsI5zF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/xive: remove unnecessary unmap_kernel_range
has been added to the -mm tree.  Its filename is
     powerpc-xive-remove-unnecessary-unmap_kernel_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-xive-remove-unnecessa=
ry-unmap_kernel_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-xive-remove-unnecessa=
ry-unmap_kernel_range.patch

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
Subject: powerpc/xive: remove unnecessary unmap_kernel_range

iounmap will remove ptes.

Link: https://lkml.kernel.org/r/20210322021806.892164-4-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: C=C3=A9dric Le Goater <clg@kaod.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/xive/common.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/powerpc/sysdev/xive/common.c~powerpc-xive-remove-unnecessary-unm=
ap_kernel_range
+++ a/arch/powerpc/sysdev/xive/common.c
@@ -959,16 +959,12 @@ EXPORT_SYMBOL_GPL(is_xive_irq);
 void xive_cleanup_irq_data(struct xive_irq_data *xd)
 {
 	if (xd->eoi_mmio) {
-		unmap_kernel_range((unsigned long)xd->eoi_mmio,
-				   1u << xd->esb_shift);
 		iounmap(xd->eoi_mmio);
 		if (xd->eoi_mmio =3D=3D xd->trig_mmio)
 			xd->trig_mmio =3D NULL;
 		xd->eoi_mmio =3D NULL;
 	}
 	if (xd->trig_mmio) {
-		unmap_kernel_range((unsigned long)xd->trig_mmio,
-				   1u << xd->esb_shift);
 		iounmap(xd->trig_mmio);
 		xd->trig_mmio =3D NULL;
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


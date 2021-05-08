Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191C2C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC8076142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhEHWoS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWoS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8787F6141E;
        Sat,  8 May 2021 22:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513795;
        bh=cBJYlGFXucRNNH9s1hC1437Hwbn1zcXoPG3KQGVDsDM=;
        h=Date:From:To:Subject:From;
        b=K7OFZVljOPIvFdm2bLq4W680yL2M7r/Y38ISk77G1e+aViVRIbyE69MuVsJXowaIR
         vPBIYq64AVukU7gQstVf17H4iCbZ01vkAxueqnrZDvpAni95wsA0NYPScdH+iJbY1U
         C59NPAoAB7GlvDgHnPKK2PonKu4mC3WhgeY1MNVA=
Date:   Sat, 08 May 2021 15:43:15 -0700
From:   akpm@linux-foundation.org
To:     clg@kaod.org, hch@lst.de, mm-commits@vger.kernel.org,
        npiggin@gmail.com, urezki@gmail.com
Subject:  [merged]
 powerpc-xive-remove-unnecessary-unmap_kernel_range.patch removed from -mm
 tree
Message-ID: <20210508224315.hJQR1T2jv%akpm@linux-foundation.org>
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
has been removed from the -mm tree.  Its filename was
     powerpc-xive-remove-unnecessary-unmap_kernel_range.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7C4C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C07661483
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhD3F7s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:59:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhD3F7s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:59:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 297BC61481;
        Fri, 30 Apr 2021 05:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762339;
        bh=7q/5DlHhJBQmR6xtmZ8j0J0eN6A5cS1qHTs6J5SJiQQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=haWfEAUAyx51cKRDaHGddTTEISJdhMwwptmO2okdzg8yAz96jN4Z4wBZQEmt56E23
         KF/aIkS8Pervdp7cdF1JJQTurKu7a6XllgBmXOBtzbNzmjqE5epSfJfPecj8JDwIrl
         rQAjPxF1bZeLKkQMJsEJwhNKjuy+iFEttHqcivFM=
Date:   Thu, 29 Apr 2021 22:58:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, clg@kaod.org, hch@lst.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, npiggin@gmail.com,
        torvalds@linux-foundation.org, urezki@gmail.com
Subject:  [patch 112/178] powerpc/xive: remove unnecessary
 unmap_kernel_range
Message-ID: <20210430055858.eOWRTWiDF%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

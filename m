Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BEFC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37F6A61426
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhEHWoQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWoQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8637761421;
        Sat,  8 May 2021 22:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513793;
        bh=tEUNXRR17bOWiOl3So2iRkaU57q9U4GWFtMvqikB9Zk=;
        h=Date:From:To:Subject:From;
        b=S9rWunMIhEC2bfY1mONWcneOdjoSAHyB7xT30xt0zNI9N8DI74AwfnLloWyTKhalc
         0h5t3A51koCitqO7dOf+g3gFYdYdqfKhm8vzMoX0qLxAtDLt8IDSFMrCSPb1szTlQE
         pcknLEDAa06XmUxd2WG3wirnPLMqIrQHGM1Pwgt0=
Date:   Sat, 08 May 2021 15:43:13 -0700
From:   akpm@linux-foundation.org
To:     clg@kaod.org, hch@lst.de, mm-commits@vger.kernel.org,
        npiggin@gmail.com, urezki@gmail.com
Subject:  [merged]
 kernel-dma-remove-unnecessary-unmap_kernel_range.patch removed from -mm
 tree
Message-ID: <20210508224313.U5XXSnCnv%akpm@linux-foundation.org>
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
has been removed from the -mm tree.  Its filename was
     kernel-dma-remove-unnecessary-unmap_kernel_range.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

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



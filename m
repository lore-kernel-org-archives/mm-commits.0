Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75DBC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7886020838
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597450497;
	bh=Klm1evmBLMQCmkZ4c4C0aFXlLBocceYImHCi24d7crY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Nt9t53b8reNQTyOfaIDKx0EzwhQgPT2YcFv/S7ug5ZysKZsorFQpN4JQ4FTzDIsyd
	 k/jQ+Fk/39/lSWoNonvLzElL4xQbDlYTxAwPHDglVKv9VkhnEQnutLqY24MIr4iu9o
	 Djs4hlbM9B//jAV93ma1jyY/01LEziCEcgaE58wE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgHOAO5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Aug 2020 20:14:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgHOAO5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Aug 2020 20:14:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39BDC20781;
        Sat, 15 Aug 2020 00:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597450496;
        bh=Klm1evmBLMQCmkZ4c4C0aFXlLBocceYImHCi24d7crY=;
        h=Date:From:To:Subject:From;
        b=Y1xVmtMoBx08r9vBRNSY/85zYEUR+nwFzQovDOJORRQPzQqC8rcPld0FU7PidMg0N
         pgQQkG1Vv734rFNMh8NyWTnT0+KxyMB5YSqNlFhonKNsVxWPLXFPNsCPqQaySl/dS+
         XGcRGa8AtK6Jn7obxq4bicQgwDKCYRbS80o1h8mg=
Date:   Fri, 14 Aug 2020 17:14:55 -0700
From:   akpm@linux-foundation.org
To:     dalias@libc.org, geert+renesas@glider.be,
        glaubitz@physik.fu-berlin.de, krzk@kernel.org,
        kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org,
        ysato@users.sourceforge.jp
Subject:  [folded-merged]
 =?US-ASCII?Q?iomap-constify-ioreadx-iomem-argument-as-in-generic-implemen?=
 =?US-ASCII?Q?tation-fix.patch?= removed from -mm tree
Message-ID: <20200815001455.S8_ace9V1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: clk: fix assignment from incompatible pointer type for ioreadX()
has been removed from the -mm tree.  Its filename was
     iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix.patch

This patch was dropped because it was folded into iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch

------------------------------------------------------
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: sh: clk: fix assignment from incompatible pointer type for ioreadX()

The ioreadX() helpers accept now pointer to const memory so declaration
of read function needs updating.

This fixes build errors like:

    drivers/sh/clk/cpg.c: In function `sh_clk_mstp_enable':
    drivers/sh/clk/cpg.c:49:9: error: assignment from incompatible pointer type [-Werror=incompatible-pointer-types]
        read = ioread8;

Link: http://lkml.kernel.org/r/20200723082017.24053-1-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sh/clk/cpg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/sh/clk/cpg.c~iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix
+++ a/drivers/sh/clk/cpg.c
@@ -40,7 +40,7 @@ static int sh_clk_mstp_enable(struct clk
 {
 	sh_clk_write(sh_clk_read(clk) & ~(1 << clk->enable_bit), clk);
 	if (clk->status_reg) {
-		unsigned int (*read)(void __iomem *addr);
+		unsigned int (*read)(const void __iomem *addr);
 		int i;
 		void __iomem *mapped_status = (phys_addr_t)clk->status_reg -
 			(phys_addr_t)clk->enable_reg + clk->mapped_reg;
_

Patches currently in -mm which might be from krzk@kernel.org are

iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
rtl818x-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch


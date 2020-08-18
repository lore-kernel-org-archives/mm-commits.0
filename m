Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6836C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81EC52078D
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790480;
	bh=YDKoMRZPWPrMzawAsBj3Mt/XWgI30wagQ5/UTDsIENg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=u8dP8pOAqAhZ4wgQ1Tfj2PLdpa4jq+BpZLviNPzdfzDdYzX3vmtMd3TNkG7AE/70I
	 ZuKEb6TaC3K2Jg+ooX2REyUOXcS3k/6g4v5mJGeK7EjV0N2IR5ymwnteRjijEdX+eO
	 pMBhQYvTnb2uqXgV7ybJu9medMMbViCQkiEJcTRw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgHRWlU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbgHRWlS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:41:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AA2A20674;
        Tue, 18 Aug 2020 22:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790478;
        bh=YDKoMRZPWPrMzawAsBj3Mt/XWgI30wagQ5/UTDsIENg=;
        h=Date:From:To:Subject:From;
        b=PuKU2CpCFKC/b1vq/AftjgLVFF016GAoeTON7NEkQJVW41T36tbwE8ArJpVlpMgBh
         C0PCsZ2IJEdBCcXpzzyeZDw1rBoMeyLLdd4VI4yj4kq0uh1fSyNoxf2CeT8aGyTaQF
         I9OZms4Pz7d4xhrjCByNe/V0yQxtEgta/io7Yshc=
Date:   Tue, 18 Aug 2020 15:41:17 -0700
From:   akpm@linux-foundation.org
To:     amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com,
        dalias@libc.org, geert+renesas@glider.be,
        glaubitz@physik.fu-berlin.de, krzk@kernel.org,
        kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org,
        romain.naour@gmail.com, sam@ravnborg.org,
        ysato@users.sourceforge.jp
Subject:  [merged] sh-clkfwk-remove-r8-r16-r32.patch removed from
 -mm tree
Message-ID: <20200818224117.DQktVBud3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: clkfwk: remove r8/r16/r32
has been removed from the -mm tree.  Its filename was
     sh-clkfwk-remove-r8-r16-r32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: sh: clkfwk: remove r8/r16/r32

SH will get below warning

${LINUX}/drivers/sh/clk/cpg.c: In function 'r8':
${LINUX}/drivers/sh/clk/cpg.c:41:17: warning: passing argument 1 of 'ioread8'
 discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
  return ioread8(addr);
                 ^~~~
In file included from ${LINUX}/arch/sh/include/asm/io.h:21,
                 from ${LINUX}/include/linux/io.h:13,
                 from ${LINUX}/drivers/sh/clk/cpg.c:14:
${LINUX}/include/asm-generic/iomap.h:29:29: note: expected 'void *' but
argument is of type 'const void *'
 extern unsigned int ioread8(void __iomem *);
                             ^~~~~~~~~~~~~~

We don't need "const" for r8/r16/r32.  And we don't need r8/r16/r32
themselvs.  This patch cleanup these.

X-MARC-Message: https://marc.info/?l=linux-renesas-soc&m=157852973916903
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Romain Naour <romain.naour@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sh/clk/cpg.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

--- a/drivers/sh/clk/cpg.c~sh-clkfwk-remove-r8-r16-r32
+++ a/drivers/sh/clk/cpg.c
@@ -36,36 +36,21 @@ static void sh_clk_write(int value, stru
 		iowrite32(value, clk->mapped_reg);
 }
 
-static unsigned int r8(const void __iomem *addr)
-{
-	return ioread8(addr);
-}
-
-static unsigned int r16(const void __iomem *addr)
-{
-	return ioread16(addr);
-}
-
-static unsigned int r32(const void __iomem *addr)
-{
-	return ioread32(addr);
-}
-
 static int sh_clk_mstp_enable(struct clk *clk)
 {
 	sh_clk_write(sh_clk_read(clk) & ~(1 << clk->enable_bit), clk);
 	if (clk->status_reg) {
-		unsigned int (*read)(const void __iomem *addr);
+		unsigned int (*read)(void __iomem *addr);
 		int i;
 		void __iomem *mapped_status = (phys_addr_t)clk->status_reg -
 			(phys_addr_t)clk->enable_reg + clk->mapped_reg;
 
 		if (clk->flags & CLK_ENABLE_REG_8BIT)
-			read = r8;
+			read = ioread8;
 		else if (clk->flags & CLK_ENABLE_REG_16BIT)
-			read = r16;
+			read = ioread16;
 		else
-			read = r32;
+			read = ioread32;
 
 		for (i = 1000;
 		     (read(mapped_status) & (1 << clk->enable_bit)) && i;
_

Patches currently in -mm which might be from kuninori.morimoto.gx@renesas.com are



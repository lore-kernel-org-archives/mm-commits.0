From: akpm@linux-foundation.org
Subject: + sh-clkfwk-remove-r8-r16-r32.patch added to -mm tree
Date: Mon, 01 Jun 2020 17:55:36 -0700
Message-ID: <20200602005536.XGMJ9Quhj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBAzi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Jun 2020 20:55:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com, dalias@libc.org, geert+renesas@glider.be, glaubitz@physik.fu-berlin.de, krzk@kernel.org, kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org, romain.naour@gmail.com, sam@ravnborg.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: clkfwk: remove r8/r16/r32
has been added to the -mm tree.  Its filename is
     sh-clkfwk-remove-r8-r16-r32.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-clkfwk-remove-r8-r16-r32.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-clkfwk-remove-r8-r16-r32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sh-clkfwk-remove-r8-r16-r32.patch
sh-use-generic-strncpy.patch
sh-convert-ins-outs-macros-to-inline-functions.patch
sh-convert-iounmap-macros-to-inline-functions.patch
sh-add-missing-export_symbol-for-__delay.patch

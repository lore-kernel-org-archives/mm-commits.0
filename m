From: akpm@linux-foundation.org
Subject: [patch 003/102] blackfin: bf609: let clk_disable() return
 immediately if clk is NULL
Date: Wed, 03 May 2017 14:51:35 -0700
Message-ID: <20170503215135.pJcTdoTJ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47140 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdECVvg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:51:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, mturquette@baylibre.com, ralf@linux-mips.org, realmz6@gmail.com, sboyd@codeaurora.org, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: blackfin: bf609: let clk_disable() return immediately if clk is NULL

In many of clk_disable() implementations, it is a no-op for a NULL
pointer input, but this is one of the exceptions.

Making it treewide consistent will allow clock consumers to call
clk_disable() without NULL pointer check.

Link: http://lkml.kernel.org/r/1490692624-11931-4-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mach-bf609/clock.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/blackfin/mach-bf609/clock.c~blackfin-bf609-let-clk_disable-return-immediately-if-clk-is-null arch/blackfin/mach-bf609/clock.c
--- a/arch/blackfin/mach-bf609/clock.c~blackfin-bf609-let-clk_disable-return-immediately-if-clk-is-null
+++ a/arch/blackfin/mach-bf609/clock.c
@@ -97,6 +97,9 @@ EXPORT_SYMBOL(clk_enable);
 
 void clk_disable(struct clk *clk)
 {
+	if (!clk)
+		return;
+
 	if (clk->ops && clk->ops->disable)
 		clk->ops->disable(clk);
 }
_

From: akpm@linux-foundation.org
Subject: +
 blackfin-bf609-let-clk_disable-return-immediately-if-clk-is-null.patch
 added to -mm tree
Date: Thu, 13 Apr 2017 12:36:15 -0700
Message-ID: <58efd32f.0Nc6e1BpzJLsgaby%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59684 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755304AbdDMTgV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 15:36:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mturquette@baylibre.com, ralf@linux-mips.org, realmz6@gmail.com, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: blackfin: bf609: let clk_disable() return immediately if clk is NULL
has been added to the -mm tree.  Its filename is
     blackfin-bf609-let-clk_disable-return-immediately-if-clk-is-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/blackfin-bf609-let-clk_disable-return-immediately-if-clk-is-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/blackfin-bf609-let-clk_disable-return-immediately-if-clk-is-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

blackfin-bf609-let-clk_disable-return-immediately-if-clk-is-null.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch


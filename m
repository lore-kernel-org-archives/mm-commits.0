From: akpm@linux-foundation.org
Subject: + sh-add-missing-export_symbol-for-__delay.patch added to
 -mm tree
Date: Mon, 01 Jun 2020 17:55:54 -0700
Message-ID: <20200602005554.zTh0h93z6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBAz4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Jun 2020 20:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com, dalias@libc.org, geert+renesas@glider.be, glaubitz@physik.fu-berlin.de, krzk@kernel.org, kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org, romain.naour@gmail.com, sam@ravnborg.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: add missing EXPORT_SYMBOL() for __delay
has been added to the -mm tree.  Its filename is
     sh-add-missing-export_symbol-for-__delay.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-add-missing-export_symbol-for-__delay.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-add-missing-export_symbol-for-__delay.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: morimoto <kuninori.morimoto.gx@renesas.com>
Subject: sh: add missing EXPORT_SYMBOL() for __delay

__delay() is used from kernel module.  We need EXPORT_SYMBOL(), otherwise
we will get compile error.

ERROR: "__delay" [drivers/net/phy/mdio-cavium.ko] undefined!

Link: https://marc.info/?l=linux-kernel&m=157611811927852
Signed-off-by: morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Romain Naour <romain.naour@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/lib/delay.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sh/lib/delay.c~sh-add-missing-export_symbol-for-__delay
+++ a/arch/sh/lib/delay.c
@@ -41,6 +41,7 @@ inline void __const_udelay(unsigned long
 		: "macl", "mach");
 	__delay(++xloops);
 }
+EXPORT_SYMBOL(__delay);
 
 void __udelay(unsigned long usecs)
 {
_

Patches currently in -mm which might be from kuninori.morimoto.gx@renesas.com are

sh-clkfwk-remove-r8-r16-r32.patch
sh-use-generic-strncpy.patch
sh-convert-ins-outs-macros-to-inline-functions.patch
sh-convert-iounmap-macros-to-inline-functions.patch
sh-add-missing-export_symbol-for-__delay.patch

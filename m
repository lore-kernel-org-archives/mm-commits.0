From: akpm@linux-foundation.org
Subject: [merged] mmc-at91_mci-dont-include-asm-mach-mmch.patch removed from -mm tree
Date: Mon, 26 Oct 2009 15:23:21 -0700
Message-ID: <200910262223.n9QMNM0i010686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968AbZJZWYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Oct 2009 18:24:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, bgat@billgatliff.com, linus.walleij@stericsson.com, linux-mmc@vger.kernel.org, nicolas.ferre@atmel.com, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mmc: at91_mci: don't include asm/mach/mmc.h
has been removed from the -mm tree.  Its filename was
     mmc-at91_mci-dont-include-asm-mach-mmch.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mmc: at91_mci: don't include asm/mach/mmc.h
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

This fixes a compile error introduced in

	6ef297f (ARM: 5720/1: Move MMCI header to amba include dir)

That commit moved arch/arm/include/asm/mach/mmc.h to
include/linux/amba/mmci.h.  Just removing the include was enough.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Bill Gatliff <bgat@billgatliff.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/mmc/host/at91_mci.c~mmc-at91_mci-dont-include-asm-mac=
h-mmch drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mci-dont-include-asm-mach-mm=
ch
+++ a/drivers/mmc/host/at91_mci.c
@@ -72,7 +72,6 @@
 #include <asm/irq.h>
 #include <asm/gpio.h>
=20
-#include <asm/mach/mmc.h>
 #include <mach/board.h>
 #include <mach/cpu.h>
 #include <mach/at91_mci.h>
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
atmel_serial-fix-bad-build_bug_on-usage.patch
linux-next.patch
mxcmmc-fix-error-path-in-mxcmci_probe.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

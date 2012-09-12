From: akpm@linux-foundation.org
Subject: + serial-imx-fix-imx-uart-macro-usage-to-reflect-correct.patch added to -mm tree
Date: Wed, 12 Sep 2012 12:04:21 -0700
Message-ID: <20120912190422.20AA720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:49567 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2ILTEY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 15:04:24 -0400
Received: by wibhr14 with SMTP id hr14so143784wib.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 12:04:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oskar@scara.com, kernel@pengutronix.de, linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de


The patch titled
     Subject: serial/imx: fix IMX UART macro usage to reflect correct
has been added to the -mm tree.  Its filename is
     serial-imx-fix-imx-uart-macro-usage-to-reflect-correct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: "Oskar Schirmer" <oskar@scara.com>
Subject: serial/imx: fix IMX UART macro usage to reflect correct

Platform dependant UART data refers to MX31 macro for MX35 machines.  F=
or
all other machines, macro usage matches machine type.

Though this compiles out to the same result, it looks much like a typo,=
 so
fix it to use the right macros instead.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-mxc/devices/platform-imx-uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/plat-mxc/devices/platform-imx-uart.c~serial-imx-fix-=
imx-uart-macro-usage-to-reflect-correct arch/arm/plat-mxc/devices/platf=
orm-imx-uart.c
--- a/arch/arm/plat-mxc/devices/platform-imx-uart.c~serial-imx-fix-imx-=
uart-macro-usage-to-reflect-correct
+++ a/arch/arm/plat-mxc/devices/platform-imx-uart.c
@@ -87,7 +87,7 @@ const struct imx_imx_uart_1irq_data imx3
 #ifdef CONFIG_SOC_IMX35
 const struct imx_imx_uart_1irq_data imx35_imx_uart_data[] __initconst =
=3D {
 #define imx35_imx_uart_data_entry(_id, _hwid)				\
-	imx_imx_uart_1irq_data_entry(MX31, _id, _hwid, SZ_16K)
+	imx_imx_uart_1irq_data_entry(MX35, _id, _hwid, SZ_16K)
 	imx35_imx_uart_data_entry(0, 1),
 	imx35_imx_uart_data_entry(1, 2),
 	imx35_imx_uart_data_entry(2, 3),
_

Patches currently in -mm which might be from oskar@scara.com are

linux-next.patch
serial-imx-fix-imx-uart-macro-usage-to-reflect-correct.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: akpm@linux-foundation.org
Subject: [merged] serial-imx-fix-imx-uart-macro-usage-to-reflect-correct.patch removed from -mm tree
Date: Mon, 17 Sep 2012 11:37:18 -0700
Message-ID: <20120917183718.B4ABC1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:59284 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab2IQShV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Sep 2012 14:37:21 -0400
Received: by ghbz15 with SMTP id z15so536727ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Sep 2012 11:37:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oskar@scara.com, kernel@pengutronix.de, linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: serial/imx: fix IMX UART macro usage to reflect correct
has been removed from the -mm tree.  Its filename was
     serial-imx-fix-imx-uart-macro-usage-to-reflect-correct.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

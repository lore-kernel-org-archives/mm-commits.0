From: akpm@linux-foundation.org
Subject: [merged] serial-imx-fix-null-dereference-oops-when-pdata-==-null.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:57 -0800
Message-ID: <200912292132.nBTLWv0p008667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbZL2Ve0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:34:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baruch@tkos.co.il, alan@linux.intel.com, dg@emlix.com, fg@emlix.com, greg@kroah.com, os@emlix.com, s.hauer@pengutronix.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     serial: imx: fix NULL dereference Oops when pdata =3D=3D NULL
has been removed from the -mm tree.  Its filename was
     serial-imx-fix-null-dereference-oops-when-pdata-=3D=3D-null.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: serial: imx: fix NULL dereference Oops when pdata =3D=3D NULL
=46rom: Baruch Siach <baruch@tkos.co.il>

The platform code doesn't have to provide platform data to get sensible
default behaviour from the imx serial driver.

This patch does not handle NULL dereference in the IrDA case, which sti=
ll
requires a valid platform data pointer (in imx_startup()/imx_shutdown()=
),
since I don't know whether there is a sensible default behaviour, or
should the operation just fail cleanly.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Fabian Godehardt <fg@emlix.com>
Cc: Daniel Gl=F6ckner <dg@emlix.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/imx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/serial/imx.c~serial-imx-fix-null-dereference-oops-whe=
n-pdata-=3D=3D-null drivers/serial/imx.c
--- a/drivers/serial/imx.c~serial-imx-fix-null-dereference-oops-when-pd=
ata-=3D=3D-null
+++ a/drivers/serial/imx.c
@@ -1279,7 +1279,7 @@ static int serial_imx_probe(struct platf
 		sport->use_irda =3D 1;
 #endif
=20
-	if (pdata->init) {
+	if (pdata && pdata->init) {
 		ret =3D pdata->init(pdev);
 		if (ret)
 			goto clkput;
@@ -1292,7 +1292,7 @@ static int serial_imx_probe(struct platf
=20
 	return 0;
 deinit:
-	if (pdata->exit)
+	if (pdata && pdata->exit)
 		pdata->exit(pdev);
 clkput:
 	clk_put(sport->clk);
@@ -1321,7 +1321,7 @@ static int serial_imx_remove(struct plat
=20
 	clk_disable(sport->clk);
=20
-	if (pdata->exit)
+	if (pdata && pdata->exit)
 		pdata->exit(pdev);
=20
 	iounmap(sport->port.membase);
_

Patches currently in -mm which might be from baruch@tkos.co.il are

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

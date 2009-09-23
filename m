From: akpm@linux-foundation.org
Subject: [merged] mtd-register-orion_nand-using-platform_driver_probe.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:05:00 -0700
Message-ID: <200909232005.n8NK50Or022479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243AbZIWUF4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:05:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, buytenh@marvell.com, dwmw2@infradead.org, gregkh@suse.de, joern@logfs.org, nico@marvell.com, saeed@marvell.com, mm-commits@vger.kernel.org


The patch titled
     mtd: register orion_nand using platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     mtd-register-orion_nand-using-platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mtd: register orion_nand using platform_driver_probe()
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

orion_nand_probe lives in .init.text, so using platform_driver_register=
 to
register it is wrong because binding a device after the init memory is
discarded (e.g.  via sysfs) results in an oops.

As requested by Nicolas Pitre platform_driver_probe is used instead of
moving the probe function to .devinit.text as proposed initially.  This
saves some memory, but devices registered after the driver is probed ar=
e
not bound (probably there are none) and binding via sysfs isn't possibl=
e.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Lennert Buytenhek <buytenh@marvell.com>
Cc: Saeed Bishara <saeed@marvell.com>
Cc: Joern Engel <joern@logfs.org>
Acked-by: Nicolas Pitre <nico@marvell.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/orion_nand.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mtd/nand/orion_nand.c~mtd-register-orion_nand-using-p=
latform_driver_probe drivers/mtd/nand/orion_nand.c
--- a/drivers/mtd/nand/orion_nand.c~mtd-register-orion_nand-using-platf=
orm_driver_probe
+++ a/drivers/mtd/nand/orion_nand.c
@@ -171,7 +171,6 @@ static int __devexit orion_nand_remove(s
 }
=20
 static struct platform_driver orion_nand_driver =3D {
-	.probe		=3D orion_nand_probe,
 	.remove		=3D __devexit_p(orion_nand_remove),
 	.driver		=3D {
 		.name	=3D "orion_nand",
@@ -181,7 +180,7 @@ static struct platform_driver orion_nand
=20
 static int __init orion_nand_init(void)
 {
-	return platform_driver_register(&orion_nand_driver);
+	return platform_driver_probe(&orion_nand_driver, orion_nand_probe);
 }
=20
 static void __exit orion_nand_exit(void)
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

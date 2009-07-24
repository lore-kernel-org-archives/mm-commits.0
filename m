From: akpm@linux-foundation.org
Subject: + mtd-register-orion_nand-using-platform_driver_probe.patch added to -mm tree
Date: Fri, 24 Jul 2009 14:16:11 -0700
Message-ID: <200907242116.n6OLGB3Z003130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281AbZGXVRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 17:17:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, buytenh@marvell.com, dwmw2@infradead.org, gregkh@suse.de, joern@logfs.org, nico@marvell.com, saeed@marvell.com


The patch titled
     mtd: register orion_nand using platform_driver_probe()
has been added to the -mm tree.  Its filename is
     mtd-register-orion_nand-using-platform_driver_probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mtd-register-orion_nand-using-platform_driver_probe.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

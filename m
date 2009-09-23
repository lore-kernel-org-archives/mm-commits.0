From: akpm@linux-foundation.org
Subject: [merged] mmc-register-mmci-omap-hs-using-platform_driver_probe.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:54:15 -0700
Message-ID: <200909231954.n8NJsFJ9000340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662AbZIWTzy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:55:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, akpm@linux-foundation.org, alowe@mvista.com, dbrownell@users.sourceforge.net, drzeus@drzeus.cx, ext-adrian.hunter@nokia.com, gregkh@suse.de, ian@mnemen


The patch titled
     mmc: register mmci-omap-hs using platform_driver_probe
has been removed from the -mm tree.  Its filename was
     mmc-register-mmci-omap-hs-using-platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mmc: register mmci-omap-hs using platform_driver_probe
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

omap_mmc_probe lives in .init.text, so using platform_driver_register t=
o
register it is wrong because binding a device after the init memory is
discarded (e.g.  via sysfs) results in an oops.

As requested by David Brownell platform_driver_probe is used instead of
moving the probe function to .devinit.text as proposed initially.  This
saves some memory, but devices registered after the driver is probed ar=
e
not bound (probably there are none) and binding via sysfs isn't possibl=
e.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Jean Pihet <jpihet@mvista.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andy Lowe <alowe@mvista.com>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Madhusudhan Chikkature<madhu.cr@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Philip Langdale <philipl@overt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~mmc-register-mmci-omap-hs-using=
-platform_driver_probe drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~mmc-register-mmci-omap-hs-using-pla=
tform_driver_probe
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -1314,7 +1314,6 @@ clk_en_err:
 #endif
=20
 static struct platform_driver omap_mmc_driver =3D {
-	.probe		=3D omap_mmc_probe,
 	.remove		=3D omap_mmc_remove,
 	.suspend	=3D omap_mmc_suspend,
 	.resume		=3D omap_mmc_resume,
@@ -1327,7 +1326,7 @@ static struct platform_driver omap_mmc_d
 static int __init omap_mmc_init(void)
 {
 	/* Register the MMC driver */
-	return platform_driver_register(&omap_mmc_driver);
+	return platform_driver_probe(&omap_mmc_driver, omap_mmc_probe);
 }
=20
 static void __exit omap_mmc_cleanup(void)
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

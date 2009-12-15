From: akpm@linux-foundation.org
Subject: [merged] mxcmmc-fix-error-path-in-mxcmci_probe.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:23 -0800
Message-ID: <200912152158.nBFLwNQd015808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934002AbZLOWQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:16:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, drzeus@drzeus.cx, linux-mmc@vger.kernel.org, mfuzzey@gmail.com, pierre@ossman.eu, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     mxcmmc: fix error path in mxcmci_probe
has been removed from the -mm tree.  Its filename was
     mxcmmc-fix-error-path-in-mxcmci_probe.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mxcmmc: fix error path in mxcmci_probe
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

After a failing allocation of mmc or a failed ioremap in mxcmci_probe h=
ost was
used uninitialized.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Martin Fuzzey <mfuzzey@gmail.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/mxcmmc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/host/mxcmmc.c~mxcmmc-fix-error-path-in-mxcmci_pro=
be drivers/mmc/host/mxcmmc.c
--- a/drivers/mmc/host/mxcmmc.c~mxcmmc-fix-error-path-in-mxcmci_probe
+++ a/drivers/mmc/host/mxcmmc.c
@@ -679,17 +679,17 @@ static int mxcmci_probe(struct platform_
 {
 	struct mmc_host *mmc;
 	struct mxcmci_host *host =3D NULL;
-	struct resource *r;
+	struct resource *iores, *r;
 	int ret =3D 0, irq;
=20
 	printk(KERN_INFO "i.MX SDHC driver\n");
=20
-	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	iores =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq =3D platform_get_irq(pdev, 0);
-	if (!r || irq < 0)
+	if (!iores || irq < 0)
 		return -EINVAL;
=20
-	r =3D request_mem_region(r->start, resource_size(r), pdev->name);
+	r =3D request_mem_region(iores->start, resource_size(iores), pdev->na=
me);
 	if (!r)
 		return -EBUSY;
=20
@@ -809,7 +809,7 @@ out_iounmap:
 out_free:
 	mmc_free_host(mmc);
 out_release_mem:
-	release_mem_region(host->res->start, resource_size(host->res));
+	release_mem_region(iores->start, resource_size(iores));
 	return ret;
 }
=20
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
rtc-add-freescale-mc13783-rtc-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

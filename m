From: akpm@linux-foundation.org
Subject: + sdhci-pltfm-do-not-print-errors-in-case-of-an-extended-iomem-size.patch added to -mm tree
Date: Mon, 22 Mar 2010 12:31:02 -0700
Message-ID: <201003221931.o2MJV2Yx022738__37363.3763673299$1269286288$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab0CVTbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 15:31:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ben@simtec.co.uk, david.vrabel@csr.com, linux-mmc@vger.kernel.org, pierre@ossman.eu, richard.rojfors@pelagicore.com


The patch titled
     sdhci-pltfm: do not print errors in case of an extended iomem size
has been added to the -mm tree.  Its filename is
     sdhci-pltfm-do-not-print-errors-in-case-of-an-extended-iomem-size.=
patch

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
Subject: sdhci-pltfm: do not print errors in case of an extended iomem =
size
=46rom: Anton Vorontsov <avorontsov@ru.mvista.com>

Some hosts have an extended SDHCI iomem size, so the driver should
only print errors if the iomem size is less than 0x100.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-pltfm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci-pltfm.c~sdhci-pltfm-do-not-print-error=
s-in-case-of-an-extended-iomem-size drivers/mmc/host/sdhci-pltfm.c
--- a/drivers/mmc/host/sdhci-pltfm.c~sdhci-pltfm-do-not-print-errors-in=
-case-of-an-extended-iomem-size
+++ a/drivers/mmc/host/sdhci-pltfm.c
@@ -61,7 +61,7 @@ static int __devinit sdhci_pltfm_probe(s
 		goto err;
 	}
=20
-	if (resource_size(iomem) !=3D 0x100)
+	if (resource_size(iomem) < 0x100)
 		dev_err(&pdev->dev, "Invalid iomem size. You may "
 			"experience problems.\n");
=20
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com a=
re

linux-next.patch
gpiolib-introduce-chip-addition-removal-notifier.patch
of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips.pa=
tch
of-gpio-implement-gpiolib-notifier-hooks.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff.patch
gpiolib-cosmetic-improvements-for-error-handling-in-gpiochip_add.patch
sdhci-implement-cap_clock_base_broken-quirk.patch
sdhci-pltfm-implement-platform-data-passing.patch
sdhci-pltfm-do-not-print-errors-in-case-of-an-extended-iomem-size.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

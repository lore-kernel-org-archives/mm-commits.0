From: akpm@linux-foundation.org
Subject: [obsolete] mtd-nand-fix-build-failure-caused-by-typo.patch removed from -mm tree
Date: Tue, 09 Feb 2010 11:01:53 -0800
Message-ID: <201002091901.o19J1rT1028093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169Ab0BITCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 14:02:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterhuewe@gmx.de, dedekind1@gmail.com, dwmw2@infradead.org, hsweeten@visionengravers.com, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     mtd/nand: fix build failure caused by typo
has been removed from the -mm tree.  Its filename was
     mtd-nand-fix-build-failure-caused-by-typo.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mtd/nand: fix build failure caused by typo
=46rom: Peter Huewe <peterhuewe@gmx.de>

=46ix a build failure introduced by the patch

    mtd: orion_nand.c: add error handling and use resource_size()

The patch assigns something to a undeclared variable 'err', whereas the
rest of the code uses 'ret' for this task.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/orion_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/orion_nand.c~mtd-nand-fix-build-failure-caus=
ed-by-typo drivers/mtd/nand/orion_nand.c
--- a/drivers/mtd/nand/orion_nand.c~mtd-nand-fix-build-failure-caused-b=
y-typo
+++ a/drivers/mtd/nand/orion_nand.c
@@ -92,7 +92,7 @@ static int __init orion_nand_probe(struc
=20
 	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-		err =3D -ENODEV;
+		ret =3D -ENODEV;
 		goto no_res;
 	}
=20
_

Patches currently in -mm which might be from peterhuewe@gmx.de are

mtd-nand-fix-build-failure-caused-by-typo.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

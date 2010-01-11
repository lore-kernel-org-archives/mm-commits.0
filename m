From: akpm@linux-foundation.org
Subject: + mtd-nand-fix-build-failure-caused-by-typo.patch added to -mm tree
Date: Mon, 11 Jan 2010 15:54:34 -0800
Message-ID: <201001112354.o0BNsYhL003849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139Ab0AKXzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 18:55:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterhuewe@gmx.de, dwmw2@infradead.org, hsweeten@visionengravers.com, u.kleine-koenig@pengutronix.de


The patch titled
     mtd/nand: fix build failure caused by typo
has been added to the -mm tree.  Its filename is
     mtd-nand-fix-build-failure-caused-by-typo.patch

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

linux-next.patch
mtd-nand-fix-build-failure-caused-by-typo.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

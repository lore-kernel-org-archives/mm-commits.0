From: akpm@linux-foundation.org
Subject: [merged] lis3-free-regulators-if-probe-fails.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:13:33 -0700
Message-ID: <201111012113.pA1LDXwB014007@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29716 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.piel@tremplin-utc.net, cascardo@holoscopio.com, chunkeey@googlemail.com, ilkka.koskinen@nokia.com, lyall.pearce@hp.com, m-starostik@versanet.de, mjg@redhat.com, witold.pilat@gmai


The patch titled
     Subject: lis3: free regulators if probe() fails
has been removed from the -mm tree.  Its filename was
     lis3-free-regulators-if-probe-fails.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: =C9ric Piel <eric.piel@tremplin-utc.net>
Subject: lis3: free regulators if probe() fails

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Witold Pilat <witold.pilat@gmail.com>
Cc: Lyall Pearce <lyall.pearce@hp.com>
Cc: Malte Starostik <m-starostik@versanet.de>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d_i2c.c~lis3-free-regulators-i=
f-probe-fails drivers/misc/lis3lv02d/lis3lv02d_i2c.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c~lis3-free-regulators-if-pr=
obe-fails
+++ a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -161,8 +161,13 @@ static int __devinit lis3lv02d_i2c_probe
 	if (lis3_dev.reg_ctrl)
 		lis3_reg_ctrl(&lis3_dev, LIS3_REG_OFF);
=20
-	if (ret =3D=3D 0)
-		return 0;
+	if (ret)
+		goto fail2;
+	return 0;
+
+fail2:
+	regulator_bulk_free(ARRAY_SIZE(lis3_dev.regulators),
+				lis3_dev.regulators);
 fail:
 	if (pdata && pdata->release_resources)
 		pdata->release_resources();
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

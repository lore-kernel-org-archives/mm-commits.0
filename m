From: akpm@linux-foundation.org
Subject: [merged] rtc-make-of_device_ids-const.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:20:24 -0700
Message-ID: <543d6968.MmAn+V5OfPp8Qi3D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbaJNSUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: make of_device_ids const
has been removed from the -mm tree.  Its filename was
     rtc-make-of_device_ids-const.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Subject: rtc: make of_device_ids const

of_device_ids (i.e.  compatible strings and the respective data) are no=
t
supposed to change at runtime.  All functions working with of_device_id=
s
provided by <linux/of.h> work with const of_device_ids.  This allows to
mark all struct of_device_id below drivers/rtc const, too.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12022.c |    2 +-
 drivers/rtc/rtc-mpc5121.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-isl12022.c~rtc-make-of_device_ids-const drive=
rs/rtc/rtc-isl12022.c
--- a/drivers/rtc/rtc-isl12022.c~rtc-make-of_device_ids-const
+++ a/drivers/rtc/rtc-isl12022.c
@@ -274,7 +274,7 @@ static int isl12022_probe(struct i2c_cli
 }
=20
 #ifdef CONFIG_OF
-static struct of_device_id isl12022_dt_match[] =3D {
+static const struct of_device_id isl12022_dt_match[] =3D {
 	{ .compatible =3D "isl,isl12022" },
 	{ },
 };
diff -puN drivers/rtc/rtc-mpc5121.c~rtc-make-of_device_ids-const driver=
s/rtc/rtc-mpc5121.c
--- a/drivers/rtc/rtc-mpc5121.c~rtc-make-of_device_ids-const
+++ a/drivers/rtc/rtc-mpc5121.c
@@ -401,7 +401,7 @@ static int mpc5121_rtc_remove(struct pla
 }
=20
 #ifdef CONFIG_OF
-static struct of_device_id mpc5121_rtc_match[] =3D {
+static const struct of_device_id mpc5121_rtc_match[] =3D {
 	{ .compatible =3D "fsl,mpc5121-rtc", },
 	{ .compatible =3D "fsl,mpc5200-rtc", },
 	{},
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

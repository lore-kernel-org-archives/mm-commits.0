From: akpm@linux-foundation.org
Subject: + rtc-make-of_device_ids-const.patch added to -mm tree
Date: Wed, 10 Sep 2014 13:27:15 -0700
Message-ID: <5410b423.rhbb4wXOMBoorRxb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaIJU1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 16:27:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: make of_device_ids const
has been added to the -mm tree.  Its filename is
     rtc-make-of_device_ids-const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-make-of_device_ids-con=
st.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-make-of_device_ids-con=
st.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-make-of_device_ids-const.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

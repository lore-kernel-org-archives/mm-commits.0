From: akpm@google.com
Subject: + rtc-mc13xxx-move-probe-and-remove-callbacks-to-inittext-and-exittext.patch added to -mm tree
Date: Mon, 26 Sep 2011 16:58:04 -0700
Message-ID: <201109262358.p8QNw447015511@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:3609 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1IZX7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2011 19:59:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-mc13xxx.c: move probe and remove callback=
s to .init.text and .exit.text
has been added to the -mm tree.  Its filename is
     rtc-mc13xxx-move-probe-and-remove-callbacks-to-inittext-and-exitte=
xt.patch

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
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Subject: drivers/rtc/rtc-mc13xxx.c: move probe and remove callbacks to =
=2Einit.text and .exit.text

The driver is added using platform_driver_probe(), so the callbacks can=
 be
discarded more aggessively.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/rtc/rtc-mc13xxx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-move-probe-and-remove-c=
allbacks-to-inittext-and-exittext drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-move-probe-and-remove-callb=
acks-to-inittext-and-exittext
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -309,7 +309,7 @@ static irqreturn_t mc13xxx_rtc_reset_han
 	return IRQ_HANDLED;
 }
=20
-static int __devinit mc13xxx_rtc_probe(struct platform_device *pdev)
+static int __init mc13xxx_rtc_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct mc13xxx_rtc *priv;
@@ -378,7 +378,7 @@ err_reset_irq_request:
 	return ret;
 }
=20
-static int __devexit mc13xxx_rtc_remove(struct platform_device *pdev)
+static int __exit mc13xxx_rtc_remove(struct platform_device *pdev)
 {
 	struct mc13xxx_rtc *priv =3D platform_get_drvdata(pdev);
=20
@@ -410,7 +410,7 @@ const struct platform_device_id mc13xxx_
=20
 static struct platform_driver mc13xxx_rtc_driver =3D {
 	.id_table =3D mc13xxx_rtc_idtable,
-	.remove =3D __devexit_p(mc13xxx_rtc_remove),
+	.remove =3D __exit_p(mc13xxx_rtc_remove),
 	.driver =3D {
 		.name =3D DRIVER_NAME,
 		.owner =3D THIS_MODULE,
_
Subject: Subject: drivers/rtc/rtc-mc13xxx.c: move probe and remove call=
backs to .init.text and .exit.text

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
rtc-mc13xxx-move-probe-and-remove-callbacks-to-inittext-and-exittext.pa=
tch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

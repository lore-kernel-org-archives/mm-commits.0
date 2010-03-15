From: akpm@linux-foundation.org
Subject: [merged] w1-mxc_w1-move-probe-and-remove-to-the-dev-text-area.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:37 -0400
Message-ID: <201003150705.o2F75AEZ017070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759708Ab0COHF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maramaopercheseimorto@gmail.com, johnpol@2ka.mipt.ru, s.hauer@pengutronix.de, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     w1: mxc_w1: move probe() and remove() to the dev* text area
has been removed from the -mm tree.  Its filename was
     w1-mxc_w1-move-probe-and-remove-to-the-dev-text-area.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: w1: mxc_w1: move probe() and remove() to the dev* text area
=46rom: Alberto Panizzo <maramaopercheseimorto@gmail.com>

This fixes the section mismatch warning for mxc_w1_probe()

Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/mxc_w1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/w1/masters/mxc_w1.c~w1-mxc_w1-move-probe-and-remove-t=
o-the-dev-text-area drivers/w1/masters/mxc_w1.c
--- a/drivers/w1/masters/mxc_w1.c~w1-mxc_w1-move-probe-and-remove-to-th=
e-dev-text-area
+++ a/drivers/w1/masters/mxc_w1.c
@@ -102,7 +102,7 @@ static u8 mxc_w1_ds2_touch_bit(void *dat
 	return ((__raw_readb(ctrl_addr)) >> 3) & 0x1;
 }
=20
-static int __init mxc_w1_probe(struct platform_device *pdev)
+static int __devinit mxc_w1_probe(struct platform_device *pdev)
 {
 	struct mxc_w1_device *mdev;
 	struct resource *res;
@@ -166,7 +166,7 @@ failed_clk:
 /*
  * disassociate the w1 device from the driver
  */
-static int mxc_w1_remove(struct platform_device *pdev)
+static int __devexit mxc_w1_remove(struct platform_device *pdev)
 {
 	struct mxc_w1_device *mdev =3D platform_get_drvdata(pdev);
 	struct resource *res;
_

Patches currently in -mm which might be from maramaopercheseimorto@gmai=
l.com are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

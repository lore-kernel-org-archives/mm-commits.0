From: akpm@linux-foundation.org
Subject: [merged] rtc-pcf2123-move-pcf2123_remove-to-devexittext.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:25 -0800
Message-ID: <201003091910.o29JAPen031593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971Ab0CITLq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:11:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it, chripell@fsfe.org, chrisv@cyberswitching.com, p_gortmaker@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     rtc-pcf2123: move pcf2123_remove to .devexit.text
has been removed from the -mm tree.  Its filename was
     rtc-pcf2123-move-pcf2123_remove-to-devexittext.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: rtc-pcf2123: move pcf2123_remove to .devexit.text
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

The function pcf2123_remove is used only wrapped by __devexit_p so defi=
ne
it using __devexit.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Christian Pellegrin <chripell@fsfe.org>
Cc: Chris Verges <chrisv@cyberswitching.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2123.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf2123.c~rtc-pcf2123-move-pcf2123_remove-to-=
devexittext drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~rtc-pcf2123-move-pcf2123_remove-to-deve=
xittext
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -315,7 +315,7 @@ kfree_exit:
 	return ret;
 }
=20
-static int pcf2123_remove(struct spi_device *spi)
+static int __devexit pcf2123_remove(struct spi_device *spi)
 {
 	struct pcf2123_plat_data *pdata =3D spi->dev.platform_data;
 	int i;
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
rtc-hctosys-only-claim-the-rtc-provided-the-system-time-if-it-did.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
timer-print-function-name-for-timer-callbacks-modifying-preemption-coun=
t.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
w1-mxc_w1-move-probe-and-remove-to-the-dev-text-area.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

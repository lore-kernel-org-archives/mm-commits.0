From: akpm@osdl.org
Subject: - rtc-sh-correctly-report-rtc_wkalrmenabled.patch removed from -mm tree
Date: Fri, 12 Jan 2007 14:17:41 -0800
Message-ID: <200701122217.l0CMHfni030745@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39057 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161139AbXALWSE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:18:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     rtc-sh: correctly report rtc_wkalrm.enabled
has been removed from the -mm tree.  Its filename was
     rtc-sh-correctly-report-rtc_wkalrmenabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-sh: correctly report rtc_wkalrm.enabled
From: David Brownell <david-b@pacbell.net>

This fixes the SH rtc driver to
  (a) correctly report 'enabled' status with other alarm status;
  (b) not duplicate that status in its procfs dump

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/rtc-sh.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-sh.c~rtc-sh-correctly-report-rtc_wkalrmenabled drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-sh-correctly-report-rtc_wkalrmenabled
+++ a/drivers/rtc/rtc-sh.c
@@ -264,8 +264,6 @@ static int sh_rtc_proc(struct device *de
 	unsigned int tmp;
 
 	tmp = readb(rtc->regbase + RCR1);
-	seq_printf(seq, "alarm_IRQ\t: %s\n",
-		   (tmp & RCR1_AIE) ? "yes" : "no");
 	seq_printf(seq, "carry_IRQ\t: %s\n",
 		   (tmp & RCR1_CIE) ? "yes" : "no");
 
@@ -428,6 +426,8 @@ static int sh_rtc_read_alarm(struct devi
 		tm->tm_mon -= 1; /* RTC is 1-12, tm_mon is 0-11 */
 	tm->tm_year     = 0xffff;
 
+	wkalrm->enabled = (readb(rtc->regbase + RCR1) & RCR1_AIE) ? 1 : 0;
+
 	spin_unlock_irq(&rtc->lock);
 
 	return 0;
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc-sh-act-on-rtc_wkalrmenabled-when-setting-an-alarm.patch
git-dvb.patch
git-mmc.patch
8250-make-probing-for-txen-bug-a-config-option.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-update.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
pnp-export-pnp_bus_type.patch
rtc-framework-driver-for-cmos-rtcs.patch
spi-freescale-imx-spi-controller-driver.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch

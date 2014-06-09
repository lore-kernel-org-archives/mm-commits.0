From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-bfinc-do-not-abort-when-requesting-irq-fails.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:30:27 -0700
Message-ID: <53960b53.yNEvMRtmMt15bXjH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbaFITa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:30:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, alnovak@suse.cz, a.zummo@towertech.it, vapier@gentoo.org

Subject: [merged] drivers-rtc-rtc-bfinc-do-not-abort-when-requesting-irq-fails.patch removed from -mm tree
To: vapier@gentoo.org,a.zummo@towertech.it,alnovak@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:30:27 -0700


The patch titled
     Subject: drivers/rtc/rtc-bfin.c: do not abort when requesting irq fails
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-bfinc-do-not-abort-when-requesting-irq-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Frysinger <vapier@gentoo.org>
Subject: drivers/rtc/rtc-bfin.c: do not abort when requesting irq fails

The RTC framework does not let you return an error once a call to
devm_rtc_device_register has succeeded.  Avoid doing that when the IRQ
request fails as we can still support reading/writing the clock without
the IRQ.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Reported-by: Ales Novak <alnovak@suse.cz>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~drivers-rtc-rtc-bfinc-do-not-abort-when-requesting-irq-fails drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~drivers-rtc-rtc-bfinc-do-not-abort-when-requesting-irq-fails
+++ a/drivers/rtc/rtc-bfin.c
@@ -346,7 +346,7 @@ static int bfin_rtc_probe(struct platfor
 {
 	struct bfin_rtc *rtc;
 	struct device *dev = &pdev->dev;
-	int ret = 0;
+	int ret;
 	unsigned long timeout = jiffies + HZ;
 
 	dev_dbg_stamp(dev);
@@ -361,16 +361,17 @@ static int bfin_rtc_probe(struct platfor
 	/* Register our RTC with the RTC framework */
 	rtc->rtc_dev = devm_rtc_device_register(dev, pdev->name, &bfin_rtc_ops,
 						THIS_MODULE);
-	if (unlikely(IS_ERR(rtc->rtc_dev))) {
-		ret = PTR_ERR(rtc->rtc_dev);
-		goto err;
-	}
+	if (unlikely(IS_ERR(rtc->rtc_dev)))
+		return PTR_ERR(rtc->rtc_dev);
 
 	/* Grab the IRQ and init the hardware */
 	ret = devm_request_irq(dev, IRQ_RTC, bfin_rtc_interrupt, 0,
 				pdev->name, dev);
 	if (unlikely(ret))
-		goto err;
+		dev_err(&pdev->dev,
+			"unable to request IRQ; alarm won't work, "
+			"and writes will be delayed\n");
+
 	/* sometimes the bootloader touched things, but the write complete was not
 	 * enabled, so let's just do a quick timeout here since the IRQ will not fire ...
 	 */
@@ -381,9 +382,6 @@ static int bfin_rtc_probe(struct platfor
 	bfin_write_RTC_SWCNT(0);
 
 	return 0;

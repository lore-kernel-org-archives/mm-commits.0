From: akpm@linux-foundation.org
Subject: - rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:52 -0800
Message-ID: <200901072218.n07MIq8o018293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763399AbZAGWhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, a.zummo@towertech.it, david-b@pacbell.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     rtc: struct device: replace bus_id with dev_name(), dev_set_name()
has been removed from the -mm tree.  Its filename was
     rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: struct device: replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>

Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Acked-By: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c     |   16 ++++++----------
 drivers/rtc/interface.c |    2 +-
 drivers/rtc/rtc-cmos.c  |   10 +++++-----
 3 files changed, 12 insertions(+), 16 deletions(-)

diff -puN drivers/rtc/class.c~rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name
+++ a/drivers/rtc/class.c
@@ -48,9 +48,7 @@ static int rtc_suspend(struct device *de
 	struct rtc_time		tm;
 	struct timespec		ts = current_kernel_time();
 
-	if (strncmp(rtc->dev.bus_id,
-				CONFIG_RTC_HCTOSYS_DEVICE,
-				BUS_ID_SIZE) != 0)
+	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
 	rtc_read_time(rtc, &tm);
@@ -71,20 +69,18 @@ static int rtc_resume(struct device *dev
 	time_t			newtime;
 	struct timespec		time;
 
-	if (strncmp(rtc->dev.bus_id,
-				CONFIG_RTC_HCTOSYS_DEVICE,
-				BUS_ID_SIZE) != 0)
+	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
 	rtc_read_time(rtc, &tm);
 	if (rtc_valid_tm(&tm) != 0) {
-		pr_debug("%s:  bogus resume time\n", rtc->dev.bus_id);
+		pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
 		return 0;
 	}
 	rtc_tm_to_time(&tm, &newtime);
 	if (newtime <= oldtime) {
 		if (newtime < oldtime)
-			pr_debug("%s:  time travel!\n", rtc->dev.bus_id);
+			pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
 		return 0;
 	}
 
@@ -156,7 +152,7 @@ struct rtc_device *rtc_device_register(c
 	init_waitqueue_head(&rtc->irq_queue);
 
 	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
-	snprintf(rtc->dev.bus_id, BUS_ID_SIZE, "rtc%d", id);
+	dev_set_name(&rtc->dev, "rtc%d", id);
 
 	rtc_dev_prepare(rtc);
 
@@ -169,7 +165,7 @@ struct rtc_device *rtc_device_register(c
 	rtc_proc_add_device(rtc);
 
 	dev_info(dev, "rtc core: registered %s as %s\n",
-			rtc->name, rtc->dev.bus_id);
+			rtc->name, dev_name(&rtc->dev));
 
 	return rtc;
 
diff -puN drivers/rtc/interface.c~rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name
+++ a/drivers/rtc/interface.c
@@ -389,7 +389,7 @@ static int __rtc_match(struct device *de
 {
 	char *name = (char *)data;
 
-	if (strncmp(dev->bus_id, name, BUS_ID_SIZE) == 0)
+	if (strcmp(dev_name(dev), name) == 0)
 		return 1;
 	return 0;
 }
diff -puN drivers/rtc/rtc-cmos.c~rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name
+++ a/drivers/rtc/rtc-cmos.c
@@ -729,7 +729,7 @@ cmos_do_probe(struct device *dev, struct
 
 	cmos_rtc.dev = dev;
 	dev_set_drvdata(dev, &cmos_rtc);
-	rename_region(ports, cmos_rtc.rtc->dev.bus_id);
+	rename_region(ports, dev_name(&cmos_rtc.rtc->dev));
 
 	spin_lock_irq(&rtc_lock);
 
@@ -777,7 +777,7 @@ cmos_do_probe(struct device *dev, struct
 			rtc_cmos_int_handler = cmos_interrupt;
 
 		retval = request_irq(rtc_irq, rtc_cmos_int_handler,
-				IRQF_DISABLED, cmos_rtc.rtc->dev.bus_id,
+				IRQF_DISABLED, dev_name(&cmos_rtc.rtc->dev),
 				cmos_rtc.rtc);
 		if (retval < 0) {
 			dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
@@ -795,7 +795,7 @@ cmos_do_probe(struct device *dev, struct
 	}
 
 	pr_info("%s: alarms up to one %s%s, %zd bytes nvram%s\n",
-			cmos_rtc.rtc->dev.bus_id,
+			dev_name(&cmos_rtc.rtc->dev),
 			is_valid_irq(rtc_irq)
 				?  (cmos_rtc.mon_alrm
 					? "year"
@@ -885,7 +885,7 @@ static int cmos_suspend(struct device *d
 	}
 
 	pr_debug("%s: suspend%s, ctrl %02x\n",
-			cmos_rtc.rtc->dev.bus_id,
+			dev_name(&cmos_rtc.rtc->dev),
 			(tmp & RTC_AIE) ? ", alarm may wake" : "",
 			tmp);
 
@@ -941,7 +941,7 @@ static int cmos_resume(struct device *de
 	}
 
 	pr_debug("%s: resume, ctrl %02x\n",
-			cmos_rtc.rtc->dev.bus_id,
+			dev_name(&cmos_rtc.rtc->dev),
 			tmp);
 
 	return 0;
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch
linux-next.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch


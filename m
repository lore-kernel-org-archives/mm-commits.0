From: akpm@linux-foundation.org
Subject: + rtc-fix-missing-id_table-in-rtc-ds1672-and-rtc-max6900-drivers.patch added to -mm tree
Date: Tue, 02 Dec 2008 20:39:22 -0800
Message-ID: <200812030439.mB34dMrh017919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879AbYLCEjk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 23:39:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.zummo@towertech.it, david-b@pacbell.net, kaloz@openwrt.org


The patch titled
     rtc: fix missing id_table in rtc-ds1672 and rtc-max6900 drivers
has been added to the -mm tree.  Its filename is
     rtc-fix-missing-id_table-in-rtc-ds1672-and-rtc-max6900-drivers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: fix missing id_table in rtc-ds1672 and rtc-max6900 drivers
From: Alessandro Zummo <a.zummo@towertech.it>

Add missing id_table to the drivers in subject.  Patch is against the
latest git.  It should go in with 2.6.28 if possible, the drivers won't
work without the id_table bits.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Reported-by: <kaloz@openwrt.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1672.c  |    6 ++++++
 drivers/rtc/rtc-max6900.c |    6 ++++++
 2 files changed, 12 insertions(+)

diff -puN drivers/rtc/rtc-ds1672.c~rtc-fix-missing-id_table-in-rtc-ds1672-and-rtc-max6900-drivers drivers/rtc/rtc-ds1672.c
--- a/drivers/rtc/rtc-ds1672.c~rtc-fix-missing-id_table-in-rtc-ds1672-and-rtc-max6900-drivers
+++ a/drivers/rtc/rtc-ds1672.c
@@ -209,12 +209,18 @@ static int ds1672_probe(struct i2c_clien
 	return err;
 }
 
+static struct i2c_device_id ds1672_id[] = {
+	{ "ds1672", 0 },
+	{ }
+};
+
 static struct i2c_driver ds1672_driver = {
 	.driver = {
 		   .name = "rtc-ds1672",
 		   },
 	.probe = &ds1672_probe,
 	.remove = &ds1672_remove,
+	.id_table = ds1672_id,
 };
 
 static int __init ds1672_init(void)
diff -puN drivers/rtc/rtc-max6900.c~rtc-fix-missing-id_table-in-rtc-ds1672-and-rtc-max6900-drivers drivers/rtc/rtc-max6900.c
--- a/drivers/rtc/rtc-max6900.c~rtc-fix-missing-id_table-in-rtc-ds1672-and-rtc-max6900-drivers
+++ a/drivers/rtc/rtc-max6900.c
@@ -247,12 +247,18 @@ max6900_probe(struct i2c_client *client,
 	return 0;
 }
 
+static struct i2c_device_id max6900_id[] = {
+	{ "max6900", 0 },
+	{ }
+};
+
 static struct i2c_driver max6900_driver = {
 	.driver = {
 		   .name = "rtc-max6900",
 		   },
 	.probe = max6900_probe,
 	.remove = max6900_remove,
+	.id_table = max6900_id,
 };
 
 static int __init max6900_init(void)
_

Patches currently in -mm which might be from a.zummo@towertech.it are

rtc-fix-missing-id_table-in-rtc-ds1672-and-rtc-max6900-drivers.patch
linux-next.patch
genrtc-disable-genrtc-on-blackfin-systems.patch
rtc-ds1307-smbus-compatibility.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2.patch
rtc-driver-for-pxa27x-and-pxa3xx-soc.patch
rtc-pxa27x-pxa3xx-driver-fixes-revised.patch
rtc-add-alarm-update-irq-interfaces-version-5.patch
rtc-rtc-ds1390-probe-sequence-and-misc-fixes.patch
rtc-kconfig-cleanup.patch
rtc-au1000-on-chip-counter0-as-rtc-driver.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
rtc-rtc-max6902-fixes-v3.patch
rtc-rtc-ds3234-fixes-v2.patch
rtc-use-set_mmss-when-set_time-is-not-available.patch
rtc-add-rtc-tx4939-driver-v2.patch
rtc-rtc-ds1216-fixes.patch


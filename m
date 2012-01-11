From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-remove-redundant-spi-driver-bus-initialization.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:38 -0800
Message-ID: <20120111213239.176D05C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:60913 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab2AKVcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:41 -0500
Received: by eaad12 with SMTP id d12so32668eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lars@metafoo.de, a.zummo@towertech.it, grant.likely@secretlab.ca, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/: remove redundant spi driver bus initialization
has been removed from the -mm tree.  Its filename was
     drivers-rtc-remove-redundant-spi-driver-bus-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Lars-Peter Clausen <lars@metafoo.de>
Subject: drivers/rtc/: remove redundant spi driver bus initialization

In ancient times it was necessary to manually initialize the bus field of
an spi_driver to spi_bus_type.  These days this is done in
spi_driver_register(), so we can drop the manual assignment.

The patch was generated using the following coccinelle semantic patch:
// <smpl>
@@
identifier _driver;
@@
struct spi_driver _driver = {
	.driver = {
-		.bus = &spi_bus_type,
	},
};
// </smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t93.c  |    1 -
 drivers/rtc/rtc-m41t94.c  |    1 -
 drivers/rtc/rtc-max6902.c |    1 -
 drivers/rtc/rtc-pcf2123.c |    1 -
 drivers/rtc/rtc-rs5c348.c |    1 -
 5 files changed, 5 deletions(-)

diff -puN drivers/rtc/rtc-m41t93.c~drivers-rtc-remove-redundant-spi-driver-bus-initialization drivers/rtc/rtc-m41t93.c
--- a/drivers/rtc/rtc-m41t93.c~drivers-rtc-remove-redundant-spi-driver-bus-initialization
+++ a/drivers/rtc/rtc-m41t93.c
@@ -200,7 +200,6 @@ static int __devexit m41t93_remove(struc
 static struct spi_driver m41t93_driver = {
 	.driver = {
 		.name	= "rtc-m41t93",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= m41t93_probe,
diff -puN drivers/rtc/rtc-m41t94.c~drivers-rtc-remove-redundant-spi-driver-bus-initialization drivers/rtc/rtc-m41t94.c
--- a/drivers/rtc/rtc-m41t94.c~drivers-rtc-remove-redundant-spi-driver-bus-initialization
+++ a/drivers/rtc/rtc-m41t94.c
@@ -147,7 +147,6 @@ static int __devexit m41t94_remove(struc
 static struct spi_driver m41t94_driver = {
 	.driver = {
 		.name	= "rtc-m41t94",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= m41t94_probe,
diff -puN drivers/rtc/rtc-max6902.c~drivers-rtc-remove-redundant-spi-driver-bus-initialization drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~drivers-rtc-remove-redundant-spi-driver-bus-initialization
+++ a/drivers/rtc/rtc-max6902.c
@@ -154,7 +154,6 @@ static int __devexit max6902_remove(stru
 static struct spi_driver max6902_driver = {
 	.driver = {
 		.name	= "rtc-max6902",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= max6902_probe,
diff -puN drivers/rtc/rtc-pcf2123.c~drivers-rtc-remove-redundant-spi-driver-bus-initialization drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~drivers-rtc-remove-redundant-spi-driver-bus-initialization
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -340,7 +340,6 @@ static int __devexit pcf2123_remove(stru
 static struct spi_driver pcf2123_driver = {
 	.driver	= {
 			.name	= "rtc-pcf2123",
-			.bus	= &spi_bus_type,
 			.owner	= THIS_MODULE,
 	},
 	.probe	= pcf2123_probe,
diff -puN drivers/rtc/rtc-rs5c348.c~drivers-rtc-remove-redundant-spi-driver-bus-initialization drivers/rtc/rtc-rs5c348.c
--- a/drivers/rtc/rtc-rs5c348.c~drivers-rtc-remove-redundant-spi-driver-bus-initialization
+++ a/drivers/rtc/rtc-rs5c348.c
@@ -229,7 +229,6 @@ static int __devexit rs5c348_remove(stru
 static struct spi_driver rs5c348_driver = {
 	.driver = {
 		.name	= "rtc-rs5c348",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= rs5c348_probe,
_

Patches currently in -mm which might be from lars@metafoo.de are

origin.patch
linux-next.patch


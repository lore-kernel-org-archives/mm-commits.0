From: akpm@linux-foundation.org
Subject: + ds1682-add-sesnsors-kconfig-variable-prefix.patch added to -mm tree
Date: Tue, 07 Aug 2007 15:50:29 -0700
Message-ID: <200708072250.l77MoTtu008952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41617 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759329AbXHGWvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:51:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: max@stro.at, grant.likely@secretlab.ca


The patch titled
     DS1682 add SESNSORS Kconfig variable prefix
has been added to the -mm tree.  Its filename is
     ds1682-add-sesnsors-kconfig-variable-prefix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: DS1682 add SESNSORS Kconfig variable prefix
From: maximilian attems <max@stro.at>

The new DS1682 chip driver "polluates" global Kconfig namespace.  make it
consistent with ds1337, ds1374 and friends.

Signed-off-by: maximilian attems <max@stro.at>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/Kconfig  |    2 +-
 drivers/i2c/chips/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/i2c/chips/Kconfig~ds1682-add-sesnsors-kconfig-variable-prefix drivers/i2c/chips/Kconfig
--- a/drivers/i2c/chips/Kconfig~ds1682-add-sesnsors-kconfig-variable-prefix
+++ a/drivers/i2c/chips/Kconfig
@@ -30,7 +30,7 @@ config SENSORS_DS1374
 	  This driver is deprecated and will be dropped soon. Use
 	  rtc-ds1374 instead.
 
-config DS1682
+config SENSORS_DS1682
 	tristate "Dallas DS1682 Total Elapsed Time Recorder with Alarm"
 	depends on EXPERIMENTAL
 	help
diff -puN drivers/i2c/chips/Makefile~ds1682-add-sesnsors-kconfig-variable-prefix drivers/i2c/chips/Makefile
--- a/drivers/i2c/chips/Makefile~ds1682-add-sesnsors-kconfig-variable-prefix
+++ a/drivers/i2c/chips/Makefile
@@ -4,7 +4,7 @@
 
 obj-$(CONFIG_SENSORS_DS1337)	+= ds1337.o
 obj-$(CONFIG_SENSORS_DS1374)	+= ds1374.o
-obj-$(CONFIG_DS1682)		+= ds1682.o
+obj-$(CONFIG_SENSORS_DS1682)	+= ds1682.o
 obj-$(CONFIG_SENSORS_EEPROM)	+= eeprom.o
 obj-$(CONFIG_SENSORS_MAX6875)	+= max6875.o
 obj-$(CONFIG_SENSORS_M41T00)	+= m41t00.o
_

Patches currently in -mm which might be from max@stro.at are

ds1682-add-sesnsors-kconfig-variable-prefix.patch
git-mtd.patch

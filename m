From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-dump-small-buffers-via-%ph.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:08 -0800
Message-ID: <20130222204308.9BC425A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:60021 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab3BVUnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:09 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103805vbi.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc: dump small buffers via %*ph
has been removed from the -mm tree.  Its filename was
     drivers-rtc-dump-small-buffers-via-%ph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: drivers/rtc: dump small buffers via %*ph

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1305.c |    8 ++------
 drivers/rtc/rtc-ds1307.c |   11 ++---------
 drivers/rtc/rtc-fm3130.c |   33 ++++-----------------------------
 3 files changed, 8 insertions(+), 44 deletions(-)

diff -puN drivers/rtc/rtc-ds1305.c~drivers-rtc-dump-small-buffers-via-%ph drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~drivers-rtc-dump-small-buffers-via-%ph
+++ a/drivers/rtc/rtc-ds1305.c
@@ -635,9 +635,7 @@ static int ds1305_probe(struct spi_devic
 		goto fail0;
 	}
 
-	dev_dbg(&spi->dev, "ctrl %s: %02x %02x %02x\n",
-			"read", ds1305->ctrl[0],
-			ds1305->ctrl[1], ds1305->ctrl[2]);
+	dev_dbg(&spi->dev, "ctrl %s: %3ph\n", "read", ds1305->ctrl);
 
 	/* Sanity check register values ... partially compensating for the
 	 * fact that SPI has no device handshake.  A pullup on MISO would
@@ -723,9 +721,7 @@ static int ds1305_probe(struct spi_devic
 			goto fail0;
 		}
 
-		dev_dbg(&spi->dev, "ctrl %s: %02x %02x %02x\n",
-				"write", ds1305->ctrl[0],
-				ds1305->ctrl[1], ds1305->ctrl[2]);
+		dev_dbg(&spi->dev, "ctrl %s: %3ph\n", "write", ds1305->ctrl);
 	}
 
 	/* see if non-Linux software set up AM/PM mode */
diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-dump-small-buffers-via-%ph drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-dump-small-buffers-via-%ph
+++ a/drivers/rtc/rtc-ds1307.c
@@ -322,12 +322,7 @@ static int ds1307_get_time(struct device
 		return -EIO;
 	}
 
-	dev_dbg(dev, "%s: %02x %02x %02x %02x %02x %02x %02x\n",
-			"read",
-			ds1307->regs[0], ds1307->regs[1],
-			ds1307->regs[2], ds1307->regs[3],
-			ds1307->regs[4], ds1307->regs[5],
-			ds1307->regs[6]);
+	dev_dbg(dev, "%s: %7ph\n", "read", ds1307->regs);
 
 	t->tm_sec = bcd2bin(ds1307->regs[DS1307_REG_SECS] & 0x7f);
 	t->tm_min = bcd2bin(ds1307->regs[DS1307_REG_MIN] & 0x7f);
@@ -398,9 +393,7 @@ static int ds1307_set_time(struct device
 		break;
 	}
 
-	dev_dbg(dev, "%s: %02x %02x %02x %02x %02x %02x %02x\n",
-		"write", buf[0], buf[1], buf[2], buf[3],
-		buf[4], buf[5], buf[6]);
+	dev_dbg(dev, "%s: %7ph\n", "write", buf);
 
 	result = ds1307->write_block_data(ds1307->client,
 		ds1307->offset, 7, buf);
diff -puN drivers/rtc/rtc-fm3130.c~drivers-rtc-dump-small-buffers-via-%ph drivers/rtc/rtc-fm3130.c
--- a/drivers/rtc/rtc-fm3130.c~drivers-rtc-dump-small-buffers-via-%ph
+++ a/drivers/rtc/rtc-fm3130.c
@@ -116,17 +116,7 @@ static int fm3130_get_time(struct device
 
 	fm3130_rtc_mode(dev, FM3130_MODE_NORMAL);
 
-	dev_dbg(dev, "%s: %02x %02x %02x %02x %02x %02x %02x %02x"
-			"%02x %02x %02x %02x %02x %02x %02x\n",
-			"read",
-			fm3130->regs[0], fm3130->regs[1],
-			fm3130->regs[2], fm3130->regs[3],
-			fm3130->regs[4], fm3130->regs[5],
-			fm3130->regs[6], fm3130->regs[7],
-			fm3130->regs[8], fm3130->regs[9],
-			fm3130->regs[0xa], fm3130->regs[0xb],
-			fm3130->regs[0xc], fm3130->regs[0xd],
-			fm3130->regs[0xe]);
+	dev_dbg(dev, "%s: %15ph\n", "read", fm3130->regs);
 
 	t->tm_sec = bcd2bin(fm3130->regs[FM3130_RTC_SECONDS] & 0x7f);
 	t->tm_min = bcd2bin(fm3130->regs[FM3130_RTC_MINUTES] & 0x7f);
@@ -175,12 +165,7 @@ static int fm3130_set_time(struct device
 	tmp = t->tm_year - 100;
 	buf[FM3130_RTC_YEARS] = bin2bcd(tmp);
 
-	dev_dbg(dev, "%s: %02x %02x %02x %02x %02x %02x %02x"
-		"%02x %02x %02x %02x %02x %02x %02x %02x\n",
-		"write", buf[0], buf[1], buf[2], buf[3],
-		buf[4], buf[5], buf[6], buf[7],
-		buf[8], buf[9], buf[0xa], buf[0xb],
-		buf[0xc], buf[0xd], buf[0xe]);
+	dev_dbg(dev, "%s: %15ph\n", "write", buf);
 
 	fm3130_rtc_mode(dev, FM3130_MODE_WRITE);
 
@@ -517,18 +502,8 @@ bad_alarm:
 bad_clock:
 
 	if (!fm3130->data_valid || !fm3130->alarm_valid)
-		dev_dbg(&client->dev,
-				"%s: %02x %02x %02x %02x %02x %02x %02x %02x"
-				"%02x %02x %02x %02x %02x %02x %02x\n",
-			"bogus registers",
-			fm3130->regs[0], fm3130->regs[1],
-			fm3130->regs[2], fm3130->regs[3],
-			fm3130->regs[4], fm3130->regs[5],
-			fm3130->regs[6], fm3130->regs[7],
-			fm3130->regs[8], fm3130->regs[9],
-			fm3130->regs[0xa], fm3130->regs[0xb],
-			fm3130->regs[0xc], fm3130->regs[0xd],
-			fm3130->regs[0xe]);
+		dev_dbg(&client->dev, "%s: %15ph\n", "bogus registers",
+			fm3130->regs);
 
 	/* We won't bail out here because we just got invalid data.
 	   Time setting from u-boot doesn't work anyway */
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch
idr-implement-lookup-hint-always-do-slow-path-when-hint-is-uninitialized.patch


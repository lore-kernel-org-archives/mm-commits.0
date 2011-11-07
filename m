From: akpm@linux-foundation.org
Subject: [merged] rtc-add-initial-support-for-mcp7941x-parts.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:26:12 -0800
Message-ID: <201111072026.pA7KQC2D027636@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5203 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1KGU0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:26:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danders.dev@gmail.com, a.zummo@towertech.it, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: add initial support for mcp7941x parts
has been removed from the -mm tree.  Its filename was
     rtc-add-initial-support-for-mcp7941x-parts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Anders <danders.dev@gmail.com>
Subject: rtc: add initial support for mcp7941x parts

Add initial support for the microchip mcp7941x series of real time clocks.

The mcp7941x series is generally compatible with the ds1307 and ds1337 rtc
devices from dallas semiconductor.  minor differences include a backup
battery enable bit, and the polarity of the oscillator enable bit.

Signed-off-by: David Anders <danders.dev@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-add-initial-support-for-mcp7941x-parts drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-add-initial-support-for-mcp7941x-parts
+++ a/drivers/rtc/rtc-ds1307.c
@@ -34,6 +34,7 @@ enum ds_type {
 	ds_1388,
 	ds_3231,
 	m41t00,
+	mcp7941x,
 	rx_8025,
 	// rs5c372 too?  different address...
 };
@@ -43,6 +44,7 @@ enum ds_type {
 #define DS1307_REG_SECS		0x00	/* 00-59 */
 #	define DS1307_BIT_CH		0x80
 #	define DS1340_BIT_nEOSC		0x80
+#	define MCP7941X_BIT_ST		0x80
 #define DS1307_REG_MIN		0x01	/* 00-59 */
 #define DS1307_REG_HOUR		0x02	/* 00-23, or 1-12{am,pm} */
 #	define DS1307_BIT_12HR		0x40	/* in REG_HOUR */
@@ -50,6 +52,7 @@ enum ds_type {
 #	define DS1340_BIT_CENTURY_EN	0x80	/* in REG_HOUR */
 #	define DS1340_BIT_CENTURY	0x40	/* in REG_HOUR */
 #define DS1307_REG_WDAY		0x03	/* 01-07 */
+#	define MCP7941X_BIT_VBATEN	0x08
 #define DS1307_REG_MDAY		0x04	/* 01-31 */
 #define DS1307_REG_MONTH	0x05	/* 01-12 */
 #	define DS1337_BIT_CENTURY	0x80	/* in REG_MONTH */
@@ -137,6 +140,8 @@ static const struct chip_desc chips[] = 
 },
 [m41t00] = {
 },
+[mcp7941x] = {
+},
 [rx_8025] = {
 }, };
 
@@ -149,6 +154,7 @@ static const struct i2c_device_id ds1307
 	{ "ds1340", ds_1340 },
 	{ "ds3231", ds_3231 },
 	{ "m41t00", m41t00 },
+	{ "mcp7941x", mcp7941x },
 	{ "pt7c4338", ds_1307 },
 	{ "rx8025", rx_8025 },
 	{ }
@@ -365,6 +371,10 @@ static int ds1307_set_time(struct device
 		buf[DS1307_REG_HOUR] |= DS1340_BIT_CENTURY_EN
 				| DS1340_BIT_CENTURY;
 		break;
+	case mcp7941x:
+		buf[DS1307_REG_SECS] |= MCP7941X_BIT_ST;
+		buf[DS1307_REG_WDAY] |= MCP7941X_BIT_VBATEN;
+		break;
 	default:
 		break;
 	}
@@ -809,6 +819,23 @@ read_rtc:
 			dev_warn(&client->dev, "SET TIME!\n");
 		}
 		break;
+	case mcp7941x:
+		/* make sure that the backup battery is enabled */
+		if (!(ds1307->regs[DS1307_REG_WDAY] & MCP7941X_BIT_VBATEN)) {
+			i2c_smbus_write_byte_data(client, DS1307_REG_WDAY,
+					ds1307->regs[DS1307_REG_WDAY]
+					| MCP7941X_BIT_VBATEN);
+		}
+
+		/* clock halted?  turn it on, so clock can tick. */
+		if (!(tmp & MCP7941X_BIT_ST)) {
+			i2c_smbus_write_byte_data(client, DS1307_REG_SECS,
+					MCP7941X_BIT_ST);
+			dev_warn(&client->dev, "SET TIME!\n");
+			goto read_rtc;
+		}
+
+		break;
 	case rx_8025:
 	case ds_1337:
 	case ds_1339:
_

Patches currently in -mm which might be from danders.dev@gmail.com are

origin.patch


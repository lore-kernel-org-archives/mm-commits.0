From: akpm@linux-foundation.org
Subject: + rtc-ds1307-refactor-chip_desc-table.patch added to -mm tree
Date: Fri, 24 Feb 2012 12:16:19 -0800
Message-ID: <20120224201620.0D4EAA00B1@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61774 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab2BXUQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 15:16:21 -0500
Received: by ggnp1 with SMTP id p1so328113ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 12:16:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, Austin.Boyle@aviatnet.com, alessandro.zummo@towertech.it, danders.dev@gmail.com


The patch titled
     Subject: rtc: ds1307: refactor chip_desc table
has been added to the -mm tree.  Its filename is
     rtc-ds1307-refactor-chip_desc-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wolfram Sang <w.sang@pengutronix.de>
Subject: rtc: ds1307: refactor chip_desc table

The chip_desc table is suboptimal.  Currently it requires an entry for
every new chip type, even if it is empty.  This has already been forgotten
for the ds1388.  Refactor the code, so new entries are only needed, when
they chip type really needs a (non-empty) description.  Also make the
table visually more appealing.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: David Anders <danders.dev@gmail.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   48 ++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-refactor-chip_desc-table drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-refactor-chip_desc-table
+++ a/drivers/rtc/rtc-ds1307.c
@@ -36,6 +36,7 @@ enum ds_type {
 	m41t00,
 	mcp7941x,
 	rx_8025,
+	last_ds_type /* always last */
 	// rs5c372 too?  different address...
 };
 
@@ -120,30 +121,23 @@ struct chip_desc {
 	unsigned		alarm:1;
 };
 
-static const struct chip_desc chips[] = {
-[ds_1307] = {
-	.nvram56	= 1,
-},
-[ds_1337] = {
-	.alarm		= 1,
-},
-[ds_1338] = {
-	.nvram56	= 1,
-},
-[ds_1339] = {
-	.alarm		= 1,
-},
-[ds_1340] = {
-},
-[ds_3231] = {
-	.alarm		= 1,
-},
-[m41t00] = {
-},
-[mcp7941x] = {
-},
-[rx_8025] = {
-}, };
+static const struct chip_desc chips[last_ds_type] = {
+	[ds_1307] = {
+		.nvram56	= 1,
+	},
+	[ds_1337] = {
+		.alarm		= 1,
+	},
+	[ds_1338] = {
+		.nvram56	= 1,
+	},
+	[ds_1339] = {
+		.alarm		= 1,
+	},
+	[ds_3231] = {
+		.alarm		= 1,
+	},
+};
 
 static const struct i2c_device_id ds1307_id[] = {
 	{ "ds1307", ds_1307 },
@@ -836,11 +830,7 @@ read_rtc:
 		}
 
 		break;
-	case rx_8025:
-	case ds_1337:
-	case ds_1339:
-	case ds_1388:
-	case ds_3231:
+	default:
 		break;
 	}
 
_
Subject: Subject: rtc: ds1307: refactor chip_desc table

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
rtc-ds1307-refactor-chip_desc-table.patch
rtc-ds1307-simplify-irq-setup-code.patch
rtc-ds1307-comment-and-format-cleanup.patch
rtc-ds1307-generalise-ram-size-and-offset.patch


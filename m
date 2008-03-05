From: akpm@linux-foundation.org
Subject: - ds1wm-report-bus-reset-error.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:20 -0800
Message-ID: <200803050744.m257iKU9021497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760051AbYCEHox (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:44:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cbouatmailru@gmail.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     ds1wm: report bus reset error
has been removed from the -mm tree.  Its filename was
     ds1wm-report-bus-reset-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ds1wm: report bus reset error
From: Anton Vorontsov <cbouatmailru@gmail.com>

The patch replaces dev_dbg() by dev_err(), so the user could actually see the
error, instead of wondering why w1 doesn't work.  The root cause of the bus
reset error isn't yet debugged though, but this sometimes happens on iPaq
H5555.

And while I'm at it, some cosmetic cleanups also made (few lines were using
spaces instead of tabs).

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds1wm.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/w1/masters/ds1wm.c~ds1wm-report-bus-reset-error drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~ds1wm-report-bus-reset-error
+++ a/drivers/w1/masters/ds1wm.c
@@ -103,12 +103,12 @@ struct ds1wm_data {
 static inline void ds1wm_write_register(struct ds1wm_data *ds1wm_data, u32 reg,
 					u8 val)
 {
-        __raw_writeb(val, ds1wm_data->map + (reg << ds1wm_data->bus_shift));
+	__raw_writeb(val, ds1wm_data->map + (reg << ds1wm_data->bus_shift));
 }
 
 static inline u8 ds1wm_read_register(struct ds1wm_data *ds1wm_data, u32 reg)
 {
-        return __raw_readb(ds1wm_data->map + (reg << ds1wm_data->bus_shift));
+	return __raw_readb(ds1wm_data->map + (reg << ds1wm_data->bus_shift));
 }
 
 
@@ -150,8 +150,8 @@ static int ds1wm_reset(struct ds1wm_data
 	timeleft = wait_for_completion_timeout(&reset_done, DS1WM_TIMEOUT);
 	ds1wm_data->reset_complete = NULL;
 	if (!timeleft) {
-                dev_dbg(&ds1wm_data->pdev->dev, "reset failed\n");
-                return 1;
+		dev_err(&ds1wm_data->pdev->dev, "reset failed\n");
+		return 1;
 	}
 
 	/* Wait for the end of the reset. According to the specs, the time
@@ -168,11 +168,11 @@ static int ds1wm_reset(struct ds1wm_data
 		(ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0));
 
 	if (!ds1wm_data->slave_present) {
-                dev_dbg(&ds1wm_data->pdev->dev, "reset: no devices found\n");
-                return 1;
-        }
+		dev_dbg(&ds1wm_data->pdev->dev, "reset: no devices found\n");
+		return 1;
+	}
 
-        return 0;
+	return 0;
 }
 
 static int ds1wm_write(struct ds1wm_data *ds1wm_data, u8 data)
@@ -335,7 +335,7 @@ static int ds1wm_probe(struct platform_d
 	if (!pdev)
 		return -ENODEV;
 
-	ds1wm_data = kzalloc(sizeof (*ds1wm_data), GFP_KERNEL);
+	ds1wm_data = kzalloc(sizeof(*ds1wm_data), GFP_KERNEL);
 	if (!ds1wm_data)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from cbouatmailru@gmail.com are



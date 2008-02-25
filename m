From: akpm@linux-foundation.org
Subject: + ds1wm-report-bus-reset-error.patch added to -mm tree
Date: Mon, 25 Feb 2008 14:35:35 -0800
Message-ID: <200802252236.m1PMaQo1023380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757821AbYBYWhQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 17:37:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cbouatmailru@gmail.com, johnpol@2ka.mipt.ru


The patch titled
     ds1wm: report bus reset error
has been added to the -mm tree.  Its filename is
     ds1wm-report-bus-reset-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ds1wm-should-check-for-is_errclk-instead-of-null.patch
ds1wm-report-bus-reset-error.patch

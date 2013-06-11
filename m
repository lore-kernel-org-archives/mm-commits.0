From: akpm@linux-foundation.org
Subject: [obsolete]
 rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot-fix.patch
 removed from -mm tree
Date: Tue, 11 Jun 2013 13:27:03 -0700
Message-ID: <51b78817./ekWWNClLIQv6Hp/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab3FKU1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 16:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holler@ahsoftware.de

Subject: [obsolete] rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot-fix.patch removed from -mm tree
To: holler@ahsoftware.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 13:27:03 -0700


The patch titled
     Subject: rtc: rtc-hid-sensor-time: fix possible bug on driver_remove
has been removed from the -mm tree.  Its filename was
     rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Alexander Holler <holler@ahsoftware.de>
Subject: rtc: rtc-hid-sensor-time: fix possible bug on driver_remove

The work we schedule on register deletes himself. Therefor we cannot
use cancel_work_sync() because that calls flush_work() but still uses
the pointer to the (now deleted) work afterwards (for clear_work_data)
which ends up in a bug.
Replacing cancel_work_sync() with flush_work() fixes that.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hid-sensor-time.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-hid-sensor-time.c~rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot-fix drivers/rtc/rtc-hid-sensor-time.c
--- a/drivers/rtc/rtc-hid-sensor-time.c~rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot-fix
+++ a/drivers/rtc/rtc-hid-sensor-time.c
@@ -385,9 +385,8 @@ static int hid_time_remove(struct platfo
 	struct hid_time_state *time_state = platform_get_drvdata(pdev);
 
 	if (time_state->workts) {
-		cancel_work_sync(&time_state->workts->work);
-		kfree(time_state->workts);
-		time_state->workts = NULL;
+		flush_work(&time_state->workts->work);
+		BUG_ON(time_state->workts != NULL);
 	}
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
 
_

Patches currently in -mm which might be from holler@ahsoftware.de are

rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch
rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch
rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch


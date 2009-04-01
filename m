From: akpm@linux-foundation.org
Subject: [merged] rtc-test-before-subtraction-on-unsigned.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:16 -0700
Message-ID: <200904011842.n31IgGv7009636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbZDAT2W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:28:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: test before subtraction on unsigned
has been removed from the -mm tree.  Its filename was
     rtc-test-before-subtraction-on-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: test before subtraction on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

new_alarm is unsigned so test before the subtraction.

[akpm@linux-foundation.org: time-wrapping fix]
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-ds1374.c~rtc-test-before-subtraction-on-unsigned drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-test-before-subtraction-on-unsigned
+++ a/drivers/rtc/rtc-ds1374.c
@@ -222,16 +222,16 @@ static int ds1374_set_alarm(struct devic
 	rtc_tm_to_time(&alarm->time, &new_alarm);
 	rtc_tm_to_time(&now, &itime);
 
-	new_alarm -= itime;
-
 	/* This can happen due to races, in addition to dates that are
 	 * truly in the past.  To avoid requiring the caller to check for
 	 * races, dates in the past are assumed to be in the recent past
 	 * (i.e. not something that we'd rather the caller know about via
 	 * an error), and the alarm is set to go off as soon as possible.
 	 */
-	if (new_alarm <= 0)
+	if (time_before_eq(new_alarm, itime))
 		new_alarm = 1;
+	else
+		new_alarm -= itime;
 
 	mutex_lock(&ds1374->mutex);
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch


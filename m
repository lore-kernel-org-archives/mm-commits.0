From: akpm@linux-foundation.org
Subject: + rtc-x1205-reset-clock-to-sane-state-after-power-failure.patch added to -mm tree
Date: Wed, 25 Nov 2009 14:11:10 -0800
Message-ID: <200911252211.nAPMBAk0031825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759550AbZKYWMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 17:12:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jw@emlix.com, a.zummo@towertech.it, p_gortmaker@yahoo.com


The patch titled
     rtc-x1205: reset clock to sane state after power failure
has been added to the -mm tree.  Its filename is
     rtc-x1205-reset-clock-to-sane-state-after-power-failure.patch

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
Subject: rtc-x1205: reset clock to sane state after power failure
From: Johannes Weiner <jw@emlix.com>

When detecting power failure, the probe function would reset the clock
time to defined state.

However, the clock's _date_ might still be bogus and a subsequent probe
fails when sanity-checking these values.

Change the power-failure fixup code to do a full setting of rtc_time,
including a valid date.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-x1205.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-x1205.c~rtc-x1205-reset-clock-to-sane-state-after-power-failure drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~rtc-x1205-reset-clock-to-sane-state-after-power-failure
+++ a/drivers/rtc/rtc-x1205.c
@@ -280,9 +280,9 @@ static int x1205_fix_osc(struct i2c_clie
 	int err;
 	struct rtc_time tm;
 
-	tm.tm_hour = tm.tm_min = tm.tm_sec = 0;
+	memset(&tm, 0, sizeof(tm));
 
-	err = x1205_set_datetime(client, &tm, 0, X1205_CCR_BASE, 0);
+	err = x1205_set_datetime(client, &tm, 1, X1205_CCR_BASE, 0);
 	if (err < 0)
 		dev_err(&client->dev, "unable to restart the oscillator\n");
 
_

Patches currently in -mm which might be from jw@emlix.com are

xtensa-use-generic-sys_pipe.patch
rtc-x1205-fix-rtc_time-to-y2k-register-value-conversion.patch
rtc-x1205-reset-clock-to-sane-state-after-power-failure.patch
rtc-x1205-unconditionally-set-date-when-setting-clock.patch


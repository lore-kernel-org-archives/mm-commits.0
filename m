From: akpm@linux-foundation.org
Subject: + rtc-test-before-subtraction-on-unsigned.patch added to -mm tree
Date: Mon, 02 Mar 2009 14:52:08 -0800
Message-ID: <200903022252.n22Mq80j030992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757572AbZCBXEY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 18:04:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: test before subtraction on unsigned
has been added to the -mm tree.  Its filename is
     rtc-test-before-subtraction-on-unsigned.patch

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
Subject: rtc: test before subtraction on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

new_alarm is unsigned so test before the subtraction.

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
+	if (new_alarm <= itime)
 		new_alarm = 1;
+	else
+		new_alarm -= itime;
 
 	mutex_lock(&ds1374->mutex);
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
mm-get_nid_for_pfn-returns-int.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
acpi-wmic-unsigned-cannot-be-less-than-0.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
jffs2_acl_count-tests-0-on-unsigned.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
hugetlb-chg-cannot-become-less-than-0.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
rtc-test-before-subtraction-on-unsigned.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
viafb-returns-0-two-too-early.patch
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch
aoe-error-printed-1-too-early.patch


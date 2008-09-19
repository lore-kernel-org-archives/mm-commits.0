From: akpm@linux-foundation.org
Subject: + hwmon-applesmc-prolong-status-wait.patch added to -mm tree
Date: Fri, 19 Sep 2008 15:55:39 -0700
Message-ID: <200809192255.m8JMtdoq010704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbYISWz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 18:55:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch, rkoktarianto@gmail.com


The patch titled
     hwmon: applesmc: prolong status wait
has been added to the -mm tree.  Its filename is
     hwmon-applesmc-prolong-status-wait.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: prolong status wait
From: Henrik Rydberg <rydberg@euromail.se>

The time to wait for a status change while reading or writing to the SMC
ports is a balance between read reliability and system performance.  The
current setting yields rougly three errors in a thousand when
simultaneously reading three different temperature values on a Macbook
Air.  This patch increases the setting to a value yielding roughly one
error in ten thousand, with no noticable system performance degradation.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Riki Oktarianto <rkoktarianto@gmail.com>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-prolong-status-wait drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-prolong-status-wait
+++ a/drivers/hwmon/applesmc.c
@@ -163,7 +163,7 @@ static unsigned int key_at_index;
 static struct workqueue_struct *applesmc_led_wq;
 
 /*
- * __wait_status - Wait up to 2ms for the status port to get a certain value
+ * __wait_status - Wait up to 10ms for the status port to get a certain value
  * (masked with 0x0f), returning zero if the value is obtained.  Callers must
  * hold applesmc_lock.
  */
@@ -173,7 +173,7 @@ static int __wait_status(u8 val)
 
 	val = val & APPLESMC_STATUS_MASK;
 
-	for (i = 0; i < 200; i++) {
+	for (i = 0; i < 1000; i++) {
 		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val) {
 			if (debug)
 				printk(KERN_DEBUG
_

Patches currently in -mm which might be from rydberg@euromail.se are

linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
hwmon-applesmc-specified-number-of-bytes-to-read-should-match-actual.patch
hwmon-applesmc-fix-the-wait-status-failed-c-=-8-problem.patch
hwmon-applesmc-prolong-status-wait.patch
hwmon-applesmc-allow-for-variable-alv0-and-alv1-package-length.patch
hwmon-applesmc-add-support-for-macbook-air.patch


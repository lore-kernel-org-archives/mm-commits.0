From: akpm@linux-foundation.org
Subject: + lis3-fix-oops-with-null-platform-data.patch added to -mm tree
Date: Thu, 23 Sep 2010 12:25:38 -0700
Message-ID: <201009231925.o8NJPdkx014040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754734Ab0IWTZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 15:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, guenter.roeck@ericsson.com, khali@linux-fr.org, samu.p.onkalo@nokia.com, stable@kernel.org


The patch titled
     lis3: fix Oops with NULL platform data
has been added to the -mm tree.  Its filename is
     lis3-fix-oops-with-null-platform-data.patch

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
Subject: lis3: fix Oops with NULL platform data
From: Takashi Iwai <tiwai@suse.de>

The recent addition of threaded irq handler causes a NULL dereference when
used with hp_accel driver, which has NULL pdata.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-fix-oops-with-null-platform-data drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-fix-oops-with-null-platform-data
+++ a/drivers/hwmon/lis3lv02d.c
@@ -277,7 +277,7 @@ static irqreturn_t lis302dl_interrupt(in
 	wake_up_interruptible(&lis3_dev.misc_wait);
 	kill_fasync(&lis3_dev.async_queue, SIGIO, POLL_IN);
 out:
-	if (lis3_dev.whoami == WAI_8B && lis3_dev.idev &&
+	if (lis3_dev.pdata && lis3_dev.whoami == WAI_8B && lis3_dev.idev &&
 	    lis3_dev.idev->input->users)
 		return IRQ_WAKE_THREAD;
 	return IRQ_HANDLED;
@@ -718,7 +718,7 @@ int lis3lv02d_init_device(struct lis3lv0
 	 * io-apic is not configurable (and generates a warning) but I keep it
 	 * in case of support for other hardware.
 	 */
-	if (dev->whoami == WAI_8B)
+	if (dev->pdata && dev->whoami == WAI_8B)
 		thread_fn = lis302dl_interrupt_thread1_8b;
 	else
 		thread_fn = NULL;
_

Patches currently in -mm which might be from tiwai@suse.de are

linux-next.patch
lis3-fix-oops-with-null-platform-data.patch
lis3-add-axes-module-parameter-for-custom-axis-mapping.patch


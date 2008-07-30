From: akpm@linux-foundation.org
Subject: - rtc-dev-stop-periodic-interrupts-on-device-release.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:38 -0700
Message-ID: <200807301915.m6UJFcx6011040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805AbYG3TQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:16:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomi@nomi.cz, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc-dev: stop periodic interrupts on device release
has been removed from the -mm tree.  Its filename was
     rtc-dev-stop-periodic-interrupts-on-device-release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-dev: stop periodic interrupts on device release
From: Tomas Janousek <tomi@nomi.cz>

Solves http://bugzilla.kernel.org/show_bug.cgi?id=11127

The old rtc.c driver did it and some drivers (like rtc-sh) do it in their
release function, though they should not -- because they should provide
the irq_set_state op and the rtc framework itself should care about it. 
This patch makes it do so.

I am aware that some drivers, like rtc-sh, handle userspace PIE sets in
their ioctl op (instead of having the framework call the op), exporting
the irq_set_state op at the same time.  The logic in rtc_irq_set_state
should make sure it doesn't matter and the driver should not need to care
stopping periodic interrupts in its release routine any more.

The correct way, in my opinion, should be this:
1) The driver provides the irq_set_state op and does not care closing the
   interrupts in its release op.
2) If the driver does not provide the op and handles PIE in the ioctl op, it's
   reponsible for closing them in its release op.
3) Something similar for other IRQs, like UIE -- if there's no in-kernel API
   like irq_set_state, handle it in ioctl and release ops. The framework will
   be responsible either for everything or for nothing. (This will probably
   change later.)

Signed-off-by: Tomas Janousek <tomi@nomi.cz>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dev.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-dev.c~rtc-dev-stop-periodic-interrupts-on-device-release drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-dev-stop-periodic-interrupts-on-device-release
+++ a/drivers/rtc/rtc-dev.c
@@ -432,6 +432,8 @@ static int rtc_dev_release(struct inode 
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	clear_uie(rtc);
 #endif
+	rtc_irq_set_state(rtc, NULL, 0);
+
 	if (rtc->ops->release)
 		rtc->ops->release(rtc->dev.parent);
 
_

Patches currently in -mm which might be from tomi@nomi.cz are

origin.patch


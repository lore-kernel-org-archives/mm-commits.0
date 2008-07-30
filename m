From: akpm@linux-foundation.org
Subject: + rtc-dev-stop-periodic-interrupts-on-device-release.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:40:07 -0700
Message-ID: <200807300040.m6U0e7tl030488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484AbYG3AlA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:41:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomi@nomi.cz, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc-dev: stop periodic interrupts on device release
has been added to the -mm tree.  Its filename is
     rtc-dev-stop-periodic-interrupts-on-device-release.patch

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

rtc-dev-stop-periodic-interrupts-on-device-release.patch


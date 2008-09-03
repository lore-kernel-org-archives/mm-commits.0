From: akpm@linux-foundation.org
Subject: + clockevents-prevent-clockevent-event_handler-ending-up-handler_noop.patch added to -mm tree
Date: Wed, 03 Sep 2008 13:27:56 -0700
Message-ID: <200809032027.m83KRuZa002414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbYICU2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 16:28:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, johnstul@us.ibm.com, mingo@elte.hu, shaohua.li@intel.com, stable@kernel.org, tglx@linutronix.de


The patch titled
     clockevents: prevent clockevent event_handler ending up handler_noop
has been added to the -mm tree.  Its filename is
     clockevents-prevent-clockevent-event_handler-ending-up-handler_noop.patch

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
Subject: clockevents: prevent clockevent event_handler ending up handler_noop
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

There is a ordering related problem with clockevents code, due to which
clockevents_register_device() called after tickless/highres switch will
not work.  The new clockevent ends up with clockevents_handle_noop as
event handler, resulting in no timer activity.

The problematic path seems to be

* old device already has hrtimer_interrupt as the event_handler
* new clockevent device registers with a higher rating
* tick_check_new_device() is called
  * clockevents_exchange_device() gets called
    * old->event_handler is set to clockevents_handle_noop
  * tick_setup_device() is called for the new device
    * which sets new->event_handler using the old->event_handler which is noop.

Change the ordering so that new device inherits the proper handler.

This does not have any issue in normal case as most likely all the
clockevent devices are setup before the highres switch.  But, can
potentially be affecting some corner case where HPET force detect happens
after the highres switch.  This was a problem with HPET in MSI mode code
that we have been experimenting with.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clockchips.h |    2 ++
 kernel/time/clockevents.c  |    3 +--
 kernel/time/tick-common.c  |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/clockchips.h~clockevents-prevent-clockevent-event_handler-ending-up-handler_noop include/linux/clockchips.h
--- a/include/linux/clockchips.h~clockevents-prevent-clockevent-event_handler-ending-up-handler_noop
+++ a/include/linux/clockchips.h
@@ -127,6 +127,8 @@ extern int clockevents_register_notifier
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, ktime_t now);
 
+extern void clockevents_handle_noop(struct clock_event_device *dev);
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
diff -puN kernel/time/clockevents.c~clockevents-prevent-clockevent-event_handler-ending-up-handler_noop kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~clockevents-prevent-clockevent-event_handler-ending-up-handler_noop
+++ a/kernel/time/clockevents.c
@@ -177,7 +177,7 @@ void clockevents_register_device(struct 
 /*
  * Noop handler when we shut down an event device
  */
-static void clockevents_handle_noop(struct clock_event_device *dev)
+void clockevents_handle_noop(struct clock_event_device *dev)
 {
 }
 
@@ -199,7 +199,6 @@ void clockevents_exchange_device(struct 
 	 * released list and do a notify add later.
 	 */
 	if (old) {
-		old->event_handler = clockevents_handle_noop;
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
diff -puN kernel/time/tick-common.c~clockevents-prevent-clockevent-event_handler-ending-up-handler_noop kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~clockevents-prevent-clockevent-event_handler-ending-up-handler_noop
+++ a/kernel/time/tick-common.c
@@ -161,6 +161,7 @@ static void tick_setup_device(struct tic
 	} else {
 		handler = td->evtdev->event_handler;
 		next_event = td->evtdev->next_event;
+		td->evtdev->event_handler = clockevents_handle_noop;
 	}
 
 	td->evtdev = newdev;
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

linux-next.patch
clockevents-prevent-clockevent-event_handler-ending-up-handler_noop.patch


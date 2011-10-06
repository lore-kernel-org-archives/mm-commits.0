From: akpm@google.com
Subject: + hrtimers-special-case-zero-length-sleeps.patch added to -mm tree
Date: Thu, 06 Oct 2011 14:01:17 -0700
Message-ID: <201110062101.p96L1IEm028035@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:63417 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab1JFVBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2011 17:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, arjan@infradead.org, tglx@linutronix.de


The patch titled
     Subject: hrtimers: Special-case zero length sleeps
has been added to the -mm tree.  Its filename is
     hrtimers-special-case-zero-length-sleeps.patch

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
From: Matthew Garrett <mjg@redhat.com>
Subject: hrtimers: Special-case zero length sleeps

sleep(0) is a common construct used by applications that want to trigger
the scheduler.  sched_yield() might make more sense, but only appeared in
POSIX.1-2001 and so plenty of example code still uses the sleep(0) form.

This wouldn't normally be a problem, but it means that event-driven
applications that are merely trying to avoid starving other processes may
actually end up sleeping due to having large timer_slack values.  Special-
casing this seems reasonable.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 kernel/hrtimer.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN kernel/hrtimer.c~hrtimers-special-case-zero-length-sleeps kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-special-case-zero-length-sleeps
+++ a/kernel/hrtimer.c
@@ -1566,6 +1566,14 @@ long hrtimer_nanosleep(struct timespec *
 	if (rt_task(current))
 		slack = 0;
 
+	/*
+	 * Applications will often sleep(0) to indicate that they wish to
+	 * be scheduled. Special case that to avoid actually putting them
+	 * to sleep for the duration of the slack.
+	 */
+	if (rqtp->tv_sec == 0 && rqtp->tv_nsec == 0)
+		slack = 0;
+
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	hrtimer_set_expires_range_ns(&t.timer, timespec_to_ktime(*rqtp), slack);
 	if (do_nanosleep(&t, mode))
_
Subject: Subject: hrtimers: Special-case zero length sleeps

Patches currently in -mm which might be from mjg@redhat.com are

origin.patch
linux-next.patch
acerhdf-add-support-for-aspire-1410-bios-v13314.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
hp_accel-add-a-new-pnp-id.patch
hp_accel-add-axis-mapping-for-hp-probook-elitebook.patch
hrtimers-special-case-zero-length-sleeps.patch
lis3lv02d-avoid-divide-by-zero-due-to-unchecked.patch
lis3-update-maintainer-information.patch
lis3-add-support-for-hp-elitebook-2730p.patch
lis3-add-support-for-hp-elitebook-8540w.patch
hp_accel-add-hp-probook-655x.patch
lis3-free-regulators-if-probe-fails.patch
lis3-change-naming-to-consistent.patch
lis3-change-exported-function-to-use-given.patch
lis3-remove-the-references-to-the-global-variable-in-core-driver.patch
maintainers-add-new-entry-for-ideapad-laptop.patch


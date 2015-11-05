From: akpm@linux-foundation.org
Subject: +
 watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn.patch
 added to -mm tree
Date: Thu, 05 Nov 2015 02:30:48 -0800
Message-ID: <563b2fd8.cblAc3wFtksMNKG7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031089AbbKEKat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 05:30:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: fix race between proc_watchdog_thresh() and watchdog_timer_fn()
has been added to the -mm tree.  Its filename is
     watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: kernel/watchdog.c: fix race between proc_watchdog_thresh() and watchdog_timer_fn()

Theoretically it is possible that the watchdog timer expires right at the
time when a user sets 'watchdog_thresh' to zero (note: this disables the
lockup detectors).  In this scenario, the is_softlockup() function - which
is called by the timer - could produce a false positive.

Fix this by checking the current value of 'watchdog_thresh'.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog.c~watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn
+++ a/kernel/watchdog.c
@@ -289,7 +289,7 @@ static int is_softlockup(unsigned long t
 {
 	unsigned long now = get_timestamp();
 
-	if (watchdog_enabled & SOFT_WATCHDOG_ENABLED) {
+	if ((watchdog_enabled & SOFT_WATCHDOG_ENABLED) && watchdog_thresh){
 		/* Warn about unreasonable delays. */
 		if (time_after(now, touch_ts + get_softlockup_thresh()))
 			return now - touch_ts;
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-fix-error-handling-in-proc_watchdog_thresh.patch
watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch
watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers.patch
watchdog-implement-error-handling-in-lockup_detector_suspend.patch
watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch
watchdog-avoid-race-between-lockup-detector-suspend-resume-and-cpu-hotplug.patch
watchdog-avoid-races-between-proc-handlers-and-cpu-hotplug.patch
watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads.patch
watchdog-fix-race-between-proc_watchdog_thresh-and-watchdog_timer_fn.patch


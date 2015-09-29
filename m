From: akpm@linux-foundation.org
Subject: + watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch
 added to -mm tree
Date: Tue, 29 Sep 2015 16:40:19 -0700
Message-ID: <560b2163.H8mNCQvhvBkWbePi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbI2XkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 19:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: move watchdog_disable_all_cpus() outside of ifdef
has been added to the -mm tree.  Its filename is
     watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch

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
Subject: watchdog: move watchdog_disable_all_cpus() outside of ifdef

Move watchdog_disable_all_cpus() outside of the ifdef so that it is
available if CONFIG_SYSCTL is not defined.  This is preparation for
"watchdog: implement error handling in update_watchdog_all_cpus() and
callers".

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/watchdog.c~watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef
+++ a/kernel/watchdog.c
@@ -347,6 +347,9 @@ static void watchdog_interrupt_count(voi
 static int watchdog_nmi_enable(unsigned int cpu);
 static void watchdog_nmi_disable(unsigned int cpu);
 
+static int watchdog_enable_all_cpus(void);
+static void watchdog_disable_all_cpus(void);
+
 /* watchdog kicker functions */
 static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 {
@@ -756,9 +759,6 @@ static int watchdog_enable_all_cpus(void
 	return err;
 }
 
-/* prepare/enable/disable routines */
-/* sysctl functions */
-#ifdef CONFIG_SYSCTL
 static void watchdog_disable_all_cpus(void)
 {
 	if (watchdog_running) {
@@ -767,6 +767,8 @@ static void watchdog_disable_all_cpus(vo
 	}
 }
 
+#ifdef CONFIG_SYSCTL
+
 /*
  * Update the run state of the lockup detectors.
  */
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-fix-error-handling-in-proc_watchdog_thresh.patch
watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch
watchdog-implement-error-handling-in-update_watchdog_all_cpus-and-callers.patch
watchdog-implement-error-handling-in-lockup_detector_suspend.patch
watchdog-do-not-unpark-threads-in-watchdog_park_threads-on-error.patch


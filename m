From: akpm@linux-foundation.org
Subject: +
 watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch added to -mm tree
Date: Mon, 23 Feb 2015 13:20:43 -0800
Message-ID: <54eb99ab.K58WLWC2/mNZ+BoM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbbBWVUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 16:20:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: move definition of 'watchdog_proc_mutex' outside of proc_dowatchdog()
has been added to the -mm tree.  Its filename is
     watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch

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
Subject: watchdog: move definition of 'watchdog_proc_mutex' outside of proc_dowatchdog()

This series removes proc_dowatchdog().  Since multiple new functions need
the 'watchdog_proc_mutex' to serialize access to the watchdog parameters
in /proc/sys/kernel, move the mutex outside of any function.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/watchdog.c~watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog
+++ a/kernel/watchdog.c
@@ -701,6 +701,8 @@ static int proc_watchdog_update(void)
 
 }
 
+static DEFINE_MUTEX(watchdog_proc_mutex);
+
 /*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
@@ -710,7 +712,6 @@ int proc_dowatchdog(struct ctl_table *ta
 {
 	int err, old_thresh, old_enabled;
 	bool old_hardlockup;
-	static DEFINE_MUTEX(watchdog_proc_mutex);
 
 	mutex_lock(&watchdog_proc_mutex);
 	old_thresh = ACCESS_ONCE(watchdog_thresh);
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-new-definitions-and-variables-initialization.patch
watchdog-introduce-the-proc_watchdog_update-function.patch
watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch
watchdog-introduce-the-proc_watchdog_common-function.patch
watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel.patch
watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch
watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch
watchdog-clean-up-some-function-names-and-arguments.patch
watchdog-introduce-the-hardlockup_detector_disable-function.patch


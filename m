From: akpm@linux-foundation.org
Subject: +
 softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu-fix.patch added to -mm tree
Date: Fri, 29 Aug 2014 12:07:06 -0700
Message-ID: <5400cf5a.uGPRYdSWj9fHs9yz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaH2THH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:07:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, chaiw.fnst@cn.fujitsu.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu-fix
has been added to the -mm tree.  Its filename is
     softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Don Zickus <dzickus@redhat.com>
Subject: softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu-fix

update comment

Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: chai wen <chaiw.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/watchdog.c~softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu-fix kernel/watchdog.c
--- a/kernel/watchdog.c~softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu-fix
+++ a/kernel/watchdog.c
@@ -336,10 +336,12 @@ static enum hrtimer_restart watchdog_tim
 		/* only warn once */
 		if (__this_cpu_read(soft_watchdog_warn) == true) {
 			/*
-			 * Handle the case where multiple processes are
-			 * causing softlockups but the duration is small
-			 * enough, the softlockup detector can not reset
-			 * itself in time.  Use task pointers to detect this.
+			 * When multiple processes are causing softlockups the
+			 * softlockup detector only warns on the first one
+			 * because the code relies on a full quiet cycle to
+			 * re-arm.  The second process prevents the quiet cycle
+			 * and never gets reported.  Use task pointers to detect
+			 * this.
 			 */
 			if (__this_cpu_read(softlockup_task_ptr_saved) !=
 			    current) {
_

Patches currently in -mm which might be from dzickus@redhat.com are

softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu.patch
softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu-fix.patch
linux-next.patch
watchdog-control-hard-lockup-detection-default.patch
watchdog-control-hard-lockup-detection-default-fix.patch
watchdog-control-hard-lockup-detection-default-fix-2.patch
kvm-ensure-hard-lockup-detection-is-disabled-by-default.patch


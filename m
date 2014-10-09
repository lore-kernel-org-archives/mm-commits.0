From: akpm@linux-foundation.org
Subject: [folded-merged]
 softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu-fix.patch removed from -mm tree
Date: Thu, 09 Oct 2014 13:27:19 -0700
Message-ID: <5436efa7.8ubBf3KAELnBKHS1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaJIU1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:27:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, chaiw.fnst@cn.fujitsu.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu-fix
has been removed from the -mm tree.  Its filename was
     softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu-fix.patch

This patch was dropped because it was folded into softlockup-make-detector-be-aware-of-task-switch-of-processes-hogging-cpu.patch

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


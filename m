From: akpm@linux-foundation.org
Subject: +
 proc-fix-timerslack_ns-cap_sys_nice-check-when-adjusting-self.patch added
 to -mm tree
Date: Tue, 30 Aug 2016 16:05:55 -0700
Message-ID: <57c61153.UXNp8zm9PN3yXukX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46314 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758001AbcH3XF5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2016 19:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john.stultz@linaro.org, arjan@linux.intel.com, ccross@android.com, dimitrysh@google.com, enh@google.com, kandoiruchi@google.com, keescook@chromium.org, kernel-team@android.com, nnk@google.com, orenl@cellrox.com, romlem@android.com, serge@hallyn.com, tglx@linutronix.de, tkjos@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix timerslack_ns CAP_SYS_NICE check when adjusting self
has been added to the -mm tree.  Its filename is
     proc-fix-timerslack_ns-cap_sys_nice-check-when-adjusting-self.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-fix-timerslack_ns-cap_sys_nice-check-when-adjusting-self.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-fix-timerslack_ns-cap_sys_nice-check-when-adjusting-self.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Stultz <john.stultz@linaro.org>
Subject: proc: fix timerslack_ns CAP_SYS_NICE check when adjusting self

In changing from checking ptrace_may_access(p, PTRACE_MODE_ATTACH_FSCREDS)
to capable(CAP_SYS_NICE), I missed that ptrace_my_access succeeds when p
== current, but the CAP_SYS_NICE doesn't.

Thus while the previous commit was intended to loosen the needed
privileges to modify a processes timerslack, it needlessly restricted a
task modifying its own timerslack via the proc/<tid>/timerslack_ns (which
is permitted also via the PR_SET_TIMERSLACK method).

This patch corrects this by checking if p == current before checking
the CAP_SYS_NICE value.

This patch applies on top of my two previous patches currently in -mm

Link: http://lkml.kernel.org/r/1471906870-28624-1-git-send-email-john.stultz@linaro.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Oren Laadan <orenl@cellrox.com>
Cc: Ruchi Kandoi <kandoiruchi@google.com>
Cc: Rom Lemarchand <romlem@android.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Colin Cross <ccross@android.com>
Cc: Nick Kralevich <nnk@google.com>
Cc: Dmitry Shmidt <dimitrysh@google.com>
Cc: Elliott Hughes <enh@google.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff -puN fs/proc/base.c~proc-fix-timerslack_ns-cap_sys_nice-check-when-adjusting-self fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-timerslack_ns-cap_sys_nice-check-when-adjusting-self
+++ a/fs/proc/base.c
@@ -2285,15 +2285,17 @@ static ssize_t timerslack_ns_write(struc
 	if (!p)
 		return -ESRCH;
 
-	if (!capable(CAP_SYS_NICE)) {
-		count = -EPERM;
-		goto out;
-	}
-
-	err = security_task_setscheduler(p);
-	if (err) {
-		count = err;
-		goto out;
+	if (p != current) {
+		if (!capable(CAP_SYS_NICE)) {
+			count = -EPERM;
+			goto out;
+		}
+
+		err = security_task_setscheduler(p);
+		if (err) {
+			count = err;
+			goto out;
+		}
 	}
 
 	task_lock(p);
@@ -2319,14 +2321,16 @@ static int timerslack_ns_show(struct seq
 	if (!p)
 		return -ESRCH;
 
-	if (!capable(CAP_SYS_NICE)) {
-		err = -EPERM;
-		goto out;
-	}
+	if (p != current) {
 
-	err = security_task_getscheduler(p);
-	if (err)
-		goto out;
+		if (!capable(CAP_SYS_NICE)) {
+			err = -EPERM;
+			goto out;
+		}
+		err = security_task_getscheduler(p);
+		if (err)
+			goto out;
+	}
 
 	task_lock(p);
 	seq_printf(m, "%llu\n", p->timer_slack_ns);
_

Patches currently in -mm which might be from john.stultz@linaro.org are

proc-relax-proc-tid-timerslack_ns-capability-requirements.patch
proc-add-lsm-hook-checks-to-proc-tid-timerslack_ns.patch
proc-fix-timerslack_ns-cap_sys_nice-check-when-adjusting-self.patch


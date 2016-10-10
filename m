From: akpm@linux-foundation.org
Subject: [merged] proc-add-lsm-hook-checks-to-proc-tid-timerslack_ns.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:57:35 -0700
Message-ID: <57fc1cdf.6tPZ/kCvSbidhGu9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38026 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752387AbcJJW5g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:57:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john.stultz@linaro.org, arjan@linux.intel.com, ccross@android.com, dimitrysh@google.com, enh@google.com, jmorris@namei.org, kandoiruchi@google.com, keescook@chromium.org, kernel-team@android.com, nnk@google.com, orenl@cellrox.com, romlem@android.com, serge@hallyn.com, tglx@linutronix.de, tkjos@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add LSM hook checks to /proc/<tid>/timerslack_ns
has been removed from the -mm tree.  Its filename was
     proc-add-lsm-hook-checks-to-proc-tid-timerslack_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Stultz <john.stultz@linaro.org>
Subject: proc: add LSM hook checks to /proc/<tid>/timerslack_ns

As requested, this patch checks the existing LSM hooks
task_getscheduler/task_setscheduler when reading or modifying the task's
timerslack value.

Previous versions added new get/settimerslack LSM hooks, but since they
checked the same PROCESS__SET/GETSCHED values as existing hooks, it was
suggested we just use the existing ones.

Link: http://lkml.kernel.org/r/1469132667-17377-2-git-send-email-john.stultz@linaro.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Kees Cook <keescook@chromium.org>
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
Cc: James Morris <jmorris@namei.org>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/proc/base.c~proc-add-lsm-hook-checks-to-proc-tid-timerslack_ns fs/proc/base.c
--- a/fs/proc/base.c~proc-add-lsm-hook-checks-to-proc-tid-timerslack_ns
+++ a/fs/proc/base.c
@@ -2285,6 +2285,12 @@ static ssize_t timerslack_ns_write(struc
 		goto out;
 	}
 
+	err = security_task_setscheduler(p);
+	if (err) {
+		count = err;
+		goto out;
+	}
+
 	task_lock(p);
 	if (slack_ns == 0)
 		p->timer_slack_ns = p->default_timer_slack_ns;
@@ -2313,6 +2319,10 @@ static int timerslack_ns_show(struct seq
 		goto out;
 	}
 
+	err = security_task_getscheduler(p);
+	if (err)
+		goto out;
+
 	task_lock(p);
 	seq_printf(m, "%llu\n", p->timer_slack_ns);
 	task_unlock(p);
_

Patches currently in -mm which might be from john.stultz@linaro.org are



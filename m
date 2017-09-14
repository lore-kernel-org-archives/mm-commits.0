From: akpm@linux-foundation.org
Subject: + fs-proc-report-eip-esp-in-prod-pid-stat-for-coredumping.patch
 added to -mm tree
Date: Thu, 14 Sep 2017 14:18:50 -0700
Message-ID: <59baf23a.Y6CANpJVV4ypxbvL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdINVSw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2017 17:18:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john.ogness@linutronix.de, keescook@chromium.org, luto@kernel.org, marco.felsch@preh.de, mingo@kernel.org, stable@vger.kernel.org, tglx@linutronix.de, tycho.andersen@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc: report eip/esp in /prod/PID/stat for coredumping
has been added to the -mm tree.  Its filename is
     fs-proc-report-eip-esp-in-prod-pid-stat-for-coredumping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-report-eip-esp-in-prod-pid-stat-for-coredumping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-report-eip-esp-in-prod-pid-stat-for-coredumping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Ogness <john.ogness@linutronix.de>
Subject: fs/proc: report eip/esp in /prod/PID/stat for coredumping

0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in /proc/PID/stat")
stopped reporting eip/esp because it is racy and dangerous for executing
tasks.  The comment adds:

    As far as I know, there are no use programs that make any
    material use of these fields, so just get rid of them.

However, existing userspace core-dump-handler applications (for example,
minicoredumper) are using these fields since they provide an excellent
cross-platform interface to these valuable pointers.  So that commit
introduced a user space visible regression.

Partially revert the change and make the readout possible for tasks with
the proper permissions and only if the target task has the PF_DUMPCORE
flag set.

Link: http://lkml.kernel.org/r/87poatfwg6.fsf@linutronix.de
Fixes: 0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in> /proc/PID/stat")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reported-by: Marco Felsch <marco.felsch@preh.de>
Reviewed-by: Andy Lutomirski <luto@kernel.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tycho Andersen <tycho.andersen@canonical.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/proc/array.c~fs-proc-report-eip-esp-in-prod-pid-stat-for-coredumping fs/proc/array.c
--- a/fs/proc/array.c~fs-proc-report-eip-esp-in-prod-pid-stat-for-coredumping
+++ a/fs/proc/array.c
@@ -421,7 +421,15 @@ static int do_task_stat(struct seq_file
 		 * esp and eip are intentionally zeroed out.  There is no
 		 * non-racy way to read them without freezing the task.
 		 * Programs that need reliable values can use ptrace(2).
+		 *
+		 * The only exception is if the task is core dumping because
+		 * a program is not able to use ptrace(2) in that case. It is
+		 * safe because the task has stopped executing permanently.
 		 */
+		if (permitted && (task->flags & PF_DUMPCORE)) {
+			eip = KSTK_EIP(task);
+			esp = KSTK_ESP(task);
+		}
 	}
 
 	get_task_comm(tcomm, task);
_

Patches currently in -mm which might be from john.ogness@linutronix.de are

fs-proc-report-eip-esp-in-prod-pid-stat-for-coredumping.patch


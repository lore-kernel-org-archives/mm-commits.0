From: akpm@linux-foundation.org
Subject: + proc-coredump-add-coredumping-flag-to-proc-pid-status.patch
 added to -mm tree
Date: Wed, 27 Sep 2017 16:31:11 -0700
Message-ID: <59cc34bf.hVWxaN9NHi5tXQ3M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33026 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752484AbdI0XbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 19:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, koct9i@gmail.com, mingo@kernel.org, oleg@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc, coredump: add CoreDumping flag to /proc/pid/status
has been added to the -mm tree.  Its filename is
     proc-coredump-add-coredumping-flag-to-proc-pid-status.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-coredump-add-coredumping-flag-to-proc-pid-status.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-coredump-add-coredumping-flag-to-proc-pid-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: proc, coredump: add CoreDumping flag to /proc/pid/status

Right now there is no convenient way to check if a process is being
coredumped at the moment.

It might be necessary to recognize such state to prevent killing the
process and getting a broken coredump.  Writing a large core might take
significant time, and the process is unresponsive during it, so it might
be killed by timeout, if another process is monitoring and
killing/restarting hanging tasks.

To provide an ability to detect if a process is in the state of being
coreduped, we can expose a boolean CoreDumping flag in /proc/pid/status.

Example:
$ cat core.sh
  #!/bin/sh

  echo "|/usr/bin/sleep 10" > /proc/sys/kernel/core_pattern
  sleep 1000 &
  PID=$!

  cat /proc/$PID/status | grep CoreDumping
  kill -ABRT $PID
  sleep 1
  cat /proc/$PID/status | grep CoreDumping

$ ./core.sh
  CoreDumping:	0
  CoreDumping:	1

Link: http://lkml.kernel.org/r/20170920230634.31572-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/proc/array.c~proc-coredump-add-coredumping-flag-to-proc-pid-status fs/proc/array.c
--- a/fs/proc/array.c~proc-coredump-add-coredumping-flag-to-proc-pid-status
+++ a/fs/proc/array.c
@@ -370,6 +370,11 @@ static void task_cpus_allowed(struct seq
 		   cpumask_pr_args(&task->cpus_allowed));
 }
 
+static inline void task_core_dumping(struct seq_file *m, struct mm_struct *mm)
+{
+	seq_printf(m, "CoreDumping:\t%d\n", !!mm->core_state);
+}
+
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
@@ -380,6 +385,7 @@ int proc_pid_status(struct seq_file *m,
 
 	if (mm) {
 		task_mem(m, mm);
+		task_core_dumping(m, mm);
 		mmput(mm);
 	}
 	task_sig(m, task);
_

Patches currently in -mm which might be from guro@fb.com are

proc-coredump-add-coredumping-flag-to-proc-pid-status.patch


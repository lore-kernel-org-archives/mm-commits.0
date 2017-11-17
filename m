From: akpm@linux-foundation.org
Subject: [patch 10/94] proc, coredump: add CoreDumping flag to
 /proc/pid/status
Date: Fri, 17 Nov 2017 15:26:45 -0800
Message-ID: <20171117232645.BAq5Olslv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759117AbdKQX0r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:26:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, koct9i@gmail.com, mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Roman Gushchin <guro@fb.com>
Subject: proc, coredump: add CoreDumping flag to /proc/pid/status

Right now there is no convenient way to check if a process is being
coredumped at the moment.

It might be necessary to recognize such state to prevent killing the
process and getting a broken coredump.  Writing a large core might take
significant time, and the process is unresponsive during it, so it might
be killed by timeout, if another process is monitoring and
killing/restarting hanging tasks.

We're getting a significant number of corrupted coredump files on
machines in our fleet, just because processes are being killed by
timeout in the middle of the core writing process.

We do have a process health check, and some agent is responsible for
restarting processes which are not responding for health check
requests.  Writing a large coredump to the disk can easily exceed the
reasonable timeout (especially on an overloaded machine).

This flag will allow the agent to distinguish processes which are being
coredumped, extend the timeout for them, and let them produce a full
coredump file.

To provide an ability to detect if a process is in the state of being
coredumped, we can expose a boolean CoreDumping flag in
/proc/pid/status.

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

[guro@fb.com: document CoreDumping flag in /proc/<pid>/status]
  Link: http://lkml.kernel.org/r/20170928135357.GA8470@castle.DHCP.thefacebook.com
Link: http://lkml.kernel.org/r/20170920230634.31572-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    3 +++
 fs/proc/array.c                    |    6 ++++++
 2 files changed, 9 insertions(+)

diff -puN Documentation/filesystems/proc.txt~proc-coredump-add-coredumping-flag-to-proc-pid-status Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-coredump-add-coredumping-flag-to-proc-pid-status
+++ a/Documentation/filesystems/proc.txt
@@ -181,6 +181,7 @@ read the file /proc/PID/status:
   VmPTE:        20 kb
   VmSwap:        0 kB
   HugetlbPages:          0 kB
+  CoreDumping:    0
   Threads:        1
   SigQ:   0/28578
   SigPnd: 0000000000000000
@@ -253,6 +254,8 @@ Table 1-2: Contents of the status files
  VmSwap                      amount of swap used by anonymous private data
                              (shmem swap usage is not included)
  HugetlbPages                size of hugetlb memory portions
+ CoreDumping                 process's memory is currently being dumped
+                             (killing the process may lead to a corrupted core)
  Threads                     number of threads
  SigQ                        number of signals queued/max. number for queue
  SigPnd                      bitmap of pending signals for the thread
diff -puN fs/proc/array.c~proc-coredump-add-coredumping-flag-to-proc-pid-status fs/proc/array.c
--- a/fs/proc/array.c~proc-coredump-add-coredumping-flag-to-proc-pid-status
+++ a/fs/proc/array.c
@@ -366,6 +366,11 @@ static void task_cpus_allowed(struct seq
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
@@ -376,6 +381,7 @@ int proc_pid_status(struct seq_file *m,
 
 	if (mm) {
 		task_mem(m, mm);
+		task_core_dumping(m, mm);
 		mmput(mm);
 	}
 	task_sig(m, task);
_

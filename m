From: akpm@linux-foundation.org
Subject: + fs-proc-dont-expose-absolute-kernel-addresses-via-wchan.patch
 added to -mm tree
Date: Wed, 30 Sep 2015 14:52:42 -0700
Message-ID: <560c59aa.6OJLAwGJ1CfA6DGH%akpm__45851.4583566741$1443649978$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769AbbI3Vwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@kernel.org, a.p.zijlstra@chello.nl, andreyknvl@google.com, bp@alien8.de, dvlasenk@redhat.com, dvyukov@google.com, efault@gmx.de, glider@google.com, kcc@google.com, keescook@chromium.org, luto@kernel.org, ryabinin.a.a@gmail.com, sasha.levin@oracle.com, stable@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc: don't expose absolute kernel addresses via wchan
has been added to the -mm tree.  Its filename is
     fs-proc-dont-expose-absolute-kernel-addresses-via-wchan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-dont-expose-absolute-kernel-addresses-via-wchan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-dont-expose-absolute-kernel-addresses-via-wchan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ingo Molnar <mingo@kernel.org>
Subject: fs/proc: don't expose absolute kernel addresses via wchan

wchan leaks absolute kernel addresses to unprivileged user-space, of
kernel functions that sleep:

static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
                          struct pid *pid, struct task_struct *task)
{
        unsigned long wchan;
        char symname[KSYM_NAME_LEN];

        wchan = get_wchan(task);

        if (lookup_symbol_name(wchan, symname) < 0) {
                if (!ptrace_may_access(task, PTRACE_MODE_READ))
                        return 0;
                seq_printf(m, "%lu", wchan);
        } else {
                seq_printf(m, "%s", symname);
        }

        return 0;
}

So for example it trivially leaks the KASLR offset to any local attacker:

  fomalhaut:~> printf "%016lx\n" $(cat /proc/$$/stat | cut -d' ' -f35)
  ffffffff8123b380

Most real-life uses of wchan are symbolic:

  ps -eo pid:10,tid:10,wchan:30,comm

and procps uses /proc/PID/wchan, not the absolute address in
/proc/PID/stat:

  triton:~/tip> strace -f ps -eo pid:10,tid:10,wchan:30,comm 2>&1 | grep wchan | tail -1
  open("/proc/30833/wchan", O_RDONLY)     = 6

These days there's very little legitimate reason user-space would be
interested in the absolute address.  The absolute address is mostly
historic: from the days when we didn't have kallsyms and user-space procps
had to do the decoding itself via the System.map.

So this patch sets all numeric output to 0 and keeps the symbolic output
in /proc/PID/wchan.

( The absolute sleep address can generally still be profiled via
  perf, by tasks with sufficient privileges. )

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20150930071537.GA19048@gmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    6 ++----
 fs/proc/base.c  |    7 +------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff -puN fs/proc/array.c~fs-proc-dont-expose-absolute-kernel-addresses-via-wchan fs/proc/array.c
--- a/fs/proc/array.c~fs-proc-dont-expose-absolute-kernel-addresses-via-wchan
+++ a/fs/proc/array.c
@@ -375,7 +375,7 @@ int proc_pid_status(struct seq_file *m,
 static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task, int whole)
 {
-	unsigned long vsize, eip, esp, wchan = ~0UL;
+	unsigned long vsize, eip, esp;
 	int priority, nice;
 	int tty_pgrp = -1, tty_nr = 0;
 	sigset_t sigign, sigcatch;
@@ -454,8 +454,6 @@ static int do_task_stat(struct seq_file
 		unlock_task_sighand(task, &flags);
 	}
 
-	if (permitted && (!whole || num_threads < 2))
-		wchan = get_wchan(task);
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
@@ -507,7 +505,7 @@ static int do_task_stat(struct seq_file
 	seq_put_decimal_ull(m, ' ', task->blocked.sig[0] & 0x7fffffffUL);
 	seq_put_decimal_ull(m, ' ', sigign.sig[0] & 0x7fffffffUL);
 	seq_put_decimal_ull(m, ' ', sigcatch.sig[0] & 0x7fffffffUL);
-	seq_put_decimal_ull(m, ' ', wchan);
+	seq_puts(m, " 0"); /* Used to be numeric wchan - replaced by /proc/PID/wchan */
 	seq_put_decimal_ull(m, ' ', 0);
 	seq_put_decimal_ull(m, ' ', 0);
 	seq_put_decimal_ll(m, ' ', task->exit_signal);
diff -puN fs/proc/base.c~fs-proc-dont-expose-absolute-kernel-addresses-via-wchan fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-dont-expose-absolute-kernel-addresses-via-wchan
+++ a/fs/proc/base.c
@@ -430,13 +430,8 @@ static int proc_pid_wchan(struct seq_fil
 
 	wchan = get_wchan(task);
 
-	if (lookup_symbol_name(wchan, symname) < 0) {
-		if (!ptrace_may_access(task, PTRACE_MODE_READ))
-			return 0;
-		seq_printf(m, "%lu", wchan);
-	} else {
+	if (!lookup_symbol_name(wchan, symname))
 		seq_printf(m, "%s", symname);
-	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from mingo@kernel.org are

fs-proc-dont-expose-absolute-kernel-addresses-via-wchan.patch


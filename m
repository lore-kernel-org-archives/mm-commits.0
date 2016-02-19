From: akpm@linux-foundation.org
Subject: + proc-add-proc-pid-timerslack_ns-interface-fix.patch added to
 -mm tree
Date: Fri, 19 Feb 2016 12:33:36 -0800
Message-ID: <56c77c20.arAhLfWKtmgdvogA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1426202AbcBSUdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Feb 2016 15:33:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john.stultz@linaro.org, arjan@linux.intel.com, kandoiruchi@google.com, keescook@chromium.org, kernel-team@android.com, orenl@cellrox.com, romlem@android.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: /proc/<pid>/timerslack_ns permissions fixes
has been added to the -mm tree.  Its filename is
     proc-add-proc-pid-timerslack_ns-interface-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-proc-pid-timerslack_ns-interface-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-proc-pid-timerslack_ns-interface-fix.patch

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
Subject: proc: /proc/<pid>/timerslack_ns permissions fixes

This patch adjusts the timerslack_ns file permissions to be 0666 but
requires PTRACE_MODE_ATTACH_FSCREDS to read or write the value.

This allows tasks with sufficient privledges (CAP_SYS_PTRACE) to be able
to modify a the timerslack for proccesses owned by a different user.

This patch also fixes a return value from EINVAL to EPERM, and does task
locking consistently, given we're handling u64s on 32bit systems.  It also
makes use of kstrtoull_from_user which simplifies some code.

I've also wired up the Android userspace side to use this interface, and
tested it there, and things seem to be working properly ( - with some
selinux noise, I still need to figure out the selinux policy changes, but
its working with permissive mode).

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oren Laadan <orenl@cellrox.com>
Cc: Ruchi Kandoi <kandoiruchi@google.com>
Cc: Rom Lemarchand <romlem@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN fs/proc/base.c~proc-add-proc-pid-timerslack_ns-interface-fix fs/proc/base.c
--- a/fs/proc/base.c~proc-add-proc-pid-timerslack_ns-interface-fix
+++ a/fs/proc/base.c
@@ -2262,18 +2262,10 @@ static ssize_t timerslack_ns_write(struc
 {
 	struct inode *inode = file_inode(file);
 	struct task_struct *p;
-	char buffer[PROC_NUMBUF];
 	u64 slack_ns;
 	int err;
 
-	memset(buffer, 0, sizeof(buffer));
-	if (count > sizeof(buffer) - 1)
-		count = sizeof(buffer) - 1;
-
-	if (copy_from_user(buffer, buf, count))
-		return -EFAULT;
-
-	err = kstrtoull(strstrip(buffer), 10, &slack_ns);
+	err = kstrtoull_from_user(buf, count, 10, &slack_ns);
 	if (err < 0)
 		return err;
 
@@ -2282,12 +2274,14 @@ static ssize_t timerslack_ns_write(struc
 		return -ESRCH;
 
 	if (ptrace_may_access(p, PTRACE_MODE_ATTACH_FSCREDS)) {
+		task_lock(p);
 		if (slack_ns == 0)
 			p->timer_slack_ns = p->default_timer_slack_ns;
 		else
 			p->timer_slack_ns = slack_ns;
+		task_unlock(p);
 	} else
-		count = -EINVAL;
+		count = -EPERM;
 
 	put_task_struct(p);
 
@@ -2298,18 +2292,22 @@ static int timerslack_ns_show(struct seq
 {
 	struct inode *inode = m->private;
 	struct task_struct *p;
+	int err =  0;
 
 	p = get_proc_task(inode);
 	if (!p)
 		return -ESRCH;
 
-	task_lock(p);
-	seq_printf(m, "%llu\n", p->timer_slack_ns);
-	task_unlock(p);
+	if (ptrace_may_access(p, PTRACE_MODE_ATTACH_FSCREDS)) {
+		task_lock(p);
+		seq_printf(m, "%llu\n", p->timer_slack_ns);
+		task_unlock(p);
+	} else
+		err = -EPERM;
 
 	put_task_struct(p);
 
-	return 0;
+	return err;
 }
 
 static int timerslack_ns_open(struct inode *inode, struct file *filp)
@@ -2899,7 +2897,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("timers",	  S_IRUGO, proc_timers_operations),
 #endif
-	REG("timerslack_ns", S_IRUGO|S_IWUSR, proc_pid_set_timerslack_ns_operations),
+	REG("timerslack_ns", S_IRUGO|S_IWUGO, proc_pid_set_timerslack_ns_operations),
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
_

Patches currently in -mm which might be from john.stultz@linaro.org are

timer-convert-timer_slack_ns-from-unsigned-long-to-u64.patch
proc-add-proc-pid-timerslack_ns-interface.patch
proc-add-proc-pid-timerslack_ns-interface-fix.patch


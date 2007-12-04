From: akpm@linux-foundation.org
Subject: + fix-for-futex_wait-signal-stack-corruption.patch added to -mm tree
Date: Tue, 04 Dec 2007 13:20:39 -0800
Message-ID: <200712042120.lB4LKdx3005892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57124 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbXLDVWW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 16:22:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, David.Holmes@Sun.COM, mingo@elte.hu, roland@redhat.com, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     fix for futex_wait signal stack corruption
has been added to the -mm tree.  Its filename is
     fix-for-futex_wait-signal-stack-corruption.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix for futex_wait signal stack corruption
From: Steven Rostedt <rostedt@goodmis.org>

David Holmes found a bug in the RT patch with respect to
pthread_cond_timedwait.  After trying his test program on the latest git
from mainline, I found the bug was there too.  The bug he was seeing that
his test program showed, was that if one were to do a "Ctrl-Z" on a process
that was in the pthread_cond_timedwait, and then did a "bg" on that
process, it would return with a "-ETIMEDOUT" but early.  That is, the timer
would go off early.

Looking into this, I found the source of the problem. And it is a rather
nasty bug at that.

Here's the relevant code from kernel/futex.c: (not in order in the file)

[...]
smlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
                          struct timespec __user *utime, u32 __user *uaddr2,
                          u32 val3)
{
        struct timespec ts;
        ktime_t t, *tp = NULL;
        u32 val2 = 0;
        int cmd = op & FUTEX_CMD_MASK;

        if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI)) {
                if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
                        return -EFAULT;
                if (!timespec_valid(&ts))
                        return -EINVAL;

                t = timespec_to_ktime(ts);
                if (cmd == FUTEX_WAIT)
                        t = ktime_add(ktime_get(), t);
                tp = &t;
        }
[...]
        return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
}

[...]

long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
                u32 __user *uaddr2, u32 val2, u32 val3)
{
        int ret;
        int cmd = op & FUTEX_CMD_MASK;
        struct rw_semaphore *fshared = NULL;

        if (!(op & FUTEX_PRIVATE_FLAG))
                fshared = &current->mm->mmap_sem;

        switch (cmd) {
        case FUTEX_WAIT:
                ret = futex_wait(uaddr, fshared, val, timeout);

[...]

static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
                      u32 val, ktime_t *abs_time)
{
[...]
               struct restart_block *restart;
                restart = &current_thread_info()->restart_block;
                restart->fn = futex_wait_restart;
                restart->arg0 = (unsigned long)uaddr;
                restart->arg1 = (unsigned long)val;
                restart->arg2 = (unsigned long)abs_time;
                restart->arg3 = 0;
                if (fshared)
                        restart->arg3 |= ARG3_SHARED;
                return -ERESTART_RESTARTBLOCK;
[...]

static long futex_wait_restart(struct restart_block *restart)
{
        u32 __user *uaddr = (u32 __user *)restart->arg0;
        u32 val = (u32)restart->arg1;
        ktime_t *abs_time = (ktime_t *)restart->arg2;
        struct rw_semaphore *fshared = NULL;

        restart->fn = do_no_restart_syscall;
        if (restart->arg3 & ARG3_SHARED)
                fshared = &current->mm->mmap_sem;
        return (long)futex_wait(uaddr, fshared, val, abs_time);
}

So when the futex_wait is interrupt by a signal we break out of the hrtimer
code and set up for return from signal.  This code does not return back to
userspace, so we set up a RESTARTBLOCK.  The bug here is that we save the
"abs_time" which is a pointer to the stack variable "ktime_t t" from
sys_futex.

This returns and unwinds the stack before we get to call our signal.  On
return from the signal we go to futex_wait_restart, where we update all the
parameters for futex_wait and call it.  But here we have a problem where
abs_time is no longer valid.

I verified this with print statements, and sure enough, what abs_time was
set to ends up being garbage when we get to futex_wait_restart.

The solution I did to solve this is to allocate a temporary buffer when
setting up the block and free it in futex_wait_restart.  This patch allows
David's test program to actually pass.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Holmes <David.Holmes@Sun.COM>
Cc: Roland McGrath <roland@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff -puN kernel/futex.c~fix-for-futex_wait-signal-stack-corruption kernel/futex.c
--- a/kernel/futex.c~fix-for-futex_wait-signal-stack-corruption
+++ a/kernel/futex.c
@@ -1288,11 +1288,27 @@ static int futex_wait(u32 __user *uaddr,
 		return -ERESTARTSYS;
 	else {
 		struct restart_block *restart;
+		ktime_t *tmp_time = NULL;
+
+		/*
+		 * abs_time is on the stack and is not a parameter.
+		 * If we save it, it will be overridden on return and
+		 * what is sent to futex_wait_restart will be corrupted.
+		 */
+		if (abs_time) {
+			tmp_time = kmalloc(sizeof(*tmp_time), GFP_KERNEL);
+			if (unlikely(!tmp_time))
+				/* Ahh, what else can we do?? */
+				printk(KERN_WARNING
+				       "Can't allocate temp timer storage\n");
+			else
+				*tmp_time = *abs_time;
+		}
 		restart = &current_thread_info()->restart_block;
 		restart->fn = futex_wait_restart;
 		restart->arg0 = (unsigned long)uaddr;
 		restart->arg1 = (unsigned long)val;
-		restart->arg2 = (unsigned long)abs_time;
+		restart->arg2 = (unsigned long)tmp_time;
 		restart->arg3 = 0;
 		if (fshared)
 			restart->arg3 |= ARG3_SHARED;
@@ -1312,13 +1328,19 @@ static long futex_wait_restart(struct re
 {
 	u32 __user *uaddr = (u32 __user *)restart->arg0;
 	u32 val = (u32)restart->arg1;
-	ktime_t *abs_time = (ktime_t *)restart->arg2;
+	ktime_t *tmp_time = (ktime_t *)restart->arg2;
+	ktime_t t;
 	struct rw_semaphore *fshared = NULL;
 
+	if (tmp_time) {
+		t = *tmp_time;
+		kfree(tmp_time);
+		tmp_time = &t;
+	}
 	restart->fn = do_no_restart_syscall;
 	if (restart->arg3 & ARG3_SHARED)
 		fshared = &current->mm->mmap_sem;
-	return (long)futex_wait(uaddr, fshared, val, abs_time);
+	return (long)futex_wait(uaddr, fshared, val, tmp_time);
 }
 
 
_

Patches currently in -mm which might be from rostedt@goodmis.org are

git-x86.patch
fix-for-futex_wait-signal-stack-corruption.patch

From: akpm@linux-foundation.org
Subject: + sched-remove-long-deprecated-clone_stopped-flag.patch added to -mm tree
Date: Tue, 04 Jan 2011 14:48:44 -0800
Message-ID: <201101042248.p04MmiqM028638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab1ADWtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 17:49:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, mingo@elte.hu, peterz@infradead.org, tj@kernel.org


The patch titled
     sched: remove long deprecated CLONE_STOPPED flag
has been added to the -mm tree.  Its filename is
     sched-remove-long-deprecated-clone_stopped-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: remove long deprecated CLONE_STOPPED flag
From: Dave Jones <davej@redhat.com>

This warning was added in commit bdff746a3915 ("clone: prepare to recycle
CLONE_STOPPED") three years ago.  2.6.26 came and went.  As far as I know,
no-one is actually using CLONE_STOPPED.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    3 ++-
 kernel/fork.c         |   28 +---------------------------
 2 files changed, 3 insertions(+), 28 deletions(-)

diff -puN include/linux/sched.h~sched-remove-long-deprecated-clone_stopped-flag include/linux/sched.h
--- a/include/linux/sched.h~sched-remove-long-deprecated-clone_stopped-flag
+++ a/include/linux/sched.h
@@ -21,7 +21,8 @@
 #define CLONE_DETACHED		0x00400000	/* Unused, ignored */
 #define CLONE_UNTRACED		0x00800000	/* set if the tracing process can't force CLONE_PTRACE on this clone */
 #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
-#define CLONE_STOPPED		0x02000000	/* Start in stopped state */
+/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
+   and is now available for re-use. */
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
diff -puN kernel/fork.c~sched-remove-long-deprecated-clone_stopped-flag kernel/fork.c
--- a/kernel/fork.c~sched-remove-long-deprecated-clone_stopped-flag
+++ a/kernel/fork.c
@@ -1411,23 +1411,6 @@ long do_fork(unsigned long clone_flags,
 	}
 
 	/*
-	 * We hope to recycle these flags after 2.6.26
-	 */
-	if (unlikely(clone_flags & CLONE_STOPPED)) {
-		static int __read_mostly count = 100;
-
-		if (count > 0 && printk_ratelimit()) {
-			char comm[TASK_COMM_LEN];
-
-			count--;
-			printk(KERN_INFO "fork(): process `%s' used deprecated "
-					"clone flags 0x%lx\n",
-				get_task_comm(comm, current),
-				clone_flags & CLONE_STOPPED);
-		}
-	}
-
-	/*
 	 * When called from kernel_thread, don't do user tracing stuff.
 	 */
 	if (likely(user_mode(regs)))
@@ -1465,16 +1448,7 @@ long do_fork(unsigned long clone_flags,
 		 */
 		p->flags &= ~PF_STARTING;
 
-		if (unlikely(clone_flags & CLONE_STOPPED)) {
-			/*
-			 * We'll start up with an immediate SIGSTOP.
-			 */
-			sigaddset(&p->pending.signal, SIGSTOP);
-			set_tsk_thread_flag(p, TIF_SIGPENDING);
-			__set_task_state(p, TASK_STOPPED);
-		} else {
-			wake_up_new_task(p, clone_flags);
-		}
+		wake_up_new_task(p, clone_flags);
 
 		tracehook_report_clone_complete(trace, regs,
 						clone_flags, nr, p);
_

Patches currently in -mm which might be from davej@redhat.com are

linux-next.patch
sched-remove-long-deprecated-clone_stopped-flag.patch
checkpatch-check-for-world-writeable-sysfs-debugfs-files.patch


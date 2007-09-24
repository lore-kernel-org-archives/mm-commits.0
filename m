From: akpm@linux-foundation.org
Subject: - patch-getrusage-return-ru_maxrss.patch removed from -mm tree
Date: Mon, 24 Sep 2007 00:57:23 -0700
Message-ID: <200709240757.l8O7vQ2V015904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36997 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756504AbXIXH6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 03:58:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fmayhar@google.com, oleg@tv-sign.ru, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     getrusage: return ru_maxrss
has been removed from the -mm tree.  Its filename was
     patch-getrusage-return-ru_maxrss.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: getrusage: return ru_maxrss
From: Frank Mayhar <fmayhar@google.com>

Properly support the ru_maxrss field of the rusage structure returned by
getrusage().  This patch includes documentation both of the getrusage()
implementation in general and of the ru_maxrss implementation specifically.
 This implementation matches that of FreeBSD, which is the only other OS of
which I'm aware that implements this field.

Like a number of other folks, we recently had a need for a non-/proc way of
getting the RSS of a process and happened on getrusage().  Unlike the rest,
though, we fixed the system call to do what we want.  I wrote a wrong
implementation and submitted it while I was sick; this time I took my time
and I think I got it right.

A test program that has been run against a number of systems (of which
only FreeBSD and Linux 2.6 with this patch applied passed) is also
available at
	http://www.exit.com/Archives/Linux/

Signed-off-by: Frank Mayhar <fmayhar@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    3 +++
 kernel/exit.c         |   21 +++++++++++++++++++++
 kernel/fork.c         |    2 ++
 kernel/sys.c          |    5 +++++
 4 files changed, 31 insertions(+)

diff -puN include/linux/sched.h~patch-getrusage-return-ru_maxrss include/linux/sched.h
--- a/include/linux/sched.h~patch-getrusage-return-ru_maxrss
+++ a/include/linux/sched.h
@@ -449,6 +449,7 @@ struct signal_struct {
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
+	unsigned long cmaxrss;
 
 	/*
 	 * Cumulative ns of scheduled CPU time for dead threads in the
@@ -942,6 +943,8 @@ struct task_struct {
 	struct timespec real_start_time;	/* boot based time */
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
 	unsigned long min_flt, maj_flt;
+/* maxrss gets the hiwater_rss in do_exit() */
+	unsigned long maxrss;
 
   	cputime_t it_prof_expires, it_virt_expires;
 	unsigned long long it_sched_expires;
diff -puN kernel/exit.c~patch-getrusage-return-ru_maxrss kernel/exit.c
--- a/kernel/exit.c~patch-getrusage-return-ru_maxrss
+++ a/kernel/exit.c
@@ -125,6 +125,8 @@ static void __exit_signal(struct task_st
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
+		if (tsk->maxrss > sig->cmaxrss)
+			sig->cmaxrss = tsk->maxrss;
 		sig = NULL; /* Marker for below. */
 	}
 
@@ -947,6 +949,14 @@ fastcall NORET_TYPE void do_exit(long co
 	if (tsk->mm) {
 		update_hiwater_rss(tsk->mm);
 		update_hiwater_vm(tsk->mm);
+		BUG_ON(tsk->maxrss != 0);
+		/*
+		 * Store the hiwater_rss in a task field, since when we need
+		 * it in __exit_signal() the mm structure is gone; we can't
+		 * stuff it in the signal structure since then we would be
+		 * racing with wait_task_zombie().
+		 */
+		tsk->maxrss = tsk->mm->hiwater_rss;
 	}
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
@@ -1255,6 +1265,17 @@ static int wait_task_zombie(struct task_
 		psig->coublock +=
 			task_io_get_oublock(p) +
 			sig->oublock + sig->coublock;
+		/*
+		 * Save the maximum RSS of this task and all its terminated,
+		 * waited-for children.  Don't accumulate the RSS since, one,
+		 * other operating systems (FreeBSD, AIX) do it this way and,
+		 * two, the cumulative RSS of a long-lived process with lots
+		 * of sequential child process would be meaningless.
+		 */
+		if (sig->cmaxrss > psig->cmaxrss)
+			psig->cmaxrss = sig->cmaxrss;
+		if (p->maxrss > psig->cmaxrss)
+			psig->cmaxrss = p->maxrss;
 		spin_unlock_irq(&p->parent->sighand->siglock);
 	}
 
diff -puN kernel/fork.c~patch-getrusage-return-ru_maxrss kernel/fork.c
--- a/kernel/fork.c~patch-getrusage-return-ru_maxrss
+++ a/kernel/fork.c
@@ -546,6 +546,7 @@ static int copy_mm(unsigned long clone_f
 
 	tsk->min_flt = tsk->maj_flt = 0;
 	tsk->nvcsw = tsk->nivcsw = 0;
+	tsk->maxrss = 0;
 
 	tsk->mm = NULL;
 	tsk->active_mm = NULL;
@@ -891,6 +892,7 @@ static inline int copy_signal(unsigned l
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
 	sig->sum_sched_runtime = 0;
+	sig->cmaxrss = 0;
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
 	INIT_LIST_HEAD(&sig->cpu_timers[2]);
diff -puN kernel/sys.c~patch-getrusage-return-ru_maxrss kernel/sys.c
--- a/kernel/sys.c~patch-getrusage-return-ru_maxrss
+++ a/kernel/sys.c
@@ -1567,6 +1567,7 @@ static void k_getrusage(struct task_stru
 			r->ru_majflt = p->signal->cmaj_flt;
 			r->ru_inblock = p->signal->cinblock;
 			r->ru_oublock = p->signal->coublock;
+			r->ru_maxrss = p->signal->cmaxrss;
 
 			if (who == RUSAGE_CHILDREN)
 				break;
@@ -1592,11 +1593,15 @@ static void k_getrusage(struct task_stru
 				r->ru_oublock += task_io_get_oublock(t);
 				t = next_thread(t);
 			} while (t != p);
+			update_hiwater_rss(p->mm);
+			if (r->ru_maxrss < p->mm->hiwater_rss)
+				r->ru_maxrss = p->mm->hiwater_rss;
 			break;
 
 		default:
 			BUG();
 	}
+	r->ru_maxrss <<= PAGE_SHIFT - 10; /* Convert from pages to kilobytes. */
 
 	unlock_task_sighand(p, &flags);
 	rcu_read_unlock();
_

Patches currently in -mm which might be from fmayhar@google.com are

patch-getrusage-return-ru_maxrss.patch

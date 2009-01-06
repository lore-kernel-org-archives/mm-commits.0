From: akpm@linux-foundation.org
Subject: + getrusage-fill-ru_maxrss-value.patch added to -mm tree
Date: Tue, 06 Jan 2009 08:38:19 -0800
Message-ID: <200901061638.n06GcJWP031316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbZAFQiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 11:38:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpirko@redhat.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com


The patch titled
     getrusage: fill ru_maxrss value
has been added to the -mm tree.  Its filename is
     getrusage-fill-ru_maxrss-value.patch

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
Subject: getrusage: fill ru_maxrss value
From: Jiri Pirko <jpirko@redhat.com>

Make ->ru_maxrss value in struct rusage filled accordingly to rss hiwater
mark.  This struct is filled as a parameter to getrusage syscall. 
->ru_maxrss value is set to KBs which is the way it is done in BSD
systems.  /usr/bin/time (gnu time) application converts ->ru_maxrss to KBs
which seems to be incorrect behavior.  Maintainer of this util was
notified by me with the patch which corrects it and cc'ed.

To make this happen we extend struct signal_struct by two fields.  The
first one is ->maxrss which we use to store rss hiwater of the task.  The
second one is ->cmaxrss which we use to store highest rss hiwater of all
task childs.  These values are used in k_getrusage() to actually fill
->ru_maxrss.  k_getrusage() uses current rss hiwater value directly if mm
struct exists.

Note:
exec() clear mm->hiwater_rss, but doesn't clear sig->maxrss.
it is intetionally behavior. *BSD getrusage have exec() inheriting.

Test progmam and test case
===========================

getrusage.c
====
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <signal.h>

static void consume(int mega)
{
	size_t sz = mega * 1024 * 1024;
	void *ptr;

	ptr = malloc(sz);
	memset(ptr, 0, sz);
	usleep(1);  /* BSD rusage statics need to sleep 1 tick */
}

static void show_rusage(char *prefix)
{
	int err, err2;
	struct rusage rusage_self;
	struct rusage rusage_children;

	printf("%s: ", prefix);
	err = getrusage(RUSAGE_SELF, &rusage_self);
	if (!err)
		printf("self %ld ", rusage_self.ru_maxrss);
	err2 = getrusage(RUSAGE_CHILDREN, &rusage_children);
	if (!err2)
		printf("children %ld ", rusage_children.ru_maxrss);

	printf("\n");
}

int main(int argc, char** argv)
{
	int status;
	int c;
	int need_sleep_before_wait = 0;
	int consume_large_memory_at_first = 0;
	int create_child_at_first = 0;
	int sigign = 0;
	int create_child_before_exec = 0;
	int after_fork_test = 0;

	while ((c = getopt(argc, argv, "ceflsz")) != -1) {
		switch (c) {
		case 'c':
			create_child_at_first = 1;
			break;
		case 'e':
			create_child_before_exec = 1;
			break;
		case 'f':
			after_fork_test = 1;
			break;
		case 'l':
			consume_large_memory_at_first = 1;
			break;
		case 's':
			sigign = 1;
			break;
		case 'z':
			need_sleep_before_wait = 1;
			break;
		default:
			break;
		}
	}

	if (consume_large_memory_at_first)
		consume(100);

	if (create_child_at_first)
		system("./child -q");

	if (sigign)
		signal(SIGCHLD, SIG_IGN);

	if (fork()) {
		usleep(1);
		if (need_sleep_before_wait)
			sleep(3); /* children become zombie */
		show_rusage("pre_wait");
		wait(&status);
		show_rusage("post_wait");
	} else {
		usleep(1);
		show_rusage("fork");

		if (after_fork_test) {
			consume(30);
			show_rusage("fork2");
		}
		if (create_child_before_exec) {
			system("./child -lq");
			usleep(1);
			show_rusage("fork3");
		}

		execl("./child", "child", 0);
		exit(0);
	}

	return 0;
}

child.c
====
#include <sys/types.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>

static void consume(int mega)
{
	size_t sz = mega * 1024 * 1024;
	void *ptr;

	ptr = malloc(sz);
	memset(ptr, 0, sz);
	usleep(1);  /* BSD rusage statics need to sleep 1 tick */
}

static void show_rusage(char *prefix)
{
	int err, err2;
	struct rusage rusage_self;
	struct rusage rusage_children;

	printf("%s: ", prefix);
	err = getrusage(RUSAGE_SELF, &rusage_self);
	if (!err)
		printf("self %ld ", rusage_self.ru_maxrss);
	err2 = getrusage(RUSAGE_CHILDREN, &rusage_children);
	if (!err2)
		printf("children %ld ", rusage_children.ru_maxrss);

	printf("\n");

}

int main(int argc, char** argv)
{
	int status;
	int c;
	int silent = 0;
	int light_weight = 0;

	while ((c = getopt(argc, argv, "lq")) != -1) {
		switch (c) {
		case 'l':
			light_weight = 1;
			break;
		case 'q':
			silent = 1;
			break;
		default:
			break;
		}
	}

	if (!silent)
		show_rusage("exec");

	if (fork()) {
		if (light_weight)
			consume(400);
		else
			consume(700);
		wait(&status);
	} else {
		if (light_weight)
			consume(600);
		else
			consume(900);

		exit(0);
	}

	return 0;
}

testcase
========

1. inherit fork?

   test way:
   	% ./getrusage -lc

   bsd result:
   	fork line is "fork: self 0 children 0".

   	-> rusage sholdn't be inherit by fork.
	   (both RUSAGE_SELF and RUSAGE_CHILDREN)

2. inherit exec?

   test way:
   	% ./getrusage -lce

   bsd result:
   	fork3: self 103204 children 60000
	exec: self 103204 children 60000

   	fork3 and exec line are the same.

   	-> rusage shold be inherit by exec.
	   (both RUSAGE_SELF and RUSAGE_CHILDREN)

3. getrusage(RUSAGE_CHILDREN) collect grandchild statics?

   test way:
   	% ./getrusage

   bsd result:
   	post_wait line is about "post_wait: self 0 children 90000".

	-> RUSAGE_CHILDREN can collect grandchild.

4. zombie, but not waited children collect or not?

   test way:
   	% ./getrusage -z

   bsd result:
   	pre_wait line is "pre_wait: self 0 children 0".

	-> zombie child process (not waited-for child process)
	   isn't accounted.

5. SIG_IGN collect or not

   test way:
   	% ./getrusage -s

   bsd result:
   	post_wait line is "post_wait: self 0 children 0".

	-> if SIGCHLD is ignored, children isn't accounted.

6. fork and malloc
   test way:
   	% ./getrusage -lcf

   bsd result:
   	fork line is "fork: self 0 children 0".
   	fork2 line is about "fork: self 130000 children 0".

   	-> rusage sholdn't be inherit by fork.
	   (both RUSAGE_SELF and RUSAGE_CHILDREN)
	   but additional memory cunsumption cause right
	   maxrss calculation.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |    7 +++++++
 include/linux/sched.h |    1 +
 kernel/exit.c         |   10 ++++++++++
 kernel/fork.c         |    1 +
 kernel/sys.c          |   17 +++++++++++++++++
 5 files changed, 36 insertions(+)

diff -puN fs/exec.c~getrusage-fill-ru_maxrss-value fs/exec.c
--- a/fs/exec.c~getrusage-fill-ru_maxrss-value
+++ a/fs/exec.c
@@ -864,6 +864,13 @@ static int de_thread(struct task_struct 
 	sig->notify_count = 0;
 
 no_thread_group:
+	if (current->mm) {
+		unsigned long hiwater_rss = get_mm_hiwater_rss(current->mm);
+
+		if (sig->maxrss < hiwater_rss)
+			sig->maxrss = hiwater_rss;
+	}
+
 	exit_itimers(sig);
 	flush_itimer_signals();
 
diff -puN include/linux/sched.h~getrusage-fill-ru_maxrss-value include/linux/sched.h
--- a/include/linux/sched.h~getrusage-fill-ru_maxrss-value
+++ a/include/linux/sched.h
@@ -560,6 +560,7 @@ struct signal_struct {
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
+	unsigned long maxrss, cmaxrss;
 	struct task_io_accounting ioac;
 
 	/*
diff -puN kernel/exit.c~getrusage-fill-ru_maxrss-value kernel/exit.c
--- a/kernel/exit.c~getrusage-fill-ru_maxrss-value
+++ a/kernel/exit.c
@@ -1053,6 +1053,12 @@ NORET_TYPE void do_exit(long code)
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
 		exit_itimers(tsk->signal);
+		if (tsk->mm) {
+			unsigned long hiwater_rss = get_mm_hiwater_rss(tsk->mm);
+
+			if (tsk->signal->maxrss < hiwater_rss)
+				tsk->signal->maxrss = hiwater_rss;
+		}
 	}
 	acct_collect(code, group_dead);
 	if (group_dead)
@@ -1296,6 +1302,7 @@ static int wait_task_zombie(struct task_
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 		struct task_cputime cputime;
+		unsigned long maxrss;
 
 		/*
 		 * The resource counters for the group leader are in its
@@ -1347,6 +1354,9 @@ static int wait_task_zombie(struct task_
 		psig->coublock +=
 			task_io_get_oublock(p) +
 			sig->oublock + sig->coublock;
+		maxrss = max(sig->maxrss, sig->cmaxrss);
+		if (psig->cmaxrss < maxrss)
+			psig->cmaxrss = maxrss;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
 		spin_unlock_irq(&p->parent->sighand->siglock);
diff -puN kernel/fork.c~getrusage-fill-ru_maxrss-value kernel/fork.c
--- a/kernel/fork.c~getrusage-fill-ru_maxrss-value
+++ a/kernel/fork.c
@@ -851,6 +851,7 @@ static int copy_signal(unsigned long clo
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
+	sig->maxrss = sig->cmaxrss = 0;
 	task_io_accounting_init(&sig->ioac);
 	taskstats_tgid_init(sig);
 
diff -puN kernel/sys.c~getrusage-fill-ru_maxrss-value kernel/sys.c
--- a/kernel/sys.c~getrusage-fill-ru_maxrss-value
+++ a/kernel/sys.c
@@ -1624,12 +1624,14 @@ static void k_getrusage(struct task_stru
 	unsigned long flags;
 	cputime_t utime, stime;
 	struct task_cputime cputime;
+	unsigned long maxrss = 0;
 
 	memset((char *) r, 0, sizeof *r);
 	utime = stime = cputime_zero;
 
 	if (who == RUSAGE_THREAD) {
 		accumulate_thread_rusage(p, r);
+		maxrss = p->signal->maxrss;
 		goto out;
 	}
 
@@ -1647,6 +1649,7 @@ static void k_getrusage(struct task_stru
 			r->ru_majflt = p->signal->cmaj_flt;
 			r->ru_inblock = p->signal->cinblock;
 			r->ru_oublock = p->signal->coublock;
+			maxrss = p->signal->cmaxrss;
 
 			if (who == RUSAGE_CHILDREN)
 				break;
@@ -1661,6 +1664,8 @@ static void k_getrusage(struct task_stru
 			r->ru_majflt += p->signal->maj_flt;
 			r->ru_inblock += p->signal->inblock;
 			r->ru_oublock += p->signal->oublock;
+			if (maxrss < p->signal->maxrss)
+				maxrss = p->signal->maxrss;
 			t = p;
 			do {
 				accumulate_thread_rusage(t, r);
@@ -1676,6 +1681,18 @@ static void k_getrusage(struct task_stru
 out:
 	cputime_to_timeval(utime, &r->ru_utime);
 	cputime_to_timeval(stime, &r->ru_stime);
+
+	if (who != RUSAGE_CHILDREN) {
+		struct mm_struct *mm = get_task_mm(p);
+		if (mm) {
+			unsigned long hiwater_rss = get_mm_hiwater_rss(mm);
+
+			if (maxrss < hiwater_rss)
+				maxrss = hiwater_rss;
+			mmput(mm);
+		}
+	}
+	r->ru_maxrss = maxrss * (PAGE_SIZE / 1024); /* convert pages to KBs */
 }
 
 int getrusage(struct task_struct *p, int who, struct rusage __user *ru)
_

Patches currently in -mm which might be from jpirko@redhat.com are

getrusage-fill-ru_maxrss-value.patch


From: akpm@linux-foundation.org
Subject: - add-rusage_thread.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:57 -0700
Message-ID: <200804300538.m3U5cvE7028788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754426AbYD3FkE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sripathik@in.ibm.com, drepper@redhat.com, mingo@elte.hu, mtk.manpages@googlemail.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     add RUSAGE_THREAD
has been removed from the -mm tree.  Its filename was
     add-rusage_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add RUSAGE_THREAD
From: Sripathi Kodi <sripathik@in.ibm.com>

Add the RUSAGE_THREAD option for the getrusage system call.  This is
essentially Roland's patch from http://lkml.org/lkml/2008/1/18/589, but the
line about RUSAGE_LWP line has been removed, as suggested by Ulrich and
Christoph.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/resource.h |    1 +
 kernel/sys.c             |   31 ++++++++++++++++++++++---------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff -puN include/linux/resource.h~add-rusage_thread include/linux/resource.h
--- a/include/linux/resource.h~add-rusage_thread
+++ a/include/linux/resource.h
@@ -19,6 +19,7 @@ struct task_struct;
 #define	RUSAGE_SELF	0
 #define	RUSAGE_CHILDREN	(-1)
 #define RUSAGE_BOTH	(-2)		/* sys_wait4() uses this */
+#define	RUSAGE_THREAD	1		/* only the calling thread */
 
 struct	rusage {
 	struct timeval ru_utime;	/* user time used */
diff -puN kernel/sys.c~add-rusage_thread kernel/sys.c
--- a/kernel/sys.c~add-rusage_thread
+++ a/kernel/sys.c
@@ -1545,6 +1545,19 @@ out:
  *
  */
 
+static void accumulate_thread_rusage(struct task_struct *t, struct rusage *r,
+				     cputime_t *utimep, cputime_t *stimep)
+{
+	*utimep = cputime_add(*utimep, t->utime);
+	*stimep = cputime_add(*stimep, t->stime);
+	r->ru_nvcsw += t->nvcsw;
+	r->ru_nivcsw += t->nivcsw;
+	r->ru_minflt += t->min_flt;
+	r->ru_majflt += t->maj_flt;
+	r->ru_inblock += task_io_get_inblock(t);
+	r->ru_oublock += task_io_get_oublock(t);
+}
+
 static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 {
 	struct task_struct *t;
@@ -1554,6 +1567,11 @@ static void k_getrusage(struct task_stru
 	memset((char *) r, 0, sizeof *r);
 	utime = stime = cputime_zero;
 
+	if (who == RUSAGE_THREAD) {
+		accumulate_thread_rusage(p, r, &utime, &stime);
+		goto out;
+	}
+
 	rcu_read_lock();
 	if (!lock_task_sighand(p, &flags)) {
 		rcu_read_unlock();
@@ -1586,14 +1604,7 @@ static void k_getrusage(struct task_stru
 			r->ru_oublock += p->signal->oublock;
 			t = p;
 			do {
-				utime = cputime_add(utime, t->utime);
-				stime = cputime_add(stime, t->stime);
-				r->ru_nvcsw += t->nvcsw;
-				r->ru_nivcsw += t->nivcsw;
-				r->ru_minflt += t->min_flt;
-				r->ru_majflt += t->maj_flt;
-				r->ru_inblock += task_io_get_inblock(t);
-				r->ru_oublock += task_io_get_oublock(t);
+				accumulate_thread_rusage(t, r, &utime, &stime);
 				t = next_thread(t);
 			} while (t != p);
 			break;
@@ -1605,6 +1616,7 @@ static void k_getrusage(struct task_stru
 	unlock_task_sighand(p, &flags);
 	rcu_read_unlock();
 
+out:
 	cputime_to_timeval(utime, &r->ru_utime);
 	cputime_to_timeval(stime, &r->ru_stime);
 }
@@ -1618,7 +1630,8 @@ int getrusage(struct task_struct *p, int
 
 asmlinkage long sys_getrusage(int who, struct rusage __user *ru)
 {
-	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN)
+	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
+	    who != RUSAGE_THREAD)
 		return -EINVAL;
 	return getrusage(current, who, ru);
 }
_

Patches currently in -mm which might be from sripathik@in.ibm.com are

origin.patch


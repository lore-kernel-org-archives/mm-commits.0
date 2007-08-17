From: akpm@linux-foundation.org
Subject: + accounting-regression-since-rc1.patch added to -mm tree
Date: Fri, 17 Aug 2007 12:37:01 -0700
Message-ID: <200708171937.l7HJb1Oj026102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbXHQThy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 15:37:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borntraeger@de.ibm.com, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, jang@linux.vnet.ibm.com, mingo@elte.hu, paulus@samba.org, schwidefsky@de.ibm.com


The patch titled
     accounting regression since rc1
has been added to the -mm tree.  Its filename is
     accounting-regression-since-rc1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: accounting regression since rc1
From: Christian Borntraeger <borntraeger@de.ibm.com>

Fix the accounting regression for CONFIG_VIRT_CPU_ACCOUNTING.  It reverts
parts of commit b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa by converting
fs/proc/array.c back to cputime_t.  The new functions task_utime and
task_stime now return cputime_t instead of clock_t.  If
CONFIG_VIRT_CPU_ACCOUTING is set, task->utime and task->stime are returned
directly instead of using sum_exec_runtime.

Patch is tested on s390x with and without VIRT_CPU_ACCOUTING as well as on
i386.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   41 ++++++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 15 deletions(-)

diff -puN fs/proc/array.c~accounting-regression-since-rc1 fs/proc/array.c
--- a/fs/proc/array.c~accounting-regression-since-rc1
+++ a/fs/proc/array.c
@@ -320,7 +320,18 @@ int proc_pid_status(struct task_struct *
 	return buffer - orig;
 }
 
-static clock_t task_utime(struct task_struct *p)
+#if defined(CONFIG_VIRT_CPU_ACCOUNTING)
+static cputime_t task_utime(struct task_struct *p)
+{
+	return p->utime;
+}
+
+static cputime_t task_stime(struct task_struct *p)
+{
+	return p->stime;
+}
+#else
+static cputime_t task_utime(struct task_struct *p)
 {
 	clock_t utime = cputime_to_clock_t(p->utime),
 		total = utime + cputime_to_clock_t(p->stime);
@@ -337,10 +348,10 @@ static clock_t task_utime(struct task_st
 	}
 	utime = (clock_t)temp;
 
-	return utime;
+	return clock_t_to_cputime(utime);
 }
 
-static clock_t task_stime(struct task_struct *p)
+static cputime_t task_stime(struct task_struct *p)
 {
 	clock_t stime;
 
@@ -349,10 +360,12 @@ static clock_t task_stime(struct task_st
 	 * the total, to make sure the total observed by userspace
 	 * grows monotonically - apps rely on that):
 	 */
-	stime = nsec_to_clock_t(p->se.sum_exec_runtime) - task_utime(p);
+	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
+			cputime_to_clock_t(task_utime(p));
 
-	return stime;
+	return clock_t_to_cputime(stime);
 }
+#endif
 
 static int do_task_stat(struct task_struct *task, char *buffer, int whole)
 {
@@ -368,8 +381,7 @@ static int do_task_stat(struct task_stru
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
 	unsigned long  min_flt = 0,  maj_flt = 0;
-	cputime_t cutime, cstime;
-	clock_t utime, stime;
+	cputime_t cutime, cstime, utime, stime;
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
@@ -387,8 +399,7 @@ static int do_task_stat(struct task_stru
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
-	cutime = cstime = cputime_zero;
-	utime = stime = 0;
+	cutime = cstime = utime = stime = cputime_zero;
 
 	rcu_read_lock();
 	if (lock_task_sighand(task, &flags)) {
@@ -414,15 +425,15 @@ static int do_task_stat(struct task_stru
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
-				utime += task_utime(t);
-				stime += task_stime(t);
+				utime = cputime_add(utime, task_utime(t));
+				stime = cputime_add(stime, task_stime(t));
 				t = next_thread(t);
 			} while (t != task);
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			utime += cputime_to_clock_t(sig->utime);
-			stime += cputime_to_clock_t(sig->stime);
+			utime = cputime_add(utime, sig->utime);
+			stime = cputime_add(stime, sig->stime);
 		}
 
 		sid = signal_session(sig);
@@ -471,8 +482,8 @@ static int do_task_stat(struct task_stru
 		cmin_flt,
 		maj_flt,
 		cmaj_flt,
-		utime,
-		stime,
+		cputime_to_clock_t(utime),
+		cputime_to_clock_t(stime),
 		cputime_to_clock_t(cutime),
 		cputime_to_clock_t(cstime),
 		priority,
_

Patches currently in -mm which might be from borntraeger@de.ibm.com are

git-s390.patch
accounting-regression-since-rc1.patch

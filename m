From: akpm@linux-foundation.org
Subject: + accounting-account-for-user-time-when-updating-memory-integrals.patch added to -mm tree
Date: Wed, 30 Apr 2008 12:04:38 -0700
Message-ID: <200804301904.m3UJ4cXL030008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760115AbYD3TFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 15:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlim@sgi.com, mingo@elte.hu


The patch titled
     accounting: account for user time when updating memory integrals
has been added to the -mm tree.  Its filename is
     accounting-account-for-user-time-when-updating-memory-integrals.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: accounting: account for user time when updating memory integrals
From: Jonathan Lim <jlim@sgi.com>

Adapt acct_update_integrals() to include user time when calculating the time
difference.  The units of acct_rss_mem1 and acct_vm_mem1 are also changed from
pages-jiffies to pages-usecs to avoid calling jiffies_to_usecs() in
xacct_add_tsk() which might overflow.

Signed-off-by: Jonathan Lim <jlim@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 kernel/sched.c        |    2 ++
 kernel/tsacct.c       |   21 ++++++++++++++-------
 3 files changed, 17 insertions(+), 8 deletions(-)

diff -puN include/linux/sched.h~accounting-account-for-user-time-when-updating-memory-integrals include/linux/sched.h
--- a/include/linux/sched.h~accounting-account-for-user-time-when-updating-memory-integrals
+++ a/include/linux/sched.h
@@ -1259,7 +1259,7 @@ struct task_struct {
 #if defined(CONFIG_TASK_XACCT)
 	u64 acct_rss_mem1;	/* accumulated rss usage */
 	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
-	cputime_t acct_stimexpd;/* stime since last update */
+	cputime_t acct_timexpd;	/* stime + utime since last update */
 #endif
 #ifdef CONFIG_NUMA
   	struct mempolicy *mempolicy;
diff -puN kernel/sched.c~accounting-account-for-user-time-when-updating-memory-integrals kernel/sched.c
--- a/kernel/sched.c~accounting-account-for-user-time-when-updating-memory-integrals
+++ a/kernel/sched.c
@@ -4305,6 +4305,8 @@ void account_user_time(struct task_struc
 		cpustat->nice = cputime64_add(cpustat->nice, tmp);
 	else
 		cpustat->user = cputime64_add(cpustat->user, tmp);
+	/* Account for user time used */
+	acct_update_integrals(p);
 }
 
 /*
diff -puN kernel/tsacct.c~accounting-account-for-user-time-when-updating-memory-integrals kernel/tsacct.c
--- a/kernel/tsacct.c~accounting-account-for-user-time-when-updating-memory-integrals
+++ a/kernel/tsacct.c
@@ -84,9 +84,9 @@ void xacct_add_tsk(struct taskstats *sta
 {
 	struct mm_struct *mm;
 
-	/* convert pages-jiffies to Mbyte-usec */
-	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
-	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
+	/* convert pages-usec to Mbyte-usec */
+	stats->coremem = p->acct_rss_mem1 * PAGE_SIZE / MB;
+	stats->virtmem = p->acct_vm_mem1 * PAGE_SIZE / MB;
 	mm = get_task_mm(p);
 	if (mm) {
 		/* adjust to KB unit */
@@ -118,12 +118,19 @@ void xacct_add_tsk(struct taskstats *sta
 void acct_update_integrals(struct task_struct *tsk)
 {
 	if (likely(tsk->mm)) {
-		long delta = cputime_to_jiffies(
-			cputime_sub(tsk->stime, tsk->acct_stimexpd));
+		cputime_t time, dtime;
+		struct timeval value;
+		u64 delta;
+
+		time = tsk->stime + tsk->utime;
+		dtime = cputime_sub(time, tsk->acct_timexpd);
+		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
+		delta = value.tv_sec;
+		delta = delta * USEC_PER_SEC + value.tv_usec;
 
 		if (delta == 0)
 			return;
-		tsk->acct_stimexpd = tsk->stime;
+		tsk->acct_timexpd = time;
 		tsk->acct_rss_mem1 += delta * get_mm_rss(tsk->mm);
 		tsk->acct_vm_mem1 += delta * tsk->mm->total_vm;
 	}
@@ -135,7 +142,7 @@ void acct_update_integrals(struct task_s
  */
 void acct_clear_integrals(struct task_struct *tsk)
 {
-	tsk->acct_stimexpd = 0;
+	tsk->acct_timexpd = 0;
 	tsk->acct_rss_mem1 = 0;
 	tsk->acct_vm_mem1 = 0;
 }
_

Patches currently in -mm which might be from jlim@sgi.com are

use-find_task_by_vpid-in-taskstats.patch
accounting-account-for-user-time-when-updating-memory-integrals.patch


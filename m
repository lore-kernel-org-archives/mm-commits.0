From: akpm@linux-foundation.org
Subject: + kernel-fix-for-checkpatch-errors-in-sys-file.patch added to -mm tree
Date: Thu, 28 Aug 2014 16:22:35 -0700
Message-ID: <53ffb9bb.Cex0kdZws6ZqAquC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:41150 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaH1XWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 19:22:36 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so423006ieb.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 16:22:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vishnu.ps@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: whitespace fixes
has been added to the -mm tree.  Its filename is
     kernel-fix-for-checkpatch-errors-in-sys-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-fix-for-checkpatch-errors-in-sys-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-fix-for-checkpatch-errors-in-sys-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "vishnu.ps" <vishnu.ps@samsung.com>
Subject: kernel/sys.c: whitespace fixes

Fix minor errors and warning messages in kernel/sys.c.  These errors were
reported by checkpatch while working with some modifications in sys.c
file.  Fixing this first will help me to improve my further patches.

ERROR: trailing whitespace - 9
ERROR: do not use assignment in if condition - 4
ERROR: spaces required around that '?' (ctx:VxO) - 10
ERROR: switch and case should be at the same indent - 3

total 26 errors & 3 warnings fixed.

Signed-off-by: vishnu.ps <vishnu.ps@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |  263 +++++++++++++++++++++++++------------------------
 1 file changed, 136 insertions(+), 127 deletions(-)

diff -puN kernel/sys.c~kernel-fix-for-checkpatch-errors-in-sys-file kernel/sys.c
--- a/kernel/sys.c~kernel-fix-for-checkpatch-errors-in-sys-file
+++ a/kernel/sys.c
@@ -62,28 +62,28 @@
 #include <asm/unistd.h>
 
 #ifndef SET_UNALIGN_CTL
-# define SET_UNALIGN_CTL(a,b)	(-EINVAL)
+# define SET_UNALIGN_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef GET_UNALIGN_CTL
-# define GET_UNALIGN_CTL(a,b)	(-EINVAL)
+# define GET_UNALIGN_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef SET_FPEMU_CTL
-# define SET_FPEMU_CTL(a,b)	(-EINVAL)
+# define SET_FPEMU_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef GET_FPEMU_CTL
-# define GET_FPEMU_CTL(a,b)	(-EINVAL)
+# define GET_FPEMU_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef SET_FPEXC_CTL
-# define SET_FPEXC_CTL(a,b)	(-EINVAL)
+# define SET_FPEXC_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef GET_FPEXC_CTL
-# define GET_FPEXC_CTL(a,b)	(-EINVAL)
+# define GET_FPEXC_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef GET_ENDIAN
-# define GET_ENDIAN(a,b)	(-EINVAL)
+# define GET_ENDIAN(a, b)	(-EINVAL)
 #endif
 #ifndef SET_ENDIAN
-# define SET_ENDIAN(a,b)	(-EINVAL)
+# define SET_ENDIAN(a, b)	(-EINVAL)
 #endif
 #ifndef GET_TSC_CTL
 # define GET_TSC_CTL(a)		(-EINVAL)
@@ -182,39 +182,40 @@ SYSCALL_DEFINE3(setpriority, int, which,
 	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
-		case PRIO_PROCESS:
-			if (who)
-				p = find_task_by_vpid(who);
-			else
-				p = current;
-			if (p)
-				error = set_one_prio(p, niceval, error);
-			break;
-		case PRIO_PGRP:
-			if (who)
-				pgrp = find_vpid(who);
-			else
-				pgrp = task_pgrp(current);
-			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
-				error = set_one_prio(p, niceval, error);
-			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
-			break;
-		case PRIO_USER:
-			uid = make_kuid(cred->user_ns, who);
-			user = cred->user;
-			if (!who)
-				uid = cred->uid;
-			else if (!uid_eq(uid, cred->uid) &&
-				 !(user = find_user(uid)))
+	case PRIO_PROCESS:
+		if (who)
+			p = find_task_by_vpid(who);
+		else
+			p = current;
+		if (p)
+			error = set_one_prio(p, niceval, error);
+		break;
+	case PRIO_PGRP:
+		if (who)
+			pgrp = find_vpid(who);
+		else
+			pgrp = task_pgrp(current);
+		do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
+			error = set_one_prio(p, niceval, error);
+		} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
+		break;
+	case PRIO_USER:
+		uid = make_kuid(cred->user_ns, who);
+		user = cred->user;
+		if (!who)
+			uid = cred->uid;
+		else if (!uid_eq(uid, cred->uid)) {
+			user = find_user(uid);
+			if (!user)
 				goto out_unlock;	/* No processes for this user */
-
-			do_each_thread(g, p) {
-				if (uid_eq(task_uid(p), uid))
-					error = set_one_prio(p, niceval, error);
-			} while_each_thread(g, p);
-			if (!uid_eq(uid, cred->uid))
-				free_uid(user);		/* For find_user() */
-			break;
+		}
+		do_each_thread(g, p) {
+			if (uid_eq(task_uid(p), uid))
+				error = set_one_prio(p, niceval, error);
+		} while_each_thread(g, p);
+		if (!uid_eq(uid, cred->uid))
+			free_uid(user);		/* For find_user() */
+		break;
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -244,47 +245,48 @@ SYSCALL_DEFINE2(getpriority, int, which,
 	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
-		case PRIO_PROCESS:
-			if (who)
-				p = find_task_by_vpid(who);
-			else
-				p = current;
-			if (p) {
+	case PRIO_PROCESS:
+		if (who)
+			p = find_task_by_vpid(who);
+		else
+			p = current;
+		if (p) {
+			niceval = nice_to_rlimit(task_nice(p));
+			if (niceval > retval)
+				retval = niceval;
+		}
+		break;
+	case PRIO_PGRP:
+		if (who)
+			pgrp = find_vpid(who);
+		else
+			pgrp = task_pgrp(current);
+		do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
+			niceval = nice_to_rlimit(task_nice(p));
+			if (niceval > retval)
+				retval = niceval;
+		} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
+		break;
+	case PRIO_USER:
+		uid = make_kuid(cred->user_ns, who);
+		user = cred->user;
+		if (!who)
+			uid = cred->uid;
+		else if (!uid_eq(uid, cred->uid)) {
+			user = find_user(uid);
+			if (!user)
+				goto out_unlock;	/* No processes for this user */
+		}
+		do_each_thread(g, p) {
+			if (uid_eq(task_uid(p), uid)) {
 				niceval = nice_to_rlimit(task_nice(p));
 				if (niceval > retval)
 					retval = niceval;
 			}
-			break;
-		case PRIO_PGRP:
-			if (who)
-				pgrp = find_vpid(who);
-			else
-				pgrp = task_pgrp(current);
-			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
-				niceval = nice_to_rlimit(task_nice(p));
-				if (niceval > retval)
-					retval = niceval;
-			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
-			break;
-		case PRIO_USER:
-			uid = make_kuid(cred->user_ns, who);
-			user = cred->user;
-			if (!who)
-				uid = cred->uid;
-			else if (!uid_eq(uid, cred->uid) &&
-				 !(user = find_user(uid)))
-				goto out_unlock;	/* No processes for this user */
-
-			do_each_thread(g, p) {
-				if (uid_eq(task_uid(p), uid)) {
-					niceval = nice_to_rlimit(task_nice(p));
-					if (niceval > retval)
-						retval = niceval;
-				}
-			} while_each_thread(g, p);
-			if (!uid_eq(uid, cred->uid))
-				free_uid(user);		/* for find_user() */
-			break;
+		} while_each_thread(g, p);
+		if (!uid_eq(uid, cred->uid))
+			free_uid(user);		/* for find_user() */
+		break;
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -306,7 +308,7 @@ out_unlock:
  *
  * The general idea is that a program which uses just setregid() will be
  * 100% compatible with BSD.  A program which uses just setgid() will be
- * 100% compatible with POSIX with saved IDs. 
+ * 100% compatible with POSIX with saved IDs.
  *
  * SMP: There are not races, the GIDs are checked only by filesystem
  *      operations (as far as semantic preservation is concerned).
@@ -364,7 +366,7 @@ error:
 }
 
 /*
- * setgid() is implemented like SysV w/ SAVED_IDS 
+ * setgid() is implemented like SysV w/ SAVED_IDS
  *
  * SMP: Same implicit races as above.
  */
@@ -442,7 +444,7 @@ static int set_user(struct cred *new)
  *
  * The general idea is that a program which uses just setreuid() will be
  * 100% compatible with BSD.  A program which uses just setuid() will be
- * 100% compatible with POSIX with saved IDs. 
+ * 100% compatible with POSIX with saved IDs.
  */
 SYSCALL_DEFINE2(setreuid, uid_t, ruid, uid_t, euid)
 {
@@ -503,17 +505,17 @@ error:
 	abort_creds(new);
 	return retval;
 }
-		
+
 /*
- * setuid() is implemented like SysV with SAVED_IDS 
- * 
+ * setuid() is implemented like SysV with SAVED_IDS
+ *
  * Note that SAVED_ID's is deficient in that a setuid root program
- * like sendmail, for example, cannot set its uid to be a normal 
+ * like sendmail, for example, cannot set its uid to be a normal
  * user and then switch back, because if you're root, setuid() sets
  * the saved uid too.  If you don't like this, blame the bright people
  * in the POSIX committee and/or USG.  Note that the BSD-style setreuid()
  * will allow a root program to temporarily drop privileges and be able to
- * regain them by swapping the real and effective uid.  
+ * regain them by swapping the real and effective uid.
  */
 SYSCALL_DEFINE1(setuid, uid_t, uid)
 {
@@ -637,10 +639,12 @@ SYSCALL_DEFINE3(getresuid, uid_t __user
 	euid = from_kuid_munged(cred->user_ns, cred->euid);
 	suid = from_kuid_munged(cred->user_ns, cred->suid);
 
-	if (!(retval   = put_user(ruid, ruidp)) &&
-	    !(retval   = put_user(euid, euidp)))
-		retval = put_user(suid, suidp);
-
+	retval = put_user(ruid, ruidp);
+	if (!retval) {
+		retval = put_user(euid, euidp);
+		if (!retval)
+			return put_user(suid, suidp);
+	}
 	return retval;
 }
 
@@ -709,9 +713,12 @@ SYSCALL_DEFINE3(getresgid, gid_t __user
 	egid = from_kgid_munged(cred->user_ns, cred->egid);
 	sgid = from_kgid_munged(cred->user_ns, cred->sgid);
 
-	if (!(retval   = put_user(rgid, rgidp)) &&
-	    !(retval   = put_user(egid, egidp)))
-		retval = put_user(sgid, sgidp);
+	retval = put_user(rgid, rgidp);
+	if (!retval) {
+		retval = put_user(egid, egidp);
+		if (!retval)
+			retval = put_user(sgid, sgidp);
+	}
 
 	return retval;
 }
@@ -1284,7 +1291,6 @@ SYSCALL_DEFINE2(getrlimit, unsigned int,
 /*
  *	Back compatibility for getrlimit. Needed for some apps.
  */
- 
 SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 		struct rlimit __user *, rlim)
 {
@@ -1299,7 +1305,7 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned
 		x.rlim_cur = 0x7FFFFFFF;
 	if (x.rlim_max > 0x7FFFFFFF)
 		x.rlim_max = 0x7FFFFFFF;
-	return copy_to_user(rlim, &x, sizeof(x))?-EFAULT:0;
+	return copy_to_user(rlim, &x, sizeof(x)) ? -EFAULT : 0;
 }
 
 #endif
@@ -1527,7 +1533,7 @@ static void k_getrusage(struct task_stru
 	cputime_t tgutime, tgstime, utime, stime;
 	unsigned long maxrss = 0;
 
-	memset((char *) r, 0, sizeof *r);
+	memset((char *)r, 0, sizeof (*r));
 	utime = stime = 0;
 
 	if (who == RUSAGE_THREAD) {
@@ -1541,41 +1547,41 @@ static void k_getrusage(struct task_stru
 		return;
 
 	switch (who) {
-		case RUSAGE_BOTH:
-		case RUSAGE_CHILDREN:
-			utime = p->signal->cutime;
-			stime = p->signal->cstime;
-			r->ru_nvcsw = p->signal->cnvcsw;
-			r->ru_nivcsw = p->signal->cnivcsw;
-			r->ru_minflt = p->signal->cmin_flt;
-			r->ru_majflt = p->signal->cmaj_flt;
-			r->ru_inblock = p->signal->cinblock;
-			r->ru_oublock = p->signal->coublock;
-			maxrss = p->signal->cmaxrss;
+	case RUSAGE_BOTH:
+	case RUSAGE_CHILDREN:
+		utime = p->signal->cutime;
+		stime = p->signal->cstime;
+		r->ru_nvcsw = p->signal->cnvcsw;
+		r->ru_nivcsw = p->signal->cnivcsw;
+		r->ru_minflt = p->signal->cmin_flt;
+		r->ru_majflt = p->signal->cmaj_flt;
+		r->ru_inblock = p->signal->cinblock;
+		r->ru_oublock = p->signal->coublock;
+		maxrss = p->signal->cmaxrss;
 
-			if (who == RUSAGE_CHILDREN)
-				break;
-
-		case RUSAGE_SELF:
-			thread_group_cputime_adjusted(p, &tgutime, &tgstime);
-			utime += tgutime;
-			stime += tgstime;
-			r->ru_nvcsw += p->signal->nvcsw;
-			r->ru_nivcsw += p->signal->nivcsw;
-			r->ru_minflt += p->signal->min_flt;
-			r->ru_majflt += p->signal->maj_flt;
-			r->ru_inblock += p->signal->inblock;
-			r->ru_oublock += p->signal->oublock;
-			if (maxrss < p->signal->maxrss)
-				maxrss = p->signal->maxrss;
-			t = p;
-			do {
-				accumulate_thread_rusage(t, r);
-			} while_each_thread(p, t);
+		if (who == RUSAGE_CHILDREN)
 			break;
 
-		default:
-			BUG();
+	case RUSAGE_SELF:
+		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
+		utime += tgutime;
+		stime += tgstime;
+		r->ru_nvcsw += p->signal->nvcsw;
+		r->ru_nivcsw += p->signal->nivcsw;
+		r->ru_minflt += p->signal->min_flt;
+		r->ru_majflt += p->signal->maj_flt;
+		r->ru_inblock += p->signal->inblock;
+		r->ru_oublock += p->signal->oublock;
+		if (maxrss < p->signal->maxrss)
+			maxrss = p->signal->maxrss;
+		t = p;
+		do {
+			accumulate_thread_rusage(t, r);
+		} while_each_thread(p, t);
+		break;
+
+	default:
+		BUG();
 	}
 	unlock_task_sighand(p, &flags);
 
@@ -1585,6 +1591,7 @@ out:
 
 	if (who != RUSAGE_CHILDREN) {
 		struct mm_struct *mm = get_task_mm(p);
+
 		if (mm) {
 			setmax_mm_hiwater_rss(&maxrss, mm);
 			mmput(mm);
@@ -1596,6 +1603,7 @@ out:
 int getrusage(struct task_struct *p, int who, struct rusage __user *ru)
 {
 	struct rusage r;
+
 	k_getrusage(p, who, &r);
 	return copy_to_user(ru, &r, sizeof(r)) ? -EFAULT : 0;
 }
@@ -2209,6 +2217,7 @@ SYSCALL_DEFINE3(getcpu, unsigned __user
 {
 	int err = 0;
 	int cpu = raw_smp_processor_id();
+
 	if (cpup)
 		err |= put_user(cpu, cpup);
 	if (nodep)
_

Patches currently in -mm which might be from vishnu.ps@samsung.com are

fix-checkpatch-errors-for-mm-mmapc.patch
kernel-fix-for-checkpatch-errors-in-sys-file.patch


From: akpm@linux-foundation.org
Subject: + kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch added to -mm tree
Date: Tue, 09 Apr 2013 13:26:21 -0700
Message-ID: <20130409202621.8ECE45A4252@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:35035 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935899Ab3DIU0X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Apr 2013 16:26:23 -0400
Received: by mail-ia0-f201.google.com with SMTP id k25so757066iah.4
        for <mm-commits@vger.kernel.org>; Tue, 09 Apr 2013 13:26:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, linux@roeck-us.net, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: kernel/timer.c: ove some non timer related syscalls to kernel/sys.c
has been added to the -mm tree.  Its filename is
     kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: kernel/timer.c: ove some non timer related syscalls to kernel/sys.c

Andrew Morton noted:

	akpm3:/usr/src/25> grep SYSCALL kernel/timer.c
	SYSCALL_DEFINE1(alarm, unsigned int, seconds)
	SYSCALL_DEFINE0(getpid)
	SYSCALL_DEFINE0(getppid)
	SYSCALL_DEFINE0(getuid)
	SYSCALL_DEFINE0(geteuid)
	SYSCALL_DEFINE0(getgid)
	SYSCALL_DEFINE0(getegid)
	SYSCALL_DEFINE0(gettid)
	SYSCALL_DEFINE1(sysinfo, struct sysinfo __user *, info)
	COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)

	Only one of those should be in kernel/timer.c.  Who wrote this thing?

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c   |  211 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/timer.c |  208 ----------------------------------------------
 2 files changed, 212 insertions(+), 207 deletions(-)

diff -puN kernel/sys.c~kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc kernel/sys.c
--- a/kernel/sys.c~kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc
+++ a/kernel/sys.c
@@ -49,6 +49,11 @@
 #include <linux/user_namespace.h>
 #include <linux/binfmts.h>
 
+#include <linux/sched.h>
+#include <linux/rcupdate.h>
+#include <linux/uidgid.h>
+#include <linux/cred.h>
+
 #include <linux/kmsg_dump.h>
 /* Move somewhere else to avoid recompiling? */
 #include <generated/utsrelease.h>
@@ -1043,6 +1048,67 @@ change_okay:
 	return old_fsgid;
 }
 
+/**
+ * sys_getpid - return the thread group id of the current process
+ *
+ * Note, despite the name, this returns the tgid not the pid.  The tgid and
+ * the pid are identical unless CLONE_THREAD was specified on clone() in
+ * which case the tgid is the same in all threads of the same group.
+ *
+ * This is SMP safe as current->tgid does not change.
+ */
+SYSCALL_DEFINE0(getpid)
+{
+	return task_tgid_vnr(current);
+}
+
+/* Thread ID - the internal kernel "pid" */
+SYSCALL_DEFINE0(gettid)
+{
+	return task_pid_vnr(current);
+}
+
+/*
+ * Accessing ->real_parent is not SMP-safe, it could
+ * change from under us. However, we can use a stale
+ * value of ->real_parent under rcu_read_lock(), see
+ * release_task()->call_rcu(delayed_put_task_struct).
+ */
+SYSCALL_DEFINE0(getppid)
+{
+	int pid;
+
+	rcu_read_lock();
+	pid = task_tgid_vnr(rcu_dereference(current->real_parent));
+	rcu_read_unlock();
+
+	return pid;
+}
+
+SYSCALL_DEFINE0(getuid)
+{
+	/* Only we change this so SMP safe */
+	return from_kuid_munged(current_user_ns(), current_uid());
+}
+
+SYSCALL_DEFINE0(geteuid)
+{
+	/* Only we change this so SMP safe */
+	return from_kuid_munged(current_user_ns(), current_euid());
+}
+
+SYSCALL_DEFINE0(getgid)
+{
+	/* Only we change this so SMP safe */
+	return from_kgid_munged(current_user_ns(), current_gid());
+}
+
+SYSCALL_DEFINE0(getegid)
+{
+	/* Only we change this so SMP safe */
+	return from_kgid_munged(current_user_ns(), current_egid());
+}
+
 void do_sys_times(struct tms *tms)
 {
 	cputime_t tgutime, tgstime, cutime, cstime;
@@ -2258,3 +2324,148 @@ int orderly_poweroff(bool force)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(orderly_poweroff);
+
+/**
+ * do_sysinfo - fill in sysinfo struct
+ * @info: pointer to buffer to fill
+ */
+static int do_sysinfo(struct sysinfo *info)
+{
+	unsigned long mem_total, sav_total;
+	unsigned int mem_unit, bitcount;
+	struct timespec tp;
+
+	memset(info, 0, sizeof(struct sysinfo));
+
+	ktime_get_ts(&tp);
+	monotonic_to_bootbased(&tp);
+	info->uptime = tp.tv_sec + (tp.tv_nsec ? 1 : 0);
+
+	get_avenrun(info->loads, 0, SI_LOAD_SHIFT - FSHIFT);
+
+	info->procs = nr_threads;
+
+	si_meminfo(info);
+	si_swapinfo(info);
+
+	/*
+	 * If the sum of all the available memory (i.e. ram + swap)
+	 * is less than can be stored in a 32 bit unsigned long then
+	 * we can be binary compatible with 2.2.x kernels.  If not,
+	 * well, in that case 2.2.x was broken anyways...
+	 *
+	 *  -Erik Andersen <andersee@debian.org>
+	 */
+
+	mem_total = info->totalram + info->totalswap;
+	if (mem_total < info->totalram || mem_total < info->totalswap)
+		goto out;
+	bitcount = 0;
+	mem_unit = info->mem_unit;
+	while (mem_unit > 1) {
+		bitcount++;
+		mem_unit >>= 1;
+		sav_total = mem_total;
+		mem_total <<= 1;
+		if (mem_total < sav_total)
+			goto out;
+	}
+
+	/*
+	 * If mem_total did not overflow, multiply all memory values by
+	 * info->mem_unit and set it to 1.  This leaves things compatible
+	 * with 2.2.x, and also retains compatibility with earlier 2.4.x
+	 * kernels...
+	 */
+
+	info->mem_unit = 1;
+	info->totalram <<= bitcount;
+	info->freeram <<= bitcount;
+	info->sharedram <<= bitcount;
+	info->bufferram <<= bitcount;
+	info->totalswap <<= bitcount;
+	info->freeswap <<= bitcount;
+	info->totalhigh <<= bitcount;
+	info->freehigh <<= bitcount;
+
+out:
+	return 0;
+}
+
+SYSCALL_DEFINE1(sysinfo, struct sysinfo __user *, info)
+{
+	struct sysinfo val;
+
+	do_sysinfo(&val);
+
+	if (copy_to_user(info, &val, sizeof(struct sysinfo)))
+		return -EFAULT;
+
+	return 0;
+}
+
+#ifdef CONFIG_COMPAT
+struct compat_sysinfo {
+	s32 uptime;
+	u32 loads[3];
+	u32 totalram;
+	u32 freeram;
+	u32 sharedram;
+	u32 bufferram;
+	u32 totalswap;
+	u32 freeswap;
+	u16 procs;
+	u16 pad;
+	u32 totalhigh;
+	u32 freehigh;
+	u32 mem_unit;
+	char _f[20-2*sizeof(u32)-sizeof(int)];
+};
+
+COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
+{
+	struct sysinfo s;
+
+	do_sysinfo(&s);
+
+	/* Check to see if any memory value is too large for 32-bit and scale
+	 *  down if needed
+	 */
+	if ((s.totalram >> 32) || (s.totalswap >> 32)) {
+		int bitcount = 0;
+
+		while (s.mem_unit < PAGE_SIZE) {
+			s.mem_unit <<= 1;
+			bitcount++;
+		}
+
+		s.totalram >>= bitcount;
+		s.freeram >>= bitcount;
+		s.sharedram >>= bitcount;
+		s.bufferram >>= bitcount;
+		s.totalswap >>= bitcount;
+		s.freeswap >>= bitcount;
+		s.totalhigh >>= bitcount;
+		s.freehigh >>= bitcount;
+	}
+
+	if (!access_ok(VERIFY_WRITE, info, sizeof(struct compat_sysinfo)) ||
+	    __put_user (s.uptime, &info->uptime) ||
+	    __put_user (s.loads[0], &info->loads[0]) ||
+	    __put_user (s.loads[1], &info->loads[1]) ||
+	    __put_user (s.loads[2], &info->loads[2]) ||
+	    __put_user (s.totalram, &info->totalram) ||
+	    __put_user (s.freeram, &info->freeram) ||
+	    __put_user (s.sharedram, &info->sharedram) ||
+	    __put_user (s.bufferram, &info->bufferram) ||
+	    __put_user (s.totalswap, &info->totalswap) ||
+	    __put_user (s.freeswap, &info->freeswap) ||
+	    __put_user (s.procs, &info->procs) ||
+	    __put_user (s.totalhigh, &info->totalhigh) ||
+	    __put_user (s.freehigh, &info->freehigh) ||
+	    __put_user (s.mem_unit, &info->mem_unit))
+		return -EFAULT;
+
+	return 0;
+}
+#endif /* CONFIG_COMPAT */
diff -puN kernel/timer.c~kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc kernel/timer.c
--- a/kernel/timer.c~kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc
+++ a/kernel/timer.c
@@ -1,7 +1,7 @@
 /*
  *  linux/kernel/timer.c
  *
- *  Kernel internal timers, basic process system calls
+ *  Kernel internal timers
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
@@ -1396,61 +1396,6 @@ SYSCALL_DEFINE1(alarm, unsigned int, sec
 
 #endif
 
-/**
- * sys_getpid - return the thread group id of the current process
- *
- * Note, despite the name, this returns the tgid not the pid.  The tgid and
- * the pid are identical unless CLONE_THREAD was specified on clone() in
- * which case the tgid is the same in all threads of the same group.
- *
- * This is SMP safe as current->tgid does not change.
- */
-SYSCALL_DEFINE0(getpid)
-{
-	return task_tgid_vnr(current);
-}
-
-/*
- * Accessing ->real_parent is not SMP-safe, it could
- * change from under us. However, we can use a stale
- * value of ->real_parent under rcu_read_lock(), see
- * release_task()->call_rcu(delayed_put_task_struct).
- */
-SYSCALL_DEFINE0(getppid)
-{
-	int pid;
-
-	rcu_read_lock();
-	pid = task_tgid_vnr(rcu_dereference(current->real_parent));
-	rcu_read_unlock();
-
-	return pid;
-}
-
-SYSCALL_DEFINE0(getuid)
-{
-	/* Only we change this so SMP safe */
-	return from_kuid_munged(current_user_ns(), current_uid());
-}
-
-SYSCALL_DEFINE0(geteuid)
-{
-	/* Only we change this so SMP safe */
-	return from_kuid_munged(current_user_ns(), current_euid());
-}
-
-SYSCALL_DEFINE0(getgid)
-{
-	/* Only we change this so SMP safe */
-	return from_kgid_munged(current_user_ns(), current_gid());
-}
-
-SYSCALL_DEFINE0(getegid)
-{
-	/* Only we change this so SMP safe */
-	return from_kgid_munged(current_user_ns(), current_egid());
-}
-
 static void process_timeout(unsigned long __data)
 {
 	wake_up_process((struct task_struct *)__data);
@@ -1558,157 +1503,6 @@ signed long __sched schedule_timeout_uni
 }
 EXPORT_SYMBOL(schedule_timeout_uninterruptible);
 
-/* Thread ID - the internal kernel "pid" */
-SYSCALL_DEFINE0(gettid)
-{
-	return task_pid_vnr(current);
-}
-
-/**
- * do_sysinfo - fill in sysinfo struct
- * @info: pointer to buffer to fill
- */
-static int do_sysinfo(struct sysinfo *info)
-{
-	unsigned long mem_total, sav_total;
-	unsigned int mem_unit, bitcount;
-	struct timespec tp;
-
-	memset(info, 0, sizeof(struct sysinfo));
-
-	ktime_get_ts(&tp);
-	monotonic_to_bootbased(&tp);
-	info->uptime = tp.tv_sec + (tp.tv_nsec ? 1 : 0);
-
-	get_avenrun(info->loads, 0, SI_LOAD_SHIFT - FSHIFT);
-
-	info->procs = nr_threads;
-
-	si_meminfo(info);
-	si_swapinfo(info);
-
-	/*
-	 * If the sum of all the available memory (i.e. ram + swap)
-	 * is less than can be stored in a 32 bit unsigned long then
-	 * we can be binary compatible with 2.2.x kernels.  If not,
-	 * well, in that case 2.2.x was broken anyways...
-	 *
-	 *  -Erik Andersen <andersee@debian.org>
-	 */
-
-	mem_total = info->totalram + info->totalswap;
-	if (mem_total < info->totalram || mem_total < info->totalswap)
-		goto out;
-	bitcount = 0;
-	mem_unit = info->mem_unit;
-	while (mem_unit > 1) {
-		bitcount++;
-		mem_unit >>= 1;
-		sav_total = mem_total;
-		mem_total <<= 1;
-		if (mem_total < sav_total)
-			goto out;
-	}
-
-	/*
-	 * If mem_total did not overflow, multiply all memory values by
-	 * info->mem_unit and set it to 1.  This leaves things compatible
-	 * with 2.2.x, and also retains compatibility with earlier 2.4.x
-	 * kernels...
-	 */
-
-	info->mem_unit = 1;
-	info->totalram <<= bitcount;
-	info->freeram <<= bitcount;
-	info->sharedram <<= bitcount;
-	info->bufferram <<= bitcount;
-	info->totalswap <<= bitcount;
-	info->freeswap <<= bitcount;
-	info->totalhigh <<= bitcount;
-	info->freehigh <<= bitcount;
-
-out:
-	return 0;
-}
-
-SYSCALL_DEFINE1(sysinfo, struct sysinfo __user *, info)
-{
-	struct sysinfo val;
-
-	do_sysinfo(&val);
-
-	if (copy_to_user(info, &val, sizeof(struct sysinfo)))
-		return -EFAULT;
-
-	return 0;
-}
-
-#ifdef CONFIG_COMPAT
-struct compat_sysinfo {
-	s32 uptime;
-	u32 loads[3];
-	u32 totalram;
-	u32 freeram;
-	u32 sharedram;
-	u32 bufferram;
-	u32 totalswap;
-	u32 freeswap;
-	u16 procs;
-	u16 pad;
-	u32 totalhigh;
-	u32 freehigh;
-	u32 mem_unit;
-	char _f[20-2*sizeof(u32)-sizeof(int)];
-};
-
-COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
-{
-	struct sysinfo s;
-
-	do_sysinfo(&s);
-
-	/* Check to see if any memory value is too large for 32-bit and scale
-	 *  down if needed
-	 */
-	if ((s.totalram >> 32) || (s.totalswap >> 32)) {
-		int bitcount = 0;
-
-		while (s.mem_unit < PAGE_SIZE) {
-			s.mem_unit <<= 1;
-			bitcount++;
-		}
-
-		s.totalram >>= bitcount;
-		s.freeram >>= bitcount;
-		s.sharedram >>= bitcount;
-		s.bufferram >>= bitcount;
-		s.totalswap >>= bitcount;
-		s.freeswap >>= bitcount;
-		s.totalhigh >>= bitcount;
-		s.freehigh >>= bitcount;
-	}
-
-	if (!access_ok(VERIFY_WRITE, info, sizeof(struct compat_sysinfo)) ||
-	    __put_user (s.uptime, &info->uptime) ||
-	    __put_user (s.loads[0], &info->loads[0]) ||
-	    __put_user (s.loads[1], &info->loads[1]) ||
-	    __put_user (s.loads[2], &info->loads[2]) ||
-	    __put_user (s.totalram, &info->totalram) ||
-	    __put_user (s.freeram, &info->freeram) ||
-	    __put_user (s.sharedram, &info->sharedram) ||
-	    __put_user (s.bufferram, &info->bufferram) ||
-	    __put_user (s.totalswap, &info->totalswap) ||
-	    __put_user (s.freeswap, &info->freeswap) ||
-	    __put_user (s.procs, &info->procs) ||
-	    __put_user (s.totalhigh, &info->totalhigh) ||
-	    __put_user (s.freehigh, &info->freehigh) ||
-	    __put_user (s.mem_unit, &info->mem_unit))
-		return -EFAULT;
-
-	return 0;
-}
-#endif /* CONFIG_COMPAT */

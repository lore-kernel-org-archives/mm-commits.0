From: akpm@linux-foundation.org
Subject: + compat-generic-compat-get-settimeofday.patch added to -mm tree
Date: Thu, 04 Sep 2008 13:21:39 -0700
Message-ID: <200809042023.m84KLdHU028877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758628AbYIDU04 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 16:26:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, benh@kernel.crashing.org, davem@davemloft.net, grundler@parisc-linux.org, heiko.carstens@de.ibm.com, hpa@zytor.com, kyle@mcmartin.ca, matthew@wil.cx, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     compat: generic compat get/settimeofday
has been added to the -mm tree.  Its filename is
     compat-generic-compat-get-settimeofday.patch

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
Subject: compat: generic compat get/settimeofday
From: Christoph Hellwig <hch@lst.de>

Nothing arch specific in get/settimeofday.  The details of the timeval
conversion varied a little from arch to arch, but all with the same
results.

Also add an extern declaration for sys_tz to linux/time.h because externs
in .c files are fowned upon.  I'll kill the externs in various other files
in a sparate patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/ia32_entry.S        |    4 -
 arch/ia64/ia32/sys_ia32.c          |   56 ----------------------
 arch/mips/kernel/linux32.c         |   66 --------------------------
 arch/mips/kernel/scall64-n32.S     |    4 -
 arch/mips/kernel/scall64-o32.S     |    4 -
 arch/parisc/kernel/sys_parisc32.c  |   58 -----------------------
 arch/parisc/kernel/syscall_table.S |    4 -
 arch/powerpc/kernel/sys_ppc32.c    |   63 -------------------------
 arch/s390/kernel/compat_linux.c    |   67 ---------------------------
 arch/s390/kernel/compat_linux.h    |    4 -
 arch/s390/kernel/compat_wrapper.S  |   12 ++--
 arch/s390/kernel/syscalls.S        |    4 -
 arch/sparc64/kernel/sys_sparc32.c  |   62 ------------------------
 arch/sparc64/kernel/systbls.S      |    4 -
 arch/x86/ia32/ia32entry.S          |    4 -
 arch/x86/ia32/sys_ia32.c           |   64 -------------------------
 include/linux/compat.h             |    5 ++
 include/linux/time.h               |    2 
 kernel/compat.c                    |   58 +++++++++++++++++++++++
 19 files changed, 85 insertions(+), 460 deletions(-)

diff -puN arch/ia64/ia32/ia32_entry.S~compat-generic-compat-get-settimeofday arch/ia64/ia32/ia32_entry.S
--- a/arch/ia64/ia32/ia32_entry.S~compat-generic-compat-get-settimeofday
+++ a/arch/ia64/ia32/ia32_entry.S
@@ -251,8 +251,8 @@ ia32_syscall_table:
 	data8 compat_sys_setrlimit	  /* 75 */
 	data8 compat_sys_old_getrlimit
 	data8 compat_sys_getrusage
-	data8 sys32_gettimeofday
-	data8 sys32_settimeofday
+	data8 compat_sys_gettimeofday
+	data8 compat_sys_settimeofday
 	data8 sys32_getgroups16	  /* 80 */
 	data8 sys32_setgroups16
 	data8 sys32_old_select
diff -puN arch/ia64/ia32/sys_ia32.c~compat-generic-compat-get-settimeofday arch/ia64/ia32/sys_ia32.c
--- a/arch/ia64/ia32/sys_ia32.c~compat-generic-compat-get-settimeofday
+++ a/arch/ia64/ia32/sys_ia32.c
@@ -1113,68 +1113,12 @@ sys32_pipe (int __user *fd)
 	return retval;
 }
 
-static inline long
-get_tv32 (struct timeval *o, struct compat_timeval __user *i)
-{
-	return (!access_ok(VERIFY_READ, i, sizeof(*i)) ||
-		(__get_user(o->tv_sec, &i->tv_sec) | __get_user(o->tv_usec, &i->tv_usec)));
-}
-
-static inline long
-put_tv32 (struct compat_timeval __user *o, struct timeval *i)
-{
-	return (!access_ok(VERIFY_WRITE, o, sizeof(*o)) ||
-		(__put_user(i->tv_sec, &o->tv_sec) | __put_user(i->tv_usec, &o->tv_usec)));
-}
-
 asmlinkage unsigned long
 sys32_alarm (unsigned int seconds)
 {
 	return alarm_setitimer(seconds);
 }
 
-/* Translations due to time_t size differences.  Which affects all
-   sorts of things, like timeval and itimerval.  */
-
-extern struct timezone sys_tz;
-
-asmlinkage long
-sys32_gettimeofday (struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	if (tv) {
-		struct timeval ktv;
-		do_gettimeofday(&ktv);
-		if (put_tv32(tv, &ktv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-asmlinkage long
-sys32_settimeofday (struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	struct timeval ktv;
-	struct timespec kts;
-	struct timezone ktz;
-
-	if (tv) {
-		if (get_tv32(&ktv, tv))
-			return -EFAULT;
-		kts.tv_sec = ktv.tv_sec;
-		kts.tv_nsec = ktv.tv_usec * 1000;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 struct sel_arg_struct {
 	unsigned int n;
 	unsigned int inp;
diff -puN arch/mips/kernel/linux32.c~compat-generic-compat-get-settimeofday arch/mips/kernel/linux32.c
--- a/arch/mips/kernel/linux32.c~compat-generic-compat-get-settimeofday
+++ a/arch/mips/kernel/linux32.c
@@ -133,72 +133,6 @@ asmlinkage long sys32_ftruncate64(unsign
 	return sys_ftruncate(fd, merge_64(a2, a3));
 }
 
-static inline long
-get_tv32(struct timeval *o, struct compat_timeval __user *i)
-{
-	return (!access_ok(VERIFY_READ, i, sizeof(*i)) ||
-		(__get_user(o->tv_sec, &i->tv_sec) |
-		 __get_user(o->tv_usec, &i->tv_usec)));
-}
-
-static inline long
-put_tv32(struct compat_timeval __user *o, struct timeval *i)
-{
-	return (!access_ok(VERIFY_WRITE, o, sizeof(*o)) ||
-		(__put_user(i->tv_sec, &o->tv_sec) |
-		 __put_user(i->tv_usec, &o->tv_usec)));
-}
-
-extern struct timezone sys_tz;
-
-asmlinkage int
-sys32_gettimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	if (tv) {
-		struct timeval ktv;
-		do_gettimeofday(&ktv);
-		if (put_tv32(tv, &ktv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-static inline long get_ts32(struct timespec *o, struct compat_timeval __user *i)
-{
-	long usec;
-
-	if (!access_ok(VERIFY_READ, i, sizeof(*i)))
-		return -EFAULT;
-	if (__get_user(o->tv_sec, &i->tv_sec))
-		return -EFAULT;
-	if (__get_user(usec, &i->tv_usec))
-		return -EFAULT;
-	o->tv_nsec = usec * 1000;
-		return 0;
-}
-
-asmlinkage int
-sys32_settimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	struct timespec kts;
-	struct timezone ktz;
-
- 	if (tv) {
-		if (get_ts32(&kts, tv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 asmlinkage int sys32_llseek(unsigned int fd, unsigned int offset_high,
 			    unsigned int offset_low, loff_t __user * result,
 			    unsigned int origin)
diff -puN arch/mips/kernel/scall64-n32.S~compat-generic-compat-get-settimeofday arch/mips/kernel/scall64-n32.S
--- a/arch/mips/kernel/scall64-n32.S~compat-generic-compat-get-settimeofday
+++ a/arch/mips/kernel/scall64-n32.S
@@ -214,7 +214,7 @@ EXPORT(sysn32_call_table)
 	PTR	sys_fchown
 	PTR	sys_lchown
 	PTR	sys_umask
-	PTR	sys32_gettimeofday
+	PTR	compat_sys_gettimeofday
 	PTR	compat_sys_getrlimit		/* 6095 */
 	PTR	compat_sys_getrusage
 	PTR	compat_sys_sysinfo
@@ -279,7 +279,7 @@ EXPORT(sysn32_call_table)
 	PTR	sys_chroot
 	PTR	sys_sync
 	PTR	sys_acct
-	PTR	sys32_settimeofday
+	PTR	compat_sys_settimeofday
 	PTR	compat_sys_mount		/* 6160 */
 	PTR	sys_umount
 	PTR	sys_swapon
diff -puN arch/mips/kernel/scall64-o32.S~compat-generic-compat-get-settimeofday arch/mips/kernel/scall64-o32.S
--- a/arch/mips/kernel/scall64-o32.S~compat-generic-compat-get-settimeofday
+++ a/arch/mips/kernel/scall64-o32.S
@@ -283,8 +283,8 @@ sys_call_table:
 	PTR	compat_sys_setrlimit		/* 4075 */
 	PTR	compat_sys_getrlimit
 	PTR	compat_sys_getrusage
-	PTR	sys32_gettimeofday
-	PTR	sys32_settimeofday
+	PTR	compat_sys_gettimeofday
+	PTR	compat_sys_settimeofday
 	PTR	sys_getgroups			/* 4080 */
 	PTR	sys_setgroups
 	PTR	sys_ni_syscall			/* old_select */
diff -puN arch/parisc/kernel/sys_parisc32.c~compat-generic-compat-get-settimeofday arch/parisc/kernel/sys_parisc32.c
--- a/arch/parisc/kernel/sys_parisc32.c~compat-generic-compat-get-settimeofday
+++ a/arch/parisc/kernel/sys_parisc32.c
@@ -179,64 +179,6 @@ asmlinkage long sys32_sched_rr_get_inter
 	return ret;
 }
 
-static int
-put_compat_timeval(struct compat_timeval __user *u, struct timeval *t)
-{
-	struct compat_timeval t32;
-	t32.tv_sec = t->tv_sec;
-	t32.tv_usec = t->tv_usec;
-	return copy_to_user(u, &t32, sizeof t32);
-}
-
-static inline long get_ts32(struct timespec *o, struct compat_timeval __user *i)
-{
-	long usec;
-
-	if (__get_user(o->tv_sec, &i->tv_sec))
-		return -EFAULT;
-	if (__get_user(usec, &i->tv_usec))
-		return -EFAULT;
-	o->tv_nsec = usec * 1000;
-	return 0;
-}
-
-asmlinkage int
-sys32_gettimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-    extern void do_gettimeofday(struct timeval *tv);
-
-    if (tv) {
-	    struct timeval ktv;
-	    do_gettimeofday(&ktv);
-	    if (put_compat_timeval(tv, &ktv))
-		    return -EFAULT;
-    }
-    if (tz) {
-	    extern struct timezone sys_tz;
-	    if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-		    return -EFAULT;
-    }
-    return 0;
-}
-
-asmlinkage 
-int sys32_settimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	struct timespec kts;
-	struct timezone ktz;
-
- 	if (tv) {
-		if (get_ts32(&kts, tv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 /*** copied from mips64 ***/
 /*
  * Ooo, nasty.  We need here to frob 32-bit unsigned longs to
diff -puN arch/parisc/kernel/syscall_table.S~compat-generic-compat-get-settimeofday arch/parisc/kernel/syscall_table.S
--- a/arch/parisc/kernel/syscall_table.S~compat-generic-compat-get-settimeofday
+++ a/arch/parisc/kernel/syscall_table.S
@@ -149,8 +149,8 @@
 	ENTRY_COMP(getrlimit)
 	ENTRY_COMP(getrusage)
 	/* struct timeval and timezone are maybe?? consistent wide and narrow */
-	ENTRY_DIFF(gettimeofday)
-	ENTRY_DIFF(settimeofday)
+	ENTRY_COMP(gettimeofday)
+	ENTRY_COMP(settimeofday)
 	ENTRY_SAME(getgroups)		/* 80 */
 	ENTRY_SAME(setgroups)
 	/* struct socketaddr... */
diff -puN arch/powerpc/kernel/sys_ppc32.c~compat-generic-compat-get-settimeofday arch/powerpc/kernel/sys_ppc32.c
--- a/arch/powerpc/kernel/sys_ppc32.c~compat-generic-compat-get-settimeofday
+++ a/arch/powerpc/kernel/sys_ppc32.c
@@ -79,69 +79,6 @@ asmlinkage long compat_sys_pause(void)
 	return -ERESTARTNOHAND;
 }
 
-static inline long get_ts32(struct timespec *o, struct compat_timeval __user *i)
-{
-	long usec;
-
-	if (!access_ok(VERIFY_READ, i, sizeof(*i)))
-		return -EFAULT;
-	if (__get_user(o->tv_sec, &i->tv_sec))
-		return -EFAULT;
-	if (__get_user(usec, &i->tv_usec))
-		return -EFAULT;
-	o->tv_nsec = usec * 1000;
-	return 0;
-}
-
-static inline long put_tv32(struct compat_timeval __user *o, struct timeval *i)
-{
-	return (!access_ok(VERIFY_WRITE, o, sizeof(*o)) ||
-		(__put_user(i->tv_sec, &o->tv_sec) |
-		 __put_user(i->tv_usec, &o->tv_usec)));
-}
-
-
-
-
-/* Translations due to time_t size differences.  Which affects all
-   sorts of things, like timeval and itimerval.  */
-extern struct timezone sys_tz;
-
-asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	if (tv) {
-		struct timeval ktv;
-		do_gettimeofday(&ktv);
-		if (put_tv32(tv, &ktv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-			return -EFAULT;
-	}
-	
-	return 0;
-}
-
-
-
-asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	struct timespec kts;
-	struct timezone ktz;
-	
- 	if (tv) {
-		if (get_ts32(&kts, tv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 #ifdef CONFIG_SYSVIPC
 long compat_sys_ipc(u32 call, u32 first, u32 second, u32 third, compat_uptr_t ptr,
 	       u32 fifth)
diff -puN arch/s390/kernel/compat_linux.c~compat-generic-compat-get-settimeofday arch/s390/kernel/compat_linux.c
--- a/arch/s390/kernel/compat_linux.c~compat-generic-compat-get-settimeofday
+++ a/arch/s390/kernel/compat_linux.c
@@ -279,22 +279,6 @@ asmlinkage long sys32_getegid16(void)
 	return high2lowgid(current->cred->egid);
 }
 
-/* 32-bit timeval and related flotsam.  */
-
-static inline long get_tv32(struct timeval *o, struct compat_timeval __user *i)
-{
-	return (!access_ok(VERIFY_READ, o, sizeof(*o)) ||
-		(__get_user(o->tv_sec, &i->tv_sec) ||
-		 __get_user(o->tv_usec, &i->tv_usec)));
-}
-
-static inline long put_tv32(struct compat_timeval __user *o, struct timeval *i)
-{
-	return (!access_ok(VERIFY_WRITE, o, sizeof(*o)) ||
-		(__put_user(i->tv_sec, &o->tv_sec) ||
-		 __put_user(i->tv_usec, &o->tv_usec)));
-}
-
 /*
  * sys32_ipc() is the de-multiplexer for the SysV IPC calls in 32bit emulation.
  *
@@ -522,57 +506,6 @@ sys32_delete_module(const char __user *n
 
 #endif  /* CONFIG_MODULES */
 
-/* Translations due to time_t size differences.  Which affects all
-   sorts of things, like timeval and itimerval.  */
-
-extern struct timezone sys_tz;
-
-asmlinkage long sys32_gettimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	if (tv) {
-		struct timeval ktv;
-		do_gettimeofday(&ktv);
-		if (put_tv32(tv, &ktv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-static inline long get_ts32(struct timespec *o, struct compat_timeval __user *i)
-{
-	long usec;
-
-	if (!access_ok(VERIFY_READ, i, sizeof(*i)))
-		return -EFAULT;
-	if (__get_user(o->tv_sec, &i->tv_sec))
-		return -EFAULT;
-	if (__get_user(usec, &i->tv_usec))
-		return -EFAULT;
-	o->tv_nsec = usec * 1000;
-	return 0;
-}
-
-asmlinkage long sys32_settimeofday(struct compat_timeval __user *tv, struct timezone __user *tz)
-{
-	struct timespec kts;
-	struct timezone ktz;
-
- 	if (tv) {
-		if (get_ts32(&kts, tv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 asmlinkage long sys32_pread64(unsigned int fd, char __user *ubuf,
 				size_t count, u32 poshi, u32 poslo)
 {
diff -puN arch/s390/kernel/compat_linux.h~compat-generic-compat-get-settimeofday arch/s390/kernel/compat_linux.h
--- a/arch/s390/kernel/compat_linux.h~compat-generic-compat-get-settimeofday
+++ a/arch/s390/kernel/compat_linux.h
@@ -202,10 +202,6 @@ long sys32_execve(void);
 long sys32_init_module(void __user *umod, unsigned long len,
 		       const char __user *uargs);
 long sys32_delete_module(const char __user *name_user, unsigned int flags);
-long sys32_gettimeofday(struct compat_timeval __user *tv,
-			struct timezone __user *tz);
-long sys32_settimeofday(struct compat_timeval __user *tv,
-			struct timezone __user *tz);
 long sys32_pread64(unsigned int fd, char __user *ubuf, size_t count,
 		   u32 poshi, u32 poslo);
 long sys32_pwrite64(unsigned int fd, const char __user *ubuf,
diff -puN arch/s390/kernel/compat_wrapper.S~compat-generic-compat-get-settimeofday arch/s390/kernel/compat_wrapper.S
--- a/arch/s390/kernel/compat_wrapper.S~compat-generic-compat-get-settimeofday
+++ a/arch/s390/kernel/compat_wrapper.S
@@ -332,17 +332,17 @@ compat_sys_getrusage_wrapper:
 	llgtr	%r3,%r3			# struct rusage_emu31 *
 	jg	compat_sys_getrusage	# branch to system call
 
-	.globl	sys32_gettimeofday_wrapper
-sys32_gettimeofday_wrapper:
+	.globl	compat_sys_gettimeofday_wrapper
+compat_sys_gettimeofday_wrapper:
 	llgtr	%r2,%r2			# struct timeval_emu31 *
 	llgtr	%r3,%r3			# struct timezone *
-	jg	sys32_gettimeofday	# branch to system call
+	jg	compat_sys_gettimeofday	# branch to system call
 
-	.globl	sys32_settimeofday_wrapper
-sys32_settimeofday_wrapper:
+	.globl	compat_sys_settimeofday_wrapper
+compat_sys_settimeofday_wrapper:
 	llgtr	%r2,%r2			# struct timeval_emu31 *
 	llgtr	%r3,%r3			# struct timezone *
-	jg	sys32_settimeofday	# branch to system call
+	jg	compat_sys_settimeofday	# branch to system call
 
 	.globl	sys32_getgroups16_wrapper
 sys32_getgroups16_wrapper:
diff -puN arch/s390/kernel/syscalls.S~compat-generic-compat-get-settimeofday arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~compat-generic-compat-get-settimeofday
+++ a/arch/s390/kernel/syscalls.S
@@ -86,8 +86,8 @@ SYSCALL(sys_sethostname,sys_sethostname,
 SYSCALL(sys_setrlimit,sys_setrlimit,compat_sys_setrlimit_wrapper)	/* 75 */
 SYSCALL(sys_old_getrlimit,sys_getrlimit,compat_sys_old_getrlimit_wrapper)
 SYSCALL(sys_getrusage,sys_getrusage,compat_sys_getrusage_wrapper)
-SYSCALL(sys_gettimeofday,sys_gettimeofday,sys32_gettimeofday_wrapper)
-SYSCALL(sys_settimeofday,sys_settimeofday,sys32_settimeofday_wrapper)
+SYSCALL(sys_gettimeofday,sys_gettimeofday,compat_sys_gettimeofday_wrapper)
+SYSCALL(sys_settimeofday,sys_settimeofday,compat_sys_settimeofday_wrapper)
 SYSCALL(sys_getgroups16,sys_ni_syscall,sys32_getgroups16_wrapper)	/* 80 old getgroups16 syscall */
 SYSCALL(sys_setgroups16,sys_ni_syscall,sys32_setgroups16_wrapper)	/* old setgroups16 syscall */
 NI_SYSCALL							/* old select syscall */
diff -puN arch/sparc64/kernel/sys_sparc32.c~compat-generic-compat-get-settimeofday arch/sparc64/kernel/sys_sparc32.c
--- a/arch/sparc64/kernel/sys_sparc32.c~compat-generic-compat-get-settimeofday
+++ a/arch/sparc64/kernel/sys_sparc32.c
@@ -58,15 +58,6 @@
 #include <asm/mmu_context.h>
 #include <asm/compat_signal.h>
 
-/* 32-bit timeval and related flotsam.  */
-
-static inline long put_tv32(struct compat_timeval __user *o, struct timeval *i)
-{
-	return (!access_ok(VERIFY_WRITE, o, sizeof(*o)) ||
-		(__put_user(i->tv_sec, &o->tv_sec) |
-		 __put_user(i->tv_usec, &o->tv_usec)));
-}
-
 #ifdef CONFIG_SYSVIPC                                                        
 asmlinkage long compat_sys_ipc(u32 call, u32 first, u32 second, u32 third, compat_uptr_t ptr, u32 fifth)
 {
@@ -487,59 +478,6 @@ asmlinkage long sys32_delete_module(cons
 
 #endif  /* CONFIG_MODULES */
 
-/* Translations due to time_t size differences.  Which affects all
-   sorts of things, like timeval and itimerval.  */
-
-extern struct timezone sys_tz;
-
-asmlinkage long sys32_gettimeofday(struct compat_timeval __user *tv,
-				   struct timezone __user *tz)
-{
-	if (tv) {
-		struct timeval ktv;
-		do_gettimeofday(&ktv);
-		if (put_tv32(tv, &ktv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-static inline long get_ts32(struct timespec *o, struct compat_timeval __user *i)
-{
-	long usec;
-
-	if (!access_ok(VERIFY_READ, i, sizeof(*i)))
-		return -EFAULT;
-	if (__get_user(o->tv_sec, &i->tv_sec))
-		return -EFAULT;
-	if (__get_user(usec, &i->tv_usec))
-		return -EFAULT;
-	o->tv_nsec = usec * 1000;
-	return 0;
-}
-
-asmlinkage long sys32_settimeofday(struct compat_timeval __user *tv,
-				   struct timezone __user *tz)
-{
-	struct timespec kts;
-	struct timezone ktz;
-
- 	if (tv) {
-		if (get_ts32(&kts, tv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 asmlinkage compat_ssize_t sys32_pread64(unsigned int fd,
 					char __user *ubuf,
 					compat_size_t count,
diff -puN arch/sparc64/kernel/systbls.S~compat-generic-compat-get-settimeofday arch/sparc64/kernel/systbls.S
--- a/arch/sparc64/kernel/systbls.S~compat-generic-compat-get-settimeofday
+++ a/arch/sparc64/kernel/systbls.S
@@ -41,8 +41,8 @@ sys_call_table32:
 /*100*/ .word sys32_getpriority, sys32_rt_sigreturn, sys32_rt_sigaction, sys32_rt_sigprocmask, sys32_rt_sigpending
 	.word compat_sys_rt_sigtimedwait, sys32_rt_sigqueueinfo, compat_sys_rt_sigsuspend, sys_setresuid, sys_getresuid
 /*110*/	.word sys_setresgid, sys_getresgid, sys_setregid, sys_nis_syscall, sys_nis_syscall
-	.word sys32_getgroups, sys32_gettimeofday, sys32_getrusage, sys_nis_syscall, sys_getcwd
-/*120*/	.word compat_sys_readv, compat_sys_writev, sys32_settimeofday, sys_fchown16, sys_fchmod
+	.word sys32_getgroups, compat_sys_gettimeofday, sys32_getrusage, sys_nis_syscall, sys_getcwd
+/*120*/	.word compat_sys_readv, compat_sys_writev, compat_sys_settimeofday, sys_fchown16, sys_fchmod
 	.word sys_nis_syscall, sys_setreuid16, sys_setregid16, sys_rename, sys_truncate
 /*130*/	.word sys_ftruncate, sys_flock, compat_sys_lstat64, sys_nis_syscall, sys_nis_syscall
 	.word sys_nis_syscall, sys32_mkdir, sys_rmdir, compat_sys_utimes, compat_sys_stat64
diff -puN arch/x86/ia32/ia32entry.S~compat-generic-compat-get-settimeofday arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~compat-generic-compat-get-settimeofday
+++ a/arch/x86/ia32/ia32entry.S
@@ -571,8 +571,8 @@ ia32_sys_call_table:
 	.quad compat_sys_setrlimit	/* 75 */
 	.quad compat_sys_old_getrlimit	/* old_getrlimit */
 	.quad compat_sys_getrusage
-	.quad sys32_gettimeofday
-	.quad sys32_settimeofday
+	.quad compat_sys_gettimeofday
+	.quad compat_sys_settimeofday
 	.quad sys_getgroups16	/* 80 */
 	.quad sys_setgroups16
 	.quad sys32_old_select
diff -puN arch/x86/ia32/sys_ia32.c~compat-generic-compat-get-settimeofday arch/x86/ia32/sys_ia32.c
--- a/arch/x86/ia32/sys_ia32.c~compat-generic-compat-get-settimeofday
+++ a/arch/x86/ia32/sys_ia32.c
@@ -367,75 +367,11 @@ asmlinkage long sys32_rt_sigprocmask(int
 	return 0;
 }
 
-static inline long get_tv32(struct timeval *o, struct compat_timeval __user *i)
-{
-	int err = -EFAULT;
-
-	if (access_ok(VERIFY_READ, i, sizeof(*i))) {
-		err = __get_user(o->tv_sec, &i->tv_sec);
-		err |= __get_user(o->tv_usec, &i->tv_usec);
-	}
-	return err;
-}
-
-static inline long put_tv32(struct compat_timeval __user *o, struct timeval *i)
-{
-	int err = -EFAULT;
-
-	if (access_ok(VERIFY_WRITE, o, sizeof(*o))) {
-		err = __put_user(i->tv_sec, &o->tv_sec);
-		err |= __put_user(i->tv_usec, &o->tv_usec);
-	}
-	return err;
-}
-
 asmlinkage long sys32_alarm(unsigned int seconds)
 {
 	return alarm_setitimer(seconds);
 }
 
-/*
- * Translations due to time_t size differences. Which affects all
- * sorts of things, like timeval and itimerval.
- */
-asmlinkage long sys32_gettimeofday(struct compat_timeval __user *tv,
-				   struct timezone __user *tz)
-{
-	if (tv) {
-		struct timeval ktv;
-
-		do_gettimeofday(&ktv);
-		if (put_tv32(tv, &ktv))
-			return -EFAULT;
-	}
-	if (tz) {
-		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-asmlinkage long sys32_settimeofday(struct compat_timeval __user *tv,
-				   struct timezone __user *tz)
-{
-	struct timeval ktv;
-	struct timespec kts;
-	struct timezone ktz;
-
-	if (tv) {
-		if (get_tv32(&ktv, tv))
-			return -EFAULT;
-		kts.tv_sec = ktv.tv_sec;
-		kts.tv_nsec = ktv.tv_usec * NSEC_PER_USEC;
-	}
-	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
-			return -EFAULT;
-	}
-
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
-}
-
 struct sel_arg_struct {
 	unsigned int n;
 	unsigned int inp;
diff -puN include/linux/compat.h~compat-generic-compat-get-settimeofday include/linux/compat.h
--- a/include/linux/compat.h~compat-generic-compat-get-settimeofday
+++ a/include/linux/compat.h
@@ -234,6 +234,11 @@ extern int get_compat_itimerspec(struct 
 extern int put_compat_itimerspec(struct compat_itimerspec __user *dst,
 				 const struct itimerspec *src);
 
+asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
+		struct timezone __user *tz);
+asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
+		struct timezone __user *tz);
+
 asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
 
 extern int compat_printk(const char *fmt, ...);
diff -puN include/linux/time.h~compat-generic-compat-get-settimeofday include/linux/time.h
--- a/include/linux/time.h~compat-generic-compat-get-settimeofday
+++ a/include/linux/time.h
@@ -29,6 +29,8 @@ struct timezone {
 
 #ifdef __KERNEL__
 
+extern struct timezone sys_tz;
+
 /* Parameters used to convert the timespec values: */
 #define MSEC_PER_SEC	1000L
 #define USEC_PER_MSEC	1000L
diff -puN kernel/compat.c~compat-generic-compat-get-settimeofday kernel/compat.c
--- a/kernel/compat.c~compat-generic-compat-get-settimeofday
+++ a/kernel/compat.c
@@ -26,6 +26,64 @@
 
 #include <asm/uaccess.h>
 
+/*
+ * Note that the native side is already converted to a timespec, because
+ * that's what we want anyway.
+ */
+static int compat_get_timeval(struct timespec *o,
+		struct compat_timeval __user *i)
+{
+	long usec;
+
+	if (get_user(o->tv_sec, &i->tv_sec) ||
+	    get_user(usec, &i->tv_usec))
+		return -EFAULT;
+	o->tv_nsec = usec * 1000;
+	return 0;
+}
+
+static int compat_put_timeval(struct compat_timeval __user *o,
+		struct timeval *i)
+{
+	return (put_user(i->tv_sec, &o->tv_sec) ||
+		put_user(i->tv_usec, &o->tv_usec)) ? -EFAULT : 0;
+}
+
+asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
+		struct timezone __user *tz)
+{
+	if (tv) {
+		struct timeval ktv;
+		do_gettimeofday(&ktv);
+		if (compat_put_timeval(tv, &ktv))
+			return -EFAULT;
+	}
+	if (tz) {
+		if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
+		struct timezone __user *tz)
+{
+	struct timespec kts;
+	struct timezone ktz;
+
+ 	if (tv) {
+		if (compat_get_timeval(&kts, tv))
+			return -EFAULT;
+	}
+	if (tz) {
+		if (copy_from_user(&ktz, tz, sizeof(ktz)))
+			return -EFAULT;
+	}
+
+	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
+}
+
 int get_compat_timespec(struct timespec *ts, const struct compat_timespec __user *cts)
 {
 	return (!access_ok(VERIFY_READ, cts, sizeof(*cts)) ||
_

Patches currently in -mm which might be from hch@lst.de are

linux-next.patch
x86-remove-init_mm-export-as-planned-for-2626.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
compat-move-cp_compat_stat-to-common-code.patch
compat-generic-compat-get-settimeofday.patch


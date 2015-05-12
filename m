From: akpm@linux-foundation.org
Subject: +
 clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic.patch
 added to -mm tree
Date: Tue, 12 May 2015 14:23:07 -0700
Message-ID: <55526f3b.RgwViLeov3ehFXyT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051AbbELVXI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 17:23:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, hpa@zytor.com, luto@kernel.org, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de, thiago.macieira@intel.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: clone: support passing tls argument via C rather than pt_regs magic
has been added to the -mm tree.  Its filename is
     clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: clone: support passing tls argument via C rather than pt_regs magic

clone has some of the quirkiest syscall handling in the kernel, with a
pile of special cases, historical curiosities, and architecture-specific
calling conventions.  In particular, clone with CLONE_SETTLS accepts a
parameter "tls" that the C entry point completely ignores and some
assembly entry points overwrite; instead, the low-level arch-specific code
pulls the tls parameter out of the arch-specific register captured as part
of pt_regs on entry to the kernel.  That's a massive hack, and it makes
the arch-specific code only work when called via the specific existing
syscall entry points; because of this hack, any new clone-like system call
would have to accept an identical tls argument in exactly the same
arch-specific position, rather than providing a unified system call entry
point across architectures.

The first patch allows architectures to handle the tls argument via normal
C parameter passing, if they opt in by selecting HAVE_COPY_THREAD_TLS. 
The second patch makes 32-bit and 64-bit x86 opt into this.

These two patches came out of the clone4 series, which isn't ready for
this merge window, but these first two cleanup patches were entirely
uncontroversial and have acks.  I'd like to go ahead and submit these two
so that other architectures can begin building on top of this and opting
into HAVE_COPY_THREAD_TLS.  However, I'm also happy to wait and send these
through the next merge window (along with v3 of clone4) if anyone would
prefer that.



This patch (of 2):

clone with CLONE_SETTLS accepts an argument to set the thread-local
storage area for the new thread.  sys_clone declares an int argument
tls_val in the appropriate point in the argument list (based on the
various CLONE_BACKWARDS variants), but doesn't actually use or pass along
that argument.  Instead, sys_clone calls do_fork, which calls
copy_process, which calls the arch-specific copy_thread, and copy_thread
pulls the corresponding syscall argument out of the pt_regs captured at
kernel entry (knowing what argument of clone that architecture passes tls
in).

Apart from being awful and inscrutable, that also only works because only
one code path into copy_thread can pass the CLONE_SETTLS flag, and that
code path comes from sys_clone with its architecture-specific
argument-passing order.  This prevents introducing a new version of the
clone system call without propagating the same architecture-specific
position of the tls argument.

However, there's no reason to pull the argument out of pt_regs when
sys_clone could just pass it down via C function call arguments.

Introduce a new CONFIG_HAVE_COPY_THREAD_TLS for architectures to opt into,
and a new copy_thread_tls that accepts the tls parameter as an additional
unsigned long (syscall-argument-sized) argument.  Change sys_clone's tls
argument to an unsigned long (which does not change the ABI), and pass
that down to copy_thread_tls.

Architectures that don't opt into copy_thread_tls will continue to ignore
the C argument to sys_clone in favor of the pt_regs captured at kernel
entry, and thus will be unable to introduce new versions of the clone
syscall.

Patch co-authored by Josh Triplett and Thiago Macieira.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thiago Macieira <thiago.macieira@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig             |    7 ++++
 include/linux/sched.h    |   14 +++++++++
 include/linux/syscalls.h |    6 ++--
 kernel/fork.c            |   55 ++++++++++++++++++++++++-------------
 4 files changed, 60 insertions(+), 22 deletions(-)

diff -puN arch/Kconfig~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic arch/Kconfig
--- a/arch/Kconfig~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic
+++ a/arch/Kconfig
@@ -499,6 +499,13 @@ config ARCH_HAS_ELF_RANDOMIZE
 	  - arch_mmap_rnd()
 	  - arch_randomize_brk()
 
+config HAVE_COPY_THREAD_TLS
+	bool
+	help
+	  Architecture provides copy_thread_tls to accept tls argument via
+	  normal C parameter passing, rather than extracting the syscall
+	  argument from pt_regs.
+
 #
 # ABI hall of shame
 #
diff -puN include/linux/sched.h~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic include/linux/sched.h
--- a/include/linux/sched.h~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic
+++ a/include/linux/sched.h
@@ -2489,8 +2489,22 @@ extern struct mm_struct *mm_access(struc
 /* Remove the current tasks stale references to the old mm_struct */
 extern void mm_release(struct task_struct *, struct mm_struct *);
 
+#ifdef CONFIG_HAVE_COPY_THREAD_TLS
+extern int copy_thread_tls(unsigned long, unsigned long, unsigned long,
+			struct task_struct *, unsigned long);
+#else
 extern int copy_thread(unsigned long, unsigned long, unsigned long,
 			struct task_struct *);
+
+/* Architectures that haven't opted into copy_thread_tls get the tls argument
+ * via pt_regs, so ignore the tls argument passed via C. */
+static inline int copy_thread_tls(
+		unsigned long clone_flags, unsigned long sp, unsigned long arg,
+		struct task_struct *p, unsigned long tls)
+{
+	return copy_thread(clone_flags, sp, arg, p);
+}
+#endif
 extern void flush_thread(void);
 extern void exit_thread(void);
 
diff -puN include/linux/syscalls.h~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic include/linux/syscalls.h
--- a/include/linux/syscalls.h~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic
+++ a/include/linux/syscalls.h
@@ -827,15 +827,15 @@ asmlinkage long sys_syncfs(int fd);
 asmlinkage long sys_fork(void);
 asmlinkage long sys_vfork(void);
 #ifdef CONFIG_CLONE_BACKWARDS
-asmlinkage long sys_clone(unsigned long, unsigned long, int __user *, int,
+asmlinkage long sys_clone(unsigned long, unsigned long, int __user *, unsigned long,
 	       int __user *);
 #else
 #ifdef CONFIG_CLONE_BACKWARDS3
 asmlinkage long sys_clone(unsigned long, unsigned long, int, int __user *,
-			  int __user *, int);
+			  int __user *, unsigned long);
 #else
 asmlinkage long sys_clone(unsigned long, unsigned long, int __user *,
-	       int __user *, int);
+	       int __user *, unsigned long);
 #endif
 #endif
 
diff -puN kernel/fork.c~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic kernel/fork.c
--- a/kernel/fork.c~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic
+++ a/kernel/fork.c
@@ -1241,7 +1241,8 @@ static struct task_struct *copy_process(
 					unsigned long stack_size,
 					int __user *child_tidptr,
 					struct pid *pid,
-					int trace)
+					int trace,
+					unsigned long tls)
 {
 	int retval;
 	struct task_struct *p;
@@ -1447,7 +1448,7 @@ static struct task_struct *copy_process(
 	retval = copy_io(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_namespaces;
-	retval = copy_thread(clone_flags, stack_start, stack_size, p);
+	retval = copy_thread_tls(clone_flags, stack_start, stack_size, p, tls);
 	if (retval)
 		goto bad_fork_cleanup_io;
 
@@ -1659,7 +1660,7 @@ static inline void init_idle_pids(struct
 struct task_struct *fork_idle(int cpu)
 {
 	struct task_struct *task;
-	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0);
+	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0, 0);
 	if (!IS_ERR(task)) {
 		init_idle_pids(task->pids);
 		init_idle(task, cpu);
@@ -1674,11 +1675,13 @@ struct task_struct *fork_idle(int cpu)
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
  */
-long do_fork(unsigned long clone_flags,
-	      unsigned long stack_start,
-	      unsigned long stack_size,
-	      int __user *parent_tidptr,
-	      int __user *child_tidptr)
+static long _do_fork(
+		unsigned long clone_flags,
+		unsigned long stack_start,
+		unsigned long stack_size,
+		int __user *parent_tidptr,
+		int __user *child_tidptr,
+		unsigned long tls)
 {
 	struct task_struct *p;
 	int trace = 0;
@@ -1703,7 +1706,7 @@ long do_fork(unsigned long clone_flags,
 	}
 
 	p = copy_process(clone_flags, stack_start, stack_size,
-			 child_tidptr, NULL, trace);
+			 child_tidptr, NULL, trace, tls);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
@@ -1744,20 +1747,34 @@ long do_fork(unsigned long clone_flags,
 	return nr;
 }
 
+#ifndef CONFIG_HAVE_COPY_THREAD_TLS
+/* For compatibility with architectures that call do_fork directly rather than
+ * using the syscall entry points below. */
+long do_fork(unsigned long clone_flags,
+	      unsigned long stack_start,
+	      unsigned long stack_size,
+	      int __user *parent_tidptr,
+	      int __user *child_tidptr)
+{
+	return _do_fork(clone_flags, stack_start, stack_size,
+			parent_tidptr, child_tidptr, 0);
+}
+#endif
+
 /*
  * Create a kernel thread.
  */
 pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 {
-	return do_fork(flags|CLONE_VM|CLONE_UNTRACED, (unsigned long)fn,
-		(unsigned long)arg, NULL, NULL);
+	return _do_fork(flags|CLONE_VM|CLONE_UNTRACED, (unsigned long)fn,
+		(unsigned long)arg, NULL, NULL, 0);
 }
 
 #ifdef __ARCH_WANT_SYS_FORK
 SYSCALL_DEFINE0(fork)
 {
 #ifdef CONFIG_MMU
-	return do_fork(SIGCHLD, 0, 0, NULL, NULL);
+	return _do_fork(SIGCHLD, 0, 0, NULL, NULL, 0);
 #else
 	/* can not support in nommu mode */
 	return -EINVAL;
@@ -1768,8 +1785,8 @@ SYSCALL_DEFINE0(fork)
 #ifdef __ARCH_WANT_SYS_VFORK
 SYSCALL_DEFINE0(vfork)
 {
-	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, 0,
-			0, NULL, NULL);
+	return _do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, 0,
+			0, NULL, NULL, 0);
 }
 #endif
 
@@ -1777,27 +1794,27 @@ SYSCALL_DEFINE0(vfork)
 #ifdef CONFIG_CLONE_BACKWARDS
 SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		 int __user *, parent_tidptr,
-		 int, tls_val,
+		 unsigned long, tls,
 		 int __user *, child_tidptr)
 #elif defined(CONFIG_CLONE_BACKWARDS2)
 SYSCALL_DEFINE5(clone, unsigned long, newsp, unsigned long, clone_flags,
 		 int __user *, parent_tidptr,
 		 int __user *, child_tidptr,
-		 int, tls_val)
+		 unsigned long, tls)
 #elif defined(CONFIG_CLONE_BACKWARDS3)
 SYSCALL_DEFINE6(clone, unsigned long, clone_flags, unsigned long, newsp,
 		int, stack_size,
 		int __user *, parent_tidptr,
 		int __user *, child_tidptr,
-		int, tls_val)
+		unsigned long, tls)
 #else
 SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		 int __user *, parent_tidptr,
 		 int __user *, child_tidptr,
-		 int, tls_val)
+		 unsigned long, tls)
 #endif
 {
-	return do_fork(clone_flags, newsp, 0, parent_tidptr, child_tidptr);
+	return _do_fork(clone_flags, newsp, 0, parent_tidptr, child_tidptr, tls);
 }
 #endif
 
_

Patches currently in -mm which might be from josh@joshtriplett.org are

uidgid-make-uid_valid-and-gid_valid-work-with-config_multiuser.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic.patch
x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch


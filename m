From: akpm@linux-foundation.org
Subject: [patch 072/111] signal: consolidate {TS,TLF}_RESTORE_SIGMASK code
Date: Tue, 02 Aug 2016 14:05:36 -0700
Message-ID: <57a10b20.R0O8ku18eCuX7nuu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbcHBVRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, luto@kernel.org, benh@kernel.crashing.org, bp@suse.de, brgerst@gmail.com, cmetcalf@mellanox.com, dalias@libc.org, davem@davemloft.net, dsafonov@virtuozzo.com, fenghua.yu@intel.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, monstr@monstr.eu, mpe@ellerman.id.au, oleg@redhat.com, paulus@samba.org, peterz@infradead.org, rth@twiddle.net, tony.luck@intel.com, ysato@users.sourceforge.jp

From: Andy Lutomirski <luto@kernel.org>
Subject: signal: consolidate {TS,TLF}_RESTORE_SIGMASK code

In general, there's no need for the "restore sigmask" flag to live in
ti->flags.  alpha, ia64, microblaze, powerpc, sh, sparc (64-bit only),
tile, and x86 use essentially identical alternative implementations,
placing the flag in ti->status.

Replace those optimized implementations with an equally good common
implementation that stores it in a bitfield in struct task_struct and drop
the custom implementations.

Additional architectures can opt in by removing their TIF_RESTORE_SIGMASK
defines.

Link: http://lkml.kernel.org/r/8a14321d64a28e40adfddc90e18a96c086a6d6f9.1468522723.git.luto@kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>	[powerpc]
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Dmitry Safonov <dsafonov@virtuozzo.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/thread_info.h      |   27 --------
 arch/ia64/include/asm/thread_info.h       |   28 --------
 arch/microblaze/include/asm/thread_info.h |   27 --------
 arch/powerpc/include/asm/thread_info.h    |   25 -------
 arch/sh/include/asm/thread_info.h         |   26 --------
 arch/sparc/include/asm/thread_info_64.h   |   24 -------
 arch/tile/include/asm/thread_info.h       |   27 --------
 arch/x86/include/asm/thread_info.h        |   24 -------
 include/linux/sched.h                     |   63 ++++++++++++++++++++
 include/linux/thread_info.h               |   41 -------------
 10 files changed, 63 insertions(+), 249 deletions(-)

diff -puN arch/alpha/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code arch/alpha/include/asm/thread_info.h
--- a/arch/alpha/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code
+++ a/arch/alpha/include/asm/thread_info.h
@@ -86,33 +86,6 @@ register struct thread_info *__current_t
 #define TS_UAC_NOPRINT		0x0001	/* ! Preserve the following three */
 #define TS_UAC_NOFIX		0x0002	/* ! flags as they match          */
 #define TS_UAC_SIGBUS		0x0004	/* ! userspace part of 'osf_sysinfo' */
-#define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
-
-#ifndef __ASSEMBLY__
-#define HAVE_SET_RESTORE_SIGMASK	1
-static inline void set_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	ti->status |= TS_RESTORE_SIGMASK;
-	WARN_ON(!test_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags));
-}
-static inline void clear_restore_sigmask(void)
-{
-	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-}
-static inline bool test_restore_sigmask(void)
-{
-	return current_thread_info()->status & TS_RESTORE_SIGMASK;
-}
-static inline bool test_and_clear_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	if (!(ti->status & TS_RESTORE_SIGMASK))
-		return false;
-	ti->status &= ~TS_RESTORE_SIGMASK;
-	return true;
-}
-#endif
 
 #define SET_UNALIGN_CTL(task,value)	({				\
 	__u32 status = task_thread_info(task)->status & ~UAC_BITMASK;	\
diff -puN arch/ia64/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code arch/ia64/include/asm/thread_info.h
--- a/arch/ia64/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code
+++ a/arch/ia64/include/asm/thread_info.h
@@ -121,32 +121,4 @@ struct thread_info {
 /* like TIF_ALLWORK_BITS but sans TIF_SYSCALL_TRACE or TIF_SYSCALL_AUDIT */
 #define TIF_WORK_MASK		(TIF_ALLWORK_MASK&~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT))
 
-#define TS_RESTORE_SIGMASK	2	/* restore signal mask in do_signal() */
-
-#ifndef __ASSEMBLY__
-#define HAVE_SET_RESTORE_SIGMASK	1
-static inline void set_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	ti->status |= TS_RESTORE_SIGMASK;
-	WARN_ON(!test_bit(TIF_SIGPENDING, &ti->flags));
-}
-static inline void clear_restore_sigmask(void)
-{
-	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-}
-static inline bool test_restore_sigmask(void)
-{
-	return current_thread_info()->status & TS_RESTORE_SIGMASK;
-}
-static inline bool test_and_clear_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	if (!(ti->status & TS_RESTORE_SIGMASK))
-		return false;
-	ti->status &= ~TS_RESTORE_SIGMASK;
-	return true;
-}
-#endif	/* !__ASSEMBLY__ */
-
 #endif /* _ASM_IA64_THREAD_INFO_H */
diff -puN arch/microblaze/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code arch/microblaze/include/asm/thread_info.h
--- a/arch/microblaze/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code
+++ a/arch/microblaze/include/asm/thread_info.h
@@ -148,33 +148,6 @@ static inline struct thread_info *curren
  */
 /* FPU was used by this task this quantum (SMP) */
 #define TS_USEDFPU		0x0001
-#define TS_RESTORE_SIGMASK	0x0002
-
-#ifndef __ASSEMBLY__
-#define HAVE_SET_RESTORE_SIGMASK 1
-static inline void set_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	ti->status |= TS_RESTORE_SIGMASK;
-	WARN_ON(!test_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags));
-}
-static inline void clear_restore_sigmask(void)
-{
-	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-}
-static inline bool test_restore_sigmask(void)
-{
-	return current_thread_info()->status & TS_RESTORE_SIGMASK;
-}
-static inline bool test_and_clear_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	if (!(ti->status & TS_RESTORE_SIGMASK))
-		return false;
-	ti->status &= ~TS_RESTORE_SIGMASK;
-	return true;
-}
-#endif
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_MICROBLAZE_THREAD_INFO_H */
diff -puN arch/powerpc/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code arch/powerpc/include/asm/thread_info.h
--- a/arch/powerpc/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code
+++ a/arch/powerpc/include/asm/thread_info.h
@@ -138,40 +138,15 @@ static inline struct thread_info *curren
 /* Don't move TLF_NAPPING without adjusting the code in entry_32.S */
 #define TLF_NAPPING		0	/* idle thread enabled NAP mode */
 #define TLF_SLEEPING		1	/* suspend code enabled SLEEP mode */
-#define TLF_RESTORE_SIGMASK	2	/* Restore signal mask in do_signal */
 #define TLF_LAZY_MMU		3	/* tlb_batch is active */
 #define TLF_RUNLATCH		4	/* Is the runlatch enabled? */
 
 #define _TLF_NAPPING		(1 << TLF_NAPPING)
 #define _TLF_SLEEPING		(1 << TLF_SLEEPING)
-#define _TLF_RESTORE_SIGMASK	(1 << TLF_RESTORE_SIGMASK)
 #define _TLF_LAZY_MMU		(1 << TLF_LAZY_MMU)
 #define _TLF_RUNLATCH		(1 << TLF_RUNLATCH)
 
 #ifndef __ASSEMBLY__
-#define HAVE_SET_RESTORE_SIGMASK	1
-static inline void set_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	ti->local_flags |= _TLF_RESTORE_SIGMASK;
-	WARN_ON(!test_bit(TIF_SIGPENDING, &ti->flags));
-}
-static inline void clear_restore_sigmask(void)
-{
-	current_thread_info()->local_flags &= ~_TLF_RESTORE_SIGMASK;
-}
-static inline bool test_restore_sigmask(void)
-{
-	return current_thread_info()->local_flags & _TLF_RESTORE_SIGMASK;
-}
-static inline bool test_and_clear_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	if (!(ti->local_flags & _TLF_RESTORE_SIGMASK))
-		return false;
-	ti->local_flags &= ~_TLF_RESTORE_SIGMASK;
-	return true;
-}
 
 static inline bool test_thread_local_flags(unsigned int flags)
 {
diff -puN arch/sh/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code arch/sh/include/asm/thread_info.h
--- a/arch/sh/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code
+++ a/arch/sh/include/asm/thread_info.h
@@ -151,19 +151,10 @@ extern void init_thread_xstate(void);
  * ever touches our thread-synchronous status, so we don't
  * have to worry about atomic accesses.
  */
-#define TS_RESTORE_SIGMASK	0x0001	/* restore signal mask in do_signal() */
 #define TS_USEDFPU		0x0002	/* FPU used by this task this quantum */
 
 #ifndef __ASSEMBLY__
 
-#define HAVE_SET_RESTORE_SIGMASK	1
-static inline void set_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	ti->status |= TS_RESTORE_SIGMASK;
-	WARN_ON(!test_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags));
-}
-
 #define TI_FLAG_FAULT_CODE_SHIFT	24
 
 /*
@@ -182,23 +173,6 @@ static inline unsigned int get_thread_fa
 	return ti->flags >> TI_FLAG_FAULT_CODE_SHIFT;
 }
 
-static inline void clear_restore_sigmask(void)
-{
-	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-}
-static inline bool test_restore_sigmask(void)
-{
-	return current_thread_info()->status & TS_RESTORE_SIGMASK;
-}
-static inline bool test_and_clear_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	if (!(ti->status & TS_RESTORE_SIGMASK))
-		return false;
-	ti->status &= ~TS_RESTORE_SIGMASK;
-	return true;
-}
-
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff -puN arch/sparc/include/asm/thread_info_64.h~signal-consolidate-tstlf_restore_sigmask-code arch/sparc/include/asm/thread_info_64.h
--- a/arch/sparc/include/asm/thread_info_64.h~signal-consolidate-tstlf_restore_sigmask-code
+++ a/arch/sparc/include/asm/thread_info_64.h
@@ -222,32 +222,8 @@ register struct thread_info *current_thr
  *
  * Note that there are only 8 bits available.
  */
-#define TS_RESTORE_SIGMASK	0x0001	/* restore signal mask in do_signal() */
 
 #ifndef __ASSEMBLY__
-#define HAVE_SET_RESTORE_SIGMASK	1
-static inline void set_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	ti->status |= TS_RESTORE_SIGMASK;
-	WARN_ON(!test_bit(TIF_SIGPENDING, &ti->flags));
-}
-static inline void clear_restore_sigmask(void)
-{
-	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-}
-static inline bool test_restore_sigmask(void)
-{
-	return current_thread_info()->status & TS_RESTORE_SIGMASK;
-}
-static inline bool test_and_clear_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	if (!(ti->status & TS_RESTORE_SIGMASK))
-		return false;
-	ti->status &= ~TS_RESTORE_SIGMASK;
-	return true;
-}
 
 #define thread32_stack_is_64bit(__SP) (((__SP) & 0x1) != 0)
 #define test_thread_64bit_stack(__SP) \
diff -puN arch/tile/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code arch/tile/include/asm/thread_info.h
--- a/arch/tile/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code
+++ a/arch/tile/include/asm/thread_info.h
@@ -166,32 +166,5 @@ extern void _cpu_idle(void);
 #ifdef __tilegx__
 #define TS_COMPAT		0x0001	/* 32-bit compatibility mode */
 #endif
-#define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal */
-
-#ifndef __ASSEMBLY__
-#define HAVE_SET_RESTORE_SIGMASK	1
-static inline void set_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	ti->status |= TS_RESTORE_SIGMASK;
-	WARN_ON(!test_bit(TIF_SIGPENDING, &ti->flags));
-}
-static inline void clear_restore_sigmask(void)
-{
-	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-}
-static inline bool test_restore_sigmask(void)
-{
-	return current_thread_info()->status & TS_RESTORE_SIGMASK;
-}
-static inline bool test_and_clear_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	if (!(ti->status & TS_RESTORE_SIGMASK))
-		return false;
-	ti->status &= ~TS_RESTORE_SIGMASK;
-	return true;
-}
-#endif	/* !__ASSEMBLY__ */
 
 #endif /* _ASM_TILE_THREAD_INFO_H */
diff -puN arch/x86/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code arch/x86/include/asm/thread_info.h
--- a/arch/x86/include/asm/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code
+++ a/arch/x86/include/asm/thread_info.h
@@ -219,32 +219,8 @@ static inline unsigned long current_stac
  * have to worry about atomic accesses.
  */
 #define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
-#define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
 
 #ifndef __ASSEMBLY__
-#define HAVE_SET_RESTORE_SIGMASK	1
-static inline void set_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	ti->status |= TS_RESTORE_SIGMASK;
-	WARN_ON(!test_bit(TIF_SIGPENDING, (unsigned long *)&ti->flags));
-}
-static inline void clear_restore_sigmask(void)
-{
-	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-}
-static inline bool test_restore_sigmask(void)
-{
-	return current_thread_info()->status & TS_RESTORE_SIGMASK;
-}
-static inline bool test_and_clear_restore_sigmask(void)
-{
-	struct thread_info *ti = current_thread_info();
-	if (!(ti->status & TS_RESTORE_SIGMASK))
-		return false;
-	ti->status &= ~TS_RESTORE_SIGMASK;
-	return true;
-}
 
 static inline bool in_ia32_syscall(void)
 {
diff -puN include/linux/sched.h~signal-consolidate-tstlf_restore_sigmask-code include/linux/sched.h
--- a/include/linux/sched.h~signal-consolidate-tstlf_restore_sigmask-code
+++ a/include/linux/sched.h
@@ -1547,6 +1547,9 @@ struct task_struct {
 	/* unserialized, strictly 'current' */
 	unsigned in_execve:1; /* bit to tell LSMs we're in execve */
 	unsigned in_iowait:1;
+#if !defined(TIF_RESTORE_SIGMASK)
+	unsigned restore_sigmask:1;
+#endif
 #ifdef CONFIG_MEMCG
 	unsigned memcg_may_oom:1;
 #ifndef CONFIG_SLOB
@@ -2680,6 +2683,66 @@ extern void sigqueue_free(struct sigqueu
 extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
 extern int do_sigaction(int, struct k_sigaction *, struct k_sigaction *);
 
+#ifdef TIF_RESTORE_SIGMASK
+/*
+ * Legacy restore_sigmask accessors.  These are inefficient on
+ * SMP architectures because they require atomic operations.
+ */
+
+/**
+ * set_restore_sigmask() - make sure saved_sigmask processing gets done
+ *
+ * This sets TIF_RESTORE_SIGMASK and ensures that the arch signal code
+ * will run before returning to user mode, to process the flag.  For
+ * all callers, TIF_SIGPENDING is already set or it's no harm to set
+ * it.  TIF_RESTORE_SIGMASK need not be in the set of bits that the
+ * arch code will notice on return to user mode, in case those bits
+ * are scarce.  We set TIF_SIGPENDING here to ensure that the arch
+ * signal code always gets run when TIF_RESTORE_SIGMASK is set.
+ */
+static inline void set_restore_sigmask(void)
+{
+	set_thread_flag(TIF_RESTORE_SIGMASK);
+	WARN_ON(!test_thread_flag(TIF_SIGPENDING));
+}
+static inline void clear_restore_sigmask(void)
+{
+	clear_thread_flag(TIF_RESTORE_SIGMASK);
+}
+static inline bool test_restore_sigmask(void)
+{
+	return test_thread_flag(TIF_RESTORE_SIGMASK);
+}
+static inline bool test_and_clear_restore_sigmask(void)
+{
+	return test_and_clear_thread_flag(TIF_RESTORE_SIGMASK);
+}
+
+#else	/* TIF_RESTORE_SIGMASK */
+
+/* Higher-quality implementation, used if TIF_RESTORE_SIGMASK doesn't exist. */
+static inline void set_restore_sigmask(void)
+{
+	current->restore_sigmask = true;
+	WARN_ON(!test_thread_flag(TIF_SIGPENDING));
+}
+static inline void clear_restore_sigmask(void)
+{
+	current->restore_sigmask = false;
+}
+static inline bool test_restore_sigmask(void)
+{
+	return current->restore_sigmask;
+}
+static inline bool test_and_clear_restore_sigmask(void)
+{
+	if (!current->restore_sigmask)
+		return false;
+	current->restore_sigmask = false;
+	return true;
+}
+#endif
+
 static inline void restore_saved_sigmask(void)
 {
 	if (test_and_clear_restore_sigmask())
diff -puN include/linux/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code include/linux/thread_info.h
--- a/include/linux/thread_info.h~signal-consolidate-tstlf_restore_sigmask-code
+++ a/include/linux/thread_info.h
@@ -105,47 +105,6 @@ static inline int test_ti_thread_flag(st
 
 #define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
 
-#if defined TIF_RESTORE_SIGMASK && !defined HAVE_SET_RESTORE_SIGMASK
-/*
- * An arch can define its own version of set_restore_sigmask() to get the
- * job done however works, with or without TIF_RESTORE_SIGMASK.
- */
-#define HAVE_SET_RESTORE_SIGMASK	1
-
-/**
- * set_restore_sigmask() - make sure saved_sigmask processing gets done
- *
- * This sets TIF_RESTORE_SIGMASK and ensures that the arch signal code
- * will run before returning to user mode, to process the flag.  For
- * all callers, TIF_SIGPENDING is already set or it's no harm to set
- * it.  TIF_RESTORE_SIGMASK need not be in the set of bits that the
- * arch code will notice on return to user mode, in case those bits
- * are scarce.  We set TIF_SIGPENDING here to ensure that the arch
- * signal code always gets run when TIF_RESTORE_SIGMASK is set.
- */
-static inline void set_restore_sigmask(void)
-{
-	set_thread_flag(TIF_RESTORE_SIGMASK);
-	WARN_ON(!test_thread_flag(TIF_SIGPENDING));
-}
-static inline void clear_restore_sigmask(void)
-{
-	clear_thread_flag(TIF_RESTORE_SIGMASK);
-}
-static inline bool test_restore_sigmask(void)
-{
-	return test_thread_flag(TIF_RESTORE_SIGMASK);
-}
-static inline bool test_and_clear_restore_sigmask(void)
-{
-	return test_and_clear_thread_flag(TIF_RESTORE_SIGMASK);
-}
-#endif	/* TIF_RESTORE_SIGMASK && !HAVE_SET_RESTORE_SIGMASK */
-
-#ifndef HAVE_SET_RESTORE_SIGMASK
-#error "no set_restore_sigmask() provided and default one won't work"
-#endif

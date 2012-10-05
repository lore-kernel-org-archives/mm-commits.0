From: akpm@linux-foundation.org
Subject: [merged] compat-move-compat_siginfo_t-definition-to-asm-compath.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:19:37 -0700
Message-ID: <20121005201938.8E4EE20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:37923 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2JEUTl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:19:41 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so57973wib.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:19:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, amwang@redhat.com, fengguang.wu@intel.com, jmfoote@cert.org, oleg@redhat.com, palves@redhat.com, roland@hack.frob.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: compat: move compat_siginfo_t definition to asm/compat.h
has been removed from the -mm tree.  Its filename was
     compat-move-compat_siginfo_t-definition-to-asm-compath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: compat: move compat_siginfo_t definition to asm/compat.h

This is a preparatory patch for the introduction of NT_SIGINFO elf note.

Make the location of compat_siginfo_t uniform across eight architectures
which have it.  Now it can be pulled in by including asm/compat.h or
linux/compat.h.

Most of the copies are verbatim.  compat_uid[32]_t had to be replaced by
__compat_uid[32]_t.  compat_uptr_t had to be moved up before
compat_siginfo_t in asm/compat.h on a several architectures (tile already
had it moved up).  compat_sigval_t had to be relocated from linux/compat.h
to asm/compat.h.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: "Jonathan M. Foote" <jmfoote@cert.org>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Pedro Alves <palves@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/compat.h       |   60 ++++++++++++++++++-
 arch/arm64/kernel/signal32.c          |   53 ----------------
 arch/mips/include/asm/compat-signal.h |   62 -------------------
 arch/mips/include/asm/compat.h        |   69 +++++++++++++++++++++-
 arch/parisc/include/asm/compat.h      |   59 ++++++++++++++++++
 arch/parisc/kernel/signal32.h         |   52 ----------------
 arch/powerpc/include/asm/compat.h     |   60 ++++++++++++++++++-
 arch/powerpc/include/asm/siginfo.h    |    1 
 arch/powerpc/kernel/ppc32.h           |   51 ----------------
 arch/s390/include/asm/compat.h        |   75 +++++++++++++++++++++++-
 arch/s390/kernel/compat_linux.h       |   68 ---------------------
 arch/sparc/include/asm/compat.h       |   61 +++++++++++++++++++
 arch/sparc/include/asm/siginfo.h      |    1 
 arch/sparc/kernel/signal32.c          |   52 ----------------
 arch/tile/include/asm/compat.h        |   62 +++++++++++++++++++
 arch/tile/kernel/compat_signal.c      |   57 ------------------
 arch/x86/include/asm/compat.h         |   74 +++++++++++++++++++++++
 arch/x86/include/asm/ia32.h           |   67 ---------------------
 include/linux/compat.h                |    5 -
 19 files changed, 513 insertions(+), 476 deletions(-)

diff -puN arch/arm64/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/arm64/include/asm/compat.h
--- a/arch/arm64/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/arm64/include/asm/compat.h
@@ -55,6 +55,7 @@ typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
+typedef u32		compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
@@ -130,6 +131,64 @@ typedef u32		compat_old_sigset_t;
 
 typedef u32		compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		/* The padding is the same size as AArch64. */
+		int _pad[128/sizeof(int) - 3];
+
+		/* kill() */
+		struct {
+			compat_pid_t _pid;	/* sender's pid */
+			__compat_uid32_t _uid;	/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;	/* timer id */
+			int _overrun;		/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;       /* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			compat_pid_t _pid;	/* sender's pid */
+			__compat_uid32_t _uid;	/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			compat_pid_t _pid;	/* which child */
+			__compat_uid32_t _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			compat_uptr_t _addr; /* faulting insn/memory ref. */
+			short _addr_lsb; /* LSB of the reported address */
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			compat_long_t _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -139,7 +198,6 @@ typedef u32		compat_sigset_word;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef	u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff -puN arch/arm64/kernel/signal32.c~compat-move-compat_siginfo_t-definition-to-asm-compath arch/arm64/kernel/signal32.c
--- a/arch/arm64/kernel/signal32.c~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/arm64/kernel/signal32.c
@@ -30,59 +30,6 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
-typedef struct compat_siginfo {
-	int si_signo;
-	int si_errno;
-	int si_code;
-
-	union {
-		/* The padding is the same size as AArch64. */
-		int _pad[SI_PAD_SIZE];
-
-		/* kill() */
-		struct {
-			compat_pid_t _pid;	/* sender's pid */
-			__compat_uid32_t _uid;	/* sender's uid */
-		} _kill;
-
-		/* POSIX.1b timers */
-		struct {
-			compat_timer_t _tid;	/* timer id */
-			int _overrun;		/* overrun count */
-			compat_sigval_t _sigval;	/* same as below */
-			int _sys_private;       /* not to be passed to user */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			compat_pid_t _pid;	/* sender's pid */
-			__compat_uid32_t _uid;	/* sender's uid */
-			compat_sigval_t _sigval;
-		} _rt;
-
-		/* SIGCHLD */
-		struct {
-			compat_pid_t _pid;	/* which child */
-			__compat_uid32_t _uid;	/* sender's uid */
-			int _status;		/* exit code */
-			compat_clock_t _utime;
-			compat_clock_t _stime;
-		} _sigchld;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
-		struct {
-			compat_uptr_t _addr; /* faulting insn/memory ref. */
-			short _addr_lsb; /* LSB of the reported address */
-		} _sigfault;
-
-		/* SIGPOLL */
-		struct {
-			compat_long_t _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int _fd;
-		} _sigpoll;
-	} _sifields;
-} compat_siginfo_t;
-
 struct compat_sigaction {
 	compat_uptr_t			sa_handler;
 	compat_ulong_t			sa_flags;
diff -puN arch/mips/include/asm/compat-signal.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/mips/include/asm/compat-signal.h
--- a/arch/mips/include/asm/compat-signal.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/mips/include/asm/compat-signal.h
@@ -10,68 +10,6 @@
 
 #include <asm/uaccess.h>
 
-#define SI_PAD_SIZE32   ((SI_MAX_SIZE/sizeof(int)) - 3)
-
-typedef struct compat_siginfo {
-	int si_signo;
-	int si_code;
-	int si_errno;
-
-	union {
-		int _pad[SI_PAD_SIZE32];
-
-		/* kill() */
-		struct {
-			compat_pid_t _pid;	/* sender's pid */
-			compat_uid_t _uid;	/* sender's uid */
-		} _kill;
-
-		/* SIGCHLD */
-		struct {
-			compat_pid_t _pid;	/* which child */
-			compat_uid_t _uid;	/* sender's uid */
-			int _status;		/* exit code */
-			compat_clock_t _utime;
-			compat_clock_t _stime;
-		} _sigchld;
-
-		/* IRIX SIGCHLD */
-		struct {
-			compat_pid_t _pid;	/* which child */
-			compat_clock_t _utime;
-			int _status;		/* exit code */
-			compat_clock_t _stime;
-		} _irix_sigchld;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
-		struct {
-			s32 _addr; /* faulting insn/memory ref. */
-		} _sigfault;
-
-		/* SIGPOLL, SIGXFSZ (To do ...)  */
-		struct {
-			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int _fd;
-		} _sigpoll;
-
-		/* POSIX.1b timers */
-		struct {
-			timer_t _tid;		/* timer id */
-			int _overrun;		/* overrun count */
-			compat_sigval_t _sigval;/* same as below */
-			int _sys_private;       /* not to be passed to user */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			compat_pid_t _pid;	/* sender's pid */
-			compat_uid_t _uid;	/* sender's uid */
-			compat_sigval_t _sigval;
-		} _rt;
-
-	} _sifields;
-} compat_siginfo_t;
-
 static inline int __copy_conv_sigset_to_user(compat_sigset_t __user *d,
 	const sigset_t *s)
 {
diff -puN arch/mips/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/mips/include/asm/compat.h
--- a/arch/mips/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/mips/include/asm/compat.h
@@ -43,6 +43,7 @@ typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
+typedef u32		compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
@@ -124,6 +125,73 @@ typedef u32		compat_old_sigset_t;	/* at 
 
 typedef u32		compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+#define SI_PAD_SIZE32	(128/sizeof(int) - 3)
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_code;
+	int si_errno;
+
+	union {
+		int _pad[SI_PAD_SIZE32];
+
+		/* kill() */
+		struct {
+			compat_pid_t _pid;	/* sender's pid */
+			__compat_uid_t _uid;	/* sender's uid */
+		} _kill;
+
+		/* SIGCHLD */
+		struct {
+			compat_pid_t _pid;	/* which child */
+			__compat_uid_t _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* IRIX SIGCHLD */
+		struct {
+			compat_pid_t _pid;	/* which child */
+			compat_clock_t _utime;
+			int _status;		/* exit code */
+			compat_clock_t _stime;
+		} _irix_sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			s32 _addr; /* faulting insn/memory ref. */
+		} _sigfault;
+
+		/* SIGPOLL, SIGXFSZ (To do ...)  */
+		struct {
+			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+
+		/* POSIX.1b timers */
+		struct {
+			timer_t _tid;		/* timer id */
+			int _overrun;		/* overrun count */
+			compat_sigval_t _sigval;/* same as below */
+			int _sys_private;       /* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			compat_pid_t _pid;	/* sender's pid */
+			__compat_uid_t _uid;	/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -133,7 +201,6 @@ typedef u32		compat_sigset_word;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff -puN arch/parisc/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/parisc/include/asm/compat.h
--- a/arch/parisc/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/parisc/include/asm/compat.h
@@ -36,6 +36,7 @@ typedef s64	compat_s64;
 typedef u32	compat_uint_t;
 typedef u32	compat_ulong_t;
 typedef u64	compat_u64;
+typedef u32	compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t		tv_sec;
@@ -127,6 +128,63 @@ typedef u32		compat_old_sigset_t;	/* at 
 
 typedef u32		compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		int _pad[128/sizeof(int) - 3];
+
+		/* kill() */
+		struct {
+			unsigned int _pid;      /* sender's pid */
+			unsigned int _uid;      /* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;            /* timer id */
+			int _overrun;           /* overrun count */
+			char _pad[sizeof(unsigned int) - sizeof(int)];
+			compat_sigval_t _sigval;        /* same as below */
+			int _sys_private;       /* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			unsigned int _pid;      /* sender's pid */
+			unsigned int _uid;      /* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			unsigned int _pid;      /* which child */
+			unsigned int _uid;      /* sender's uid */
+			int _status;            /* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			unsigned int _addr;     /* faulting insn/memory ref. */
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int _band;      /* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -136,7 +194,6 @@ typedef u32		compat_sigset_word;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef	u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff -puN arch/parisc/kernel/signal32.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/parisc/kernel/signal32.h
--- a/arch/parisc/kernel/signal32.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/parisc/kernel/signal32.h
@@ -55,58 +55,6 @@ struct k_sigaction32 {
 	struct compat_sigaction sa;
 };
 
-typedef struct compat_siginfo {
-        int si_signo;
-        int si_errno;
-        int si_code;
-
-        union {
-                int _pad[((128/sizeof(int)) - 3)];
-
-                /* kill() */
-                struct {
-                        unsigned int _pid;      /* sender's pid */
-                        unsigned int _uid;      /* sender's uid */
-                } _kill;
-
-                /* POSIX.1b timers */
-                struct {
-                        compat_timer_t _tid;            /* timer id */
-                        int _overrun;           /* overrun count */
-                        char _pad[sizeof(unsigned int) - sizeof(int)];
-                        compat_sigval_t _sigval;        /* same as below */
-                        int _sys_private;       /* not to be passed to user */
-                } _timer;
-
-                /* POSIX.1b signals */
-                struct {
-                        unsigned int _pid;      /* sender's pid */
-                        unsigned int _uid;      /* sender's uid */
-                        compat_sigval_t _sigval;
-                } _rt;
-
-                /* SIGCHLD */
-                struct {
-                        unsigned int _pid;      /* which child */
-                        unsigned int _uid;      /* sender's uid */
-                        int _status;            /* exit code */
-                        compat_clock_t _utime;
-                        compat_clock_t _stime;
-                } _sigchld;
-
-                /* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
-                struct {
-                        unsigned int _addr;     /* faulting insn/memory ref. */
-                } _sigfault;
-
-                /* SIGPOLL */
-                struct {
-                        int _band;      /* POLL_IN, POLL_OUT, POLL_MSG */
-                        int _fd;
-                } _sigpoll;
-        } _sifields;
-} compat_siginfo_t;
-
 int copy_siginfo_to_user32 (compat_siginfo_t __user *to, siginfo_t *from);
 int copy_siginfo_from_user32 (siginfo_t *to, compat_siginfo_t __user *from);
 
diff -puN arch/powerpc/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/powerpc/include/asm/compat.h
--- a/arch/powerpc/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/powerpc/include/asm/compat.h
@@ -38,6 +38,7 @@ typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
+typedef u32		compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
@@ -114,6 +115,64 @@ typedef u32		compat_old_sigset_t;
 
 typedef u32		compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+#define SI_PAD_SIZE32	(128/sizeof(int) - 3)
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		int _pad[SI_PAD_SIZE32];
+
+		/* kill() */
+		struct {
+			compat_pid_t _pid;		/* sender's pid */
+			__compat_uid_t _uid;		/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;		/* timer id */
+			int _overrun;			/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;	/* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			compat_pid_t _pid;		/* sender's pid */
+			__compat_uid_t _uid;		/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			compat_pid_t _pid;		/* which child */
+			__compat_uid_t _uid;		/* sender's uid */
+			int _status;			/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS, SIGEMT */
+		struct {
+			unsigned int _addr; /* faulting insn/memory ref. */
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -123,7 +182,6 @@ typedef u32		compat_sigset_word;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef	u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff -puN arch/powerpc/include/asm/siginfo.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/powerpc/include/asm/siginfo.h
--- a/arch/powerpc/include/asm/siginfo.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/powerpc/include/asm/siginfo.h
@@ -10,7 +10,6 @@
 
 #ifdef __powerpc64__
 #    define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
-#    define SI_PAD_SIZE32		((SI_MAX_SIZE/sizeof(int)) - 3)
 #endif
 
 #include <asm-generic/siginfo.h>
diff -puN arch/powerpc/kernel/ppc32.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/powerpc/kernel/ppc32.h
--- a/arch/powerpc/kernel/ppc32.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/powerpc/kernel/ppc32.h
@@ -16,57 +16,6 @@
 
 /* These are here to support 32-bit syscalls on a 64-bit kernel. */
 
-typedef struct compat_siginfo {
-	int si_signo;
-	int si_errno;
-	int si_code;
-
-	union {
-		int _pad[SI_PAD_SIZE32];
-
-		/* kill() */
-		struct {
-			compat_pid_t _pid;		/* sender's pid */
-			compat_uid_t _uid;		/* sender's uid */
-		} _kill;
-
-		/* POSIX.1b timers */
-		struct {
-			compat_timer_t _tid;			/* timer id */
-			int _overrun;			/* overrun count */
-			compat_sigval_t _sigval;		/* same as below */
-			int _sys_private;		/* not to be passed to user */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			compat_pid_t _pid;		/* sender's pid */
-			compat_uid_t _uid;		/* sender's uid */
-			compat_sigval_t _sigval;
-		} _rt;
-
-		/* SIGCHLD */
-		struct {
-			compat_pid_t _pid;		/* which child */
-			compat_uid_t _uid;		/* sender's uid */
-			int _status;			/* exit code */
-			compat_clock_t _utime;
-			compat_clock_t _stime;
-		} _sigchld;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS, SIGEMT */
-		struct {
-			unsigned int _addr; /* faulting insn/memory ref. */
-		} _sigfault;
-
-		/* SIGPOLL */
-		struct {
-			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int _fd;
-		} _sigpoll;
-	} _sifields;
-} compat_siginfo_t;
-
 #define __old_sigaction32	old_sigaction32
 
 struct __old_sigaction32 {
diff -puN arch/s390/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/s390/include/asm/compat.h
--- a/arch/s390/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/s390/include/asm/compat.h
@@ -65,6 +65,7 @@ typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
+typedef u32		compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
@@ -144,6 +145,79 @@ typedef u32		compat_old_sigset_t;	/* at 
 
 typedef u32		compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+typedef struct compat_siginfo {
+	int	si_signo;
+	int	si_errno;
+	int	si_code;
+
+	union {
+		int _pad[128/sizeof(int) - 3];
+
+		/* kill() */
+		struct {
+			pid_t	_pid;	/* sender's pid */
+			uid_t	_uid;	/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;		/* timer id */
+			int _overrun;			/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;	/* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			pid_t			_pid;	/* sender's pid */
+			uid_t			_uid;	/* sender's uid */
+			compat_sigval_t		_sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			pid_t			_pid;	/* which child */
+			uid_t			_uid;	/* sender's uid */
+			int			_status;/* exit code */
+			compat_clock_t		_utime;
+			compat_clock_t		_stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			__u32	_addr;	/* faulting insn/memory ref. - pointer */
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int	_band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int	_fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
+/*
+ * How these fields are to be accessed.
+ */
+#define si_pid		_sifields._kill._pid
+#define si_uid		_sifields._kill._uid
+#define si_status	_sifields._sigchld._status
+#define si_utime	_sifields._sigchld._utime
+#define si_stime	_sifields._sigchld._stime
+#define si_value	_sifields._rt._sigval
+#define si_int		_sifields._rt._sigval.sival_int
+#define si_ptr		_sifields._rt._sigval.sival_ptr
+#define si_addr		_sifields._sigfault._addr
+#define si_band		_sifields._sigpoll._band
+#define si_fd		_sifields._sigpoll._fd
+#define si_tid		_sifields._timer._tid
+#define si_overrun	_sifields._timer._overrun
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -153,7 +227,6 @@ typedef u32		compat_sigset_word;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef	u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff -puN arch/s390/kernel/compat_linux.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/s390/kernel/compat_linux.h
--- a/arch/s390/kernel/compat_linux.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/s390/kernel/compat_linux.h
@@ -23,74 +23,6 @@ struct old_sigaction32 {
        __u32			sa_flags;
        __u32			sa_restorer;	/* Another 32 bit pointer */
 };
- 
-typedef struct compat_siginfo {
-	int	si_signo;
-	int	si_errno;
-	int	si_code;
-
-	union {
-		int _pad[((128/sizeof(int)) - 3)];
-
-		/* kill() */
-		struct {
-			pid_t	_pid;	/* sender's pid */
-			uid_t	_uid;	/* sender's uid */
-		} _kill;
-
-		/* POSIX.1b timers */
-		struct {
-			compat_timer_t _tid;		/* timer id */
-			int _overrun;		/* overrun count */
-			compat_sigval_t _sigval;	/* same as below */
-			int _sys_private;       /* not to be passed to user */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			pid_t			_pid;	/* sender's pid */
-			uid_t			_uid;	/* sender's uid */
-			compat_sigval_t		_sigval;
-		} _rt;
-
-		/* SIGCHLD */
-		struct {
-			pid_t			_pid;	/* which child */
-			uid_t			_uid;	/* sender's uid */
-			int			_status;/* exit code */
-			compat_clock_t		_utime;
-			compat_clock_t		_stime;
-		} _sigchld;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
-		struct {
-			__u32	_addr;	/* faulting insn/memory ref. - pointer */
-		} _sigfault;
-                          
-		/* SIGPOLL */
-		struct {
-			int	_band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int	_fd;
-		} _sigpoll;
-	} _sifields;
-} compat_siginfo_t;
-
-/*
- * How these fields are to be accessed.
- */
-#define si_pid		_sifields._kill._pid
-#define si_uid		_sifields._kill._uid
-#define si_status	_sifields._sigchld._status
-#define si_utime	_sifields._sigchld._utime
-#define si_stime	_sifields._sigchld._stime
-#define si_value	_sifields._rt._sigval
-#define si_int		_sifields._rt._sigval.sival_int
-#define si_ptr		_sifields._rt._sigval.sival_ptr
-#define si_addr		_sifields._sigfault._addr
-#define si_band		_sifields._sigpoll._band
-#define si_fd		_sifields._sigpoll._fd    
-#define si_tid		_sifields._timer._tid
-#define si_overrun	_sifields._timer._overrun
 
 /* asm/sigcontext.h */
 typedef union
diff -puN arch/sparc/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/sparc/include/asm/compat.h
--- a/arch/sparc/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/sparc/include/asm/compat.h
@@ -36,6 +36,7 @@ typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
+typedef u32		compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
@@ -147,6 +148,65 @@ typedef u32		compat_old_sigset_t;
 
 typedef u32		compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+#define SI_PAD_SIZE32	(128/sizeof(int) - 3)
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		int _pad[SI_PAD_SIZE32];
+
+		/* kill() */
+		struct {
+			compat_pid_t _pid;		/* sender's pid */
+			unsigned int _uid;		/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;		/* timer id */
+			int _overrun;			/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;	/* not to be passed to user */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			compat_pid_t _pid;		/* sender's pid */
+			unsigned int _uid;		/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			compat_pid_t _pid;		/* which child */
+			unsigned int _uid;		/* sender's uid */
+			int _status;			/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS, SIGEMT */
+		struct {
+			u32 _addr; /* faulting insn/memory ref. */
+			int _trapno;
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -156,7 +216,6 @@ typedef u32		compat_sigset_word;
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef	u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff -puN arch/sparc/include/asm/siginfo.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/sparc/include/asm/siginfo.h
--- a/arch/sparc/include/asm/siginfo.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/sparc/include/asm/siginfo.h
@@ -3,7 +3,6 @@
 
 #if defined(__sparc__) && defined(__arch64__)
 
-#define SI_PAD_SIZE32	((SI_MAX_SIZE/sizeof(int)) - 3)
 #define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
 #define __ARCH_SI_BAND_T int
 
diff -puN arch/sparc/kernel/signal32.c~compat-move-compat_siginfo_t-definition-to-asm-compath arch/sparc/kernel/signal32.c
--- a/arch/sparc/kernel/signal32.c~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/sparc/kernel/signal32.c
@@ -54,58 +54,6 @@ struct signal_frame32 {
 	/* __siginfo_rwin_t * */u32 rwin_save;
 } __attribute__((aligned(8)));
 
-typedef struct compat_siginfo{
-	int si_signo;
-	int si_errno;
-	int si_code;
-
-	union {
-		int _pad[SI_PAD_SIZE32];
-
-		/* kill() */
-		struct {
-			compat_pid_t _pid;		/* sender's pid */
-			unsigned int _uid;		/* sender's uid */
-		} _kill;
-
-		/* POSIX.1b timers */
-		struct {
-			compat_timer_t _tid;			/* timer id */
-			int _overrun;			/* overrun count */
-			compat_sigval_t _sigval;		/* same as below */
-			int _sys_private;		/* not to be passed to user */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			compat_pid_t _pid;		/* sender's pid */
-			unsigned int _uid;		/* sender's uid */
-			compat_sigval_t _sigval;
-		} _rt;
-
-		/* SIGCHLD */
-		struct {
-			compat_pid_t _pid;		/* which child */
-			unsigned int _uid;		/* sender's uid */
-			int _status;			/* exit code */
-			compat_clock_t _utime;
-			compat_clock_t _stime;
-		} _sigchld;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS, SIGEMT */
-		struct {
-			u32 _addr; /* faulting insn/memory ref. */
-			int _trapno;
-		} _sigfault;
-
-		/* SIGPOLL */
-		struct {
-			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int _fd;
-		} _sigpoll;
-	} _sifields;
-}compat_siginfo_t;
-
 struct rt_signal_frame32 {
 	struct sparc_stackf32	ss;
 	compat_siginfo_t	info;
diff -puN arch/tile/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/tile/include/asm/compat.h
--- a/arch/tile/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/tile/include/asm/compat.h
@@ -110,6 +110,68 @@ struct compat_flock64 {
 
 typedef u32               compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+#define COMPAT_SI_PAD_SIZE	(128/sizeof(int) - 3)
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		int _pad[COMPAT_SI_PAD_SIZE];
+
+		/* kill() */
+		struct {
+			unsigned int _pid;	/* sender's pid */
+			unsigned int _uid;	/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;	/* timer id */
+			int _overrun;		/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;	/* not to be passed to user */
+			int _overrun_incr;	/* amount to add to overrun */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			unsigned int _pid;	/* sender's pid */
+			unsigned int _uid;	/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			unsigned int _pid;	/* which child */
+			unsigned int _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			unsigned int _addr;	/* faulting insn/memory ref. */
+#ifdef __ARCH_SI_TRAPNO
+			int _trapno;	/* TRAP # which caused the signal */
+#endif
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
diff -puN arch/tile/kernel/compat_signal.c~compat-move-compat_siginfo_t-definition-to-asm-compath arch/tile/kernel/compat_signal.c
--- a/arch/tile/kernel/compat_signal.c~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/tile/kernel/compat_signal.c
@@ -55,63 +55,6 @@ struct compat_ucontext {
 	sigset_t	  uc_sigmask;	/* mask last for extensibility */
 };
 
-#define COMPAT_SI_PAD_SIZE	((SI_MAX_SIZE - 3 * sizeof(int)) / sizeof(int))
-
-struct compat_siginfo {
-	int si_signo;
-	int si_errno;
-	int si_code;
-
-	union {
-		int _pad[COMPAT_SI_PAD_SIZE];
-
-		/* kill() */
-		struct {
-			unsigned int _pid;	/* sender's pid */
-			unsigned int _uid;	/* sender's uid */
-		} _kill;
-
-		/* POSIX.1b timers */
-		struct {
-			compat_timer_t _tid;	/* timer id */
-			int _overrun;		/* overrun count */
-			compat_sigval_t _sigval;	/* same as below */
-			int _sys_private;	/* not to be passed to user */
-			int _overrun_incr;	/* amount to add to overrun */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			unsigned int _pid;	/* sender's pid */
-			unsigned int _uid;	/* sender's uid */
-			compat_sigval_t _sigval;
-		} _rt;
-
-		/* SIGCHLD */
-		struct {
-			unsigned int _pid;	/* which child */
-			unsigned int _uid;	/* sender's uid */
-			int _status;		/* exit code */
-			compat_clock_t _utime;
-			compat_clock_t _stime;
-		} _sigchld;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
-		struct {
-			unsigned int _addr;	/* faulting insn/memory ref. */
-#ifdef __ARCH_SI_TRAPNO
-			int _trapno;	/* TRAP # which caused the signal */
-#endif
-		} _sigfault;
-
-		/* SIGPOLL */
-		struct {
-			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int _fd;
-		} _sigpoll;
-	} _sifields;
-};
-
 struct compat_rt_sigframe {
 	unsigned char save_area[C_ABI_SAVE_AREA_SIZE]; /* caller save area */
 	struct compat_siginfo info;
diff -puN arch/x86/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/x86/include/asm/compat.h
--- a/arch/x86/include/asm/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/x86/include/asm/compat.h
@@ -41,6 +41,7 @@ typedef s64 __attribute__((aligned(4))) 
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
 typedef u64 __attribute__((aligned(4))) compat_u64;
+typedef u32		compat_uptr_t;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
@@ -124,6 +125,78 @@ typedef u32		compat_old_sigset_t;	/* at 
 
 typedef u32               compat_sigset_word;
 
+typedef union compat_sigval {
+	compat_int_t	sival_int;
+	compat_uptr_t	sival_ptr;
+} compat_sigval_t;
+
+typedef struct compat_siginfo {
+	int si_signo;
+	int si_errno;
+	int si_code;
+
+	union {
+		int _pad[128/sizeof(int) - 3];
+
+		/* kill() */
+		struct {
+			unsigned int _pid;	/* sender's pid */
+			unsigned int _uid;	/* sender's uid */
+		} _kill;
+
+		/* POSIX.1b timers */
+		struct {
+			compat_timer_t _tid;	/* timer id */
+			int _overrun;		/* overrun count */
+			compat_sigval_t _sigval;	/* same as below */
+			int _sys_private;	/* not to be passed to user */
+			int _overrun_incr;	/* amount to add to overrun */
+		} _timer;
+
+		/* POSIX.1b signals */
+		struct {
+			unsigned int _pid;	/* sender's pid */
+			unsigned int _uid;	/* sender's uid */
+			compat_sigval_t _sigval;
+		} _rt;
+
+		/* SIGCHLD */
+		struct {
+			unsigned int _pid;	/* which child */
+			unsigned int _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_clock_t _utime;
+			compat_clock_t _stime;
+		} _sigchld;
+
+		/* SIGCHLD (x32 version) */
+		struct {
+			unsigned int _pid;	/* which child */
+			unsigned int _uid;	/* sender's uid */
+			int _status;		/* exit code */
+			compat_s64 _utime;
+			compat_s64 _stime;
+		} _sigchld_x32;
+
+		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+		struct {
+			unsigned int _addr;	/* faulting insn/memory ref. */
+		} _sigfault;
+
+		/* SIGPOLL */
+		struct {
+			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			int _fd;
+		} _sigpoll;
+
+		struct {
+			unsigned int _call_addr; /* calling insn */
+			int _syscall;	/* triggering system call number */
+			unsigned int _arch;	/* AUDIT_ARCH_* of syscall */
+		} _sigsys;
+	} _sifields;
+} compat_siginfo_t;
+
 #define COMPAT_OFF_T_MAX	0x7fffffff
 #define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
 
@@ -209,7 +282,6 @@ typedef struct user_regs_struct32 compat
  * as pointers because the syscall entry code will have
  * appropriately converted them already.
  */
-typedef	u32		compat_uptr_t;
 
 static inline void __user *compat_ptr(compat_uptr_t uptr)
 {
diff -puN arch/x86/include/asm/ia32.h~compat-move-compat_siginfo_t-definition-to-asm-compath arch/x86/include/asm/ia32.h
--- a/arch/x86/include/asm/ia32.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/arch/x86/include/asm/ia32.h
@@ -86,73 +86,6 @@ struct stat64 {
 	unsigned long long	st_ino;
 } __attribute__((packed));
 
-typedef struct compat_siginfo {
-	int si_signo;
-	int si_errno;
-	int si_code;
-
-	union {
-		int _pad[((128 / sizeof(int)) - 3)];
-
-		/* kill() */
-		struct {
-			unsigned int _pid;	/* sender's pid */
-			unsigned int _uid;	/* sender's uid */
-		} _kill;
-
-		/* POSIX.1b timers */
-		struct {
-			compat_timer_t _tid;	/* timer id */
-			int _overrun;		/* overrun count */
-			compat_sigval_t _sigval;	/* same as below */
-			int _sys_private;	/* not to be passed to user */
-			int _overrun_incr;	/* amount to add to overrun */
-		} _timer;
-
-		/* POSIX.1b signals */
-		struct {
-			unsigned int _pid;	/* sender's pid */
-			unsigned int _uid;	/* sender's uid */
-			compat_sigval_t _sigval;
-		} _rt;
-
-		/* SIGCHLD */
-		struct {
-			unsigned int _pid;	/* which child */
-			unsigned int _uid;	/* sender's uid */
-			int _status;		/* exit code */
-			compat_clock_t _utime;
-			compat_clock_t _stime;
-		} _sigchld;
-
-		/* SIGCHLD (x32 version) */
-		struct {
-			unsigned int _pid;	/* which child */
-			unsigned int _uid;	/* sender's uid */
-			int _status;		/* exit code */
-			compat_s64 _utime;
-			compat_s64 _stime;
-		} _sigchld_x32;
-
-		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
-		struct {
-			unsigned int _addr;	/* faulting insn/memory ref. */
-		} _sigfault;
-
-		/* SIGPOLL */
-		struct {
-			int _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
-			int _fd;
-		} _sigpoll;
-
-		struct {
-			unsigned int _call_addr; /* calling insn */
-			int _syscall;	/* triggering system call number */
-			unsigned int _arch;	/* AUDIT_ARCH_* of syscall */
-		} _sigsys;
-	} _sifields;
-} compat_siginfo_t;
-
 #define IA32_STACK_TOP IA32_PAGE_OFFSET
 
 #ifdef __KERNEL__
diff -puN include/linux/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath include/linux/compat.h
--- a/include/linux/compat.h~compat-move-compat_siginfo_t-definition-to-asm-compath
+++ a/include/linux/compat.h
@@ -160,11 +160,6 @@ struct compat_ustat {
 	char			f_fpack[6];
 };
 
-typedef union compat_sigval {
-	compat_int_t	sival_int;
-	compat_uptr_t	sival_ptr;
-} compat_sigval_t;

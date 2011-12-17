From: akpm@linux-foundation.org
Subject: + ipc-provide-generic-compat-versions-of-ipc-syscalls.patch added to -mm tree
Date: Fri, 16 Dec 2011 16:32:01 -0800
Message-ID: <20111217003207.D1FC35C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63721 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab1LQAcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 19:32:12 -0500
Received: by eekc1 with SMTP id c1so111749eek.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 16:32:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmetcalf@tilera.com, arnd@arndb.de, benh@kernel.crashing.org, bfields@redhat.com, davem@davemloft.net, dmitry.torokhov@gmail.com, ebiederm@xmission.com, hch@lst.de, heiko.carstens@de.ibm.com, hpa@zytor.com, lucas.demarchi@profusion.mobi, mingo@redhat.com, neilb@suse.de, paulus@samba.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de


The patch titled
     Subject: ipc: provide generic compat versions of IPC syscalls
has been added to the -mm tree.  Its filename is
     ipc-provide-generic-compat-versions-of-ipc-syscalls.patch

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
From: Chris Metcalf <cmetcalf@tilera.com>
Subject: ipc: provide generic compat versions of IPC syscalls

When using the "compat" APIs, architectures will generally want to be able
to make direct syscalls to msgsnd(), shmctl(), etc., and in the kernel we
would want them to be handled directly by compat_sys_xxx() functions, as
is true for other compat syscalls.

However, for historical reasons, several of the existing compat IPC
syscalls do not do this.  semctl() expects a pointer to the fourth
argument, instead of the fourth argument itself.  msgsnd(), msgrcv() and
shmat() expect arguments in different order.

This change adds an ARCH_WANT_OLD_COMPAT_IPC config option that can be set
to preserve this behavior for ports that use it (x86, sparc, powerpc,
s390, and mips).  No actual semantics are changed for those architectures,
and there is only a minimal amount of code refactoring in ipc/compat.c.

Newer architectures like tile (and perhaps future architectures such as
arm64 and unicore64) should not select this option, and thus can avoid
having any IPC-specific code at all in their architecture-specific compat
layer.  In the same vein, if this option is not selected, IPC_64 mode is
assumed, since that's what the <asm-generic> headers expect.

The workaround code in "tile" for msgsnd() and msgrcv() is removed with
this change; it also fixes the bug that shmat() and semctl() were not
being properly handled.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "J. Bruce Fields" <bfields@redhat.com>
Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                   |    3 +
 arch/mips/Kconfig              |    1 
 arch/powerpc/Kconfig           |    1 
 arch/s390/Kconfig              |    1 
 arch/sparc/Kconfig             |    1 
 arch/tile/include/asm/compat.h |   11 ----
 arch/tile/kernel/compat.c      |   43 -------------------
 arch/x86/Kconfig               |    1 
 include/linux/compat.h         |   12 ++++-
 ipc/compat.c                   |   70 ++++++++++++++++++++++++++++---
 10 files changed, 83 insertions(+), 61 deletions(-)

diff -puN arch/Kconfig~ipc-provide-generic-compat-versions-of-ipc-syscalls arch/Kconfig
--- a/arch/Kconfig~ipc-provide-generic-compat-versions-of-ipc-syscalls
+++ a/arch/Kconfig
@@ -202,4 +202,7 @@ config HAVE_CMPXCHG_LOCAL
 config HAVE_CMPXCHG_DOUBLE
 	bool
 
+config ARCH_WANT_OLD_COMPAT_IPC
+	bool
+
 source "kernel/gcov/Kconfig"
diff -puN arch/mips/Kconfig~ipc-provide-generic-compat-versions-of-ipc-syscalls arch/mips/Kconfig
--- a/arch/mips/Kconfig~ipc-provide-generic-compat-versions-of-ipc-syscalls
+++ a/arch/mips/Kconfig
@@ -2455,6 +2455,7 @@ config MIPS32_COMPAT
 config COMPAT
 	bool
 	depends on MIPS32_COMPAT
+	select ARCH_WANT_OLD_COMPAT_IPC
 	default y
 
 config SYSVIPC_COMPAT
diff -puN arch/powerpc/Kconfig~ipc-provide-generic-compat-versions-of-ipc-syscalls arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~ipc-provide-generic-compat-versions-of-ipc-syscalls
+++ a/arch/powerpc/Kconfig
@@ -148,6 +148,7 @@ config COMPAT
 	bool
 	default y if PPC64
 	select COMPAT_BINFMT_ELF
+	select ARCH_WANT_OLD_COMPAT_IPC
 
 config SYSVIPC_COMPAT
 	bool
diff -puN arch/s390/Kconfig~ipc-provide-generic-compat-versions-of-ipc-syscalls arch/s390/Kconfig
--- a/arch/s390/Kconfig~ipc-provide-generic-compat-versions-of-ipc-syscalls
+++ a/arch/s390/Kconfig
@@ -219,6 +219,7 @@ config COMPAT
 	prompt "Kernel support for 31 bit emulation"
 	depends on 64BIT
 	select COMPAT_BINFMT_ELF
+	select ARCH_WANT_OLD_COMPAT_IPC
 	help
 	  Select this option if you want to enable your system kernel to
 	  handle system-calls from ELF binaries for 31 bit ESA.  This option
diff -puN arch/sparc/Kconfig~ipc-provide-generic-compat-versions-of-ipc-syscalls arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~ipc-provide-generic-compat-versions-of-ipc-syscalls
+++ a/arch/sparc/Kconfig
@@ -576,6 +576,7 @@ config COMPAT
 	depends on SPARC64
 	default y
 	select COMPAT_BINFMT_ELF
+	select ARCH_WANT_OLD_COMPAT_IPC
 
 config SYSVIPC_COMPAT
 	bool
diff -puN arch/tile/include/asm/compat.h~ipc-provide-generic-compat-versions-of-ipc-syscalls arch/tile/include/asm/compat.h
--- a/arch/tile/include/asm/compat.h~ipc-provide-generic-compat-versions-of-ipc-syscalls
+++ a/arch/tile/include/asm/compat.h
@@ -242,17 +242,6 @@ long compat_sys_fallocate(int fd, int mo
 long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 				      struct compat_timespec __user *interval);
 
-/* Versions of compat functions that differ from generic Linux. */
-struct compat_msgbuf;
-long tile_compat_sys_msgsnd(int msqid,
-			    struct compat_msgbuf __user *msgp,
-			    size_t msgsz, int msgflg);
-long tile_compat_sys_msgrcv(int msqid,
-			    struct compat_msgbuf __user *msgp,
-			    size_t msgsz, long msgtyp, int msgflg);
-long tile_compat_sys_ptrace(compat_long_t request, compat_long_t pid,
-			    compat_long_t addr, compat_long_t data);
-
 /* Tilera Linux syscalls that don't have "compat" versions. */
 #define compat_sys_flush_cache sys_flush_cache
 
diff -puN arch/tile/kernel/compat.c~ipc-provide-generic-compat-versions-of-ipc-syscalls arch/tile/kernel/compat.c
--- a/arch/tile/kernel/compat.c~ipc-provide-generic-compat-versions-of-ipc-syscalls
+++ a/arch/tile/kernel/compat.c
@@ -16,7 +16,6 @@
 #define __SYSCALL_COMPAT
 
 #include <linux/compat.h>
-#include <linux/msg.h>
 #include <linux/syscalls.h>
 #include <linux/kdev_t.h>
 #include <linux/fs.h>
@@ -95,52 +94,10 @@ long compat_sys_sched_rr_get_interval(co
 	return ret;
 }
 
-/*
- * The usual compat_sys_msgsnd() and _msgrcv() seem to be assuming
- * some different calling convention than our normal 32-bit tile code.
- */
-
-/* Already defined in ipc/compat.c, but we need it here. */
-struct compat_msgbuf {
-	compat_long_t mtype;
-	char mtext[1];
-};
-
-long tile_compat_sys_msgsnd(int msqid,
-			    struct compat_msgbuf __user *msgp,
-			    size_t msgsz, int msgflg)
-{
-	compat_long_t mtype;
-
-	if (get_user(mtype, &msgp->mtype))
-		return -EFAULT;
-	return do_msgsnd(msqid, mtype, msgp->mtext, msgsz, msgflg);
-}
-
-long tile_compat_sys_msgrcv(int msqid,
-			    struct compat_msgbuf __user *msgp,
-			    size_t msgsz, long msgtyp, int msgflg)
-{
-	long err, mtype;
-
-	err =  do_msgrcv(msqid, &mtype, msgp->mtext, msgsz, msgtyp, msgflg);
-	if (err < 0)
-		goto out;
-
-	if (put_user(mtype, &msgp->mtype))
-		err = -EFAULT;
- out:
-	return err;
-}
-
 /* Provide the compat syscall number to call mapping. */
 #undef __SYSCALL
 #define __SYSCALL(nr, call) [nr] = (call),
 
-/* The generic versions of these don't work for Tile. */
-#define compat_sys_msgrcv tile_compat_sys_msgrcv
-#define compat_sys_msgsnd tile_compat_sys_msgsnd
-
 /* See comments in sys.c */
 #define compat_sys_fadvise64_64 sys32_fadvise64_64
 #define compat_sys_readahead sys32_readahead
diff -puN arch/x86/Kconfig~ipc-provide-generic-compat-versions-of-ipc-syscalls arch/x86/Kconfig
--- a/arch/x86/Kconfig~ipc-provide-generic-compat-versions-of-ipc-syscalls
+++ a/arch/x86/Kconfig
@@ -2207,6 +2207,7 @@ config IA32_AOUT
 config COMPAT
 	def_bool y
 	depends on IA32_EMULATION
+	select ARCH_WANT_OLD_COMPAT_IPC
 
 config COMPAT_FOR_U64_ALIGNMENT
 	def_bool COMPAT
diff -puN include/linux/compat.h~ipc-provide-generic-compat-versions-of-ipc-syscalls include/linux/compat.h
--- a/include/linux/compat.h~ipc-provide-generic-compat-versions-of-ipc-syscalls
+++ a/include/linux/compat.h
@@ -224,6 +224,7 @@ struct compat_sysinfo;
 struct compat_sysctl_args;
 struct compat_kexec_segment;
 struct compat_mq_attr;
+struct compat_msgbuf;
 
 extern void compat_exit_robust_list(struct task_struct *curr);
 
@@ -234,13 +235,22 @@ asmlinkage long
 compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 			   compat_size_t __user *len_ptr);
 
+#ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
 long compat_sys_semctl(int first, int second, int third, void __user *uptr);
 long compat_sys_msgsnd(int first, int second, int third, void __user *uptr);
 long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 		int version, void __user *uptr);
-long compat_sys_msgctl(int first, int second, void __user *uptr);
 long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
 		void __user *uptr);
+#else
+long compat_sys_semctl(int semid, int semnum, int cmd, int arg);
+long compat_sys_msgsnd(int msqid, struct compat_msgbuf __user *msgp,
+		size_t msgsz, int msgflg);
+long compat_sys_msgrcv(int msqid, struct compat_msgbuf __user *msgp,
+		size_t msgsz, long msgtyp, int msgflg);
+long compat_sys_shmat(int shmid, compat_uptr_t shmaddr, int shmflg);
+#endif
+long compat_sys_msgctl(int first, int second, void __user *uptr);
 long compat_sys_shmctl(int first, int second, void __user *uptr);
 long compat_sys_semtimedop(int semid, struct sembuf __user *tsems,
 		unsigned nsems, const struct compat_timespec __user *timeout);
diff -puN ipc/compat.c~ipc-provide-generic-compat-versions-of-ipc-syscalls ipc/compat.c
--- a/ipc/compat.c~ipc-provide-generic-compat-versions-of-ipc-syscalls
+++ a/ipc/compat.c
@@ -27,6 +27,7 @@
 #include <linux/msg.h>
 #include <linux/shm.h>
 #include <linux/syscalls.h>
+#include <linux/ptrace.h>
 
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
@@ -117,6 +118,7 @@ extern int sem_ctls[];
 
 static inline int compat_ipc_parse_version(int *cmd)
 {
+#ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
 	int version = *cmd & IPC_64;
 
 	/* this is tricky: architectures that have support for the old
@@ -128,6 +130,10 @@ static inline int compat_ipc_parse_versi
 	*cmd &= ~IPC_64;
 #endif
 	return version;
+#else
+	/* With the asm-generic APIs, we always use the 64-bit versions. */
+	return IPC_64;
+#endif
 }
 
 static inline int __get_compat_ipc64_perm(struct ipc64_perm *p64,
@@ -232,10 +238,9 @@ static inline int put_compat_semid_ds(st
 	return err;
 }
 
-long compat_sys_semctl(int first, int second, int third, void __user *uptr)
+static long do_compat_semctl(int first, int second, int third, u32 pad)
 {
 	union semun fourth;
-	u32 pad;
 	int err, err2;
 	struct semid64_ds s64;
 	struct semid64_ds __user *up64;
@@ -243,10 +248,6 @@ long compat_sys_semctl(int first, int se
 
 	memset(&s64, 0, sizeof(s64));
 
-	if (!uptr)
-		return -EINVAL;
-	if (get_user(pad, (u32 __user *) uptr))
-		return -EFAULT;
 	if ((third & (~IPC_64)) == SETVAL)
 		fourth.val = (int) pad;
 	else
@@ -305,6 +306,18 @@ long compat_sys_semctl(int first, int se
 	return err;
 }
 
+#ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
+long compat_sys_semctl(int first, int second, int third, void __user *uptr)
+{
+	u32 pad;
+
+	if (!uptr)
+		return -EINVAL;
+	if (get_user(pad, (u32 __user *) uptr))
+		return -EFAULT;
+	return do_compat_semctl(first, second, third, pad);
+}
+
 long compat_sys_msgsnd(int first, int second, int third, void __user *uptr)
 {
 	struct compat_msgbuf __user *up = uptr;
@@ -353,6 +366,37 @@ long compat_sys_msgrcv(int first, int se
 out:
 	return err;
 }
+#else
+long compat_sys_semctl(int semid, int semnum, int cmd, int arg)
+{
+	return do_compat_semctl(semid, semnum, cmd, arg);
+}
+
+long compat_sys_msgsnd(int msqid, struct compat_msgbuf __user *msgp,
+		       size_t msgsz, int msgflg)
+{
+	compat_long_t mtype;
+
+	if (get_user(mtype, &msgp->mtype))
+		return -EFAULT;
+	return do_msgsnd(msqid, mtype, msgp->mtext, msgsz, msgflg);
+}
+
+long compat_sys_msgrcv(int msqid, struct compat_msgbuf __user *msgp,
+		       size_t msgsz, long msgtyp, int msgflg)
+{
+	long err, mtype;
+
+	err =  do_msgrcv(msqid, &mtype, msgp->mtext, msgsz, msgtyp, msgflg);
+	if (err < 0)
+		goto out;
+
+	if (put_user(mtype, &msgp->mtype))
+		err = -EFAULT;
+ out:
+	return err;
+}
+#endif
 
 static inline int get_compat_msqid64(struct msqid64_ds *m64,
 				     struct compat_msqid64_ds __user *up64)
@@ -470,6 +514,7 @@ long compat_sys_msgctl(int first, int se
 	return err;
 }
 
+#ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
 long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
 			void __user *uptr)
 {
@@ -485,6 +530,19 @@ long compat_sys_shmat(int first, int sec
 	uaddr = compat_ptr(third);
 	return put_user(raddr, uaddr);
 }
+#else
+long compat_sys_shmat(int shmid, compat_uptr_t shmaddr, int shmflg)
+{
+	unsigned long ret;
+	long err;
+
+	err = do_shmat(shmid, compat_ptr(shmaddr), shmflg, &ret);
+	if (err)
+		return err;
+	force_successful_syscall_return();
+	return (long)ret;
+}
+#endif
 
 static inline int get_compat_shmid64_ds(struct shmid64_ds *s64,
 					struct compat_shmid64_ds __user *up64)
_
Subject: Subject: ipc: provide generic compat versions of IPC syscalls

Patches currently in -mm which might be from cmetcalf@tilera.com are

linux-next.patch
consolidate-config_debug_strict_user_copy_checks.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch


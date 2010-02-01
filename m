From: akpm@linux-foundation.org
Subject: + improve-sys_personality-for-compat-architectures.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:58:24 -0800
Message-ID: <201002012258.o11MwONp017906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063Ab0BAW76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:59:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, arnd@arndb.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, hpa@zytor.com, jdike@addtoit.com, jmorris@namei.org, lethal@linux-sh.org, mingo@elte.hu, ralf@linux-mips.org, schwab@linux-m68k.org, schwidefsky@de.ibm.com, takata@linux-m32r.org, tglx@linutronix.de, tony.luck@intel.com, viro@zeniv.linux.org.uk


The patch titled
     improve sys_personality() for compat architectures
has been added to the -mm tree.  Its filename is
     improve-sys_personality-for-compat-architectures.patch

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
Subject: improve sys_personality() for compat architectures
From: Christoph Hellwig <hch@lst.de>

On an architecture that supports 32-bit compat we need to claim to be
PER_LINUX even if we're actually PER_LINUX32.  Instead of duplicating the
code for that in all architectures and having various bugs in the handling
of personality flags do it once and right in the common code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/ia32_entry.S         |    2 +-
 arch/ia64/ia32/sys_ia32.c           |   13 -------------
 arch/mips/kernel/linux32.c          |   13 -------------
 arch/mips/kernel/scall64-n32.S      |    2 +-
 arch/mips/kernel/scall64-o32.S      |    2 +-
 arch/parisc/kernel/sys_parisc.c     |   15 ---------------
 arch/parisc/kernel/syscall_table.S  |    2 +-
 arch/powerpc/include/asm/syscalls.h |    1 -
 arch/powerpc/include/asm/systbl.h   |    2 +-
 arch/powerpc/kernel/syscalls.c      |   15 ---------------
 arch/s390/kernel/compat_wrapper.S   |    2 +-
 arch/s390/kernel/entry.h            |    1 -
 arch/s390/kernel/sys_s390.c         |   13 -------------
 arch/s390/kernel/syscalls.S         |    2 +-
 arch/sparc/kernel/sys_sparc_64.c    |   14 --------------
 arch/sparc/kernel/systbls.h         |    1 -
 arch/sparc/kernel/systbls_64.S      |    4 ++--
 arch/x86/ia32/sys_ia32.c            |   14 --------------
 arch/x86/include/asm/sys_ia32.h     |    1 -
 kernel/exec_domain.c                |   11 ++++++++++-
 20 files changed, 19 insertions(+), 111 deletions(-)

diff -puN arch/ia64/ia32/ia32_entry.S~improve-sys_personality-for-compat-architectures arch/ia64/ia32/ia32_entry.S
--- a/arch/ia64/ia32/ia32_entry.S~improve-sys_personality-for-compat-architectures
+++ a/arch/ia64/ia32/ia32_entry.S
@@ -314,7 +314,7 @@ ia32_syscall_table:
 	data8 sys_fchdir
 	data8 sys_ni_syscall	/* sys_bdflush */
 	data8 sys_sysfs		/* 135 */
-	data8 sys32_personality
+	data8 sys_personality
 	data8 sys_ni_syscall	  /* for afs_syscall */
 	data8 sys_setfsuid	/* 16-bit version */
 	data8 sys_setfsgid	/* 16-bit version */
diff -puN arch/ia64/ia32/sys_ia32.c~improve-sys_personality-for-compat-architectures arch/ia64/ia32/sys_ia32.c
--- a/arch/ia64/ia32/sys_ia32.c~improve-sys_personality-for-compat-architectures
+++ a/arch/ia64/ia32/sys_ia32.c
@@ -1867,19 +1867,6 @@ sys32_sendfile (int out_fd, int in_fd, i
 	return ret;
 }
 
-asmlinkage long
-sys32_personality (unsigned int personality)
-{
-	long ret;
-
-	if (current->personality == PER_LINUX32 && personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-	return ret;
-}
-
 asmlinkage unsigned long
 sys32_brk (unsigned int brk)
 {
diff -puN arch/mips/kernel/linux32.c~improve-sys_personality-for-compat-architectures arch/mips/kernel/linux32.c
--- a/arch/mips/kernel/linux32.c~improve-sys_personality-for-compat-architectures
+++ a/arch/mips/kernel/linux32.c
@@ -265,19 +265,6 @@ SYSCALL_DEFINE1(32_newuname, struct new_
 	return ret;
 }
 
-SYSCALL_DEFINE1(32_personality, unsigned long, personality)
-{
-	int ret;
-	personality &= 0xffffffff;
-	if (personality(current->personality) == PER_LINUX32 &&
-	    personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-	return ret;
-}
-
 SYSCALL_DEFINE4(32_sendfile, long, out_fd, long, in_fd,
 	compat_off_t __user *, offset, s32, count)
 {
diff -puN arch/mips/kernel/scall64-n32.S~improve-sys_personality-for-compat-architectures arch/mips/kernel/scall64-n32.S
--- a/arch/mips/kernel/scall64-n32.S~improve-sys_personality-for-compat-architectures
+++ a/arch/mips/kernel/scall64-n32.S
@@ -252,7 +252,7 @@ EXPORT(sysn32_call_table)
 	PTR	sys32_sigaltstack
 	PTR	compat_sys_utime		/* 6130 */
 	PTR	sys_mknod
-	PTR	sys_32_personality
+	PTR	sys_personality
 	PTR	compat_sys_ustat
 	PTR	compat_sys_statfs
 	PTR	compat_sys_fstatfs		/* 6135 */
diff -puN arch/mips/kernel/scall64-o32.S~improve-sys_personality-for-compat-architectures arch/mips/kernel/scall64-o32.S
--- a/arch/mips/kernel/scall64-o32.S~improve-sys_personality-for-compat-architectures
+++ a/arch/mips/kernel/scall64-o32.S
@@ -339,7 +339,7 @@ sys_call_table:
 	PTR	sys_fchdir
 	PTR	sys_bdflush
 	PTR	sys_sysfs			/* 4135 */
-	PTR	sys_32_personality
+	PTR	sys_personality
 	PTR	sys_ni_syscall	 		/* for afs_syscall */
 	PTR	sys_setfsuid
 	PTR	sys_setfsgid
diff -puN arch/parisc/kernel/sys_parisc.c~improve-sys_personality-for-compat-architectures arch/parisc/kernel/sys_parisc.c
--- a/arch/parisc/kernel/sys_parisc.c~improve-sys_personality-for-compat-architectures
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -220,21 +220,6 @@ asmlinkage int sys_free_hugepages(unsign
 	return -EINVAL;
 }
 
-long parisc_personality(unsigned long personality)
-{
-	long err;
-
-	if (personality(current->personality) == PER_LINUX32
-	    && personality == PER_LINUX)
-		personality = PER_LINUX32;
-
-	err = sys_personality(personality);
-	if (err == PER_LINUX32)
-		err = PER_LINUX;
-
-	return err;
-}
-
 long parisc_newuname(struct new_utsname __user *name)
 {
 	int err = sys_newuname(name);
diff -puN arch/parisc/kernel/syscall_table.S~improve-sys_personality-for-compat-architectures arch/parisc/kernel/syscall_table.S
--- a/arch/parisc/kernel/syscall_table.S~improve-sys_personality-for-compat-architectures
+++ a/arch/parisc/kernel/syscall_table.S
@@ -216,7 +216,7 @@
 	ENTRY_SAME(fchdir)
 	ENTRY_SAME(bdflush)
 	ENTRY_SAME(sysfs)		/* 135 */
-	ENTRY_OURS(personality)
+	ENTRY_SAME(personality)
 	ENTRY_SAME(ni_syscall)	/* for afs_syscall */
 	ENTRY_SAME(setfsuid)
 	ENTRY_SAME(setfsgid)
diff -puN arch/powerpc/include/asm/syscalls.h~improve-sys_personality-for-compat-architectures arch/powerpc/include/asm/syscalls.h
--- a/arch/powerpc/include/asm/syscalls.h~improve-sys_personality-for-compat-architectures
+++ a/arch/powerpc/include/asm/syscalls.h
@@ -35,7 +35,6 @@ asmlinkage long sys_pipe2(int __user *fi
 asmlinkage long sys_rt_sigaction(int sig,
 		const struct sigaction __user *act,
 		struct sigaction __user *oact, size_t sigsetsize);
-asmlinkage long ppc64_personality(unsigned long personality);
 asmlinkage int ppc_rtas(struct rtas_args __user *uargs);
 asmlinkage time_t sys64_time(time_t __user * tloc);
 asmlinkage long ppc_newuname(struct new_utsname __user * name);
diff -puN arch/powerpc/include/asm/systbl.h~improve-sys_personality-for-compat-architectures arch/powerpc/include/asm/systbl.h
--- a/arch/powerpc/include/asm/systbl.h~improve-sys_personality-for-compat-architectures
+++ a/arch/powerpc/include/asm/systbl.h
@@ -139,7 +139,7 @@ COMPAT_SYS_SPU(getpgid)
 SYSCALL_SPU(fchdir)
 SYSCALL_SPU(bdflush)
 COMPAT_SYS(sysfs)
-SYSX_SPU(ppc64_personality,ppc64_personality,sys_personality)
+SYSCALL_SPU(personality)
 SYSCALL(ni_syscall)
 SYSCALL_SPU(setfsuid)
 SYSCALL_SPU(setfsgid)
diff -puN arch/powerpc/kernel/syscalls.c~improve-sys_personality-for-compat-architectures arch/powerpc/kernel/syscalls.c
--- a/arch/powerpc/kernel/syscalls.c~improve-sys_personality-for-compat-architectures
+++ a/arch/powerpc/kernel/syscalls.c
@@ -102,21 +102,6 @@ ppc_select(int n, fd_set __user *inp, fd
 #endif
 
 #ifdef CONFIG_PPC64
-long ppc64_personality(unsigned long personality)
-{
-	long ret;
-
-	if (personality(current->personality) == PER_LINUX32
-	    && personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-	return ret;
-}
-#endif
-
-#ifdef CONFIG_PPC64
 #define OVERRIDE_MACHINE    (personality(current->personality) == PER_LINUX32)
 #else
 #define OVERRIDE_MACHINE    0
diff -puN arch/s390/kernel/compat_wrapper.S~improve-sys_personality-for-compat-architectures arch/s390/kernel/compat_wrapper.S
--- a/arch/s390/kernel/compat_wrapper.S~improve-sys_personality-for-compat-architectures
+++ a/arch/s390/kernel/compat_wrapper.S
@@ -615,7 +615,7 @@ sys32_sysfs_wrapper:
 	.globl	sys32_personality_wrapper
 sys32_personality_wrapper:
 	llgfr	%r2,%r2			# unsigned long
-	jg	sys_s390_personality	# branch to system call
+	jg	sys_personality		# branch to system call
 
 	.globl	sys32_setfsuid16_wrapper
 sys32_setfsuid16_wrapper:
diff -puN arch/s390/kernel/entry.h~improve-sys_personality-for-compat-architectures arch/s390/kernel/entry.h
--- a/arch/s390/kernel/entry.h~improve-sys_personality-for-compat-architectures
+++ a/arch/s390/kernel/entry.h
@@ -33,7 +33,6 @@ long sys_mmap2(struct s390_mmap_arg_stru
 long sys_s390_ipc(uint call, int first, unsigned long second,
 	     unsigned long third, void __user *ptr);
 long sys_s390_newuname(struct new_utsname __user *name);
-long sys_s390_personality(unsigned long personality);
 long sys_s390_fadvise64(int fd, u32 offset_high, u32 offset_low,
 		    size_t len, int advice);
 long sys_s390_fadvise64_64(struct fadvise64_64_args __user *args);
diff -puN arch/s390/kernel/sys_s390.c~improve-sys_personality-for-compat-architectures arch/s390/kernel/sys_s390.c
--- a/arch/s390/kernel/sys_s390.c~improve-sys_personality-for-compat-architectures
+++ a/arch/s390/kernel/sys_s390.c
@@ -141,19 +141,6 @@ SYSCALL_DEFINE1(s390_newuname, struct ne
 	}
 	return ret;
 }
-
-SYSCALL_DEFINE1(s390_personality, unsigned long, personality)
-{
-	int ret;
-
-	if (current->personality == PER_LINUX32 && personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-
-	return ret;
-}
 #endif /* CONFIG_64BIT */
 
 /*
diff -puN arch/s390/kernel/syscalls.S~improve-sys_personality-for-compat-architectures arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~improve-sys_personality-for-compat-architectures
+++ a/arch/s390/kernel/syscalls.S
@@ -144,7 +144,7 @@ SYSCALL(sys_getpgid,sys_getpgid,sys32_ge
 SYSCALL(sys_fchdir,sys_fchdir,sys32_fchdir_wrapper)
 SYSCALL(sys_bdflush,sys_bdflush,sys32_bdflush_wrapper)
 SYSCALL(sys_sysfs,sys_sysfs,sys32_sysfs_wrapper)		/* 135 */
-SYSCALL(sys_personality,sys_s390_personality,sys32_personality_wrapper)
+SYSCALL(sys_personality,sys_personality,sys32_personality_wrapper)
 NI_SYSCALL							/* for afs_syscall */
 SYSCALL(sys_setfsuid16,sys_ni_syscall,sys32_setfsuid16_wrapper)	/* old setfsuid16 syscall */
 SYSCALL(sys_setfsgid16,sys_ni_syscall,sys32_setfsgid16_wrapper)	/* old setfsgid16 syscall */
diff -puN arch/sparc/kernel/sys_sparc_64.c~improve-sys_personality-for-compat-architectures arch/sparc/kernel/sys_sparc_64.c
--- a/arch/sparc/kernel/sys_sparc_64.c~improve-sys_personality-for-compat-architectures
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -522,20 +522,6 @@ SYSCALL_DEFINE1(sparc64_newuname, struct
 	return ret;
 }
 
-SYSCALL_DEFINE1(sparc64_personality, unsigned long, personality)
-{
-	int ret;
-
-	if (current->personality == PER_LINUX32 &&
-	    personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-
-	return ret;
-}
-
 int sparc_mmap_check(unsigned long addr, unsigned long len)
 {
 	if (test_thread_flag(TIF_32BIT)) {
diff -puN arch/sparc/kernel/systbls.h~improve-sys_personality-for-compat-architectures arch/sparc/kernel/systbls.h
--- a/arch/sparc/kernel/systbls.h~improve-sys_personality-for-compat-architectures
+++ a/arch/sparc/kernel/systbls.h
@@ -15,7 +15,6 @@ extern asmlinkage long sys_sparc_ipc(uns
 			       unsigned long third,
 			       void __user *ptr, long fifth);
 extern asmlinkage long sparc64_newuname(struct new_utsname __user *name);
-extern asmlinkage long sparc64_personality(unsigned long personality);
 extern asmlinkage long sys64_munmap(unsigned long addr, size_t len);
 extern asmlinkage unsigned long sys64_mremap(unsigned long addr,
 					     unsigned long old_len,
diff -puN arch/sparc/kernel/systbls_64.S~improve-sys_personality-for-compat-architectures arch/sparc/kernel/systbls_64.S
--- a/arch/sparc/kernel/systbls_64.S~improve-sys_personality-for-compat-architectures
+++ a/arch/sparc/kernel/systbls_64.S
@@ -56,7 +56,7 @@ sys_call_table32:
 	.word sys_setsid, sys_fchdir, sys32_fgetxattr, sys_listxattr, sys_llistxattr
 /*180*/	.word sys32_flistxattr, sys_removexattr, sys_lremovexattr, compat_sys_sigpending, sys_ni_syscall
 	.word sys32_setpgid, sys32_fremovexattr, sys32_tkill, sys32_exit_group, sys_sparc64_newuname
-/*190*/	.word sys32_init_module, sys_sparc64_personality, sys_remap_file_pages, sys32_epoll_create, sys32_epoll_ctl
+/*190*/	.word sys32_init_module, sys_personality, sys_remap_file_pages, sys32_epoll_create, sys32_epoll_ctl
 	.word sys32_epoll_wait, sys32_ioprio_set, sys_getppid, sys32_sigaction, sys_sgetmask
 /*200*/	.word sys32_ssetmask, sys_sigsuspend, compat_sys_newlstat, sys_uselib, compat_sys_old_readdir
 	.word sys32_readahead, sys32_socketcall, sys32_syslog, sys32_lookup_dcookie, sys32_fadvise64
@@ -131,7 +131,7 @@ sys_call_table:
 	.word sys_setsid, sys_fchdir, sys_fgetxattr, sys_listxattr, sys_llistxattr
 /*180*/	.word sys_flistxattr, sys_removexattr, sys_lremovexattr, sys_nis_syscall, sys_ni_syscall
 	.word sys_setpgid, sys_fremovexattr, sys_tkill, sys_exit_group, sys_sparc64_newuname
-/*190*/	.word sys_init_module, sys_sparc64_personality, sys_remap_file_pages, sys_epoll_create, sys_epoll_ctl
+/*190*/	.word sys_init_module, sys_personality, sys_remap_file_pages, sys_epoll_create, sys_epoll_ctl
 	.word sys_epoll_wait, sys_ioprio_set, sys_getppid, sys_nis_syscall, sys_sgetmask
 /*200*/	.word sys_ssetmask, sys_nis_syscall, sys_newlstat, sys_uselib, sys_nis_syscall
 	.word sys_readahead, sys_socketcall, sys_syslog, sys_lookup_dcookie, sys_fadvise64
diff -puN arch/x86/ia32/sys_ia32.c~improve-sys_personality-for-compat-architectures arch/x86/ia32/sys_ia32.c
--- a/arch/x86/ia32/sys_ia32.c~improve-sys_personality-for-compat-architectures
+++ a/arch/x86/ia32/sys_ia32.c
@@ -414,20 +414,6 @@ asmlinkage long sys32_pwrite(unsigned in
 			  ((loff_t)AA(poshi) << 32) | AA(poslo));
 }
 
-
-asmlinkage long sys32_personality(unsigned long personality)
-{
-	int ret;
-
-	if (personality(current->personality) == PER_LINUX32 &&
-		personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-	return ret;
-}
-
 asmlinkage long sys32_sendfile(int out_fd, int in_fd,
 			       compat_off_t __user *offset, s32 count)
 {
diff -puN arch/x86/include/asm/sys_ia32.h~improve-sys_personality-for-compat-architectures arch/x86/include/asm/sys_ia32.h
--- a/arch/x86/include/asm/sys_ia32.h~improve-sys_personality-for-compat-architectures
+++ a/arch/x86/include/asm/sys_ia32.h
@@ -51,7 +51,6 @@ asmlinkage long sys32_rt_sigqueueinfo(in
 asmlinkage long sys32_pread(unsigned int, char __user *, u32, u32, u32);
 asmlinkage long sys32_pwrite(unsigned int, char __user *, u32, u32, u32);
 
-asmlinkage long sys32_personality(unsigned long);
 asmlinkage long sys32_sendfile(int, int, compat_off_t __user *, s32);
 
 struct oldold_utsname;
diff -puN kernel/exec_domain.c~improve-sys_personality-for-compat-architectures kernel/exec_domain.c
--- a/kernel/exec_domain.c~improve-sys_personality-for-compat-architectures
+++ a/kernel/exec_domain.c
@@ -188,17 +188,26 @@ static int __init proc_execdomains_init(
 module_init(proc_execdomains_init);
 #endif
 
+/*
+ * Get/set the personality.
+ *
+ * Note that we simply return PER_LINUX even if we actually have a 32-bit
+ * task (PER_LINUX32) as this is expected by 32-bit userland.
+ */
 SYSCALL_DEFINE1(personality, u_long, personality)
 {
 	u_long old = current->personality;
 
 	if (personality != 0xffffffff) {
+		if (personality(old) == PER_LINUX32 &&
+		    personality == PER_LINUX)
+			personality = PER_LINUX32;
 		set_personality(personality);
 		if (current->personality != personality)
 			return -EINVAL;
 	}
 
-	return (long)old;
+	return (long)(old == PER_LINUX32 ? PER_LINUX : old);
 }
 
 
_

Patches currently in -mm which might be from hch@lst.de are

linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
add-generic-sys_old_select.patch
add-generic-sys_old_mmap.patch
add-generic-sys_ipc-wrapper.patch
improve-sys_personality-for-compat-architectures.patch
improve-sys_newuname-for-compat-architectures.patch
add-generic-sys_olduname.patch


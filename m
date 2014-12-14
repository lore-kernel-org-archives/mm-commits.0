From: akpm@linux-foundation.org
Subject: [merged] x86-hook-up-execveat-system-call.patch removed from -mm
 tree
Date: Sat, 13 Dec 2014 20:09:21 -0800
Message-ID: <548d0d71.F1FxYdNov0H+Abir%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaLNEJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drysdale@google.com, arnd@arndb.de, dalias@aerifal.cx, ebiederm@xmission.com, hch@infradead.org, hpa@zytor.com, keescook@chromium.org, luto@amacapital.net, meredydd@senatehouse.org, mingo@redhat.com, mtk.manpages@gmail.com, shuah.kh@samsung.com, tglx@linutronix.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: hook up execveat system call
has been removed from the -mm tree.  Its filename was
     x86-hook-up-execveat-system-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Drysdale <drysdale@google.com>
Subject: x86: hook up execveat system call

Hook up x86-64, i386 and x32 ABIs.

Signed-off-by: David Drysdale <drysdale@google.com>
Cc: Meredydd Luff <meredydd@senatehouse.org>
Cc: Shuah Khan <shuah.kh@samsung.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rich Felker <dalias@aerifal.cx>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/audit.c            |    1 +
 arch/x86/ia32/ia32entry.S        |    1 +
 arch/x86/kernel/audit_64.c       |    1 +
 arch/x86/kernel/entry_64.S       |   28 ++++++++++++++++++++++++++++
 arch/x86/syscalls/syscall_32.tbl |    1 +
 arch/x86/syscalls/syscall_64.tbl |    2 ++
 arch/x86/um/sys_call_table_64.c  |    1 +
 7 files changed, 35 insertions(+)

diff -puN arch/x86/ia32/audit.c~x86-hook-up-execveat-system-call arch/x86/ia32/audit.c
--- a/arch/x86/ia32/audit.c~x86-hook-up-execveat-system-call
+++ a/arch/x86/ia32/audit.c
@@ -35,6 +35,7 @@ int ia32_classify_syscall(unsigned sysca
 	case __NR_socketcall:
 		return 4;
 	case __NR_execve:
+	case __NR_execveat:
 		return 5;
 	default:
 		return 1;
diff -puN arch/x86/ia32/ia32entry.S~x86-hook-up-execveat-system-call arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~x86-hook-up-execveat-system-call
+++ a/arch/x86/ia32/ia32entry.S
@@ -480,6 +480,7 @@ GLOBAL(\label)
 	PTREGSCALL stub32_rt_sigreturn, sys32_rt_sigreturn
 	PTREGSCALL stub32_sigreturn, sys32_sigreturn
 	PTREGSCALL stub32_execve, compat_sys_execve
+	PTREGSCALL stub32_execveat, compat_sys_execveat
 	PTREGSCALL stub32_fork, sys_fork
 	PTREGSCALL stub32_vfork, sys_vfork
 
diff -puN arch/x86/kernel/audit_64.c~x86-hook-up-execveat-system-call arch/x86/kernel/audit_64.c
--- a/arch/x86/kernel/audit_64.c~x86-hook-up-execveat-system-call
+++ a/arch/x86/kernel/audit_64.c
@@ -50,6 +50,7 @@ int audit_classify_syscall(int abi, unsi
 	case __NR_openat:
 		return 3;
 	case __NR_execve:
+	case __NR_execveat:
 		return 5;
 	default:
 		return 0;
diff -puN arch/x86/kernel/entry_64.S~x86-hook-up-execveat-system-call arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S~x86-hook-up-execveat-system-call
+++ a/arch/x86/kernel/entry_64.S
@@ -652,6 +652,20 @@ ENTRY(stub_execve)
 	CFI_ENDPROC
 END(stub_execve)
 
+ENTRY(stub_execveat)
+	CFI_STARTPROC
+	addq $8, %rsp
+	PARTIAL_FRAME 0
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %r11
+	call sys_execveat
+	RESTORE_TOP_OF_STACK %r11
+	movq %rax,RAX(%rsp)
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_execveat)
+
 /*
  * sigreturn is special because it needs to restore all registers on return.
  * This cannot be done with SYSRET, so use the IRET return path instead.
@@ -697,6 +711,20 @@ ENTRY(stub_x32_execve)
 	CFI_ENDPROC
 END(stub_x32_execve)
 
+ENTRY(stub_x32_execveat)
+	CFI_STARTPROC
+	addq $8, %rsp
+	PARTIAL_FRAME 0
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %r11
+	call compat_sys_execveat
+	RESTORE_TOP_OF_STACK %r11
+	movq %rax,RAX(%rsp)
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_x32_execveat)
+
 #endif
 
 /*
diff -puN arch/x86/syscalls/syscall_32.tbl~x86-hook-up-execveat-system-call arch/x86/syscalls/syscall_32.tbl
--- a/arch/x86/syscalls/syscall_32.tbl~x86-hook-up-execveat-system-call
+++ a/arch/x86/syscalls/syscall_32.tbl
@@ -364,3 +364,4 @@
 355	i386	getrandom		sys_getrandom
 356	i386	memfd_create		sys_memfd_create
 357	i386	bpf			sys_bpf
+358	i386	execveat		sys_execveat			stub32_execveat
diff -puN arch/x86/syscalls/syscall_64.tbl~x86-hook-up-execveat-system-call arch/x86/syscalls/syscall_64.tbl
--- a/arch/x86/syscalls/syscall_64.tbl~x86-hook-up-execveat-system-call
+++ a/arch/x86/syscalls/syscall_64.tbl
@@ -328,6 +328,7 @@
 319	common	memfd_create		sys_memfd_create
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
+322	64	execveat		stub_execveat
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
@@ -366,3 +367,4 @@
 542	x32	getsockopt		compat_sys_getsockopt
 543	x32	io_setup		compat_sys_io_setup
 544	x32	io_submit		compat_sys_io_submit
+545	x32	execveat		stub_x32_execveat
diff -puN arch/x86/um/sys_call_table_64.c~x86-hook-up-execveat-system-call arch/x86/um/sys_call_table_64.c
--- a/arch/x86/um/sys_call_table_64.c~x86-hook-up-execveat-system-call
+++ a/arch/x86/um/sys_call_table_64.c
@@ -31,6 +31,7 @@
 #define stub_fork sys_fork
 #define stub_vfork sys_vfork
 #define stub_execve sys_execve
+#define stub_execveat sys_execveat
 #define stub_rt_sigreturn sys_rt_sigreturn
 
 #define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
_

Patches currently in -mm which might be from drysdale@google.com are

origin.patch


From: akpm@linux-foundation.org
Subject: [merged] sparc-hook-up-execveat-system-call.patch removed from
 -mm tree
Date: Sat, 13 Dec 2014 20:09:30 -0800
Message-ID: <548d0d7a.GrmET1elDZ0eDcX9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaLNEJX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drysdale@google.com, davem@davemloft.net, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: hook up execveat system call
has been removed from the -mm tree.  Its filename was
     sparc-hook-up-execveat-system-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Drysdale <drysdale@google.com>
Subject: sparc: hook up execveat system call

Signed-off-by: David Drysdale <drysdale@google.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/uapi/asm/unistd.h |    3 ++-
 arch/sparc/kernel/syscalls.S         |   10 ++++++++++
 arch/sparc/kernel/systbls_32.S       |    1 +
 arch/sparc/kernel/systbls_64.S       |    2 ++
 4 files changed, 15 insertions(+), 1 deletion(-)

diff -puN arch/sparc/include/uapi/asm/unistd.h~sparc-hook-up-execveat-system-call arch/sparc/include/uapi/asm/unistd.h
--- a/arch/sparc/include/uapi/asm/unistd.h~sparc-hook-up-execveat-system-call
+++ a/arch/sparc/include/uapi/asm/unistd.h
@@ -415,8 +415,9 @@
 #define __NR_getrandom		347
 #define __NR_memfd_create	348
 #define __NR_bpf		349
+#define __NR_execveat		350
 
-#define NR_syscalls		350
+#define NR_syscalls		351
 
 /* Bitmask values returned from kern_features system call.  */
 #define KERN_FEATURE_MIXED_MODE_STACK	0x00000001
diff -puN arch/sparc/kernel/syscalls.S~sparc-hook-up-execveat-system-call arch/sparc/kernel/syscalls.S
--- a/arch/sparc/kernel/syscalls.S~sparc-hook-up-execveat-system-call
+++ a/arch/sparc/kernel/syscalls.S
@@ -6,6 +6,11 @@ sys64_execve:
 	jmpl	%g1, %g0
 	 flushw
 
+sys64_execveat:
+	set	sys_execveat, %g1
+	jmpl	%g1, %g0
+	 flushw
+
 #ifdef CONFIG_COMPAT
 sunos_execv:
 	mov	%g0, %o2
@@ -13,6 +18,11 @@ sys32_execve:
 	set	compat_sys_execve, %g1
 	jmpl	%g1, %g0
 	 flushw
+
+sys32_execveat:
+	set	compat_sys_execveat, %g1
+	jmpl	%g1, %g0
+	 flushw
 #endif
 
 	.align	32
diff -puN arch/sparc/kernel/systbls_32.S~sparc-hook-up-execveat-system-call arch/sparc/kernel/systbls_32.S
--- a/arch/sparc/kernel/systbls_32.S~sparc-hook-up-execveat-system-call
+++ a/arch/sparc/kernel/systbls_32.S
@@ -87,3 +87,4 @@ sys_call_table:
 /*335*/	.long sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.long sys_ni_syscall, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 /*345*/	.long sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
+/*350*/	.long sys_execveat
diff -puN arch/sparc/kernel/systbls_64.S~sparc-hook-up-execveat-system-call arch/sparc/kernel/systbls_64.S
--- a/arch/sparc/kernel/systbls_64.S~sparc-hook-up-execveat-system-call
+++ a/arch/sparc/kernel/systbls_64.S
@@ -88,6 +88,7 @@ sys_call_table32:
 	.word sys_syncfs, compat_sys_sendmmsg, sys_setns, compat_sys_process_vm_readv, compat_sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 	.word sys32_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
+/*350*/	.word sys32_execveat
 
 #endif /* CONFIG_COMPAT */
 
@@ -167,3 +168,4 @@ sys_call_table:
 	.word sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 	.word sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
+/*350*/	.word sys64_execveat
_

Patches currently in -mm which might be from drysdale@google.com are

origin.patch


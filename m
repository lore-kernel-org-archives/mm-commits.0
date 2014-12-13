From: akpm@linux-foundation.org
Subject: [folded-merged] sparc-hook-up-execveat-system-call-v10.patch
 removed from -mm tree
Date: Fri, 12 Dec 2014 16:46:31 -0800
Message-ID: <548b8c67.vp3kwB8px+ivQENo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaLMAqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:46:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drysdale@google.com, davem@davemloft.net, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc-hook-up-execveat-system-call-v10
has been removed from the -mm tree.  Its filename was
     sparc-hook-up-execveat-system-call-v10.patch

This patch was dropped because it was folded into sparc-hook-up-execveat-system-call.patch

------------------------------------------------------
From: David Drysdale <drysdale@google.com>
Subject: sparc-hook-up-execveat-system-call-v10

Add sparc syscall wrappers and use correct sparc 32b compatibility
function [Stephen Rothwell, David S.  Miller]

Signed-off-by: David Drysdale <drysdale@google.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/syscalls.S   |   10 ++++++++++
 arch/sparc/kernel/systbls_64.S |    4 ++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff -puN arch/sparc/kernel/syscalls.S~sparc-hook-up-execveat-system-call-v10 arch/sparc/kernel/syscalls.S
--- a/arch/sparc/kernel/syscalls.S~sparc-hook-up-execveat-system-call-v10
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
diff -puN arch/sparc/kernel/systbls_64.S~sparc-hook-up-execveat-system-call-v10 arch/sparc/kernel/systbls_64.S
--- a/arch/sparc/kernel/systbls_64.S~sparc-hook-up-execveat-system-call-v10
+++ a/arch/sparc/kernel/systbls_64.S
@@ -88,7 +88,7 @@ sys_call_table32:
 	.word sys_syncfs, compat_sys_sendmmsg, sys_setns, compat_sys_process_vm_readv, compat_sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 	.word sys32_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
-/*350*/	.word sys_execveat
+/*350*/	.word sys32_execveat
 
 #endif /* CONFIG_COMPAT */
 
@@ -168,4 +168,4 @@ sys_call_table:
 	.word sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 	.word sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
-/*350*/	.word sys_execveat
+/*350*/	.word sys64_execveat
_

Patches currently in -mm which might be from drysdale@google.com are

syscalls-implement-execveat-system-call.patch
x86-hook-up-execveat-system-call.patch
syscalls-add-selftest-for-execveat2.patch
sparc-hook-up-execveat-system-call.patch


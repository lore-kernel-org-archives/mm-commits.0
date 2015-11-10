From: akpm@linux-foundation.org
Subject: [merged]
 sparc-sparc64-allocate-sys_membarrier-system-call-number.patch removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:02 -0800
Message-ID: <5642547e.5/8zCbYm+Oo9zasS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbKJUdC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@efficios.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc/sparc64: allocate sys_membarrier system call number
has been removed from the -mm tree.  Its filename was
     sparc-sparc64-allocate-sys_membarrier-system-call-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: sparc/sparc64: allocate sys_membarrier system call number

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/uapi/asm/unistd.h |    3 ++-
 arch/sparc/kernel/systbls_32.S       |    2 +-
 arch/sparc/kernel/systbls_64.S       |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/sparc/include/uapi/asm/unistd.h~sparc-sparc64-allocate-sys_membarrier-system-call-number arch/sparc/include/uapi/asm/unistd.h
--- a/arch/sparc/include/uapi/asm/unistd.h~sparc-sparc64-allocate-sys_membarrier-system-call-number
+++ a/arch/sparc/include/uapi/asm/unistd.h
@@ -416,8 +416,9 @@
 #define __NR_memfd_create	348
 #define __NR_bpf		349
 #define __NR_execveat		350
+#define __NR_membarrier		351
 
-#define NR_syscalls		351
+#define NR_syscalls		352
 
 /* Bitmask values returned from kern_features system call.  */
 #define KERN_FEATURE_MIXED_MODE_STACK	0x00000001
diff -puN arch/sparc/kernel/systbls_32.S~sparc-sparc64-allocate-sys_membarrier-system-call-number arch/sparc/kernel/systbls_32.S
--- a/arch/sparc/kernel/systbls_32.S~sparc-sparc64-allocate-sys_membarrier-system-call-number
+++ a/arch/sparc/kernel/systbls_32.S
@@ -87,4 +87,4 @@ sys_call_table:
 /*335*/	.long sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.long sys_ni_syscall, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 /*345*/	.long sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
-/*350*/	.long sys_execveat
+/*350*/	.long sys_execveat, sys_membarrier
diff -puN arch/sparc/kernel/systbls_64.S~sparc-sparc64-allocate-sys_membarrier-system-call-number arch/sparc/kernel/systbls_64.S
--- a/arch/sparc/kernel/systbls_64.S~sparc-sparc64-allocate-sys_membarrier-system-call-number
+++ a/arch/sparc/kernel/systbls_64.S
@@ -88,7 +88,7 @@ sys_call_table32:
 	.word sys_syncfs, compat_sys_sendmmsg, sys_setns, compat_sys_process_vm_readv, compat_sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 	.word sys32_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
-/*350*/	.word sys32_execveat
+/*350*/	.word sys32_execveat, sys_membarrier
 
 #endif /* CONFIG_COMPAT */
 
@@ -168,4 +168,4 @@ sys_call_table:
 	.word sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 	.word sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
-/*350*/	.word sys64_execveat
+/*350*/	.word sys64_execveat, sys_membarrier
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are



From: akpm@linux-foundation.org
Subject: + sparc-sparc64-allocate-sys_membarrier-system-call-number.patch
 added to -mm tree
Date: Mon, 28 Sep 2015 13:34:00 -0700
Message-ID: <5609a438.AApHvQ1AJAHgow3g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbI1UeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 16:34:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@efficios.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc/sparc64: allocate sys_membarrier system call number
has been added to the -mm tree.  Its filename is
     sparc-sparc64-allocate-sys_membarrier-system-call-number.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-sparc64-allocate-sys_membarrier-system-call-number.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc-sparc64-allocate-sys_membarrier-system-call-number.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mips-allocate-sys_membarrier-system-call-number.patch
sparc-sparc64-allocate-sys_membarrier-system-call-number.patch


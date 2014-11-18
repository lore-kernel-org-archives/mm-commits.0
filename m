From: akpm@linux-foundation.org
Subject: + sparc-hook-up-execveat-system-call.patch added to -mm tree
Date: Mon, 17 Nov 2014 16:13:00 -0800
Message-ID: <546a8f0c.twkiv4rfMmbTnc37%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaKRANB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 19:13:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drysdale@google.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: hook up execveat system call
has been added to the -mm tree.  Its filename is
     sparc-hook-up-execveat-system-call.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-hook-up-execveat-system-call.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/sparc-hook-up-execveat-system-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Drysdale <drysdale@google.com>
Subject: sparc: hook up execveat system call

Signed-off-by: David Drysdale <drysdale@google.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/uapi/asm/unistd.h |    3 ++-
 arch/sparc/kernel/systbls_32.S       |    1 +
 arch/sparc/kernel/systbls_64.S       |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

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
+/*350*/	.word sys_execveat
 
 #endif /* CONFIG_COMPAT */
 
@@ -167,3 +168,4 @@ sys_call_table:
 	.word sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
 /*340*/	.word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
 	.word sys_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
+/*350*/	.word sys_execveat
_

Patches currently in -mm which might be from drysdale@google.com are

syscallsx86-implement-execveat-system-call.patch
syscallsx86-implement-execveat-system-call-v8.patch
syscallsx86-add-selftest-for-execveat2.patch
sparc-hook-up-execveat-system-call.patch


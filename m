From: akpm@linux-foundation.org
Subject: - sparc64-wire-up-accept4.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:42:21 -0800
Message-ID: <200811202042.mAKKgLug006902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755422AbYKTUoE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:44:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, drepper@redhat.com, mtk.manpages@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sparc64: wire up accept4()
has been removed from the -mm tree.  Its filename was
     sparc64-wire-up-accept4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc64: wire up accept4()
From: David Miller <davem@davemloft.net>

This adds the sparc syscall hookups.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/unistd_32.h |    3 ++-
 arch/sparc/include/asm/unistd_64.h |    3 ++-
 arch/sparc/kernel/systbls.S        |    2 +-
 arch/sparc64/kernel/sys32.S        |   13 ++++++++++++-
 arch/sparc64/kernel/systbls.S      |    4 ++--
 5 files changed, 19 insertions(+), 6 deletions(-)

diff -puN arch/sparc/include/asm/unistd_32.h~sparc64-wire-up-accept4 arch/sparc/include/asm/unistd_32.h
--- a/arch/sparc/include/asm/unistd_32.h~sparc64-wire-up-accept4
+++ a/arch/sparc/include/asm/unistd_32.h
@@ -338,8 +338,9 @@
 #define __NR_dup3		320
 #define __NR_pipe2		321
 #define __NR_inotify_init1	322
+#define __NR_accept4		323
 
-#define NR_SYSCALLS		323
+#define NR_SYSCALLS		324
 
 /* Sparc 32-bit only has the "setresuid32", "getresuid32" variants,
  * it never had the plain ones and there is no value to adding those
diff -puN arch/sparc/include/asm/unistd_64.h~sparc64-wire-up-accept4 arch/sparc/include/asm/unistd_64.h
--- a/arch/sparc/include/asm/unistd_64.h~sparc64-wire-up-accept4
+++ a/arch/sparc/include/asm/unistd_64.h
@@ -340,8 +340,9 @@
 #define __NR_dup3		320
 #define __NR_pipe2		321
 #define __NR_inotify_init1	322
+#define __NR_accept4		323
 
-#define NR_SYSCALLS		323
+#define NR_SYSCALLS		324
 
 #ifdef __KERNEL__
 #define __ARCH_WANT_IPC_PARSE_VERSION
diff -puN arch/sparc/kernel/systbls.S~sparc64-wire-up-accept4 arch/sparc/kernel/systbls.S
--- a/arch/sparc/kernel/systbls.S~sparc64-wire-up-accept4
+++ a/arch/sparc/kernel/systbls.S
@@ -81,4 +81,4 @@ sys_call_table:
 /*305*/	.long sys_set_mempolicy, sys_kexec_load, sys_move_pages, sys_getcpu, sys_epoll_pwait
 /*310*/	.long sys_utimensat, sys_signalfd, sys_timerfd_create, sys_eventfd, sys_fallocate
 /*315*/	.long sys_timerfd_settime, sys_timerfd_gettime, sys_signalfd4, sys_eventfd2, sys_epoll_create1
-/*320*/	.long sys_dup3, sys_pipe2, sys_inotify_init1
+/*320*/	.long sys_dup3, sys_pipe2, sys_inotify_init1, sys_accept4
diff -puN arch/sparc64/kernel/sys32.S~sparc64-wire-up-accept4 arch/sparc64/kernel/sys32.S
--- a/arch/sparc64/kernel/sys32.S~sparc64-wire-up-accept4
+++ a/arch/sparc64/kernel/sys32.S
@@ -150,7 +150,7 @@ sys32_mmap2:
 sys32_socketcall:	/* %o0=call, %o1=args */
 	cmp		%o0, 1
 	bl,pn		%xcc, do_einval
-	 cmp		%o0, 17
+	 cmp		%o0, 18
 	bg,pn		%xcc, do_einval
 	 sub		%o0, 1, %o0
 	sllx		%o0, 5, %o0
@@ -319,6 +319,15 @@ do_sys_recvmsg: /* compat_sys_recvmsg(in
 	nop
 	nop
 	nop
+do_sys_accept4: /* sys_accept4(int, struct sockaddr *, int *, int) */
+63:	ldswa		[%o1 + 0x0] %asi, %o0
+	sethi		%hi(sys_accept4), %g1
+64:	lduwa		[%o1 + 0x8] %asi, %o2
+65:	ldswa		[%o1 + 0xc] %asi, %o3
+	jmpl		%g1 + %lo(sys_accept4), %g0
+66:	 lduwa		[%o1 + 0x4] %asi, %o1
+	nop
+	nop
 
 	.section	__ex_table,"a"
 	.align		4
@@ -353,4 +362,6 @@ do_sys_recvmsg: /* compat_sys_recvmsg(in
 	.word		57b, __retl_efault, 58b, __retl_efault
 	.word		59b, __retl_efault, 60b, __retl_efault
 	.word		61b, __retl_efault, 62b, __retl_efault
+	.word		63b, __retl_efault, 64b, __retl_efault
+	.word		65b, __retl_efault, 66b, __retl_efault
 	.previous
diff -puN arch/sparc64/kernel/systbls.S~sparc64-wire-up-accept4 arch/sparc64/kernel/systbls.S
--- a/arch/sparc64/kernel/systbls.S~sparc64-wire-up-accept4
+++ a/arch/sparc64/kernel/systbls.S
@@ -82,7 +82,7 @@ sys_call_table32:
 	.word compat_sys_set_mempolicy, compat_sys_kexec_load, compat_sys_move_pages, sys_getcpu, compat_sys_epoll_pwait
 /*310*/	.word compat_sys_utimensat, compat_sys_signalfd, sys_timerfd_create, sys_eventfd, compat_sys_fallocate
 	.word compat_sys_timerfd_settime, compat_sys_timerfd_gettime, compat_sys_signalfd4, sys_eventfd2, sys_epoll_create1
-/*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1
+/*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1, sys_accept4
 
 #endif /* CONFIG_COMPAT */
 
@@ -156,4 +156,4 @@ sys_call_table:
 	.word sys_set_mempolicy, sys_kexec_load, sys_move_pages, sys_getcpu, sys_epoll_pwait
 /*310*/	.word sys_utimensat, sys_signalfd, sys_timerfd_create, sys_eventfd, sys_fallocate
 	.word sys_timerfd_settime, sys_timerfd_gettime, sys_signalfd4, sys_eventfd2, sys_epoll_create1
-/*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1
+/*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1, sys_accept4
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
linux-next.patch
net-tipc-bcasth-use-array_size.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
unaligned-introduce-common-header.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch


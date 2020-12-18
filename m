Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AF4C4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0924723B7E
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgLRWGY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgLRWGY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:06:24 -0500
Date:   Fri, 18 Dec 2020 14:05:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329142;
        bh=ijEvgyIh4mCm0UNuUMzEgEigB1judULww4GwyOgn7xs=;
        h=From:To:Subject:In-Reply-To:From;
        b=SjNlYPGaFl4D4q+s7ISy5n3wlJF7QnYohHfSWE3LGWWXA8IwfV6LVWiiGmioVxHjI
         zFyWyiflPENwOmwHR0j8f0gOptSJl3vjPxv3L8NwpnXjQVOSnJtxCP5LHsUj6iiyZ9
         CDdmP6vgwmwE1dVNNEQ9Oo2+MQPJ/veWm+uZ6URU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, willemb@google.com, willy@infradead.org
Subject:  [patch 77/78] epoll: wire up syscall epoll_pwait2
Message-ID: <20201218220541.HmQ5hLrPx%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>
Subject: epoll: wire up syscall epoll_pwait2

Split off from prev patch in the series that implements the syscall.

Link: https://lkml.kernel.org/r/20201121144401.3727659-4-willemdebruijn.kernel@gmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/syscalls/syscall.tbl      |    1 +
 arch/arm/tools/syscall.tbl                  |    1 +
 arch/arm64/include/asm/unistd.h             |    2 +-
 arch/arm64/include/asm/unistd32.h           |    2 ++
 arch/ia64/kernel/syscalls/syscall.tbl       |    1 +
 arch/m68k/kernel/syscalls/syscall.tbl       |    1 +
 arch/microblaze/kernel/syscalls/syscall.tbl |    1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   |    1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl   |    1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl   |    1 +
 arch/parisc/kernel/syscalls/syscall.tbl     |    1 +
 arch/powerpc/kernel/syscalls/syscall.tbl    |    1 +
 arch/s390/kernel/syscalls/syscall.tbl       |    1 +
 arch/sh/kernel/syscalls/syscall.tbl         |    1 +
 arch/sparc/kernel/syscalls/syscall.tbl      |    1 +
 arch/x86/entry/syscalls/syscall_32.tbl      |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl      |    1 +
 arch/xtensa/kernel/syscalls/syscall.tbl     |    1 +
 include/linux/compat.h                      |    6 ++++++
 include/linux/syscalls.h                    |    5 +++++
 include/uapi/asm-generic/unistd.h           |    4 +++-
 kernel/sys_ni.c                             |    2 ++
 22 files changed, 35 insertions(+), 2 deletions(-)

--- a/arch/alpha/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/alpha/kernel/syscalls/syscall.tbl
@@ -480,3 +480,4 @@
 548	common	pidfd_getfd			sys_pidfd_getfd
 549	common	faccessat2			sys_faccessat2
 550	common	process_madvise			sys_process_madvise
+551	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/arm64/include/asm/unistd32.h~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/arm64/include/asm/unistd32.h
@@ -889,6 +889,8 @@ __SYSCALL(__NR_pidfd_getfd, sys_pidfd_ge
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
 #define __NR_process_madvise 440
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
+#define __NR_epoll_pwait2 441
+__SYSCALL(__NR_epoll_pwait2, sys_epoll_pwait2)
 
 /*
  * Please add new compat syscalls above this comment and update
--- a/arch/arm64/include/asm/unistd.h~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/arm64/include/asm/unistd.h
@@ -38,7 +38,7 @@
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE + 5)
 #define __ARM_NR_COMPAT_END		(__ARM_NR_COMPAT_BASE + 0x800)
 
-#define __NR_compat_syscalls		441
+#define __NR_compat_syscalls		442
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
--- a/arch/arm/tools/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/arm/tools/syscall.tbl
@@ -454,3 +454,4 @@
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
+441	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/ia64/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/ia64/kernel/syscalls/syscall.tbl
@@ -361,3 +361,4 @@
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
+441	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/m68k/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/m68k/kernel/syscalls/syscall.tbl
@@ -440,3 +440,4 @@
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
+441	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/microblaze/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -446,3 +446,4 @@
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
+441	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -379,3 +379,4 @@
 438	n32	pidfd_getfd			sys_pidfd_getfd
 439	n32	faccessat2			sys_faccessat2
 440	n32	process_madvise			sys_process_madvise
+441	n32	epoll_pwait2			sys_epoll_pwait2
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -355,3 +355,4 @@
 438	n64	pidfd_getfd			sys_pidfd_getfd
 439	n64	faccessat2			sys_faccessat2
 440	n64	process_madvise			sys_process_madvise
+441	n64	epoll_pwait2			sys_epoll_pwait2
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -428,3 +428,4 @@
 438	o32	pidfd_getfd			sys_pidfd_getfd
 439	o32	faccessat2			sys_faccessat2
 440	o32	process_madvise			sys_process_madvise
+441	o32	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
--- a/arch/parisc/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/parisc/kernel/syscalls/syscall.tbl
@@ -438,3 +438,4 @@
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
+441	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
--- a/arch/powerpc/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -530,3 +530,4 @@
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
+441	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
--- a/arch/s390/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -443,3 +443,4 @@
 438  common	pidfd_getfd		sys_pidfd_getfd			sys_pidfd_getfd
 439  common	faccessat2		sys_faccessat2			sys_faccessat2
 440  common	process_madvise		sys_process_madvise		sys_process_madvise
+441  common	epoll_pwait2		sys_epoll_pwait2		sys_epoll_pwait2
--- a/arch/sh/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/sh/kernel/syscalls/syscall.tbl
@@ -443,3 +443,4 @@
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
+441	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/sparc/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/sparc/kernel/syscalls/syscall.tbl
@@ -486,3 +486,4 @@
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
+441	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/x86/entry/syscalls/syscall_32.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -445,3 +445,4 @@
 438	i386	pidfd_getfd		sys_pidfd_getfd
 439	i386	faccessat2		sys_faccessat2
 440	i386	process_madvise		sys_process_madvise
+441	i386	epoll_pwait2		sys_epoll_pwait2		compat_sys_epoll_pwait2
--- a/arch/x86/entry/syscalls/syscall_64.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -362,6 +362,7 @@
 438	common	pidfd_getfd		sys_pidfd_getfd
 439	common	faccessat2		sys_faccessat2
 440	common	process_madvise		sys_process_madvise
+441	common	epoll_pwait2		sys_epoll_pwait2
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
--- a/arch/xtensa/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -411,3 +411,4 @@
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
+441	common	epoll_pwait2			sys_epoll_pwait2
--- a/include/linux/compat.h~epoll-wire-up-syscall-epoll_pwait2
+++ a/include/linux/compat.h
@@ -537,6 +537,12 @@ asmlinkage long compat_sys_epoll_pwait(i
 			int maxevents, int timeout,
 			const compat_sigset_t __user *sigmask,
 			compat_size_t sigsetsize);
+asmlinkage long compat_sys_epoll_pwait2(int epfd,
+			struct epoll_event __user *events,
+			int maxevents,
+			const struct __kernel_timespec __user *timeout,
+			const compat_sigset_t __user *sigmask,
+			compat_size_t sigsetsize);
 
 /* fs/fcntl.c */
 asmlinkage long compat_sys_fcntl(unsigned int fd, unsigned int cmd,
--- a/include/linux/syscalls.h~epoll-wire-up-syscall-epoll_pwait2
+++ a/include/linux/syscalls.h
@@ -362,6 +362,11 @@ asmlinkage long sys_epoll_pwait(int epfd
 				int maxevents, int timeout,
 				const sigset_t __user *sigmask,
 				size_t sigsetsize);
+asmlinkage long sys_epoll_pwait2(int epfd, struct epoll_event __user *events,
+				 int maxevents,
+				 const struct __kernel_timespec __user *timeout,
+				 const sigset_t __user *sigmask,
+				 size_t sigsetsize);
 
 /* fs/fcntl.c */
 asmlinkage long sys_dup(unsigned int fildes);
--- a/include/uapi/asm-generic/unistd.h~epoll-wire-up-syscall-epoll_pwait2
+++ a/include/uapi/asm-generic/unistd.h
@@ -859,9 +859,11 @@ __SYSCALL(__NR_pidfd_getfd, sys_pidfd_ge
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
 #define __NR_process_madvise 440
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
+#define __NR_epoll_pwait2 441
+__SC_COMP(__NR_epoll_pwait2, sys_epoll_pwait2, compat_sys_epoll_pwait2)
 
 #undef __NR_syscalls
-#define __NR_syscalls 441
+#define __NR_syscalls 442
 
 /*
  * 32 bit systems traditionally used different
--- a/kernel/sys_ni.c~epoll-wire-up-syscall-epoll_pwait2
+++ a/kernel/sys_ni.c
@@ -68,6 +68,8 @@ COND_SYSCALL(epoll_create1);
 COND_SYSCALL(epoll_ctl);
 COND_SYSCALL(epoll_pwait);
 COND_SYSCALL_COMPAT(epoll_pwait);
+COND_SYSCALL(epoll_pwait2);
+COND_SYSCALL_COMPAT(epoll_pwait2);
 
 /* fs/fcntl.c */
 
_

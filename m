Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7AC9C6379D
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A568D207BC
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:48:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CgepV0YH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgKZAsk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 19:48:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKZAsk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 19:48:40 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29EF72168B;
        Thu, 26 Nov 2020 00:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606351719;
        bh=0DGSlZW4t9yt9R7HoDrADa809hHAVC2a35YuyZZ+tGQ=;
        h=Date:From:To:Subject:From;
        b=CgepV0YHu/xDEE3tRWWrhdX59r0V6SRW7As8sb01pHxl3iO8w7lG++F4EgfjMsaSS
         feZ9iVBSWLD8OraT1BLyPNEzU2Qjrv/kubR9Mf6ds/E83z47anIgEMNpQnyEEVI4vr
         lBQicueltm4JdDOnAJedHB5becad400y56lm1kc4=
Date:   Wed, 25 Nov 2020 16:48:38 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willemb@google.com, willy@infradead.org
Subject:  + epoll-wire-up-syscall-epoll_pwait2.patch added to -mm
 tree
Message-ID: <20201126004838.jAmk_KBa8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: wire up syscall epoll_pwait2
has been added to the -mm tree.  Its filename is
     epoll-wire-up-syscall-epoll_pwait2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/epoll-wire-up-syscall-epoll_pwait2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/epoll-wire-up-syscall-epoll_pwait2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -481,3 +481,4 @@
 549	common	faccessat2			sys_faccessat2
 550	common	process_madvise			sys_process_madvise
 551	common	watch_mount			sys_watch_mount
+553	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/arm64/include/asm/unistd32.h~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/arm64/include/asm/unistd32.h
@@ -891,6 +891,8 @@ __SYSCALL(__NR_faccessat2, sys_faccessat
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 #define __NR_watch_mount 441
 __SYSCALL(__NR_watch_mount, sys_watch_mount)
+#define __NR_epoll_pwait2 442
+__SYSCALL(__NR_epoll_pwait2, sys_epoll_pwait2)
 
 /*
  * Please add new compat syscalls above this comment and update
--- a/arch/arm64/include/asm/unistd.h~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/arm64/include/asm/unistd.h
@@ -38,7 +38,7 @@
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE + 5)
 #define __ARM_NR_COMPAT_END		(__ARM_NR_COMPAT_BASE + 0x800)
 
-#define __NR_compat_syscalls		442
+#define __NR_compat_syscalls		443
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
--- a/arch/arm/tools/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/arm/tools/syscall.tbl
@@ -455,3 +455,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
+443	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/ia64/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/ia64/kernel/syscalls/syscall.tbl
@@ -362,3 +362,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
+443	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/m68k/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/m68k/kernel/syscalls/syscall.tbl
@@ -441,3 +441,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
+443	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/microblaze/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -447,3 +447,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
+443	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -380,3 +380,4 @@
 439	n32	faccessat2			sys_faccessat2
 440	n32	process_madvise			sys_process_madvise
 441	n32	watch_mount			sys_watch_mount
+443	n32	epoll_pwait2			sys_epoll_pwait2
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -356,3 +356,4 @@
 439	n64	faccessat2			sys_faccessat2
 440	n64	process_madvise			sys_process_madvise
 441	n64	watch_mount			sys_watch_mount
+443	n64	epoll_pwait2			sys_epoll_pwait2
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -429,3 +429,4 @@
 439	o32	faccessat2			sys_faccessat2
 440	o32	process_madvise			sys_process_madvise
 441	o32	watch_mount			sys_watch_mount
+443	o32	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
--- a/arch/parisc/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/parisc/kernel/syscalls/syscall.tbl
@@ -439,3 +439,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
+443	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
--- a/arch/powerpc/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -531,3 +531,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
+443	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
--- a/arch/s390/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -444,3 +444,4 @@
 439  common	faccessat2		sys_faccessat2			sys_faccessat2
 440  common	process_madvise		sys_process_madvise		sys_process_madvise
 441	common	watch_mount		sys_watch_mount			sys_watch_mount
+443  common	epoll_pwait2		sys_epoll_pwait2		sys_epoll_pwait2
--- a/arch/sh/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/sh/kernel/syscalls/syscall.tbl
@@ -444,3 +444,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
+443	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/sparc/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/sparc/kernel/syscalls/syscall.tbl
@@ -487,3 +487,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
+443	common	epoll_pwait2			sys_epoll_pwait2
--- a/arch/x86/entry/syscalls/syscall_32.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -446,3 +446,4 @@
 439	i386	faccessat2		sys_faccessat2
 440	i386	process_madvise		sys_process_madvise
 441	i386	watch_mount		sys_watch_mount
+442	i386	epoll_pwait2		sys_epoll_pwait2		compat_sys_epoll_pwait2
--- a/arch/x86/entry/syscalls/syscall_64.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -363,6 +363,7 @@
 439	common	faccessat2		sys_faccessat2
 440	common	process_madvise		sys_process_madvise
 441	common	watch_mount		sys_watch_mount
+442	common	epoll_pwait2		sys_epoll_pwait2
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
--- a/arch/xtensa/kernel/syscalls/syscall.tbl~epoll-wire-up-syscall-epoll_pwait2
+++ a/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -412,3 +412,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	watch_mount			sys_watch_mount
+443	common	epoll_pwait2			sys_epoll_pwait2
--- a/include/linux/compat.h~epoll-wire-up-syscall-epoll_pwait2
+++ a/include/linux/compat.h
@@ -505,6 +505,12 @@ asmlinkage long compat_sys_epoll_pwait(i
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
@@ -861,9 +861,11 @@ __SYSCALL(__NR_faccessat2, sys_faccessat
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 #define __NR_watch_mount 441
 __SYSCALL(__NR_watch_mount, sys_watch_mount)
+#define __NR_epoll_pwait2 442
+__SC_COMP(__NR_epoll_pwait2, sys_epoll_pwait2, compat_sys_epoll_pwait2)
 
 #undef __NR_syscalls
-#define __NR_syscalls 442
+#define __NR_syscalls 443
 
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

Patches currently in -mm which might be from willemb@google.com are

epoll-convert-internal-api-to-timespec64.patch
epoll-add-syscall-epoll_pwait2.patch
epoll-wire-up-syscall-epoll_pwait2.patch
selftests-filesystems-expand-epoll-with-epoll_pwait2.patch


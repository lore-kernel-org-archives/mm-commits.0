Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9228EC4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 23:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4478623BA7
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 23:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgLRXPw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 18:15:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgLRXPw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 18:15:52 -0500
Date:   Fri, 18 Dec 2020 15:15:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608333311;
        bh=dbiXbGXqUkhZk6zC8fOGozRVCf00i2d4tenb4rR5/JE=;
        h=From:To:Subject:From;
        b=wTSP1hqZWOKNBmHoTO6JHQDDMWQJxHgVkIX+sYh5Pg7m5zJGNEshWbSf/JUnBW0mA
         kbGDouF8SNgTmOhS7z/5ISr0TTYJoMiGFos/SGAAd9+OpKA7fp32KbRZlafe0x79mE
         5bvi0f4TSHTDjaZASB9gLKXPIRiAbB9GjfTTq9SQ=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org
Subject:  + linux-next-rejects.patch added to -mm tree
Message-ID: <20201218231511.ufGS6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst           |    4 ++--
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
 include/uapi/asm-generic/unistd.h           |    4 +++-
 20 files changed, 24 insertions(+), 4 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~linux-next-rejects
+++ a/Documentation/dev-tools/kasan.rst
@@ -21,8 +21,8 @@ out-of-bounds accesses for global variab
 
 Tag-based KASAN is only supported in Clang.
 
-Currently generic KASAN is supported for the x86_64, arm64, xtensa, s390 and
-and riscv architectures, and tag-based KASAN modes are supported only for arm64.
+Currently generic KASAN is supported for the x86_64, arm, arm64, xtensa, s390
+and riscv architectures, and tag-based KASAN is supported only for arm64.
 
 Usage
 -----
--- a/arch/alpha/kernel/syscalls/syscall.tbl~linux-next-rejects
+++ a/arch/alpha/kernel/syscalls/syscall.tbl
@@ -481,3 +481,4 @@
 549	common	faccessat2			sys_faccessat2
 550	common	process_madvise			sys_process_madvise
 551	common	epoll_pwait2			sys_epoll_pwait2
+552	common	watch_mount			sys_watch_mount
--- a/arch/arm/tools/syscall.tbl~linux-next-rejects
+++ a/arch/arm/tools/syscall.tbl
@@ -455,3 +455,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	epoll_pwait2			sys_epoll_pwait2
+442	common	watch_mount			sys_watch_mount
--- a/arch/arm64/include/asm/unistd.h~linux-next-rejects
+++ a/arch/arm64/include/asm/unistd.h
@@ -38,7 +38,7 @@
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE + 5)
 #define __ARM_NR_COMPAT_END		(__ARM_NR_COMPAT_BASE + 0x800)
 
-#define __NR_compat_syscalls		442
+#define __NR_compat_syscalls		443
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
--- a/arch/arm64/include/asm/unistd32.h~linux-next-rejects
+++ a/arch/arm64/include/asm/unistd32.h
@@ -891,6 +891,8 @@ __SYSCALL(__NR_faccessat2, sys_faccessat
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 #define __NR_epoll_pwait2 441
 __SYSCALL(__NR_epoll_pwait2, sys_epoll_pwait2)
+#define __NR_watch_mount 442
+__SYSCALL(__NR_watch_mount, sys_watch_mount)
 
 /*
  * Please add new compat syscalls above this comment and update
--- a/arch/ia64/kernel/syscalls/syscall.tbl~linux-next-rejects
+++ a/arch/ia64/kernel/syscalls/syscall.tbl
@@ -362,3 +362,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	epoll_pwait2			sys_epoll_pwait2
+442	common	watch_mount			sys_watch_mount
--- a/arch/m68k/kernel/syscalls/syscall.tbl~linux-next-rejects
+++ a/arch/m68k/kernel/syscalls/syscall.tbl
@@ -441,3 +441,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	epoll_pwait2			sys_epoll_pwait2
+442	common	watch_mount			sys_watch_mount
--- a/arch/microblaze/kernel/syscalls/syscall.tbl~linux-next-rejects
+++ a/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -447,3 +447,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	epoll_pwait2			sys_epoll_pwait2
+442	common	watch_mount			sys_watch_mount
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl~linux-next-rejects
+++ a/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -380,3 +380,4 @@
 439	n32	faccessat2			sys_faccessat2
 440	n32	process_madvise			sys_process_madvise
 441	n32	epoll_pwait2			sys_epoll_pwait2
+442	n32	watch_mount			sys_watch_mount
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl~linux-next-rejects
+++ a/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -356,3 +356,4 @@
 439	n64	faccessat2			sys_faccessat2
 440	n64	process_madvise			sys_process_madvise
 441	n64	epoll_pwait2			sys_epoll_pwait2
+442	n64	watch_mount			sys_watch_mount
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~linux-next-rejects
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -429,3 +429,4 @@
 439	o32	faccessat2			sys_faccessat2
 440	o32	process_madvise			sys_process_madvise
 441	o32	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
+442	o32	watch_mount			sys_watch_mount
--- a/arch/parisc/kernel/syscalls/syscall.tbl~linux-next-rejects
+++ a/arch/parisc/kernel/syscalls/syscall.tbl
@@ -439,3 +439,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
+442	common	watch_mount			sys_watch_mount
--- a/arch/powerpc/kernel/syscalls/syscall.tbl~linux-next-rejects
+++ a/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -531,3 +531,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	epoll_pwait2			sys_epoll_pwait2		compat_sys_epoll_pwait2
+442	common	watch_mount			sys_watch_mount
--- a/arch/s390/kernel/syscalls/syscall.tbl~linux-next-rejects
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -444,3 +444,4 @@
 439  common	faccessat2		sys_faccessat2			sys_faccessat2
 440  common	process_madvise		sys_process_madvise		sys_process_madvise
 441  common	epoll_pwait2		sys_epoll_pwait2		sys_epoll_pwait2
+442	common	watch_mount		sys_watch_mount			sys_watch_mount
--- a/arch/sh/kernel/syscalls/syscall.tbl~linux-next-rejects
+++ a/arch/sh/kernel/syscalls/syscall.tbl
@@ -444,3 +444,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	epoll_pwait2			sys_epoll_pwait2
+442	common	watch_mount			sys_watch_mount
--- a/arch/sparc/kernel/syscalls/syscall.tbl~linux-next-rejects
+++ a/arch/sparc/kernel/syscalls/syscall.tbl
@@ -487,3 +487,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	epoll_pwait2			sys_epoll_pwait2
+442	common	watch_mount			sys_watch_mount
--- a/arch/x86/entry/syscalls/syscall_32.tbl~linux-next-rejects
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -446,3 +446,4 @@
 439	i386	faccessat2		sys_faccessat2
 440	i386	process_madvise		sys_process_madvise
 441	i386	epoll_pwait2		sys_epoll_pwait2		compat_sys_epoll_pwait2
+442	i386	watch_mount		sys_watch_mount
--- a/arch/x86/entry/syscalls/syscall_64.tbl~linux-next-rejects
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -363,6 +363,7 @@
 439	common	faccessat2		sys_faccessat2
 440	common	process_madvise		sys_process_madvise
 441	common	epoll_pwait2		sys_epoll_pwait2
+442	common	watch_mount		sys_watch_mount
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
--- a/arch/xtensa/kernel/syscalls/syscall.tbl~linux-next-rejects
+++ a/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -412,3 +412,4 @@
 439	common	faccessat2			sys_faccessat2
 440	common	process_madvise			sys_process_madvise
 441	common	epoll_pwait2			sys_epoll_pwait2
+442	common	watch_mount			sys_watch_mount
--- a/include/uapi/asm-generic/unistd.h~linux-next-rejects
+++ a/include/uapi/asm-generic/unistd.h
@@ -861,9 +861,11 @@ __SYSCALL(__NR_faccessat2, sys_faccessat
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 #define __NR_epoll_pwait2 441
 __SC_COMP(__NR_epoll_pwait2, sys_epoll_pwait2, compat_sys_epoll_pwait2)
+#define __NR_watch_mount 442
+__SYSCALL(__NR_watch_mount, sys_watch_mount)
 
 #undef __NR_syscalls
-#define __NR_syscalls 442
+#define __NR_syscalls 443
 
 /*
  * 32 bit systems traditionally used different
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


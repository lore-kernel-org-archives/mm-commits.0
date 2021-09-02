Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CFE0C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 385B2610CF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347625AbhIBWBd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347929AbhIBWBd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:01:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B338610A0;
        Thu,  2 Sep 2021 22:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620034;
        bh=hdf+tahRSgaRlvPc35IH9rFFkNwCzyXPZRasbjnT7zw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EIK64g3tn3I+gWCzdKwjVbVGsMcQsH9Ljp4AaZGk0s5C+DKv4L3RW7BnUTbgf3Ziw
         U4huOT7RrdaBClC9kNxUMl1HODiiJ7Bx91xPCYcXhE0Lvza2M/W+yHGFWyDVfU7VlX
         jphRyIl06oUhUx3V/dmVygLl2vjdZHJkqeW83nYc=
Date:   Thu, 02 Sep 2021 15:00:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christian.brauner@ubuntu.com,
        david@redhat.com, fweimer@redhat.com, geert@linux-m68k.org,
        guro@fb.com, hannes@cmpxchg.org, hch@infradead.org,
        jannh@google.com, jengelh@inai.de, linux-mm@kvack.org,
        luto@kernel.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, oleg@redhat.com, riel@surriel.com,
        rientjes@google.com, shakeelb@google.com, surenb@google.com,
        timmurray@google.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 199/212] mm: wire up syscall process_mrelease
Message-ID: <20210902220033.zwrUiofAF%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: wire up syscall process_mrelease

Split off from prev patch in the series that implements the syscall.

Link: https://lkml.kernel.org/r/20210809185259.405936-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jan Engelhardt <jengelh@inai.de>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/syscalls/syscall.tbl      |    2 ++
 arch/arm/tools/syscall.tbl                  |    2 ++
 arch/arm64/include/asm/unistd.h             |    2 +-
 arch/arm64/include/asm/unistd32.h           |    2 ++
 arch/ia64/kernel/syscalls/syscall.tbl       |    2 ++
 arch/m68k/kernel/syscalls/syscall.tbl       |    2 ++
 arch/microblaze/kernel/syscalls/syscall.tbl |    2 ++
 arch/mips/kernel/syscalls/syscall_n32.tbl   |    2 ++
 arch/mips/kernel/syscalls/syscall_n64.tbl   |    2 ++
 arch/mips/kernel/syscalls/syscall_o32.tbl   |    2 ++
 arch/parisc/kernel/syscalls/syscall.tbl     |    2 ++
 arch/powerpc/kernel/syscalls/syscall.tbl    |    2 ++
 arch/s390/kernel/syscalls/syscall.tbl       |    2 ++
 arch/sh/kernel/syscalls/syscall.tbl         |    2 ++
 arch/sparc/kernel/syscalls/syscall.tbl      |    2 ++
 arch/x86/entry/syscalls/syscall_32.tbl      |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl      |    1 +
 arch/xtensa/kernel/syscalls/syscall.tbl     |    2 ++
 include/linux/syscalls.h                    |    1 +
 include/uapi/asm-generic/unistd.h           |    4 +++-
 kernel/sys_ni.c                             |    1 +
 21 files changed, 38 insertions(+), 2 deletions(-)

--- a/arch/alpha/kernel/syscalls/syscall.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/alpha/kernel/syscalls/syscall.tbl
@@ -486,3 +486,5 @@
 554	common	landlock_create_ruleset		sys_landlock_create_ruleset
 555	common	landlock_add_rule		sys_landlock_add_rule
 556	common	landlock_restrict_self		sys_landlock_restrict_self
+# 557 reserved for memfd_secret
+558	common	process_mrelease		sys_process_mrelease
--- a/arch/arm64/include/asm/unistd32.h~mm-wire-up-syscall-process_mrelease
+++ a/arch/arm64/include/asm/unistd32.h
@@ -901,6 +901,8 @@ __SYSCALL(__NR_landlock_create_ruleset,
 __SYSCALL(__NR_landlock_add_rule, sys_landlock_add_rule)
 #define __NR_landlock_restrict_self 446
 __SYSCALL(__NR_landlock_restrict_self, sys_landlock_restrict_self)
+#define __NR_process_mrelease 448
+__SYSCALL(__NR_process_mrelease, sys_process_mrelease)
 
 /*
  * Please add new compat syscalls above this comment and update
--- a/arch/arm64/include/asm/unistd.h~mm-wire-up-syscall-process_mrelease
+++ a/arch/arm64/include/asm/unistd.h
@@ -38,7 +38,7 @@
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE + 5)
 #define __ARM_NR_COMPAT_END		(__ARM_NR_COMPAT_BASE + 0x800)
 
-#define __NR_compat_syscalls		447
+#define __NR_compat_syscalls		449
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
--- a/arch/arm/tools/syscall.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/arm/tools/syscall.tbl
@@ -460,3 +460,5 @@
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448	common	process_mrelease		sys_process_mrelease
--- a/arch/ia64/kernel/syscalls/syscall.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/ia64/kernel/syscalls/syscall.tbl
@@ -367,3 +367,5 @@
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448	common	process_mrelease		sys_process_mrelease
--- a/arch/m68k/kernel/syscalls/syscall.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/m68k/kernel/syscalls/syscall.tbl
@@ -446,3 +446,5 @@
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448	common	process_mrelease		sys_process_mrelease
--- a/arch/microblaze/kernel/syscalls/syscall.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -452,3 +452,5 @@
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448	common	process_mrelease		sys_process_mrelease
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -385,3 +385,5 @@
 444	n32	landlock_create_ruleset		sys_landlock_create_ruleset
 445	n32	landlock_add_rule		sys_landlock_add_rule
 446	n32	landlock_restrict_self		sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448	n32	process_mrelease		sys_process_mrelease
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -361,3 +361,5 @@
 444	n64	landlock_create_ruleset		sys_landlock_create_ruleset
 445	n64	landlock_add_rule		sys_landlock_add_rule
 446	n64	landlock_restrict_self		sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448	n64	process_mrelease		sys_process_mrelease
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -434,3 +434,5 @@
 444	o32	landlock_create_ruleset		sys_landlock_create_ruleset
 445	o32	landlock_add_rule		sys_landlock_add_rule
 446	o32	landlock_restrict_self		sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448	o32	process_mrelease		sys_process_mrelease
--- a/arch/parisc/kernel/syscalls/syscall.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/parisc/kernel/syscalls/syscall.tbl
@@ -444,3 +444,5 @@
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448	common	process_mrelease		sys_process_mrelease
--- a/arch/powerpc/kernel/syscalls/syscall.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -526,3 +526,5 @@
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448	common	process_mrelease		sys_process_mrelease
--- a/arch/s390/kernel/syscalls/syscall.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -449,3 +449,5 @@
 444  common	landlock_create_ruleset	sys_landlock_create_ruleset	sys_landlock_create_ruleset
 445  common	landlock_add_rule	sys_landlock_add_rule		sys_landlock_add_rule
 446  common	landlock_restrict_self	sys_landlock_restrict_self	sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448  common	process_mrelease	sys_process_mrelease		sys_process_mrelease
--- a/arch/sh/kernel/syscalls/syscall.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/sh/kernel/syscalls/syscall.tbl
@@ -449,3 +449,5 @@
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448	common	process_mrelease		sys_process_mrelease
--- a/arch/sparc/kernel/syscalls/syscall.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/sparc/kernel/syscalls/syscall.tbl
@@ -492,3 +492,5 @@
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448	common	process_mrelease		sys_process_mrelease
--- a/arch/x86/entry/syscalls/syscall_32.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -452,3 +452,4 @@
 445	i386	landlock_add_rule	sys_landlock_add_rule
 446	i386	landlock_restrict_self	sys_landlock_restrict_self
 447	i386	memfd_secret		sys_memfd_secret
+448	i386	process_mrelease	sys_process_mrelease
--- a/arch/x86/entry/syscalls/syscall_64.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -369,6 +369,7 @@
 445	common	landlock_add_rule	sys_landlock_add_rule
 446	common	landlock_restrict_self	sys_landlock_restrict_self
 447	common	memfd_secret		sys_memfd_secret
+448	common	process_mrelease	sys_process_mrelease
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
--- a/arch/xtensa/kernel/syscalls/syscall.tbl~mm-wire-up-syscall-process_mrelease
+++ a/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -417,3 +417,5 @@
 444	common	landlock_create_ruleset		sys_landlock_create_ruleset
 445	common	landlock_add_rule		sys_landlock_add_rule
 446	common	landlock_restrict_self		sys_landlock_restrict_self
+# 447 reserved for memfd_secret
+448	common	process_mrelease		sys_process_mrelease
--- a/include/linux/syscalls.h~mm-wire-up-syscall-process_mrelease
+++ a/include/linux/syscalls.h
@@ -915,6 +915,7 @@ asmlinkage long sys_mincore(unsigned lon
 asmlinkage long sys_madvise(unsigned long start, size_t len, int behavior);
 asmlinkage long sys_process_madvise(int pidfd, const struct iovec __user *vec,
 			size_t vlen, int behavior, unsigned int flags);
+asmlinkage long sys_process_mrelease(int pidfd, unsigned int flags);
 asmlinkage long sys_remap_file_pages(unsigned long start, unsigned long size,
 			unsigned long prot, unsigned long pgoff,
 			unsigned long flags);
--- a/include/uapi/asm-generic/unistd.h~mm-wire-up-syscall-process_mrelease
+++ a/include/uapi/asm-generic/unistd.h
@@ -877,9 +877,11 @@ __SYSCALL(__NR_landlock_restrict_self, s
 #define __NR_memfd_secret 447
 __SYSCALL(__NR_memfd_secret, sys_memfd_secret)
 #endif
+#define __NR_process_mrelease 448
+__SYSCALL(__NR_process_mrelease, sys_process_mrelease)
 
 #undef __NR_syscalls
-#define __NR_syscalls 448
+#define __NR_syscalls 449
 
 /*
  * 32 bit systems traditionally used different
--- a/kernel/sys_ni.c~mm-wire-up-syscall-process_mrelease
+++ a/kernel/sys_ni.c
@@ -289,6 +289,7 @@ COND_SYSCALL(munlockall);
 COND_SYSCALL(mincore);
 COND_SYSCALL(madvise);
 COND_SYSCALL(process_madvise);
+COND_SYSCALL(process_mrelease);
 COND_SYSCALL(remap_file_pages);
 COND_SYSCALL(mbind);
 COND_SYSCALL_COMPAT(mbind);
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3AAC433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 22:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B03BC61433
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 22:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhEMWMp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 18:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhEMWMo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 18:12:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B7D4610F7;
        Thu, 13 May 2021 22:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620943893;
        bh=svPE8WUHPK40zNu5Dz0tzrL2aTPlv6kxzekJItYA458=;
        h=Date:From:To:Subject:From;
        b=u0WXU9ZInGSEr7siK/ILDBIJenlIi2RszJZZg2C6R5fkX6nqpO3m0Spu077aFnP0B
         NZ1Go3uwJMzzcghlFhftBlvUbUxy7Jstfs+/moGtGEVUsf6Xi/WdpDzRTbsJFhHLbV
         kvk7ojIu0rwJ7DOgPt26f9owjU5InodzcGl+5W/A=
Date:   Thu, 13 May 2021 15:11:31 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, elena.reshetova@intel.com, guro@fb.com,
        hagen@jauu.net, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, kirill@shutemov.name,
        lkp@intel.com, luto@kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, tycho@tycho.ws, viro@zeniv.linux.org.uk,
        will@kernel.org, willy@infradead.org
Subject:  +
 arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch added to -mm
 tree
Message-ID: <20210513221131.0wECrDK8j%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch, mm: wire up memfd_secret system call where relevant
has been added to the -mm tree.  Its filename is
     arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arch, mm: wire up memfd_secret system call where relevant

Wire up memfd_secret system call on architectures that define
ARCH_HAS_SET_DIRECT_MAP, namely arm64, risc-v and x86.

Link: https://lkml.kernel.org/r/20210513184734.29317-8-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/uapi/asm/unistd.h   |    1 +
 arch/riscv/include/asm/unistd.h        |    1 +
 arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h               |    1 +
 include/uapi/asm-generic/unistd.h      |    7 ++++++-
 scripts/checksyscalls.sh               |    4 ++++
 7 files changed, 15 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/uapi/asm/unistd.h~arch-mm-wire-up-memfd_secret-system-call-where-relevant
+++ a/arch/arm64/include/uapi/asm/unistd.h
@@ -20,5 +20,6 @@
 #define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_TIME32_SYSCALLS
 #define __ARCH_WANT_SYS_CLONE3
+#define __ARCH_WANT_MEMFD_SECRET
 
 #include <asm-generic/unistd.h>
--- a/arch/riscv/include/asm/unistd.h~arch-mm-wire-up-memfd_secret-system-call-where-relevant
+++ a/arch/riscv/include/asm/unistd.h
@@ -9,6 +9,7 @@
  */
 
 #define __ARCH_WANT_SYS_CLONE
+#define __ARCH_WANT_MEMFD_SECRET
 
 #include <uapi/asm/unistd.h>
 
--- a/arch/x86/entry/syscalls/syscall_32.tbl~arch-mm-wire-up-memfd_secret-system-call-where-relevant
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -451,3 +451,4 @@
 444	i386	landlock_create_ruleset	sys_landlock_create_ruleset
 445	i386	landlock_add_rule	sys_landlock_add_rule
 446	i386	landlock_restrict_self	sys_landlock_restrict_self
+447	i386	memfd_secret		sys_memfd_secret
--- a/arch/x86/entry/syscalls/syscall_64.tbl~arch-mm-wire-up-memfd_secret-system-call-where-relevant
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -368,6 +368,7 @@
 444	common	landlock_create_ruleset	sys_landlock_create_ruleset
 445	common	landlock_add_rule	sys_landlock_add_rule
 446	common	landlock_restrict_self	sys_landlock_restrict_self
+447	common	memfd_secret		sys_memfd_secret
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
--- a/include/linux/syscalls.h~arch-mm-wire-up-memfd_secret-system-call-where-relevant
+++ a/include/linux/syscalls.h
@@ -1050,6 +1050,7 @@ asmlinkage long sys_landlock_create_rule
 asmlinkage long sys_landlock_add_rule(int ruleset_fd, enum landlock_rule_type rule_type,
 		const void __user *rule_attr, __u32 flags);
 asmlinkage long sys_landlock_restrict_self(int ruleset_fd, __u32 flags);
+asmlinkage long sys_memfd_secret(unsigned int flags);
 
 /*
  * Architecture-specific system calls
--- a/include/uapi/asm-generic/unistd.h~arch-mm-wire-up-memfd_secret-system-call-where-relevant
+++ a/include/uapi/asm-generic/unistd.h
@@ -873,8 +873,13 @@ __SYSCALL(__NR_landlock_add_rule, sys_la
 #define __NR_landlock_restrict_self 446
 __SYSCALL(__NR_landlock_restrict_self, sys_landlock_restrict_self)
 
+#ifdef __ARCH_WANT_MEMFD_SECRET
+#define __NR_memfd_secret 447
+__SYSCALL(__NR_memfd_secret, sys_memfd_secret)
+#endif
+
 #undef __NR_syscalls
-#define __NR_syscalls 447
+#define __NR_syscalls 448
 
 /*
  * 32 bit systems traditionally used different
--- a/scripts/checksyscalls.sh~arch-mm-wire-up-memfd_secret-system-call-where-relevant
+++ a/scripts/checksyscalls.sh
@@ -40,6 +40,10 @@ cat << EOF
 #define __IGNORE_setrlimit	/* setrlimit */
 #endif
 
+#ifndef __ARCH_WANT_MEMFD_SECRET
+#define __IGNORE_memfd_secret
+#endif
+
 /* Missing flags argument */
 #define __IGNORE_renameat	/* renameat2 */
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-mmzoneh-simplify-is_highmem_idx.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
memblock-update-initialization-of-reserved-pages.patch
arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch


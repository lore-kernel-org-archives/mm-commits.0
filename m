Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AA9C2D0E4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 22:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0E312222F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 22:14:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="SM9wbzsE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgKLWOj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:14:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727214AbgKLWOj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 17:14:39 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72BCF20709;
        Thu, 12 Nov 2020 22:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605219277;
        bh=9yg8HrlT6pLaypWbjo7zZnjKAC+4Awejnb21VUTQ2QQ=;
        h=Date:From:To:Subject:From;
        b=SM9wbzsEI7qfDwNtrxaDgpLVFLpQTiM0oHcD8V/IWIXAmzJTDFC6a04iH68pS4fgG
         PFNXFCrkmWrRRqr/Jlu6cQfvbmJPfK4R5RdVGDcmBDvJFmTu38z3QMUBsMN4aTW3SY
         lAExj/atbT2xI12JU05PQCnKcav1KOebO+cchY1I=
Date:   Thu, 12 Nov 2020 14:14:35 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, elena.reshetova@intel.com, hagen@jauu.net,
        hpa@zytor.com, jejb@linux.ibm.com, kirill@shutemov.name,
        luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mtk.manpages@gmail.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shuah@kernel.org, tglx@linutronix.de,
        tycho@tycho.ws, viro@zeniv.linux.org.uk, will@kernel.org,
        willy@infradead.org
Subject:  +
 arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch added to -mm
 tree
Message-ID: <20201112221435.kcHbQbwKo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch, mm: wire up memfd_secret system call were relevant
has been added to the -mm tree.  Its filename is
     arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch

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
Subject: arch, mm: wire up memfd_secret system call were relevant

Wire up memfd_secret system call on architectures that define
ARCH_HAS_SET_DIRECT_MAP, namely arm64, risc-v and x86.

Link: https://lkml.kernel.org/r/20201110151444.20662-9-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/unistd.h        |    2 +-
 arch/arm64/include/asm/unistd32.h      |    2 ++
 arch/arm64/include/uapi/asm/unistd.h   |    1 +
 arch/riscv/include/asm/unistd.h        |    1 +
 arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h               |    1 +
 include/uapi/asm-generic/unistd.h      |    6 +++++-
 scripts/checksyscalls.sh               |    4 ++++
 9 files changed, 17 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/unistd32.h~arch-mm-wire-up-memfd_secret-system-call-were-relevant
+++ a/arch/arm64/include/asm/unistd32.h
@@ -891,6 +891,8 @@ __SYSCALL(__NR_faccessat2, sys_faccessat
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 #define __NR_watch_mount 441
 __SYSCALL(__NR_watch_mount, sys_watch_mount)
+#define __NR_memfd_secret 442
+__SYSCALL(__NR_memfd_secret, sys_memfd_secret)
 
 /*
  * Please add new compat syscalls above this comment and update
--- a/arch/arm64/include/asm/unistd.h~arch-mm-wire-up-memfd_secret-system-call-were-relevant
+++ a/arch/arm64/include/asm/unistd.h
@@ -38,7 +38,7 @@
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE + 5)
 #define __ARM_NR_COMPAT_END		(__ARM_NR_COMPAT_BASE + 0x800)
 
-#define __NR_compat_syscalls		442
+#define __NR_compat_syscalls		443
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
--- a/arch/arm64/include/uapi/asm/unistd.h~arch-mm-wire-up-memfd_secret-system-call-were-relevant
+++ a/arch/arm64/include/uapi/asm/unistd.h
@@ -20,5 +20,6 @@
 #define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_TIME32_SYSCALLS
 #define __ARCH_WANT_SYS_CLONE3
+#define __ARCH_WANT_MEMFD_SECRET
 
 #include <asm-generic/unistd.h>
--- a/arch/riscv/include/asm/unistd.h~arch-mm-wire-up-memfd_secret-system-call-were-relevant
+++ a/arch/riscv/include/asm/unistd.h
@@ -9,6 +9,7 @@
  */
 
 #define __ARCH_WANT_SYS_CLONE
+#define __ARCH_WANT_MEMFD_SECRET
 
 #include <uapi/asm/unistd.h>
 
--- a/arch/x86/entry/syscalls/syscall_32.tbl~arch-mm-wire-up-memfd_secret-system-call-were-relevant
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -446,3 +446,4 @@
 439	i386	faccessat2		sys_faccessat2
 440	i386	process_madvise		sys_process_madvise
 441	i386	watch_mount		sys_watch_mount
+442	i386	memfd_secret		sys_memfd_secret
--- a/arch/x86/entry/syscalls/syscall_64.tbl~arch-mm-wire-up-memfd_secret-system-call-were-relevant
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -363,6 +363,7 @@
 439	common	faccessat2		sys_faccessat2
 440	common	process_madvise		sys_process_madvise
 441	common	watch_mount		sys_watch_mount
+442	common	memfd_secret		sys_memfd_secret
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
--- a/include/linux/syscalls.h~arch-mm-wire-up-memfd_secret-system-call-were-relevant
+++ a/include/linux/syscalls.h
@@ -1010,6 +1010,7 @@ asmlinkage long sys_pidfd_send_signal(in
 asmlinkage long sys_pidfd_getfd(int pidfd, int fd, unsigned int flags);
 asmlinkage long sys_watch_mount(int dfd, const char __user *path,
 				unsigned int at_flags, int watch_fd, int watch_id);
+asmlinkage long sys_memfd_secret(unsigned long flags);
 
 /*
  * Architecture-specific system calls
--- a/include/uapi/asm-generic/unistd.h~arch-mm-wire-up-memfd_secret-system-call-were-relevant
+++ a/include/uapi/asm-generic/unistd.h
@@ -861,9 +861,13 @@ __SYSCALL(__NR_faccessat2, sys_faccessat
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 #define __NR_watch_mount 441
 __SYSCALL(__NR_watch_mount, sys_watch_mount)
+#ifdef __ARCH_WANT_MEMFD_SECRET
+#define __NR_memfd_secret 442
+__SYSCALL(__NR_memfd_secret, sys_memfd_secret)
+#endif
 
 #undef __NR_syscalls
-#define __NR_syscalls 442
+#define __NR_syscalls 443
 
 /*
  * 32 bit systems traditionally used different
--- a/scripts/checksyscalls.sh~arch-mm-wire-up-memfd_secret-system-call-were-relevant
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

alpha-switch-from-discontigmem-to-sparsemem.patch
ia64-remove-custom-__early_pfn_to_nid.patch
ia64-remove-ifdef-config_zone_dma32-statements.patch
ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch
ia64-split-virtual-map-initialization-out-of-paging_init.patch
ia64-forbid-using-virtual_mem_map-with-flatmem.patch
ia64-make-sparsemem-default-and-disable-discontigmem.patch
arm-remove-config_arch_has_holes_memorymodel.patch
arm-arm64-move-free_unused_memmap-to-generic-mm.patch
arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch
m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch
m68k-deprecate-discontigmem.patch
mm-introduce-debug_pagealloc_mapunmap_pages-helpers.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-on-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch


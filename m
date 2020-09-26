Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2496DC4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D82A721741
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087855;
	bh=xoW7HULL0cnbyXOn8mj1Z1P3rVHiWtDZSnOCz4sbKrg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=d1ufI4jXi01zYLRNdL7E0ieG2JXnTWncGuJ2WbBEMC7VuDMKQQOjlQ1rZOB0D1Cio
	 4sdis9WZ954carqOvaLuIfqDzro1eOmMa0K7CUTgdk2pu20sYl0IErbBZV60ROAUjg
	 aaYgZBZYq88ZOgRT4SFhE0M4mAZQ1z+N3cOojF5k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgIZChf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgIZChf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:37:35 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19A9020BED;
        Sat, 26 Sep 2020 02:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087854;
        bh=xoW7HULL0cnbyXOn8mj1Z1P3rVHiWtDZSnOCz4sbKrg=;
        h=Date:From:To:Subject:From;
        b=uyKyvlqDm3A9Ne9IHz6PZsVAHzyjUft/A5oPPulVSvLEhvlPSYew8zkVhgqsky/kV
         rnpR+6ATSsQTakU5OvQCkPdPIIbvmXK7FDt16VDzRLUt6lwQPkmJgiY1oDM+HlPech
         sVIUiaOk6OqX3i+ulgpsI0J7yTUVYuJfEKYhsLpQ=
Date:   Fri, 25 Sep 2020 19:37:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        viro@zeniv.linux.org.uk, tycho@tycho.ws, tglx@linutronix.de,
        shuah@kernel.org, peterz@infradead.org, paul.walmsley@sifive.com,
        palmerdabbelt@google.com, palmer@dabbelt.com,
        mtk.manpages@gmail.com, mingo@redhat.com, mark.rutland@arm.com,
        luto@kernel.org, kirill@shutemov.name, jejb@linux.ibm.com,
        idan.yaniv@ibm.com, hpa@zytor.com, elena.reshetova@intel.com,
        david@redhat.com, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, cl@linux.com, catalin.marinas@arm.com,
        bp@alien8.de, arnd@arndb.de, rppt@linux.ibm.com
Subject:  [to-be-updated]
 arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch removed from -mm
 tree
Message-ID: <20200926023732.mH516%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch, mm: wire up memfd_secret system call were relevant
has been removed from the -mm tree.  Its filename was
     arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arch, mm: wire up memfd_secret system call were relevant

Wire up memfd_secret system call on architectures that define
ARCH_HAS_SET_DIRECT_MAP, namely arm64, risc-v and x86.

Link: https://lkml.kernel.org/r/20200924132904.1391-5-rppt@kernel.org
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
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Idan Yaniv <idan.yaniv@ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
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
 include/uapi/asm-generic/unistd.h      |    7 ++++++-
 scripts/checksyscalls.sh               |    4 ++++
 9 files changed, 18 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/unistd32.h~arch-mm-wire-up-memfd_secret-system-call-were-relevant
+++ a/arch/arm64/include/asm/unistd32.h
@@ -891,6 +891,8 @@ __SYSCALL(__NR_faccessat2, sys_faccessat
 __SYSCALL(__NR_watch_mount, sys_watch_mount)
 #define __NR_process_madvise 441
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
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
 440	i386	watch_mount		sys_watch_mount
 441	i386	process_madvise		sys_process_madvise
+442	i386	memfd_secret		sys_memfd_secret
--- a/arch/x86/entry/syscalls/syscall_64.tbl~arch-mm-wire-up-memfd_secret-system-call-were-relevant
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -363,6 +363,7 @@
 439	common	faccessat2		sys_faccessat2
 440	common	watch_mount		sys_watch_mount
 441	common	process_madvise		sys_process_madvise
+442	common	memfd_secret		sys_memfd_secret
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
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
@@ -864,8 +864,13 @@ __SYSCALL(__NR_watch_mount, sys_watch_mo
 #define __NR_process_madvise 441
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 
+#ifdef __ARCH_WANT_MEMFD_SECRET
+#define __NR_memfd_secret 440
+__SYSCALL(__NR_memfd_secret, sys_memfd_secret)
+#endif
+
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

mm-account-pmd-tables-like-pte-tables-fix.patch
kvm-ppc-book3s-hv-simplify-kvm_cma_reserve.patch
dma-contiguous-simplify-cma_early_percent_memory.patch
arm-xtensa-simplify-initialization-of-high-memory-pages.patch
arm64-numa-simplify-dummy_numa_init.patch
h8300-nds32-openrisc-simplify-detection-of-memory-extents.patch
riscv-drop-unneeded-node-initialization.patch
mircoblaze-drop-unneeded-numa-and-sparsemem-initializations.patch
memblock-make-for_each_memblock_type-iterator-private.patch
memblock-make-memblock_debug-and-related-functionality-private.patch
memblock-reduce-number-of-parameters-in-for_each_mem_range.patch
arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch
x86-setup-simplify-initrd-relocation-and-reservation.patch
x86-setup-simplify-reserve_crashkernel.patch
memblock-remove-unused-memblock_mem_size.patch
memblock-implement-for_each_reserved_mem_region-using-__next_mem_region.patch
memblock-use-separate-iterators-for-memory-and-reserved-regions.patch
mm-remove-unused-early_pfn_valid.patch
mm-secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch


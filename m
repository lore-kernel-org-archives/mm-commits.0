Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8EB10F7
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235290; cv=none; b=D+1HTYr6qm7XQ2hm7ebWl/Y9IfgJkzgwhnpr7lT816effaR/u5nmW30Eg85qsUJErh23b5YXmag5S2dVsblWrUsFkDLKOOFeIRsGXPyS7iK3kDpkIdsYa8wqvOZ39+OgF9A3cygmgeZ/gkObx4imBGlYnEYmpPv31+pZ0B3kkRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235290; c=relaxed/simple;
	bh=aKkCjiuOODZyhw6TyTmHTF6+/iy9If1s+suh2rTUtqc=;
	h=Date:To:From:Subject:Message-Id; b=iIetOj0UbVTsrFgsEv8znk1MuIMV4xFbgROKLVu33Pq9KjvfWcUH2LVGRiP1sZ0HoQInzDNWI2tSDXBrPNXvPihVwwHtnATojhmhVIwFcJh9ytfwaSCatKmi0/fo2h1O9/8G26dbWJwI9Hk5LNuMXV2Gk4PwvsGlHH1yIure6bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NvZUhxmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NvZUhxmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08BAC433F1;
	Fri, 26 Jan 2024 02:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235290;
	bh=aKkCjiuOODZyhw6TyTmHTF6+/iy9If1s+suh2rTUtqc=;
	h=Date:To:From:Subject:From;
	b=NvZUhxmGij5DxBarOrP1hcmBBNrNKQsP4YMGVLX+UNgolZOlcpXdn4ddf3w8enEgS
	 M19vZ0LrVVtrWpyW5de4rZemZYyDlFTKilskcMQ7cZ+3N7+FW7aBesDQg+DpveBIib
	 o1L97tBcJRKjFzbGT8k/hoqH6750rfqGXbXDvzpc=
Date: Thu, 25 Jan 2024 18:14:47 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-remove-thumb2-__builtin_thread_pointer-workaround-for-clang.patch added to mm-nonmm-unstable branch
Message-Id: <20240126021449.A08BAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ARM: remove Thumb2 __builtin_thread_pointer workaround for Clang
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm-remove-thumb2-__builtin_thread_pointer-workaround-for-clang.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-remove-thumb2-__builtin_thread_pointer-workaround-for-clang.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: ARM: remove Thumb2 __builtin_thread_pointer workaround for Clang
Date: Thu, 25 Jan 2024 15:55:10 -0700

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, the conditional expression added to get_current()
by commit c1e42efacb9b ("ARM: 9151/1: Thumb2: avoid
__builtin_thread_pointer() on Clang") is always true, as the build will
fail during the configuration stage for older LLVM versions.  Remove it,
effectively reverting the aforementioned change.

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-4-f5ff9bda41c5@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Conor Dooley <conor@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/current.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/arm/include/asm/current.h~arm-remove-thumb2-__builtin_thread_pointer-workaround-for-clang
+++ a/arch/arm/include/asm/current.h
@@ -18,18 +18,12 @@ static __always_inline __attribute_const
 {
 	struct task_struct *cur;
 
-#if __has_builtin(__builtin_thread_pointer) && \
-    defined(CONFIG_CURRENT_POINTER_IN_TPIDRURO) && \
-    !(defined(CONFIG_THUMB2_KERNEL) && \
-      defined(CONFIG_CC_IS_CLANG) && CONFIG_CLANG_VERSION < 130001)
+#if __has_builtin(__builtin_thread_pointer) && defined(CONFIG_CURRENT_POINTER_IN_TPIDRURO)
 	/*
 	 * Use the __builtin helper when available - this results in better
 	 * code, especially when using GCC in combination with the per-task
 	 * stack protector, as the compiler will recognize that it needs to
 	 * load the TLS register only once in every function.
-	 *
-	 * Clang < 13.0.1 gets this wrong for Thumb2 builds:
-	 * https://github.com/ClangBuiltLinux/linux/issues/1485
 	 */
 	cur = __builtin_thread_pointer();
 #elif defined(CONFIG_CURRENT_POINTER_IN_TPIDRURO) || defined(CONFIG_SMP)
_

Patches currently in -mm which might be from nathan@kernel.org are

selftests-bpf-update-llvm-phabricator-links.patch
arch-and-include-update-llvm-phabricator-links.patch
treewide-update-llvm-bugzilla-links.patch
kbuild-raise-the-minimum-supported-version-of-llvm-to-1301.patch
makefile-drop-warn-stack-size-plugin-opt.patch
x86-drop-stack-alignment-plugin-opt.patch
arm-remove-thumb2-__builtin_thread_pointer-workaround-for-clang.patch
arm64-kconfig-clean-up-tautological-llvm-version-checks.patch
powerpc-kconfig-remove-tautology-in-config_compat.patch
riscv-remove-mcount_name-workaround.patch
riscv-kconfig-remove-version-dependency-from-config_clang_supports_dynamic_ftrace.patch
fortify-drop-clang-version-check-for-1201-or-newer.patch
lib-kconfigdebug-update-clang-version-check-in-config_kcov.patch
compiler-clangh-update-__diag_clang-macros-for-minimum-version-bump.patch


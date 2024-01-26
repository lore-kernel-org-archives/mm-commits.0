Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2111C13
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235280; cv=none; b=lz/a7Ei+2jdsQg4mYGVQh/mfJXI2PWPeEx9MGV1UTP+A/8WmnE/Jnxe90wotPsgQJv3pgPhhE3YkW4myA+IVGR6cGfwfhYzJ/RjNkP0Uy/zk1cKe6GSFANRcMsYqwyTNkpX/oZMPC5PZfJ1kADOMRe8OmLRTOoE/62k//v+E6AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235280; c=relaxed/simple;
	bh=tB9Wxk+j6V1r3Po0PYO2Eore4md3Zx3l9Sg4riy/VoQ=;
	h=Date:To:From:Subject:Message-Id; b=KDUcC9iOww1AgQq88qepUOo7MH0jfd2m0aJKHHFPpESHc7m/sMJLe/rx1ghEmT3MOD6U6sn9AqtmxfWR5siSXz2I1Ry8gGa3vE9jMiyHWQAxsf/c+rf98GvgjomeWLGCdwyh8kihzrw5G+MNN1R72tKvPLE8+B5bRDKsZgDRBPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nOcL8exc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nOcL8exc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA09C433C7;
	Fri, 26 Jan 2024 02:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235279;
	bh=tB9Wxk+j6V1r3Po0PYO2Eore4md3Zx3l9Sg4riy/VoQ=;
	h=Date:To:From:Subject:From;
	b=nOcL8excV42Z/B25M9iwkzRE495pFN65Q+RtTe53gk1X6k1wSau6oPfoN85GSqrLY
	 vJIuqoTqFGlds5loc6KNja5tO2OnTzDa8+S7GzgBMgIZqg4krK+pkInybeaCfdxoHB
	 f1JmoCRXklpomrzQiOK4D6D79e04OY1PNv47Tv60=
Date: Thu, 25 Jan 2024 18:14:36 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-drop-stack-alignment-plugin-opt.patch added to mm-nonmm-unstable branch
Message-Id: <20240126021439.0BA09C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: drop stack-alignment plugin opt
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-drop-stack-alignment-plugin-opt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-drop-stack-alignment-plugin-opt.patch

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
Subject: x86: drop stack-alignment plugin opt
Date: Thu, 25 Jan 2024 15:55:09 -0700

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, the inner ifeq statement is always false, as the
build will fail during the configuration stage for older LLVM versions.

This effectively reverts part of commit b33fff07e3e3 ("x86, build: allow
LTO to be selected") and its follow up fix, commit 2398ce80152a ("x86,
lto: Pass -stack-alignment only on LLD < 13.0.0").

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-3-f5ff9bda41c5@kernel.org
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

 arch/x86/Makefile |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/x86/Makefile~x86-drop-stack-alignment-plugin-opt
+++ a/arch/x86/Makefile
@@ -217,12 +217,6 @@ endif
 
 KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
 
-ifdef CONFIG_LTO_CLANG
-ifeq ($(call test-lt, $(CONFIG_LLD_VERSION), 130000),y)
-KBUILD_LDFLAGS	+= -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
-endif
-endif
-
 ifdef CONFIG_X86_NEED_RELOCS
 LDFLAGS_vmlinux := --emit-relocs --discard-none
 else
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


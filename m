Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234051864
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235287; cv=none; b=d+mVoUSb8LBAx/wWX4or9V39qpnu+w6srCJ4gDoc1wueHMX+9J06PlQfGKLhZbyGXi17QMl3kJC75Aj4sWMwI2fxyIVMqgplPsRyUQbzFzWuCpP/UE1cK3+dvf2ApxfoSkSqdiPKnrpNzYJNB67G05XtHTmK8kvG8EFsvz2FdyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235287; c=relaxed/simple;
	bh=6ijg6LesWxm+WH4vAOfWxAOwv6mcPspaTOcipFCPR28=;
	h=Date:To:From:Subject:Message-Id; b=FZRTT4eOuDr4KR2/9bdntUhKja0cMrlqkozgLzA8gbgsraak6r5fPx6NAfIW7Us+ngLzyNsjJ+TvawOAseEEgXCDLtDgPvOEMrlTGfdOCOkI1WmCTzXeebttzmJSnEa4uy4ans3tvKM1gmlaxQxV6eFhccOVvgvSIcm50EqIaf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cvwDRdvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cvwDRdvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AC5C433F1;
	Fri, 26 Jan 2024 02:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235286;
	bh=6ijg6LesWxm+WH4vAOfWxAOwv6mcPspaTOcipFCPR28=;
	h=Date:To:From:Subject:From;
	b=cvwDRdvwJwwm6+WWYXMius8IjC8yqZWBn5Cko+JqJTuNqC86li1YQYzi/A1xcy5CS
	 wHyzLZYYiGdEAKh5UZdEu3eg1WgjyF6YhI9XitFia0OvLJW65CY133Qv9uxXEySUNK
	 PH9itcW+Pf9HK4Z2pfx5Z9VQHNCEyUDc9g9jPRPE=
Date: Thu, 25 Jan 2024 18:14:43 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-kconfig-clean-up-tautological-llvm-version-checks.patch added to mm-nonmm-unstable branch
Message-Id: <20240126021446.21AC5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: Kconfig: clean up tautological LLVM version checks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm64-kconfig-clean-up-tautological-llvm-version-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-kconfig-clean-up-tautological-llvm-version-checks.patch

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
Subject: arm64: Kconfig: clean up tautological LLVM version checks
Date: Thu, 25 Jan 2024 15:55:11 -0700

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, several conditions become tautologies, as they will
always be true because the build will fail during the configuration stage
for older LLVM versions.  Drop them, as they are unnecessary.

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-5-f5ff9bda41c5@kernel.org
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

 arch/arm64/Kconfig |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/arm64/Kconfig~arm64-kconfig-clean-up-tautological-llvm-version-checks
+++ a/arch/arm64/Kconfig
@@ -384,7 +384,7 @@ config BUILTIN_RETURN_ADDRESS_STRIPS_PAC
 	bool
 	# Clang's __builtin_return_adddress() strips the PAC since 12.0.0
 	# https://github.com/llvm/llvm-project/commit/2a96f47c5ffca84cd774ad402cacd137f4bf45e2
-	default y if CC_IS_CLANG && (CLANG_VERSION >= 120000)
+	default y if CC_IS_CLANG
 	# GCC's __builtin_return_address() strips the PAC since 11.1.0,
 	# and this was backported to 10.2.0, 9.4.0, 8.5.0, but not earlier
 	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94891
@@ -1388,7 +1388,6 @@ choice
 
 config CPU_BIG_ENDIAN
 	bool "Build big-endian kernel"
-	depends on !LD_IS_LLD || LLD_VERSION >= 130000
 	# https://github.com/llvm/llvm-project/commit/1379b150991f70a5782e9a143c2ba5308da1161c
 	depends on AS_IS_GNU || AS_VERSION >= 150000
 	help
@@ -2019,8 +2018,6 @@ config ARM64_BTI_KERNEL
 	depends on !CC_IS_GCC || GCC_VERSION >= 100100
 	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106671
 	depends on !CC_IS_GCC
-	# https://github.com/llvm/llvm-project/commit/a88c722e687e6780dcd6a58718350dc76fcc4cc9
-	depends on !CC_IS_CLANG || CLANG_VERSION >= 120000
 	depends on (!FUNCTION_GRAPH_TRACER || DYNAMIC_FTRACE_WITH_ARGS)
 	help
 	  Build the kernel with Branch Target Identification annotations
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


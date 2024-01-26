Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7387E3232
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235312; cv=none; b=nYdY0fD9zoegK3BWNdnY5HTcq1s8y22an47JDQ50nD3z23OLc752hV50aB9CaJFuyrSUk88zVc+5tHXG1tcwptgNPQdsApp2TwbLgmBkocrMyfslwOYR3WZKQWmIKQXLmbTdOPBWJjI/zpkzhlkuCjK8SAhpx9v2nTgqFbzPXuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235312; c=relaxed/simple;
	bh=VROcE70pNfsE2BkUehm5J29fAuEwg7A0GvTpbLFxGao=;
	h=Date:To:From:Subject:Message-Id; b=XFLAP7lzpnAp+bnirjOI/P1Ubjh4xv990olUhWUlGmmNQzIoQt+EAq4TEuHJtLE8QhzGv4wFC58+xFaIgJwXdDfD1aROrsujAFLauO9CqZFoAfQEikAPGB8lCLSEG7zFfqyXWjwcIraNCT+X2qnf9eoNyv/6TkVb0hK+9PTKClE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gZ943KD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gZ943KD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6504FC433F1;
	Fri, 26 Jan 2024 02:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235311;
	bh=VROcE70pNfsE2BkUehm5J29fAuEwg7A0GvTpbLFxGao=;
	h=Date:To:From:Subject:From;
	b=gZ943KD0eoxVIt7uHL3LI3g4dutewk9xWeoqX/pMSYHgwbaYRDE8sZUYgYCpHoO+P
	 eAkAijsgdgkIza4SEA0TOli8kYYJS70yKzyJsc2ZrbQfnhBC/YjOoIApaO1eJP5mRW
	 d/eHJa9HZ1bXCoGeMqUv/ZV1ONO4PaZbzujwpcLQ=
Date: Thu, 25 Jan 2024 18:15:08 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfigdebug-update-clang-version-check-in-config_kcov.patch added to mm-nonmm-unstable branch
Message-Id: <20240126021511.6504FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/Kconfig.debug: update Clang version check in CONFIG_KCOV
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kconfigdebug-update-clang-version-check-in-config_kcov.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kconfigdebug-update-clang-version-check-in-config_kcov.patch

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
Subject: lib/Kconfig.debug: update Clang version check in CONFIG_KCOV
Date: Thu, 25 Jan 2024 15:55:16 -0700

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, this condition can be changed to just
CONFIG_CC_IS_CLANG, as the build will fail during the configuration stage
for older LLVM versions.

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-10-f5ff9bda41c5@kernel.org
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

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-update-clang-version-check-in-config_kcov
+++ a/lib/Kconfig.debug
@@ -2085,7 +2085,7 @@ config KCOV
 	depends on ARCH_HAS_KCOV
 	depends on CC_HAS_SANCOV_TRACE_PC || GCC_PLUGINS
 	depends on !ARCH_WANTS_NO_INSTR || HAVE_NOINSTR_HACK || \
-		   GCC_VERSION >= 120000 || CLANG_VERSION >= 130000
+		   GCC_VERSION >= 120000 || CC_IS_CLANG
 	select DEBUG_FS
 	select GCC_PLUGIN_SANCOV if !CC_HAS_SANCOV_TRACE_PC
 	select OBJTOOL if HAVE_NOINSTR_HACK
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


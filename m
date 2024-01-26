Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8194687
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235308; cv=none; b=CWae2oAZ3mjTKk6FTE83r+y6zwu7wo/39Ath5daLslzvEo92Jodjr4stJ/rB/wV/p3vG5PxzaMs/rvIOHhofNqOQ4DSdHx3C2GqAyV9s+bDyoI4My924CY6q/TsgrBlndAl1cM5bh9BCLvqRo1S9juUUSjDoYK5TWzA7o0ROZLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235308; c=relaxed/simple;
	bh=6byrbjpzwYZmHhImbtaBj614ZN6ET+TpaFXhmcg3yqI=;
	h=Date:To:From:Subject:Message-Id; b=AmxGFfemUIEGTACGaMKoYAKRqRNV+BIx6IZjXv/kARI3eO7ObzM5uQE00oYpg1AKQnnRyz3NI7t7XHk6ZNHG+jeLqKu6ESxM2Y8ZfJzfiOvIGA8vieuXJs4sVwByR5aoP+Sd2u5TjsweFZOTrEWVGQDFWjrJ2ZObA4715zzAOZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pJ8regS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pJ8regS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABA4C433F1;
	Fri, 26 Jan 2024 02:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235308;
	bh=6byrbjpzwYZmHhImbtaBj614ZN6ET+TpaFXhmcg3yqI=;
	h=Date:To:From:Subject:From;
	b=pJ8regS8+/Uu/3GQWYyMIUvQYZbSUWndG74e8DeNMOhfUwido5ZQqlOhUff1XIas7
	 iZZsf3Pq7w/pFJY6IrZdxLqwB18Hhjc8Dsu6pLDykT3IQcpM99nYnO9AHzp3LMit54
	 80SEZT3hRYdWi3YhdQsvw5COcHqzrnMvdfWhNrSM=
Date: Thu, 25 Jan 2024 18:15:05 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler-clangh-update-__diag_clang-macros-for-minimum-version-bump.patch added to mm-nonmm-unstable branch
Message-Id: <20240126021507.DABA4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: compiler-clang.h: update __diag_clang() macros for minimum version bump
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compiler-clangh-update-__diag_clang-macros-for-minimum-version-bump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler-clangh-update-__diag_clang-macros-for-minimum-version-bump.patch

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
Subject: compiler-clang.h: update __diag_clang() macros for minimum version bump
Date: Thu, 25 Jan 2024 15:55:17 -0700

The minimum supported version of LLVM for building the kernel has been
bumped to 13.0.1.  Update the __diag_clang() macros for this bump.

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-11-f5ff9bda41c5@kernel.org
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

 include/linux/compiler-clang.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/include/linux/compiler-clang.h~compiler-clangh-update-__diag_clang-macros-for-minimum-version-bump
+++ a/include/linux/compiler-clang.h
@@ -114,11 +114,7 @@
 #define __diag_str(s)		__diag_str1(s)
 #define __diag(s)		_Pragma(__diag_str(clang diagnostic s))
 
-#if CONFIG_CLANG_VERSION >= 110000
-#define __diag_clang_11(s)	__diag(s)
-#else
-#define __diag_clang_11(s)
-#endif
+#define __diag_clang_13(s)	__diag(s)
 
 #define __diag_ignore_all(option, comment) \
-	__diag_clang(11, ignore, option)
+	__diag_clang(13, ignore, option)
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


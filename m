Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AE210F7
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235283; cv=none; b=a6D+9gcs0cdXHdUIlu+hkmUmmNUqgqZ7c/5lIWIN8n+x2yEQJuGSL3UTn9uQulQF/EllR27Cd8bqfizFSaLj37LtEU6Ug5rBBi0mtQ/rTdg5QdMNffPYiGlcWJdPDeknSW9ePJEA2OaUkeaD+h/onGRU0V0U4VKbARj+fHIwWAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235283; c=relaxed/simple;
	bh=Q6O0QFkyVp+f9xWlRGgjy8MNZ+w5iW5w7MsJvAGVK0g=;
	h=Date:To:From:Subject:Message-Id; b=CSmN89La2qkchkxCMGDz/yAF4SwKmUV9qot0dMCleP7iWGQiWIWvd1zMzeUA77ZWdKc70Yv9rZNqOgHnDeS21YQnqFjKQXdDLlkFpRmoMore/5a/+fBwiqXwmeW+oE1OR9TCRGYFAWnGqhJo9WEsAz21rThC69W57zd7dwQdhPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j4U9gWkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j4U9gWkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC21C433C7;
	Fri, 26 Jan 2024 02:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235283;
	bh=Q6O0QFkyVp+f9xWlRGgjy8MNZ+w5iW5w7MsJvAGVK0g=;
	h=Date:To:From:Subject:From;
	b=j4U9gWkZthXQ74TvH5erDCQaTI7ptoaewNXAJKcropsOmosS+ixE528YgImJ6CqDP
	 o7Iafq0Am/loYOeT2CWF9FceJx6TapIQbInK+/YIz8Db2so/V1stwA21wS7lKCezcN
	 ezsgF5TqNc4mD1ezVe1/+T7vfw6pFT1mssQBKj1I=
Date: Thu, 25 Jan 2024 18:14:40 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + makefile-drop-warn-stack-size-plugin-opt.patch added to mm-nonmm-unstable branch
Message-Id: <20240126021442.AEC21C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Makefile: drop warn-stack-size plugin opt
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     makefile-drop-warn-stack-size-plugin-opt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/makefile-drop-warn-stack-size-plugin-opt.patch

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
Subject: Makefile: drop warn-stack-size plugin opt
Date: Thu, 25 Jan 2024 15:55:08 -0700

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, the inner ifeq statement is always false, as the
build will fail during the configuration stage for older LLVM versions.

This effectively reverts commit 24845dcb170e ("Makefile: LTO: have linker
check -Wframe-larger-than") and its follow up fix, commit 0236526d76b8
("Makefile: lto: Pass -warn-stack-size only on LLD < 13.0.0").

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-2-f5ff9bda41c5@kernel.org
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

 Makefile |    8 --------
 1 file changed, 8 deletions(-)

--- a/Makefile~makefile-drop-warn-stack-size-plugin-opt
+++ a/Makefile
@@ -951,14 +951,6 @@ CC_FLAGS_LTO	+= -fvisibility=hidden
 
 # Limit inlining across translation units to reduce binary size
 KBUILD_LDFLAGS += -mllvm -import-instr-limit=5
-
-# Check for frame size exceeding threshold during prolog/epilog insertion
-# when using lld < 13.0.0.
-ifneq ($(CONFIG_FRAME_WARN),0)
-ifeq ($(call test-lt, $(CONFIG_LLD_VERSION), 130000),y)
-KBUILD_LDFLAGS	+= -plugin-opt=-warn-stack-size=$(CONFIG_FRAME_WARN)
-endif
-endif
 endif
 
 ifdef CONFIG_LTO
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


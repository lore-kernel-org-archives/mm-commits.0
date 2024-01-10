Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB8B6107
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 04:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="etkuygH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205A9C433F1;
	Wed, 10 Jan 2024 04:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704860173;
	bh=NuBrP6tDxxzM4WCFS6CKpgxvWmX75EITbW1EQmWt0BY=;
	h=Date:To:From:Subject:From;
	b=etkuygH962KKareJhq6Oo2Djsw4JXWg5rt2NPrkZADZmGTPT3t6hwq9r8Y1gpQyVG
	 QYaNkuVQ/xwCYDTEgXhEwdqmew1+rDS0KvtqsWW6+p9KuCos0rgCAnEt2jvzddX6l2
	 lsc8/HLSR3FYnmakQ2LxhWRqaPb2k7xfQbu/Y9oU=
Date: Tue, 09 Jan 2024 20:16:12 -0800
To: mm-commits@vger.kernel.org,mykolal@fb.com,daniel@iogearbox.net,ast@kernel.org,andrii@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-and-include-update-llvm-phabricator-links.patch added to mm-nonmm-unstable branch
Message-Id: <20240110041613.205A9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch and include: update LLVM Phabricator links
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arch-and-include-update-llvm-phabricator-links.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-and-include-update-llvm-phabricator-links.patch

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
Subject: arch and include: update LLVM Phabricator links
Date: Tue, 09 Jan 2024 15:16:30 -0700

reviews.llvm.org was LLVM's Phabricator instances for code review.  It has
been abandoned in favor of GitHub pull requests.  While the majority of
links in the kernel sources still work because of the work Fangrui has
done turning the dynamic Phabricator instance into a static archive, there
are some issues with that work, so preemptively convert all the links in
the kernel sources to point to the commit on GitHub.

Most of the commits have the corresponding differential review link in the
commit message itself so there should not be any loss of fidelity in the
relevant information.

Link: https://discourse.llvm.org/t/update-on-github-pull-requests/71540/172
Link: https://lkml.kernel.org/r/20240109-update-llvm-links-v1-2-eb09b59db071@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Mykola Lysenko <mykolal@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig              |    4 ++--
 arch/riscv/Kconfig              |    2 +-
 arch/riscv/include/asm/ftrace.h |    2 +-
 include/linux/compiler-clang.h  |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm64/Kconfig~arch-and-include-update-llvm-phabricator-links
+++ a/arch/arm64/Kconfig
@@ -381,7 +381,7 @@ config BROKEN_GAS_INST
 config BUILTIN_RETURN_ADDRESS_STRIPS_PAC
 	bool
 	# Clang's __builtin_return_adddress() strips the PAC since 12.0.0
-	# https://reviews.llvm.org/D75044
+	# https://github.com/llvm/llvm-project/commit/2a96f47c5ffca84cd774ad402cacd137f4bf45e2
 	default y if CC_IS_CLANG && (CLANG_VERSION >= 120000)
 	# GCC's __builtin_return_address() strips the PAC since 11.1.0,
 	# and this was backported to 10.2.0, 9.4.0, 8.5.0, but not earlier
@@ -2203,7 +2203,7 @@ config STACKPROTECTOR_PER_TASK
 
 config UNWIND_PATCH_PAC_INTO_SCS
 	bool "Enable shadow call stack dynamically using code patching"
-	# needs Clang with https://reviews.llvm.org/D111780 incorporated
+	# needs Clang with https://github.com/llvm/llvm-project/commit/de07cde67b5d205d58690be012106022aea6d2b3 incorporated
 	depends on CC_IS_CLANG && CLANG_VERSION >= 150000
 	depends on ARM64_PTR_AUTH_KERNEL && CC_HAS_BRANCH_PROT_PAC_RET
 	depends on SHADOW_CALL_STACK
--- a/arch/riscv/include/asm/ftrace.h~arch-and-include-update-llvm-phabricator-links
+++ a/arch/riscv/include/asm/ftrace.h
@@ -15,7 +15,7 @@
 
 /*
  * Clang prior to 13 had "mcount" instead of "_mcount":
- * https://reviews.llvm.org/D98881
+ * https://github.com/llvm/llvm-project/commit/ef58ae86ba778ed7d01cd3f6bd6d08f943abab44
  */
 #if defined(CONFIG_CC_IS_GCC) || CONFIG_CLANG_VERSION >= 130000
 #define MCOUNT_NAME _mcount
--- a/arch/riscv/Kconfig~arch-and-include-update-llvm-phabricator-links
+++ a/arch/riscv/Kconfig
@@ -291,7 +291,7 @@ config AS_HAS_INSN
 	def_bool $(as-instr,.insn r 51$(comma) 0$(comma) 0$(comma) t0$(comma) t0$(comma) zero)
 
 config AS_HAS_OPTION_ARCH
-	# https://reviews.llvm.org/D123515
+	# https://github.com/llvm/llvm-project/commit/9e8ed3403c191ab9c4903e8eeb8f732ff8a43cb4
 	def_bool y
 	depends on $(as-instr, .option arch$(comma) +m)
 	depends on !$(as-instr, .option arch$(comma) -i)
--- a/include/linux/compiler-clang.h~arch-and-include-update-llvm-phabricator-links
+++ a/include/linux/compiler-clang.h
@@ -9,7 +9,7 @@
  * Clang prior to 17 is being silly and considers many __cleanup() variables
  * as unused (because they are, their sole purpose is to go out of scope).
  *
- * https://reviews.llvm.org/D152180
+ * https://github.com/llvm/llvm-project/commit/877210faa447f4cc7db87812f8ed80e398fedd61
  */
 #undef __cleanup
 #define __cleanup(func) __maybe_unused __attribute__((__cleanup__(func)))
_

Patches currently in -mm which might be from nathan@kernel.org are

lib-kconfigdebug-disable-config_debug_info_btf-for-hexagon.patch
selftests-bpf-update-llvm-phabricator-links.patch
arch-and-include-update-llvm-phabricator-links.patch
treewide-update-llvm-bugzilla-links.patch


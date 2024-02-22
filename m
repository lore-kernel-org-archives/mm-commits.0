Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4DE17BBA
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645167; cv=none; b=Cgo74mAnVCBxMf9qynwfpDBiDJcPjJZ5apCWqTCeZZbAB97HN3dWIxN3UlS2d/vc1smO3YYsmUH91n1haiw+4tb8urci5gzG8ZmqSy6BSe1rVRD/9as/CS1d9Rqp/x2GlnaZhfF5UKoYf3zyrEVpaUxxWrbrlFmac5m/OD+BdeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645167; c=relaxed/simple;
	bh=bhns/tG/EMovVYXL0/oDWuAXxgxEcgxlALJ8paI8Uv4=;
	h=Date:To:From:Subject:Message-Id; b=UGVk2zL/z23fkpe8I/ilkGE2quoT39UKbKAP8gg2ul97R74aEC+cvpIxtVTpY7kidS/ukA45JcKmW1rlCbKIUsXTL/xrhSUqcSyLf3TJM8uDQL7Qwciu/llyE6Sgcsq9un8Qh8O9OnAAq4BD1OsiLe7RsNYWVuk5y21s/L2tnHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GAqhDWWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GAqhDWWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D342CC43390;
	Thu, 22 Feb 2024 23:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645166;
	bh=bhns/tG/EMovVYXL0/oDWuAXxgxEcgxlALJ8paI8Uv4=;
	h=Date:To:From:Subject:From;
	b=GAqhDWWqdr1zYh8CO/5P0IwUnTVS11iyaQWcjFVmXXT62hqFHB/FH4Cv2Ni4OShXA
	 EH8Ncg7DHfZf4fAAN/YLg4G/JnWCzoUXBohiUOrlBYYCOb0TN4aZGs7lwaXqSks7jN
	 RTJbqh/INzZU07gJ1ReF3GT1KFJqdY0ovcXFaD80=
Date: Thu, 22 Feb 2024 15:39:26 -0800
To: mm-commits@vger.kernel.org,mykolal@fb.com,maskray@google.com,keescook@chromium.org,daniel@iogearbox.net,conor.dooley@microchip.com,ast@kernel.org,andrii@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arch-and-include-update-llvm-phabricator-links.patch removed from -mm tree
Message-Id: <20240222233926.D342CC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch and include: update LLVM Phabricator links
has been removed from the -mm tree.  Its filename was
     arch-and-include-update-llvm-phabricator-links.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Fangrui Song <maskray@google.com>
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
@@ -382,7 +382,7 @@ config BROKEN_GAS_INST
 config BUILTIN_RETURN_ADDRESS_STRIPS_PAC
 	bool
 	# Clang's __builtin_return_adddress() strips the PAC since 12.0.0
-	# https://reviews.llvm.org/D75044
+	# https://github.com/llvm/llvm-project/commit/2a96f47c5ffca84cd774ad402cacd137f4bf45e2
 	default y if CC_IS_CLANG && (CLANG_VERSION >= 120000)
 	# GCC's __builtin_return_address() strips the PAC since 11.1.0,
 	# and this was backported to 10.2.0, 9.4.0, 8.5.0, but not earlier
@@ -2222,7 +2222,7 @@ config STACKPROTECTOR_PER_TASK
 
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
@@ -312,7 +312,7 @@ config AS_HAS_INSN
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



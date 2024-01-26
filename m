Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AAA3232
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235294; cv=none; b=mFUDmRGLRJoY/EynLt5PVwl1L2JYcDuTfvG5EBXwOP3eNOq9qR8ZjXMQLGMW9QyQlHMCR9lvpv+RIX0uNhsTOoo3NIuJZ/NqbYCJHH+31pJ5YCxxPORI+h/6cjbTDSoLirA/CraJDqnRIx6tL4kPVFmqtT360IJA6eQxWXdV2f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235294; c=relaxed/simple;
	bh=pkjg7KacvKDZzTjO632WnpI/wa6CG7+oKguQb8NgYy0=;
	h=Date:To:From:Subject:Message-Id; b=iL3bzQthQwMgilbR1uqjn0jnwd7oeWoQv6fsQWIVzZkqWp4lsRnWTEcIDB7E6vlnDoJLVNf+3Jp1ViyYXk3hXK2RMFl2eP17ZQnBLXuDS4sbRqbPSiOm9b7iVVhcBdS17Km4+Cef34t2x3yn1xT8mqMJXpsyx5JrKpMNUcX2Eb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HtmTNAtC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HtmTNAtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A5BC433C7;
	Fri, 26 Jan 2024 02:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235293;
	bh=pkjg7KacvKDZzTjO632WnpI/wa6CG7+oKguQb8NgYy0=;
	h=Date:To:From:Subject:From;
	b=HtmTNAtCIU4po4YfM4lPLvIaSzwEG6uMXjp60SbhBRpSSFWcl7UD7KjalMYucDKgc
	 yqHiGWaEFW9qBJXjPtGkb08DjTxsZVv+TXIkHTVIxPYuiMTUJs1hBcYA6laFZcjegc
	 zZQnIyQ81M/w10VgBsePEj5/bvTf9XP2JRcm3WDs=
Date: Thu, 25 Jan 2024 18:14:50 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-remove-mcount_name-workaround.patch added to mm-nonmm-unstable branch
Message-Id: <20240126021453.37A5BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: remove MCOUNT_NAME workaround
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-remove-mcount_name-workaround.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-remove-mcount_name-workaround.patch

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
Subject: riscv: remove MCOUNT_NAME workaround
Date: Thu, 25 Jan 2024 15:55:13 -0700

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, the condition for using _mcount as MCOUNT_NAME is
always true, as the build will fail during the configuration stage for
older LLVM versions.  Replace MCOUNT_NAME with _mcount directly.

This effectively reverts commit 7ce047715030 ("riscv: Workaround mcount
name prior to clang-13").

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-7-f5ff9bda41c5@kernel.org
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

 arch/riscv/include/asm/ftrace.h |   14 ++------------
 arch/riscv/kernel/mcount.S      |   10 +++++-----
 scripts/recordmcount.pl         |    2 +-
 3 files changed, 8 insertions(+), 18 deletions(-)

--- a/arch/riscv/include/asm/ftrace.h~riscv-remove-mcount_name-workaround
+++ a/arch/riscv/include/asm/ftrace.h
@@ -13,19 +13,9 @@
 #endif
 #define HAVE_FUNCTION_GRAPH_RET_ADDR_PTR
 
-/*
- * Clang prior to 13 had "mcount" instead of "_mcount":
- * https://github.com/llvm/llvm-project/commit/ef58ae86ba778ed7d01cd3f6bd6d08f943abab44
- */
-#if defined(CONFIG_CC_IS_GCC) || CONFIG_CLANG_VERSION >= 130000
-#define MCOUNT_NAME _mcount
-#else
-#define MCOUNT_NAME mcount
-#endif
-
 #define ARCH_SUPPORTS_FTRACE_OPS 1
 #ifndef __ASSEMBLY__
-void MCOUNT_NAME(void);
+void _mcount(void);
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
 	return addr;
@@ -75,7 +65,7 @@ struct dyn_arch_ftrace {
  * both auipc and jalr at the same time.
  */
 
-#define MCOUNT_ADDR		((unsigned long)MCOUNT_NAME)
+#define MCOUNT_ADDR		((unsigned long)_mcount)
 #define JALR_SIGN_MASK		(0x00000800)
 #define JALR_OFFSET_MASK	(0x00000fff)
 #define AUIPC_OFFSET_MASK	(0xfffff000)
--- a/arch/riscv/kernel/mcount.S~riscv-remove-mcount_name-workaround
+++ a/arch/riscv/kernel/mcount.S
@@ -50,8 +50,8 @@
 
 SYM_TYPED_FUNC_START(ftrace_stub)
 #ifdef CONFIG_DYNAMIC_FTRACE
-       .global MCOUNT_NAME
-       .set    MCOUNT_NAME, ftrace_stub
+       .global _mcount
+       .set    _mcount, ftrace_stub
 #endif
 	ret
 SYM_FUNC_END(ftrace_stub)
@@ -80,7 +80,7 @@ SYM_FUNC_END(return_to_handler)
 #endif
 
 #ifndef CONFIG_DYNAMIC_FTRACE
-SYM_FUNC_START(MCOUNT_NAME)
+SYM_FUNC_START(_mcount)
 	la	t4, ftrace_stub
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	la	t0, ftrace_graph_return
@@ -126,6 +126,6 @@ SYM_FUNC_START(MCOUNT_NAME)
 	jalr	t5
 	RESTORE_ABI_STATE
 	ret
-SYM_FUNC_END(MCOUNT_NAME)
+SYM_FUNC_END(_mcount)
 #endif
-EXPORT_SYMBOL(MCOUNT_NAME)
+EXPORT_SYMBOL(_mcount)
--- a/scripts/recordmcount.pl~riscv-remove-mcount_name-workaround
+++ a/scripts/recordmcount.pl
@@ -352,7 +352,7 @@ if ($arch eq "x86_64") {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
 } elsif ($arch eq "riscv") {
     $function_regex = "^([0-9a-fA-F]+)\\s+<([^.0-9][0-9a-zA-Z_\\.]+)>:";
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\sR_RISCV_CALL(_PLT)?\\s_?mcount\$";
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\sR_RISCV_CALL(_PLT)?\\s_mcount\$";
     $type = ".quad";
     $alignment = 2;
 } elsif ($arch eq "csky") {
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


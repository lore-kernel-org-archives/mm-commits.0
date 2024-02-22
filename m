Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED02513BAE4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645207; cv=none; b=Eq2Vf18XAEBx8/esJAoa8rxzDsvcRyGlrSNx+Zzr/Ds8ajIfzYWrIUn+4Vcb5u+5LzIXYCtrXSZX9wgR3Ujr4VeUnGnqA3XF2mOOaPecYB6cMCdybr4DVOaezdC/iFl9pvu++UoVbJcgv4hBqX0hLLZQGSHKFXCXt7fUR01zz3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645207; c=relaxed/simple;
	bh=vg7FpjxMCtkjToxecFNzgc8KBQa9jjzQaHrhkS80JnE=;
	h=Date:To:From:Subject:Message-Id; b=koHJ0tQyqxwxfun7BDnYQHakhHOLS6QWaRaGF4iIi1ffUsXQFMeNmeDRedukYrqM9E5vJQm8Mi1Pl55OW5LOQqQUmOOjqNq8yEPZnDr85Q26t9cFe0Nlb9I8h3cn/oYe+1scKtsuFHqNufVsjPB/Kt5xupRB8kEAlb5LTtxCi/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FayrquMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FayrquMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEDFC433F1;
	Thu, 22 Feb 2024 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645206;
	bh=vg7FpjxMCtkjToxecFNzgc8KBQa9jjzQaHrhkS80JnE=;
	h=Date:To:From:Subject:From;
	b=FayrquMxeYSP68Jh6tIJMcVRYxPh4Ou5Vb+QeYWG8V9lf53UpL9h5JYlSgnOi6hHb
	 GxjDduR82YKYywQ2XAt7ZjM3+YDD63d49UPCh0Q/HdXRA3l1a7ZQmwfBG0IutE4EzD
	 ss+WI6GE8evPhCDrs/Gw3gSOczAkQfJugFOU32ig=
Date: Thu, 22 Feb 2024 15:40:05 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] riscv-remove-mcount_name-workaround.patch removed from -mm tree
Message-Id: <20240222234006.5CEDFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: remove MCOUNT_NAME workaround
has been removed from the -mm tree.  Its filename was
     riscv-remove-mcount_name-workaround.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



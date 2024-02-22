Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9E413BAD2
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645205; cv=none; b=CEBIkYTU5xQazC4vYHDHNPcMbgkgZUSw0tZulhf4bSj4X0ik8Lvk1W++fcD2zKo3q1qkAjfe1FBJJSx+4jomk8Kff7Z3gR+icesKChmBbv/Jubr6YfxIhXtj/3X7ZNpnxgVy8EQh5fQT646KiHjEGMGn+GJ8AUP/msLXvvpd1BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645205; c=relaxed/simple;
	bh=NZtM9ztZR6usSQz4e+4YHSSNXHceJQpPGR1sVCDoYD0=;
	h=Date:To:From:Subject:Message-Id; b=tt6FfTqhmilYyc8qKAft7ZQVdkqigWPko2C7+HXvrKmRlaXskreAr6qM94EPD3cr8Er8xT4GRgt7hpcr1ykvuIz7wm9MuZ/sfXdCxxvqThI+P0e8ZhArS4eRnvSrSpx9AN/TLpQ0vJS9Mmhbg3mGfdxg8mo+BCi2QQ1TazK5p6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hy41+tEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hy41+tEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777A8C433C7;
	Thu, 22 Feb 2024 23:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645204;
	bh=NZtM9ztZR6usSQz4e+4YHSSNXHceJQpPGR1sVCDoYD0=;
	h=Date:To:From:Subject:From;
	b=Hy41+tEjCuQ4esYUa3CpyPuN+2Fo95PC/H7FxzBVqwiNc6ZeVhBwwAx9wU9xJVVrs
	 ZyLwrtkL7xZfaKCdzzPmzIWfr2Npe/kerXTfvNymhBTzfpuxFkftrz/OP5UDFTlt/z
	 u2FJtPDWabYY0ax8g9BNfLyTKJ2XDa+eegJBVOQ8=
Date: Thu, 22 Feb 2024 15:40:03 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arm64-kconfig-clean-up-tautological-llvm-version-checks.patch removed from -mm tree
Message-Id: <20240222234004.777A8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: Kconfig: clean up tautological LLVM version checks
has been removed from the -mm tree.  Its filename was
     arm64-kconfig-clean-up-tautological-llvm-version-checks.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -383,7 +383,7 @@ config BUILTIN_RETURN_ADDRESS_STRIPS_PAC
 	bool
 	# Clang's __builtin_return_adddress() strips the PAC since 12.0.0
 	# https://github.com/llvm/llvm-project/commit/2a96f47c5ffca84cd774ad402cacd137f4bf45e2
-	default y if CC_IS_CLANG && (CLANG_VERSION >= 120000)
+	default y if CC_IS_CLANG
 	# GCC's __builtin_return_address() strips the PAC since 11.1.0,
 	# and this was backported to 10.2.0, 9.4.0, 8.5.0, but not earlier
 	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94891
@@ -1387,7 +1387,6 @@ choice
 
 config CPU_BIG_ENDIAN
 	bool "Build big-endian kernel"
-	depends on !LD_IS_LLD || LLD_VERSION >= 130000
 	# https://github.com/llvm/llvm-project/commit/1379b150991f70a5782e9a143c2ba5308da1161c
 	depends on AS_IS_GNU || AS_VERSION >= 150000
 	help
@@ -2018,8 +2017,6 @@ config ARM64_BTI_KERNEL
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



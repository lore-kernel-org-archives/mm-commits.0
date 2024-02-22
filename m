Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A65137928
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645207; cv=none; b=AH+PTBWqJT1pAFrv2+3e2310nEKO9rZJVFjBKCIQk40uEhy+8+pSUdY04xjQqieRWpgEJjoAeixMxqStiAMWN5FNzkrk1CojzZ2YsDcmvIgZYKS7ciq9jYPCf068gWDQuy+AgNdDQ3AGEmItlsYArwM5Rdknhujw8sCBvzmYkDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645207; c=relaxed/simple;
	bh=7I9IOdwymeYF+9/5ctysQm0BqUmFmXw7e9zfgXUCVM8=;
	h=Date:To:From:Subject:Message-Id; b=CvtUcEkea/fNy08+qb41NAgfeOYtXA+lIC8Qpjqwf1L7UYvnvCpaZ/axr2CK9upbSj5Hl0D0thJQF+wWOhwNS8q0P8w131xlnaq4EfKb8Dhjp9+pPxayYYyaRSfFc6ppb9aFQCWMyI4zEsMi60l/UZwm474MpDWhYwu8Tmey9EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xbzeuTEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xbzeuTEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AC7C433C7;
	Thu, 22 Feb 2024 23:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645207;
	bh=7I9IOdwymeYF+9/5ctysQm0BqUmFmXw7e9zfgXUCVM8=;
	h=Date:To:From:Subject:From;
	b=xbzeuTEteAdzaP3Btgdfh5cAi5iYb43NnEPAHaOi7XJBjfxH9i5tScYtr+QjB9jWX
	 0KxF/w+NmK1z1peT7VyIFQmrEZpFXrirgCqjm12INy/xASz73+Z8Z4z6//UkgXgsDB
	 yc/UhkpAQEbgvBGXi/xmGsKuvW2OP5A/8nLUAFw8=
Date: Thu, 22 Feb 2024 15:40:06 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] riscv-kconfig-remove-version-dependency-from-config_clang_supports_dynamic_ftrace.patch removed from -mm tree
Message-Id: <20240222234007.59AC7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: Kconfig: remove version dependency from CONFIG_CLANG_SUPPORTS_DYNAMIC_FTRACE
has been removed from the -mm tree.  Its filename was
     riscv-kconfig-remove-version-dependency-from-config_clang_supports_dynamic_ftrace.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: riscv: Kconfig: remove version dependency from CONFIG_CLANG_SUPPORTS_DYNAMIC_FTRACE
Date: Thu, 25 Jan 2024 15:55:14 -0700

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, this condition is always true, as the build will
fail during the configuration stage for older LLVM versions.  Remove it.

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-8-f5ff9bda41c5@kernel.org
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

 arch/riscv/Kconfig |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/riscv/Kconfig~riscv-kconfig-remove-version-dependency-from-config_clang_supports_dynamic_ftrace
+++ a/arch/riscv/Kconfig
@@ -174,8 +174,6 @@ config RISCV
 
 config CLANG_SUPPORTS_DYNAMIC_FTRACE
 	def_bool CC_IS_CLANG
-	# https://github.com/llvm/llvm-project/commit/6ab8927931851bb42b2c93a00801dc499d7d9b1e
-	depends on CLANG_VERSION >= 130000
 	# https://github.com/ClangBuiltLinux/linux/issues/1817
 	depends on AS_IS_GNU || (AS_IS_LLVM && (LD_IS_LLD || LD_VERSION >= 23600))
 
_

Patches currently in -mm which might be from nathan@kernel.org are



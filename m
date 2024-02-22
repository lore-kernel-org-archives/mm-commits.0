Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E31113BAD2
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645204; cv=none; b=hbDSH2pBBau+quRQKVjaCt8viZFfX8vq4UvLKyCRZBRFvVv7Nm+qcQ8YN59b9j6x4OKAK4Tq0I6/9VKjvjGuCDEHZ+tuy0TAonNCLeCSgopbZAXwUfCMoLqgv15PTADsHK8zonzF3F9uxpmcMtIrSLGsj1A2XXaYzy6lJTPTyhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645204; c=relaxed/simple;
	bh=PfgEtJcno0FofJEwqu85N0MJU9q7Jv5qooNdOxfQsTc=;
	h=Date:To:From:Subject:Message-Id; b=eV2atK8l9xuPvJx3rRi3brsm2fxNWwMWWQGojBgV7bWCzmZ8zUm6n61jc5GzmfMTMpmUSLN2B4FD1M6Gaix17Z28icufcf+sZuDqSzUSmhy3GjaF3JEF2eHkcWSXy1xjtsZOSJzzR+YgOfSe7XJuoWNymPVcKQS+qI5m0Bpb5Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0lzV/pKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0lzV/pKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76998C433C7;
	Thu, 22 Feb 2024 23:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645203;
	bh=PfgEtJcno0FofJEwqu85N0MJU9q7Jv5qooNdOxfQsTc=;
	h=Date:To:From:Subject:From;
	b=0lzV/pKjiMQPcKPRLMdrWqGDr7UHZZb898nEtD8F5C2TauEDyHbZ+FtW1eRhbqGLc
	 vVosKpxodXvxlXAlt+cRLn9ceXKL2uyf2855L83zU8M0UDJ/7PSXUvgmZ46l3tdtyv
	 YQq7x+3CSq68Nh1efDy3sNmeBQLEXQ5/q3c6EZE8=
Date: Thu, 22 Feb 2024 15:40:02 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arm-remove-thumb2-__builtin_thread_pointer-workaround-for-clang.patch removed from -mm tree
Message-Id: <20240222234003.76998C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ARM: remove Thumb2 __builtin_thread_pointer workaround for Clang
has been removed from the -mm tree.  Its filename was
     arm-remove-thumb2-__builtin_thread_pointer-workaround-for-clang.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: ARM: remove Thumb2 __builtin_thread_pointer workaround for Clang
Date: Thu, 25 Jan 2024 15:55:10 -0700

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, the conditional expression added to get_current()
by commit c1e42efacb9b ("ARM: 9151/1: Thumb2: avoid
__builtin_thread_pointer() on Clang") is always true, as the build will
fail during the configuration stage for older LLVM versions.  Remove it,
effectively reverting the aforementioned change.

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-4-f5ff9bda41c5@kernel.org
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

 arch/arm/include/asm/current.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/arm/include/asm/current.h~arm-remove-thumb2-__builtin_thread_pointer-workaround-for-clang
+++ a/arch/arm/include/asm/current.h
@@ -18,18 +18,12 @@ static __always_inline __attribute_const
 {
 	struct task_struct *cur;
 
-#if __has_builtin(__builtin_thread_pointer) && \
-    defined(CONFIG_CURRENT_POINTER_IN_TPIDRURO) && \
-    !(defined(CONFIG_THUMB2_KERNEL) && \
-      defined(CONFIG_CC_IS_CLANG) && CONFIG_CLANG_VERSION < 130001)
+#if __has_builtin(__builtin_thread_pointer) && defined(CONFIG_CURRENT_POINTER_IN_TPIDRURO)
 	/*
 	 * Use the __builtin helper when available - this results in better
 	 * code, especially when using GCC in combination with the per-task
 	 * stack protector, as the compiler will recognize that it needs to
 	 * load the TLS register only once in every function.
-	 *
-	 * Clang < 13.0.1 gets this wrong for Thumb2 builds:
-	 * https://github.com/ClangBuiltLinux/linux/issues/1485
 	 */
 	cur = __builtin_thread_pointer();
 #elif defined(CONFIG_CURRENT_POINTER_IN_TPIDRURO) || defined(CONFIG_SMP)
_

Patches currently in -mm which might be from nathan@kernel.org are



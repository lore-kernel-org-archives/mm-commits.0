Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8DF13BAD2
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645205; cv=none; b=nA20w+FPG9pXjtG5kBzPNqbiSWhXnk+VVgep7oGJUIqxYPpSiBMtfYCMVHC71xNTou+NjpW7H4bTONFP8I480fESKzTbziDpw+zlJvdL6I4J+pPQX9zuayUtYcvJHCuYwI53d+U4r18KIwMqrEk3FNY6jMaA9zVGZqHQgLzSLYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645205; c=relaxed/simple;
	bh=9AN6vgrPuu6vTioTyGKcWdLt4HVO9MtSLGQ1nRJB7fo=;
	h=Date:To:From:Subject:Message-Id; b=r2je6YojUbJwTOMZSQgswtXxDqCKWCLSxGku79kAfONKH8Gp/aHTVGDigycwEqxkLHmgHt4Hlk9TpC2CqN+m3DEmUFmuSPYeGio8LsqdrSbgMF+QVWRzFZiWxeb7LIpG4w2OJW/dq2l9Yei05mNQtKKdiGSV6bwBaYMgpeBH04E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZJ28uD0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZJ28uD0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6188DC43390;
	Thu, 22 Feb 2024 23:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645205;
	bh=9AN6vgrPuu6vTioTyGKcWdLt4HVO9MtSLGQ1nRJB7fo=;
	h=Date:To:From:Subject:From;
	b=ZJ28uD0lUQrXDowIKj78d8gWoBLyQ7Y6SB6OwHy9W4c3DK2n+q9U6Lt8UIzuC8RAX
	 JsGD2iAo4zPxX8FRWE4adtWw0EiWxbJX0tcHHjPIqsXWFyZb+tfFYOZ6e5gGw5XR3d
	 NbsCoWNVlLDHDGJaG4uQ1OUoJG0Qt9+AsQClLDKI=
Date: Thu, 22 Feb 2024 15:40:04 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] powerpc-kconfig-remove-tautology-in-config_compat.patch removed from -mm tree
Message-Id: <20240222234005.6188DC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc: Kconfig: remove tautology in CONFIG_COMPAT
has been removed from the -mm tree.  Its filename was
     powerpc-kconfig-remove-tautology-in-config_compat.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: powerpc: Kconfig: remove tautology in CONFIG_COMPAT
Date: Thu, 25 Jan 2024 15:55:12 -0700

This reverts commit 6fcb574125e6 ("powerpc: Kconfig: disable
CONFIG_COMPAT for clang < 12").

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, this condition is always true, as the build will
fail during the configuration stage for older LLVM versions.  Remove it.

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-6-f5ff9bda41c5@kernel.org
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

 arch/powerpc/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/powerpc/Kconfig~powerpc-kconfig-remove-tautology-in-config_compat
+++ a/arch/powerpc/Kconfig
@@ -333,7 +333,6 @@ config PANIC_TIMEOUT
 config COMPAT
 	bool "Enable support for 32bit binaries"
 	depends on PPC64
-	depends on !CC_IS_CLANG || CLANG_VERSION >= 120000
 	default y if !CPU_LITTLE_ENDIAN
 	select ARCH_WANT_OLD_COMPAT_IPC
 	select COMPAT_OLD_SIGACTION
_

Patches currently in -mm which might be from nathan@kernel.org are



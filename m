Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA000137928
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645208; cv=none; b=pNuS/F3NeJcPqEhGm3IXxZ8QUd2d0mj2VGUNvRmFmgZPFiI3norTYcIRbm2lDP7+NhVampnETKM4taVa9lIatsN9iZL9rxUAXDyubm8Nk3ioZPdncp5vB7FDM34RZ3b+5piGFQ7EgY0VTwbSSG91ExJkQPEHLvB88Sn4LcOKQ5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645208; c=relaxed/simple;
	bh=5DqzhX8V9Ik+T0C60eO7j9fQSkQr9P5+IDSn3O1l3t0=;
	h=Date:To:From:Subject:Message-Id; b=HeTv5UhjpqwSuuQcdw5cUvsYJoh1M3VQ7K6ruWzB1rdfEbqOfBHElbUHgMeMD8AZy3Q7KqfgglEVwK7nhMy3t8+WCboGSue6e757U/MEBTdHrnTzJHFiuryI4qNkxiCfqbqx7e61YoSbEoNoCaTziX+nFiVO/d9k13mHMkw9m/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q6Rfknm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q6Rfknm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC50C433F1;
	Thu, 22 Feb 2024 23:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645208;
	bh=5DqzhX8V9Ik+T0C60eO7j9fQSkQr9P5+IDSn3O1l3t0=;
	h=Date:To:From:Subject:From;
	b=Q6Rfknm9jfiC6PpJsbw/BoxZgD/52zGoNvPSNcMZfZ+zaZOpMV69Nlv1sooJahpKh
	 dkBxHFc9v54xvff/2uybrGj67TfV8pH7iIKoRTh3O7djDC9PHAqwu7kSKuhBScmDsv
	 A2RVRfRT7UA4igdXXKFIwDjkalVpxYglllclr1Ug=
Date: Thu, 22 Feb 2024 15:40:07 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fortify-drop-clang-version-check-for-1201-or-newer.patch removed from -mm tree
Message-Id: <20240222234008.5DC50C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fortify: drop Clang version check for 12.0.1 or newer
has been removed from the -mm tree.  Its filename was
     fortify-drop-clang-version-check-for-1201-or-newer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: fortify: drop Clang version check for 12.0.1 or newer
Date: Thu, 25 Jan 2024 15:55:15 -0700

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, this condition is always true, as the build will
fail during the configuration stage for older LLVM versions.  Remove it.

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-9-f5ff9bda41c5@kernel.org
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

 security/Kconfig |    2 --
 1 file changed, 2 deletions(-)

--- a/security/Kconfig~fortify-drop-clang-version-check-for-1201-or-newer
+++ a/security/Kconfig
@@ -142,8 +142,6 @@ config HARDENED_USERCOPY
 config FORTIFY_SOURCE
 	bool "Harden common str/mem functions against buffer overflows"
 	depends on ARCH_HAS_FORTIFY_SOURCE
-	# https://llvm.org/pr41459
-	depends on !CC_IS_CLANG || CLANG_VERSION >= 120001
 	# https://github.com/llvm/llvm-project/issues/53645
 	depends on !CC_IS_CLANG || !X86_32
 	help
_

Patches currently in -mm which might be from nathan@kernel.org are



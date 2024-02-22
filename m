Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC63BFBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645209; cv=none; b=UWT5bRHZYTl6Or9OPKuC+Cc+4jzf1eYBfYXbFDx8vJJvPdf/hNX8vd6WgP7GMPtloqh7udsZiCvRarB1bT5Cj5tfLC/FFutYX+gP5mCdkKCFDMS1xiTjNnw7hY5zO3A1gol/p/G0t0TbVHbtX0Eco6Vxja9xvl14Qsz/P3tw0TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645209; c=relaxed/simple;
	bh=8FF0/2VmM8HY96gIsl9q1RRmwdiQPQ732kRIRKTrnCA=;
	h=Date:To:From:Subject:Message-Id; b=BiKhVB8DbzAOqa6b+h1tVSDsOmJY0MSsQuE4QdvGZr9paNc3vIeP2el7yTCwtAogf2txrJcHqn53jeZFyUH30n9KhEQWWHI8Q7ewCcXaN/DNniiJXb1E1Xpuh8yBw271PrLGr81wWq/9w5vYhVGMEF68SlXC9HfgYhB2TTZB/IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FkBrlChH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FkBrlChH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB2AC43390;
	Thu, 22 Feb 2024 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645209;
	bh=8FF0/2VmM8HY96gIsl9q1RRmwdiQPQ732kRIRKTrnCA=;
	h=Date:To:From:Subject:From;
	b=FkBrlChHMNcEVjargWxA9iKGkhfgFLp6tRMK0XAEjElVIEru5zDkO6d/tholhtDF4
	 KMtp84XEOuF9EZUlbYNbI0r9h6fPXx5fH2yWWl3RcVmmXNimGSmT/0v91iA95he9Ec
	 y88h4Rrhxlde+VlaGanzYuhh3KZ2hTFzTf10z3io=
Date: Thu, 22 Feb 2024 15:40:08 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-kconfigdebug-update-clang-version-check-in-config_kcov.patch removed from -mm tree
Message-Id: <20240222234009.5CB2AC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/Kconfig.debug: update Clang version check in CONFIG_KCOV
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-update-clang-version-check-in-config_kcov.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: lib/Kconfig.debug: update Clang version check in CONFIG_KCOV
Date: Thu, 25 Jan 2024 15:55:16 -0700

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, this condition can be changed to just
CONFIG_CC_IS_CLANG, as the build will fail during the configuration stage
for older LLVM versions.

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-10-f5ff9bda41c5@kernel.org
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

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-update-clang-version-check-in-config_kcov
+++ a/lib/Kconfig.debug
@@ -2085,7 +2085,7 @@ config KCOV
 	depends on ARCH_HAS_KCOV
 	depends on CC_HAS_SANCOV_TRACE_PC || GCC_PLUGINS
 	depends on !ARCH_WANTS_NO_INSTR || HAVE_NOINSTR_HACK || \
-		   GCC_VERSION >= 120000 || CLANG_VERSION >= 130000
+		   GCC_VERSION >= 120000 || CC_IS_CLANG
 	select DEBUG_FS
 	select GCC_PLUGIN_SANCOV if !CC_HAS_SANCOV_TRACE_PC
 	select OBJTOOL if HAVE_NOINSTR_HACK
_

Patches currently in -mm which might be from nathan@kernel.org are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776EF3F9D2
	for <mm-commits@vger.kernel.org>; Sat, 11 Oct 2025 18:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760208321; cv=none; b=EKix4uiRbPTJsxXfjTgJqABN8LLWvOLc9FaKLqzyxTbLn88GYlRKY9ueIbL1a1UyF7a7J/t7sxSqc+MPxLD95n8qPuCWzZI47jBvzzTSYWD/ElIzK+XXPGXRMzBi/t0gser2j6lzHOIzQM+JP8Raqptw4SD+LkC52dKDEGJ+I1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760208321; c=relaxed/simple;
	bh=LzQIUyRm7ZTBOgCgw6Sxp9qxdOZ9x2XkxVbAPS0LPJQ=;
	h=Date:To:From:Subject:Message-Id; b=iLlKC1rrgzHa/9Y3BpPGFo8rFfdKM3/1bDQl95+TtsD7Dfgv4xRSEFWAokGaTP/Sxcn2rzvuZUfQJhagLbo1om6DIU7dIdgs7aqCr0Pkg5gkKlxPxHcU54C2WRxWDANvnb4TYvPFXnGli9M0OiPQMktWoheDvRZyuQLRqjJ9tsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qCwu5qYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qCwu5qYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0FCC4CEF4;
	Sat, 11 Oct 2025 18:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760208320;
	bh=LzQIUyRm7ZTBOgCgw6Sxp9qxdOZ9x2XkxVbAPS0LPJQ=;
	h=Date:To:From:Subject:From;
	b=qCwu5qYegB8RkX4q3twgmC6jV7fBnHuDhnta94p4gDcsxp70a8hgygz4rBOJtrcKo
	 ELyaPLhLI8PZZSaClxEo/HeVErRLa2QCpcm/hxyWdfQNvC5ORhODEE5qpB4T3hDPsQ
	 WOhC4c/gl8Zi1wKuYlkYIL3qz52h+lFE96Dk7BL4=
Date: Sat, 11 Oct 2025 11:45:20 -0700
To: mm-commits@vger.kernel.org,nathan@kernel.org,morbo@google.com,linux@armlinux.org.uk,justinstitt@google.com,lukas.bulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + treewide-drop-outdated-compiler-version-remarks-in-kconfig-help-texts.patch added to mm-nonmm-unstable branch
Message-Id: <20251011184520.CD0FCC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: treewide: drop outdated compiler version remarks in Kconfig help texts
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     treewide-drop-outdated-compiler-version-remarks-in-kconfig-help-texts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/treewide-drop-outdated-compiler-version-remarks-in-kconfig-help-texts.patch

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
From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: treewide: drop outdated compiler version remarks in Kconfig help texts
Date: Fri, 10 Oct 2025 10:21:38 +0200

As of writing, Documentation/Changes states the minimal versions of GNU C
being 8.1, Clang being 15.0.0 and binutils being 2.30.  A few Kconfig help
texts are pointing out that specific GCC and Clang versions are needed,
but by now, those pointers to versions, such later than 4.0, later than
4.4, or clang later than 5.0, are obsolete and unlikely to be found by
users configuring their kernel builds anyway.

Drop these outdated remarks in Kconfig help texts referring to older
compiler and binutils versions.  No functional change.

Link: https://lkml.kernel.org/r/20251010082138.185752-1-lukas.bulwahn@redhat.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Russel King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig      |   19 ++++++++-----------
 arch/arm/Kconfig  |    2 --
 lib/Kconfig.debug |    3 +--
 3 files changed, 9 insertions(+), 15 deletions(-)

--- a/arch/arm/Kconfig~treewide-drop-outdated-compiler-version-remarks-in-kconfig-help-texts
+++ a/arch/arm/Kconfig
@@ -1158,8 +1158,6 @@ config AEABI
 	  disambiguate both ABIs and allow for backward compatibility support
 	  (selected with CONFIG_OABI_COMPAT).
 
-	  To use this you need GCC version 4.0.0 or later.
-
 config OABI_COMPAT
 	bool "Allow old ABI binaries to run with this kernel (EXPERIMENTAL)"
 	depends on AEABI && !THUMB2_KERNEL
--- a/arch/Kconfig~treewide-drop-outdated-compiler-version-remarks-in-kconfig-help-texts
+++ a/arch/Kconfig
@@ -232,17 +232,14 @@ config HAVE_EFFICIENT_UNALIGNED_ACCESS
 config ARCH_USE_BUILTIN_BSWAP
 	bool
 	help
-	  Modern versions of GCC (since 4.4) have builtin functions
-	  for handling byte-swapping. Using these, instead of the old
-	  inline assembler that the architecture code provides in the
-	  __arch_bswapXX() macros, allows the compiler to see what's
-	  happening and offers more opportunity for optimisation. In
-	  particular, the compiler will be able to combine the byteswap
-	  with a nearby load or store and use load-and-swap or
-	  store-and-swap instructions if the architecture has them. It
-	  should almost *never* result in code which is worse than the
-	  hand-coded assembler in <asm/swab.h>.  But just in case it
-	  does, the use of the builtins is optional.
+	  GCC and Clang have builtin functions for handling byte-swapping.
+	  Using these allows the compiler to see what's happening and
+	  offers more opportunity for optimisation. In particular, the
+	  compiler will be able to combine the byteswap with a nearby load
+	  or store and use load-and-swap or store-and-swap instructions if
+	  the architecture has them. It should almost *never* result in code
+	  which is worse than the hand-coded assembler in <asm/swab.h>.
+	  But just in case it does, the use of the builtins is optional.
 
 	  Any architecture with load-and-swap or store-and-swap
 	  instructions should set this. And it shouldn't hurt to set it
--- a/lib/Kconfig.debug~treewide-drop-outdated-compiler-version-remarks-in-kconfig-help-texts
+++ a/lib/Kconfig.debug
@@ -332,8 +332,7 @@ config DEBUG_INFO_COMPRESSED_ZLIB
 	depends on $(cc-option,-gz=zlib)
 	depends on $(ld-option,--compress-debug-sections=zlib)
 	help
-	  Compress the debug information using zlib.  Requires GCC 5.0+ or Clang
-	  5.0+, binutils 2.26+, and zlib.
+	  Compress the debug information using zlib.
 
 	  Users of dpkg-deb via debian/rules may find an increase in
 	  size of their debug .deb packages with this config set, due to the
_

Patches currently in -mm which might be from lukas.bulwahn@redhat.com are

treewide-drop-outdated-compiler-version-remarks-in-kconfig-help-texts.patch


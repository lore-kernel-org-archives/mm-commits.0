Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D4814B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908576; cv=none; b=IK3TK8HSkY7tfCbo8Gy36CZuZ37+X7VswZfClgSHRCSFwHCvQ5vQ/ZKm1Ilrc8v4tqem8Kok3TwMHTUWSJEcSJomVxkPT7YjbvMV6EZfaAEEwezYP/v4RuZylPvSQtzFKIdlZxv1lKw0Cl5lUxPJGhvAjDusgGknMGGgRcft8r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908576; c=relaxed/simple;
	bh=ulnxQHPET/m0YgBYAhwibgZW3n9qpZRTGOPIhvAFj44=;
	h=Date:To:From:Subject:Message-Id; b=FUpHQSGCVqeCMwG4+qeFxov9r7WcrU9GtZfTVYGeqZc6onMCYI/kHgYMYQTnXjAby+hF//yGNxcc6lxGeXsSJUktPoiBJ4zhONTIPUuU5Ub6uqzGQePmxCBUtrRsUPzxmoxfBv65PGRotCCtMAHXEg6QJ5xqqUurXQoq/1r4fgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TKXNptva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TKXNptva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FC5C113D0;
	Wed, 12 Nov 2025 00:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908575;
	bh=ulnxQHPET/m0YgBYAhwibgZW3n9qpZRTGOPIhvAFj44=;
	h=Date:To:From:Subject:From;
	b=TKXNptvaOQDST9mXny0WaFyUqLE/UbkVvsCzmAQcyKOeOG0QO/T1dIs7GhIi42bq0
	 k0b6CJyxcoztW49rXyzdaYRDTuUVPNi5V233HYHN5rXYqw6LadhfBuvHXX+L1ByUY0
	 7Nq8X1nbpdrX0xw+emOqtnJ7OCYsCv4BFmKnWY9Q=
Date: Tue, 11 Nov 2025 16:49:35 -0800
To: mm-commits@vger.kernel.org,nathan@kernel.org,morbo@google.com,linux@armlinux.org.uk,justinstitt@google.com,lukas.bulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] treewide-drop-outdated-compiler-version-remarks-in-kconfig-help-texts.patch removed from -mm tree
Message-Id: <20251112004935.86FC5C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: treewide: drop outdated compiler version remarks in Kconfig help texts
has been removed from the -mm tree.  Its filename was
     treewide-drop-outdated-compiler-version-remarks-in-kconfig-help-texts.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1161,8 +1161,6 @@ config AEABI
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43651415B83
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 02:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788230140; cv=none; b=Q4W0+rH4nOcDbazBEOWQjRZ7byU+gpciILx4U+xKYzKUf36jIT9eaCj3yfuNGTKeMsUXFX1E1mKJKIyeUqpKcTMagJ56MVI/S2pIo2he4zbPy7weriHRBy9h5kB25BIDSzQ3jIp8bS3wdp/QkehnJ4jl4XZo5OpswB+VlhQKKuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788230140; c=relaxed/simple;
	bh=T2hTVZ8F3Qvtm+UGXUNvK6Jp9pJHlj7q/ubhQEkqpuo=;
	h=Date:To:From:Subject:Message-Id; b=UfAzffv/mCBV8y27t6zW7fDRyCRGKngz/9EdXbb0NbD/hI1lT55qzGEbBfklNN24T3ynya0UH8faSkhHv+Cxs2dfpK8HtFSfR5tHuvdPGObG/SfFus3sFg6TAqBiCSiHuf1lfkBkxcwzXhH7Xo9II2u83Y4qYurgfD7GaDaNP5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TiMWgPZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TiMWgPZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2161F000E9;
	Tue,  1 Sep 2026 02:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788230137;
	bh=cZjVB23RW8HiKBfqNqboxxgDUIXW9C5rZS499PLCCac=;
	h=Date:To:From:Subject;
	b=TiMWgPZjhyvfyoxcKdubTghWPPogFshLHD6if0x7Y5FXQ1zvBiWme0acekBrxS27z
	 m36mlJbuEXVoPvs+6qDxpZ7FwELTotElQHDgtHlqvQbDMHyXHMdREhAF4bxjq9wF7d
	 D5PN8HRJA4fOPjoeEBGVtmBcEe7ZN1eu1eATowSA=
Date: Mon, 31 Aug 2026 19:35:36 -0700
To: mm-commits@vger.kernel.org,ruanjinjie@huawei.com,arnd@arndb.de,julianbraha@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-kconfig-fix-dead-conditions-by-removing-dead-options.patch added to mm-nonmm-unstable branch
Message-Id: <20260901023537.3C2161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/Kconfig: fix dead conditions by removing dead options
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arch-kconfig-fix-dead-conditions-by-removing-dead-options.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-kconfig-fix-dead-conditions-by-removing-dead-options.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Julian Braha <julianbraha@gmail.com>
Subject: arch/Kconfig: fix dead conditions by removing dead options
Date: Mon, 31 Aug 2026 00:00:16 +0100

These two 'int' options:

ARCH_MMAP_RND_BITS_DEFAULT
ARCH_MMAP_RND_COMPAT_BITS_DEFAULT

are used directly as conditions for defaults. 'int' options should not be
used as conditions, because they will always evaluate to false.

Let's remove these options, because they are not used anywhere else.

This dead code was found by kconfirm, a static analysis tool for Kconfig.

Link: https://lore.kernel.org/20260830230016.2730093-1-julianbraha@gmail.com
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/Kconfig~arch-kconfig-fix-dead-conditions-by-removing-dead-options
+++ a/arch/Kconfig
@@ -1238,13 +1238,9 @@ config ARCH_MMAP_RND_BITS_MIN
 config ARCH_MMAP_RND_BITS_MAX
 	int
 
-config ARCH_MMAP_RND_BITS_DEFAULT
-	int
-
 config ARCH_MMAP_RND_BITS
 	int "Number of bits to use for ASLR of mmap base address" if EXPERT
 	range ARCH_MMAP_RND_BITS_MIN ARCH_MMAP_RND_BITS_MAX
-	default ARCH_MMAP_RND_BITS_DEFAULT if ARCH_MMAP_RND_BITS_DEFAULT
 	default ARCH_MMAP_RND_BITS_MIN
 	depends on HAVE_ARCH_MMAP_RND_BITS
 	help
@@ -1272,13 +1268,9 @@ config ARCH_MMAP_RND_COMPAT_BITS_MIN
 config ARCH_MMAP_RND_COMPAT_BITS_MAX
 	int
 
-config ARCH_MMAP_RND_COMPAT_BITS_DEFAULT
-	int
-
 config ARCH_MMAP_RND_COMPAT_BITS
 	int "Number of bits to use for ASLR of mmap base address for compatible applications" if EXPERT
 	range ARCH_MMAP_RND_COMPAT_BITS_MIN ARCH_MMAP_RND_COMPAT_BITS_MAX
-	default ARCH_MMAP_RND_COMPAT_BITS_DEFAULT if ARCH_MMAP_RND_COMPAT_BITS_DEFAULT
 	default ARCH_MMAP_RND_COMPAT_BITS_MIN
 	depends on HAVE_ARCH_MMAP_RND_COMPAT_BITS
 	help
_

Patches currently in -mm which might be from julianbraha@gmail.com are

lib-cleanup-fake-tristates-in-kconfig.patch
arch-kconfig-fix-dead-conditions-by-removing-dead-options.patch


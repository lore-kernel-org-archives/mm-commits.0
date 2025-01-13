Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959CB25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742143; cv=none; b=edul0Pqhl3CznxGS7K7X7n0vMfylPdOJzyKm19QTri00aXadveM+HBD55kUp3uelssd4PycTAZeV1Np0un9B74Zwsi46SfsgSzGenc0C5ja6E+nyY4Ck56VjA7uB102gAioYybbinxDOo/BuLeQSnVKL5tPTwQw0bkJIVLcxH84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742143; c=relaxed/simple;
	bh=lRGqjOPUl+0+L6bpgE9MrMQDM86bDrJOgk8wGGd/8Ng=;
	h=Date:To:From:Subject:Message-Id; b=hPAkfs+udTBkv75heSVqGFc6aoElNc1TtTrhIt3W4euXL9hea2QVcckGIINYoS3Bzxkjadf3p5cfwdAavNsAm93ClO4uIl0HuaVzuyGpBd9nc/eb5fs2u7/mejKZnYkZgoXgJ1XyR9bMrmwc2XWSvXTqfKCiWct2ejK0HJe5AI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wCrJe2Pa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wCrJe2Pa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60835C4CED6;
	Mon, 13 Jan 2025 04:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742143;
	bh=lRGqjOPUl+0+L6bpgE9MrMQDM86bDrJOgk8wGGd/8Ng=;
	h=Date:To:From:Subject:From;
	b=wCrJe2Pafd62phr3fjtUCIn5Lv8a4pJAbWJIFBlecMfftQqS0VZCDiCVApUid3Sdj
	 oKB3o+Rf18yDwO9yaoF2v1adzn3tpXSV8V2wTGTA8J/udIslpJQ3Um3AwCIfvIwNr8
	 SibENdk/BUrB0MFaw30KL+m6tSid3uUemDsbH56w=
Date: Sun, 12 Jan 2025 20:22:22 -0800
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,oleg@redhat.com,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,lukas.bulwahn@gmail.com,linux@rasmusvillemoes.dk,joe@perches.com,dwaipayanray1@gmail.com,arnd@arndb.de,apw@canonical.com,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] include-update-references-to-include-asm-arch.patch removed from -mm tree
Message-Id: <20250113042223.60835C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include: update references to include/asm-<arch>
has been removed from the -mm tree.  Its filename was
     include-update-references-to-include-asm-arch.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: include: update references to include/asm-<arch>
Date: Thu, 5 Dec 2024 14:20:44 +0100

"include/asm-<arch>" was replaced by "arch/<arch>/include/asm" a long time
ago.

Link: https://lkml.kernel.org/r/541258219b0441fa1da890e2f8458a7ac18c2ef9.1733404444.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/syscall.h |    2 +-
 include/linux/bitmap.h        |    2 +-
 include/linux/types.h         |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/asm-generic/syscall.h~include-update-references-to-include-asm-arch
+++ a/include/asm-generic/syscall.h
@@ -5,7 +5,7 @@
  * Copyright (C) 2008-2009 Red Hat, Inc.  All rights reserved.
  *
  * This file is a stub providing documentation for what functions
- * asm-ARCH/syscall.h files need to define.  Most arch definitions
+ * arch/ARCH/include/asm/syscall.h files need to define.  Most arch definitions
  * will be simple inlines.
  *
  * All of these functions expect to be called with no locks,
--- a/include/linux/bitmap.h~include-update-references-to-include-asm-arch
+++ a/include/linux/bitmap.h
@@ -23,7 +23,7 @@ struct device;
  *
  * Function implementations generic to all architectures are in
  * lib/bitmap.c.  Functions implementations that are architecture
- * specific are in various include/asm-<arch>/bitops.h headers
+ * specific are in various arch/<arch>/include/asm/bitops.h headers
  * and other arch/<arch> specific files.
  *
  * See lib/bitmap.c for more details.
--- a/include/linux/types.h~include-update-references-to-include-asm-arch
+++ a/include/linux/types.h
@@ -43,7 +43,7 @@ typedef unsigned long		uintptr_t;
 typedef long			intptr_t;
 
 #ifdef CONFIG_HAVE_UID16
-/* This is defined by include/asm-{arch}/posix_types.h */
+/* This is defined by arch/{arch}/include/asm/posix_types.h */
 typedef __kernel_old_uid_t	old_uid_t;
 typedef __kernel_old_gid_t	old_gid_t;
 #endif /* CONFIG_UID16 */
_

Patches currently in -mm which might be from geert+renesas@glider.be are



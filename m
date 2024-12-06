Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127691F5FD
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 01:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733447637; cv=none; b=OqjGxgre7BNf8zhLpUpw51KD2PEljzZObCmFcwcV67Dh9RAkpRa5Bu/ixnlnTbTtae87kopaDCZYb77b1E1Qu9H5edL8w8r5+wwbwfYLsiE9zK1O53yaWpADqqwwMcjJnXAPtjb5NM5zFn0GFJZaMrSogxXA648c5PdKlACw35Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733447637; c=relaxed/simple;
	bh=vQ0ib/XF385TGOlhfiKYZPWyiYPzrCOYz1rnGKegeKU=;
	h=Date:To:From:Subject:Message-Id; b=EH9Wv7qUHeW1H+iQhE8Vbw+itTrXBAvcKgix7eZzTbkRiIxwFBZrNFf3bDwpOsgLch1dFXpvL3fZ0lRm0LjiOF520NLOH6wJfr8uGWqqugqrYcBzgdULEpS8GraDWLoB+D28OyjB2RRKhFUp2SJABec3vXdywRsbNSzoZMwFYzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y/oL6fka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y/oL6fka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A5AC4CED1;
	Fri,  6 Dec 2024 01:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733447636;
	bh=vQ0ib/XF385TGOlhfiKYZPWyiYPzrCOYz1rnGKegeKU=;
	h=Date:To:From:Subject:From;
	b=Y/oL6fkay1CZXalJIH+FM+qHtm5jDGz2H7SYPbD0GnMUx4gkaCivzYFbEj7iGSP2F
	 Jui0oiaZWxERps3RJ2OEn008LA0PPiAX1ZemF3OmDh2ZOUnWBxr8VBWtU2SmZcPIr8
	 MQZI3Y3LIFjYtyQqylsHITrtOrQK6oTRMtyDvHUU=
Date: Thu, 05 Dec 2024 17:13:55 -0800
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,oleg@redhat.com,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,lukas.bulwahn@gmail.com,linux@rasmusvillemoes.dk,joe@perches.com,dwaipayanray1@gmail.com,arnd@arndb.de,apw@canonical.com,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + include-update-references-to-include-asm-arch.patch added to mm-nonmm-unstable branch
Message-Id: <20241206011356.70A5AC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include: update references to include/asm-<arch>
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     include-update-references-to-include-asm-arch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-update-references-to-include-asm-arch.patch

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

checkpatch-update-reference-to-include-asm-arch.patch
kbuild-drop-support-for-include-asm-arch-in-headers_checkpl.patch
include-update-references-to-include-asm-arch.patch


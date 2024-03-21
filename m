Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EE0134CD2
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 22:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711060165; cv=none; b=NU+p5HbY71sltT5jdqL0ARM0RVX1ViZWWXu75Cuk6xCI/nqWfQjXo6w+xQmtFrRWHCLKXcHoo+P60j7kUevus0es3imD/UEjup3REEE2pVFRGWvhFpE5fEi6xoZ/gg9iA8thxqiFHrZOAaDbMp9auc6/JmDEZlSVprbFoau36Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711060165; c=relaxed/simple;
	bh=GApywQfliI5lRws7Ib/CRe2T4hzQ827wadaw2hTuT68=;
	h=Date:To:From:Subject:Message-Id; b=ELi4izj0xW/CDyrTNTit4MRXhTWVWU/6dhKyCzAu40pZ8DFJhg9mAJ+brHb6TGjdVJHMBneQzxqlotf9pLW9lTmTNRcijUFqssMVhCPILOyvB/93x1G5QP999ViFJidO1jjNPtmAOAgkzTkt+9qy5aDYrMacmxxyfLGiVyQwyc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q9FzzQaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q9FzzQaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347EDC433F1;
	Thu, 21 Mar 2024 22:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711060163;
	bh=GApywQfliI5lRws7Ib/CRe2T4hzQ827wadaw2hTuT68=;
	h=Date:To:From:Subject:From;
	b=q9FzzQazRAYY/pHR/NMf5Ith5s2b7QdehOAiB+4MKNL/oJy9m6NqZz1lUFEfRrvBk
	 jzx/KCGLCgp85VSRqea1hJ4hA7FFR+iv5M97jhH7J63d7kAQ8z4sQ9UWEQfJGVi05X
	 eH1uC73EsKop/d1t5hc6AvMUf1nJ5Uoixj+x8yLU=
Date: Thu, 21 Mar 2024 15:29:22 -0700
To: mm-commits@vger.kernel.org,jiat0218@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch added to mm-nonmm-unstable branch
Message-Id: <20240321222923.347EDC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xz: switch from public domain to BSD Zero Clause License (0BSD)
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch

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
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: xz: switch from public domain to BSD Zero Clause License (0BSD)
Date: Wed, 20 Mar 2024 20:38:36 +0200

Remove the public domain notices and add SPDX license identifiers.

Change MODULE_LICENSE from "GPL" to "Dual BSD/GPL" because 0BSD should
count as a BSD license variant here.

The switch to 0BSD was done in the upstream XZ Embedded project because
public domain has (real or perceived) legal issues in some jurisdictions.

Link: https://lkml.kernel.org/r/20240320183846.19475-4-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Jia Tan <jiat0218@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/unxz.h |    5 ++---
 include/linux/xz.h              |    5 ++---
 lib/decompress_unxz.c           |    5 ++---
 lib/xz/xz_crc32.c               |    5 ++---
 lib/xz/xz_dec_bcj.c             |    5 ++---
 lib/xz/xz_dec_lzma2.c           |    5 ++---
 lib/xz/xz_dec_stream.c          |    5 ++---
 lib/xz/xz_dec_syms.c            |   12 +++---------
 lib/xz/xz_dec_test.c            |   12 +++---------
 lib/xz/xz_lzma2.h               |    5 ++---
 lib/xz/xz_private.h             |    5 ++---
 lib/xz/xz_stream.h              |    5 ++---
 scripts/xz_wrap.sh              |    5 +----
 13 files changed, 27 insertions(+), 52 deletions(-)

--- a/include/linux/decompress/unxz.h~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/include/linux/decompress/unxz.h
@@ -1,10 +1,9 @@
+/* SPDX-License-Identifier: 0BSD */
+
 /*
  * Wrapper for decompressing XZ-compressed kernel, initramfs, and initrd
  *
  * Author: Lasse Collin <lasse.collin@tukaani.org>
- *
- * This file has been put into the public domain.
- * You can do whatever you want with this file.
  */
 
 #ifndef DECOMPRESS_UNXZ_H
--- a/include/linux/xz.h~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/include/linux/xz.h
@@ -1,11 +1,10 @@
+/* SPDX-License-Identifier: 0BSD */
+
 /*
  * XZ decompressor
  *
  * Authors: Lasse Collin <lasse.collin@tukaani.org>
  *          Igor Pavlov <https://7-zip.org/>
- *
- * This file has been put into the public domain.
- * You can do whatever you want with this file.
  */
 
 #ifndef XZ_H
--- a/lib/decompress_unxz.c~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/lib/decompress_unxz.c
@@ -1,10 +1,9 @@
+// SPDX-License-Identifier: 0BSD
+
 /*
  * Wrapper for decompressing XZ-compressed kernel, initramfs, and initrd
  *
  * Author: Lasse Collin <lasse.collin@tukaani.org>
- *
- * This file has been put into the public domain.
- * You can do whatever you want with this file.
  */
 
 /*
--- a/lib/xz/xz_crc32.c~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/lib/xz/xz_crc32.c
@@ -1,11 +1,10 @@
+// SPDX-License-Identifier: 0BSD
+
 /*
  * CRC32 using the polynomial from IEEE-802.3
  *
  * Authors: Lasse Collin <lasse.collin@tukaani.org>
  *          Igor Pavlov <https://7-zip.org/>
- *
- * This file has been put into the public domain.
- * You can do whatever you want with this file.
  */
 
 /*
--- a/lib/xz/xz_dec_bcj.c~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/lib/xz/xz_dec_bcj.c
@@ -1,11 +1,10 @@
+// SPDX-License-Identifier: 0BSD
+
 /*
  * Branch/Call/Jump (BCJ) filter decoders
  *
  * Authors: Lasse Collin <lasse.collin@tukaani.org>
  *          Igor Pavlov <https://7-zip.org/>
- *
- * This file has been put into the public domain.
- * You can do whatever you want with this file.
  */
 
 #include "xz_private.h"
--- a/lib/xz/xz_dec_lzma2.c~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/lib/xz/xz_dec_lzma2.c
@@ -1,11 +1,10 @@
+// SPDX-License-Identifier: 0BSD
+
 /*
  * LZMA2 decoder
  *
  * Authors: Lasse Collin <lasse.collin@tukaani.org>
  *          Igor Pavlov <https://7-zip.org/>
- *
- * This file has been put into the public domain.
- * You can do whatever you want with this file.
  */
 
 #include "xz_private.h"
--- a/lib/xz/xz_dec_stream.c~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/lib/xz/xz_dec_stream.c
@@ -1,10 +1,9 @@
+// SPDX-License-Identifier: 0BSD
+
 /*
  * .xz Stream decoder
  *
  * Author: Lasse Collin <lasse.collin@tukaani.org>
- *
- * This file has been put into the public domain.
- * You can do whatever you want with this file.
  */
 
 #include "xz_private.h"
--- a/lib/xz/xz_dec_syms.c~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/lib/xz/xz_dec_syms.c
@@ -1,10 +1,9 @@
+// SPDX-License-Identifier: 0BSD
+
 /*
  * XZ decoder module information
  *
  * Author: Lasse Collin <lasse.collin@tukaani.org>
- *
- * This file has been put into the public domain.
- * You can do whatever you want with this file.
  */
 
 #include <linux/module.h>
@@ -25,9 +24,4 @@ EXPORT_SYMBOL(xz_dec_microlzma_end);
 MODULE_DESCRIPTION("XZ decompressor");
 MODULE_VERSION("1.1");
 MODULE_AUTHOR("Lasse Collin <lasse.collin@tukaani.org> and Igor Pavlov");
-
-/*
- * This code is in the public domain, but in Linux it's simplest to just
- * say it's GPL and consider the authors as the copyright holders.
- */
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
--- a/lib/xz/xz_dec_test.c~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/lib/xz/xz_dec_test.c
@@ -1,10 +1,9 @@
+// SPDX-License-Identifier: 0BSD
+
 /*
  * XZ decoder tester
  *
  * Author: Lasse Collin <lasse.collin@tukaani.org>
- *
- * This file has been put into the public domain.
- * You can do whatever you want with this file.
  */
 
 #include <linux/kernel.h>
@@ -212,9 +211,4 @@ module_exit(xz_dec_test_exit);
 MODULE_DESCRIPTION("XZ decompressor tester");
 MODULE_VERSION("1.0");
 MODULE_AUTHOR("Lasse Collin <lasse.collin@tukaani.org>");
-
-/*
- * This code is in the public domain, but in Linux it's simplest to just
- * say it's GPL and consider the authors as the copyright holders.
- */
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
--- a/lib/xz/xz_lzma2.h~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/lib/xz/xz_lzma2.h
@@ -1,11 +1,10 @@
+/* SPDX-License-Identifier: 0BSD */
+
 /*
  * LZMA2 definitions
  *
  * Authors: Lasse Collin <lasse.collin@tukaani.org>
  *          Igor Pavlov <https://7-zip.org/>
- *
- * This file has been put into the public domain.
- * You can do whatever you want with this file.
  */
 
 #ifndef XZ_LZMA2_H
--- a/lib/xz/xz_private.h~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/lib/xz/xz_private.h
@@ -1,10 +1,9 @@
+/* SPDX-License-Identifier: 0BSD */
+
 /*
  * Private includes and definitions
  *
  * Author: Lasse Collin <lasse.collin@tukaani.org>
- *
- * This file has been put into the public domain.
- * You can do whatever you want with this file.
  */
 
 #ifndef XZ_PRIVATE_H
--- a/lib/xz/xz_stream.h~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/lib/xz/xz_stream.h
@@ -1,10 +1,9 @@
+/* SPDX-License-Identifier: 0BSD */
+
 /*
  * Definitions for handling the .xz file format
  *
  * Author: Lasse Collin <lasse.collin@tukaani.org>
- *
- * This file has been put into the public domain.
- * You can do whatever you want with this file.
  */
 
 #ifndef XZ_STREAM_H
--- a/scripts/xz_wrap.sh~xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd
+++ a/scripts/xz_wrap.sh
@@ -1,13 +1,10 @@
 #!/bin/sh
+# SPDX-License-Identifier: 0BSD
 #
 # This is a wrapper for xz to compress the kernel image using appropriate
 # compression options depending on the architecture.
 #
 # Author: Lasse Collin <lasse.collin@tukaani.org>
-#
-# This file has been put into the public domain.
-# You can do whatever you want with this file.
-#
 
 BCJ=
 LZMA2OPTS=
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

maintainers-add-xz-embedded-maintainers.patch
licenses-add-0bsd-license-text.patch
xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch
xz-documentation-staging-xzrst-revise-thoroughly.patch
xz-fix-comments-and-coding-style.patch
xz-cleanup-crc32-edits-from-2018.patch
xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch
xz-add-arm64-bcj-filter.patch
xz-add-risc-v-bcj-filter.patch
xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch
xz-adjust-arch-specific-options-for-better-kernel-compression.patch


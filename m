Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128EC13AD06
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248761; cv=none; b=QbxwR4bhPrlMNOxqzU4jP3BmdjhvSQsJW+i3wxCehJyiTBp8+lZXMgkGDqgcEvF/GoAvkilRjGrzYBJj+dZMLrliIpdsNAgSDnQEJXDHIl0jwghjtl/ETafLL1AnMr9B+VyrNUbZMMmGCwU8A67YJjf3qCZ5JEFsuB3OjI4XpZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248761; c=relaxed/simple;
	bh=iA5LfotyI+sxn3ZoePtjzK3Ynt//pAhuTlPdYkW5nTE=;
	h=Date:To:From:Subject:Message-Id; b=pQ/SGG0j4zpfd2HCGoMF1xOGOrwAorNkqzJdBa1iHL6Yg/rRWXzFDF9DvBzFNDa/NFlGIXq7Zb4Jpn0aO+adhd8i7/FoQrznaflofdpU/P+JoMCVZozzK6w3Jgn8ehDR5nrqKY7l2Wy3va5fQ+QnJY1oqSjb4YyX+XEhtp0YbXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qcN08aYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qcN08aYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B792C4CEC2;
	Mon,  2 Sep 2024 03:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248760;
	bh=iA5LfotyI+sxn3ZoePtjzK3Ynt//pAhuTlPdYkW5nTE=;
	h=Date:To:From:Subject:From;
	b=qcN08aYW08FcOCug9ejK2/90T5ZQDdUmUGZ+izqDXTlICeQXvID4CUqWnr1N65Myq
	 v80QUik2aA61/kT0B6xjI7q2BMD4KLeIRwic1vLyUjpJdxoCvcK39o2WcYp7/GPj53
	 suNsFaiHmIqSlvT/DHR/Dr6thFp/4MvxVAXrjv9k=
Date: Sun, 01 Sep 2024 20:46:00 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch removed from -mm tree
Message-Id: <20240902034600.9B792C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xz: switch from public domain to BSD Zero Clause License (0BSD)
has been removed from the -mm tree.  Its filename was
     xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: xz: switch from public domain to BSD Zero Clause License (0BSD)
Date: Sun, 21 Jul 2024 16:36:18 +0300

Remove the public domain notices and add SPDX license identifiers.

Change MODULE_LICENSE from "GPL" to "Dual BSD/GPL" because 0BSD should
count as a BSD license variant here.

The switch to 0BSD was done in the upstream XZ Embedded project because
public domain has (real or perceived) legal issues in some jurisdictions.

Link: https://lkml.kernel.org/r/20240721133633.47721-4-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Sam James <sam@gentoo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Cc: Jules Maselbas <jmaselbas@zdiv.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rui Li <me@lirui.org>
Cc: Simon Glass <sjg@chromium.org>
Cc: Will Deacon <will@kernel.org>
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B361A32
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248762; cv=none; b=SrOLxU4cExbBTTzyI6e621Y801QnNgq1A2lrn9mL8r7A6pl74HgsS54JkcRETxwC34ju0HK0HKMm/bso1VaghuoHMsn70VHyxfUwTbp/lNAamuu55Y5qBPDz211swY386PgbYmi56KP7Pxq0EPO6ZwBOi3lRhvi76mskhV6gg+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248762; c=relaxed/simple;
	bh=RUODdIMif7TKI9BarNWwFxr81DbhbCMYi0fUF7zgJRk=;
	h=Date:To:From:Subject:Message-Id; b=OzY0A9D8LPoMSfTj8iYYSYyaAKmgCOkjy13hb6lK/I8YnjL8Auu67osjIUMHtAdDB9Tw6Id2x2iZYtx8PHcQ7wKXPHrce9ahjsTpDUYd9813wT4adOY5ncJgN9fKeysJCnqZnTP/GaxDDe0FWK1SEaxlwwlazmldrRWprnqWEqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xWfYrAQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xWfYrAQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFA3C4CEC2;
	Mon,  2 Sep 2024 03:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248762;
	bh=RUODdIMif7TKI9BarNWwFxr81DbhbCMYi0fUF7zgJRk=;
	h=Date:To:From:Subject:From;
	b=xWfYrAQfeuVKkcsO4m5olQ3vi2d0MpROouIfBVcAbVO5SAg2bf1sO9bpr85E/cD2y
	 rQKmyj7xGJWB1aEf7XBJ8+XTqk9MTDxhd2sen8jT0MicwmDxGdBiXGHDn8eKcim0iy
	 Er0hLmirHe/9/aGVsELb79u9/CWtbkSA2mpJdXfE=
Date: Sun, 01 Sep 2024 20:46:01 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xz-fix-comments-and-coding-style.patch removed from -mm tree
Message-Id: <20240902034602.1FFA3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xz: fix comments and coding style
has been removed from the -mm tree.  Its filename was
     xz-fix-comments-and-coding-style.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: xz: fix comments and coding style
Date: Sun, 21 Jul 2024 16:36:19 +0300

- Fix comments that were no longer in sync with the code below them.
- Fix language errors.
- Fix coding style.

Link: https://lkml.kernel.org/r/20240721133633.47721-5-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Sam James <sam@gentoo.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unxz.c |   20 ++++++++++----------
 lib/xz/Kconfig        |    3 ++-
 scripts/Makefile.lib  |   13 ++++++++-----
 3 files changed, 20 insertions(+), 16 deletions(-)

--- a/lib/decompress_unxz.c~xz-fix-comments-and-coding-style
+++ a/lib/decompress_unxz.c
@@ -102,7 +102,7 @@
 #ifdef STATIC
 #	define XZ_PREBOOT
 #else
-#include <linux/decompress/unxz.h>
+#	include <linux/decompress/unxz.h>
 #endif
 #ifdef __KERNEL__
 #	include <linux/decompress/mm.h>
@@ -219,7 +219,7 @@ void *memmove(void *dest, const void *sr
 #endif
 
 /*
- * Since we need memmove anyway, would use it as memcpy too.
+ * Since we need memmove anyway, we could use it as memcpy too.
  * Commented out for now to avoid breaking things.
  */
 /*
@@ -389,17 +389,17 @@ error_alloc_state:
 }
 
 /*
- * This macro is used by architecture-specific files to decompress
+ * This function is used by architecture-specific files to decompress
  * the kernel image.
  */
 #ifdef XZ_PREBOOT
-STATIC int INIT __decompress(unsigned char *buf, long len,
-			   long (*fill)(void*, unsigned long),
-			   long (*flush)(void*, unsigned long),
-			   unsigned char *out_buf, long olen,
-			   long *pos,
-			   void (*error)(char *x))
+STATIC int INIT __decompress(unsigned char *in, long in_size,
+			     long (*fill)(void *dest, unsigned long size),
+			     long (*flush)(void *src, unsigned long size),
+			     unsigned char *out, long out_size,
+			     long *in_used,
+			     void (*error)(char *x))
 {
-	return unxz(buf, len, fill, flush, out_buf, pos, error);
+	return unxz(in, in_size, fill, flush, out, in_used, error);
 }
 #endif
--- a/lib/xz/Kconfig~xz-fix-comments-and-coding-style
+++ a/lib/xz/Kconfig
@@ -5,7 +5,8 @@ config XZ_DEC
 	help
 	  LZMA2 compression algorithm and BCJ filters are supported using
 	  the .xz file format as the container. For integrity checking,
-	  CRC32 is supported. See Documentation/staging/xz.rst for more information.
+	  CRC32 is supported. See Documentation/staging/xz.rst for more
+	  information.
 
 if XZ_DEC
 
--- a/scripts/Makefile.lib~xz-fix-comments-and-coding-style
+++ a/scripts/Makefile.lib
@@ -530,14 +530,17 @@ quiet_cmd_fit = FIT     $@
 
 # XZ
 # ---------------------------------------------------------------------------
-# Use xzkern to compress the kernel image and xzmisc to compress other things.
+# Use xzkern or xzkern_with_size to compress the kernel image and xzmisc to
+# compress other things.
 #
 # xzkern uses a big LZMA2 dictionary since it doesn't increase memory usage
 # of the kernel decompressor. A BCJ filter is used if it is available for
-# the target architecture. xzkern also appends uncompressed size of the data
-# using size_append. The .xz format has the size information available at
-# the end of the file too, but it's in more complex format and it's good to
-# avoid changing the part of the boot code that reads the uncompressed size.
+# the target architecture.
+#
+# xzkern_with_size also appends uncompressed size of the data using
+# size_append. The .xz format has the size information available at the end
+# of the file too, but it's in more complex format and it's good to avoid
+# changing the part of the boot code that reads the uncompressed size.
 # Note that the bytes added by size_append will make the xz tool think that
 # the file is corrupt. This is expected.
 #
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are



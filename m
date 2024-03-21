Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBDA134CD2
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 22:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711060178; cv=none; b=P4jrjyMIt8LTRSktXHk/VGnemzQSPt7xoh/tnkoLdSl+pNQ9Q6igd7ljGBEDDHSx/pqdxDZNIgu2WHvjD2qa3QfEc5XFP4d6ghTPxX0/FhkLptXFHDjMFgjROCXhX68Khojhyf1J0ScTasgjYFOTIBRAcIrmoSX8tfGJuBpexY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711060178; c=relaxed/simple;
	bh=DX2xuuq24adKVUttbvitiAs1hZ7Y2S9s2BFJBIv6qMM=;
	h=Date:To:From:Subject:Message-Id; b=j+ToNfNPqaiXq39YuEyFSwZsyj/xm0gG5zmQkRqFp8kp9QUl4gv56Cr9ZRcrzagmzpLjf5hdpfGzO7EcuxaVEzUHmC4Fi4WE+mYNKqFlnO+Pd0r9KWVUqkb5Cwxyt4/E02WGBQ/3tOw7MJlkZEY2R5CbWfG6D1gIA7cPrIBU5fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ywaonmQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ywaonmQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EB1C433F1;
	Thu, 21 Mar 2024 22:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711060177;
	bh=DX2xuuq24adKVUttbvitiAs1hZ7Y2S9s2BFJBIv6qMM=;
	h=Date:To:From:Subject:From;
	b=ywaonmQIMxcA41ONdqUsUiytBYKiRxXzFr87F0zmT2vVtkofosE0EbEXNXBEYkHoB
	 MUmB+foi5WMVIBsgOxOKILPntuTnwupg1Ib9cskrc0LmCuUs9uCsoFvInRqq3svYD5
	 sPlyw2VabtDkboy2L7IN19K74Mv8BtR2xcSMp/Zw=
Date: Thu, 21 Mar 2024 15:29:37 -0700
To: mm-commits@vger.kernel.org,jiat0218@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xz-fix-comments-and-coding-style.patch added to mm-nonmm-unstable branch
Message-Id: <20240321222937.B8EB1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xz: fix comments and coding style
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xz-fix-comments-and-coding-style.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xz-fix-comments-and-coding-style.patch

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
Subject: xz: fix comments and coding style
Date: Wed, 20 Mar 2024 20:38:38 +0200

- Update the URL of the .xz file format specification.
- Fix comments that were no longer in sync with the code below them.
- Fix language errors.
- Fix coding style.

Link: https://lkml.kernel.org/r/20240320183846.19475-6-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Jia Tan <jiat0218@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unxz.c |   20 ++++++++++----------
 lib/xz/Kconfig        |    3 ++-
 lib/xz/xz_stream.h    |    2 +-
 scripts/Makefile.lib  |   13 ++++++++-----
 4 files changed, 21 insertions(+), 17 deletions(-)

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
 
--- a/lib/xz/xz_stream.h~xz-fix-comments-and-coding-style
+++ a/lib/xz/xz_stream.h
@@ -18,7 +18,7 @@
 
 /*
  * See the .xz file format specification at
- * https://tukaani.org/xz/xz-file-format.txt
+ * https://xz.tukaani.org/format/xz-file-format.txt
  * to understand the container format.
  */
 
--- a/scripts/Makefile.lib~xz-fix-comments-and-coding-style
+++ a/scripts/Makefile.lib
@@ -500,14 +500,17 @@ quiet_cmd_uimage = UIMAGE  $@
 
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


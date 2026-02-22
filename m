Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141D03EBF08
	for <mm-commits@vger.kernel.org>; Sun, 22 Feb 2026 19:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771788502; cv=none; b=t9ADu9ZCOI1vKqqxEONtSHGpCxr5ftCx8cvHvQ+P4G3Gche3SHzTlQC59rWuIms7CAFswDRzAXKA6TKhN/MPkP5mOniEX7iDgxiRhbZxZ68ABI4wVe1F6zodGlsIxqnAgUppx9ITUtMDNKVSHRZoaqxOwKOin6FiYv9JVOa1hDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771788502; c=relaxed/simple;
	bh=QwFtNREnlHDjAisQDuDhrLMAnN3PgtQonzKNcN5bqJ4=;
	h=Date:To:From:Subject:Message-Id; b=fNe/PZHbQDhoH9ghrb+MQjFt/WzHtGZf5HwofqRGrMmRqcGF47Z9/zvJfDUavT8UYrDDCEGtvo9CbNnfsJAd3nlM16HOQiu5Lkb/fZeqWrJmn2N+LXETTGuBMIYcXKyUJBESvXPOg2F37LL/wxJpmpXwUCmi/veDqPrScxZEfiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uckl5zIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uckl5zIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880DAC116D0;
	Sun, 22 Feb 2026 19:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771788501;
	bh=QwFtNREnlHDjAisQDuDhrLMAnN3PgtQonzKNcN5bqJ4=;
	h=Date:To:From:Subject:From;
	b=Uckl5zIpDKwn2ASnp0SH2jWz/LRb87GFBt9MbtkSEYi2axuch6M5QUZERN7TwsWP5
	 0lPBa3CMTfM3G5K0Y8sDIqF/yYh3/+6AWG77vV23PcKAem6kOTUgyN7V8eLaMTScHn
	 ijXwb6HlwR15FfGO2KawC5w8seCD6aYLR2q0DCdk=
Date: Sun, 22 Feb 2026 11:28:20 -0800
To: mm-commits@vger.kernel.org,lasse.collin@tukaani.org,kees@kernel.org,haiyuewa@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xz-fix-arm-fdt-compile-error-for-kmalloc-replacement.patch added to mm-hotfixes-unstable branch
Message-Id: <20260222192821.880DAC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xz: fix the preboot code to match the kmalloc_obj change
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     xz-fix-arm-fdt-compile-error-for-kmalloc-replacement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xz-fix-arm-fdt-compile-error-for-kmalloc-replacement.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Haiyue Wang <haiyuewa@163.com>
Subject: xz: fix the preboot code to match the kmalloc_obj change
Date: Sun, 22 Feb 2026 20:11:00 +0800

kmalloc was replaced with kmalloc_obj in lib/xz.  Make the same change
also in the preboot code to fix building of XZ-compressed kernel on a few
archs.  For example, on ARM:

In file included from arch/arm/boot/compressed/../../../../lib/decompress_unxz.c:241,
                 from arch/arm/boot/compressed/decompress.c:56:
arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c: In function 'xz_dec_init':
arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c:787:28: error: implicit declaration of function 'kmalloc_obj'; did you mean 'kmalloc'? [-Wimplicit-function-declaration]
   787 |         struct xz_dec *s = kmalloc_obj(*s);
       |                            ^~~~~~~~~~~
       |                            kmalloc
arch/arm/boot/compressed/../../../../lib/xz/xz_dec_stream.c:787:28: error: initialization of 'struct xz_dec *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
arch/arm/boot/compressed/../../../../lib/decompress_unxz.c:242:
arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c: In function 'xz_dec_lzma2_create':
arch/arm/boot/compressed/../../../../lib/xz/xz_dec_lzma2.c:1141:34: error: initialization of 'struct xz_dec_lzma2 *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
  1141 |         struct xz_dec_lzma2 *s = kmalloc_obj(*s);
       |                                  ^~~~~~~~~~~
arch/arm/boot/compressed/../../../../lib/decompress_unxz.c:243:
arch/arm/boot/compressed/../../../../lib/xz/xz_dec_bcj.c: In function 'xz_dec_bcj_create':
arch/arm/boot/compressed/../../../../lib/xz/xz_dec_bcj.c:594:32: error: initialization of 'struct xz_dec_bcj *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
   594 |         struct xz_dec_bcj *s = kmalloc_obj(*s);
       |                                ^~~~~~~~~~~
CC      arch/arm/boot/compressed/fdt.o

[lasse.collin@tukaani.org: changelog updates]
Link: https://lkml.kernel.org/r/20260222121107.116775-1-haiyuewa@163.com
Fixes: 69050f8d6d07 ("treewide: Replace kmalloc with kmalloc_obj for non-scalar types")
Fixes: bf4afc53b77a ("Convert 'alloc_obj' family to use the new default GFP_KERNEL argument")
Signed-off-by: Haiyue Wang <haiyuewa@163.com>
Acked-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unxz.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/decompress_unxz.c~xz-fix-arm-fdt-compile-error-for-kmalloc-replacement
+++ a/lib/decompress_unxz.c
@@ -157,11 +157,11 @@
  * when XZ_DYNALLOC is used, but the pre-boot free() doesn't support it.
  * Workaround it here because the other decompressors don't need it.
  */
-#undef kmalloc
+#undef kmalloc_obj
 #undef kfree
 #undef vmalloc
 #undef vfree
-#define kmalloc(size, flags) malloc(size)
+#define kmalloc_obj(type) malloc(sizeof(type))
 #define kfree(ptr) free(ptr)
 #define vmalloc(size) malloc(size)
 #define vfree(ptr) do { if (ptr != NULL) free(ptr); } while (0)
_

Patches currently in -mm which might be from haiyuewa@163.com are

xz-fix-arm-fdt-compile-error-for-kmalloc-replacement.patch


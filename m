Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB923385AC
	for <mm-commits@vger.kernel.org>; Mon, 23 Feb 2026 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771869082; cv=none; b=HDSSBYqnwDfltQZgASrMnt5zg2e9kH2Ohqf1RnLOhirSTiKkfbXQXk+9M3ix/Dh1MunIg8qMKLv9JHygDZIIatyjgsdjdyH/vlQ/Rn3OEnm+zi8otF8rgQTv9gR9r7/9K+RAyg7u5S0XKqs5Rj55xxBYzBSVHa/bjYnpewW/0eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771869082; c=relaxed/simple;
	bh=NydPV7HTyZKSe+5ih4qygcp79rk0w6AnnLaI9qoprZM=;
	h=Date:To:From:Subject:Message-Id; b=UyBOtuZT05Ie1Oba1iYqz6Q0AjrGbHQ96rAgcmn5uXmKjBxjgnNSA5UodlCVtdsG9F/TTuC4wViarjplHGWoOhZz/x4yBvchf4DmDBMrT9L8LOzCDPsBVrcojNUEAht2yswm9HWWKdanlJI+sHd7qp3dNXD5C0+M4i+3OIew2RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sehnZ4Rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sehnZ4Rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71614C116C6;
	Mon, 23 Feb 2026 17:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771869082;
	bh=NydPV7HTyZKSe+5ih4qygcp79rk0w6AnnLaI9qoprZM=;
	h=Date:To:From:Subject:From;
	b=sehnZ4RzuhP+ZMHjLyAKNovLW8ik0qVXfEa4RK2kwx//cZtGCLNbB56YUHnuvNZ0u
	 bKXl+htpmn1LeGBaW6jUJ6a4NpzP2r3SOaY6OIeG2bgFm/O579a0vkJtmauI/nDn8g
	 UfsBm8wEPl6ChzcvP8O5Ntn2s8MXepzcjYBlU6HA=
Date: Mon, 23 Feb 2026 09:51:21 -0800
To: mm-commits@vger.kernel.org,lasse.collin@tukaani.org,kees@kernel.org,haiyuewa@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] xz-fix-arm-fdt-compile-error-for-kmalloc-replacement.patch removed from -mm tree
Message-Id: <20260223175122.71614C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xz: fix the preboot code to match the kmalloc_obj change
has been removed from the -mm tree.  Its filename was
     xz-fix-arm-fdt-compile-error-for-kmalloc-replacement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



From: akpm@linux-foundation.org
Subject: [merged] m32r-add-memcpy-for-config_kernel_gzip=y.patch removed from -mm tree
Date: Mon, 23 Jul 2012 14:31:01 -0700
Message-ID: <20120723213101.8B8FC1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:44753 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2GWVbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 17:31:02 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so783980vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 14:31:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: add memcpy() for CONFIG_KERNEL_GZIP=y
has been removed from the -mm tree.  Its filename was
     m32r-add-memcpy-for-config_kernel_gzip=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: m32r: add memcpy() for CONFIG_KERNEL_GZIP=y

  LD      arch/m32r/boot/compressed/vmlinux
arch/m32r/boot/compressed/misc.o: In function `zlib_updatewindow':
misc.c:(.text+0x190): undefined reference to `memcpy'
misc.c:(.text+0x190): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
misc.c:(.text+0x1e0): undefined reference to `memcpy'
misc.c:(.text+0x1e0): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
misc.c:(.text+0x218): undefined reference to `memcpy'
misc.c:(.text+0x218): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
arch/m32r/boot/compressed/misc.o: In function `zlib_inflate':
misc.c:(.text+0x171c): undefined reference to `memcpy'
misc.c:(.text+0x171c): relocation truncated to fit: R_M32R_26_PLTREL against undefined symbol `memcpy'
make[5]: *** [arch/m32r/boot/compressed/vmlinux] Error 1

Add our own implementation of memcpy() to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/boot/compressed/misc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN arch/m32r/boot/compressed/misc.c~m32r-add-memcpy-for-config_kernel_gzip=y arch/m32r/boot/compressed/misc.c
--- a/arch/m32r/boot/compressed/misc.c~m32r-add-memcpy-for-config_kernel_gzip=y
+++ a/arch/m32r/boot/compressed/misc.c
@@ -39,6 +39,16 @@ static void *memset(void *s, int c, size
 #endif
 
 #ifdef CONFIG_KERNEL_GZIP
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	char *d = dest;
+	const char *s = src;
+	while (n--)
+		*d++ = *s++;
+
+	return dest;
+}
+
 #define BOOT_HEAP_SIZE             0x10000
 #include "../../../../lib/decompress_inflate.c"
 #endif
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch
frv-kill-used-but-uninitialized-variable.patch


From: akpm@linux-foundation.org
Subject: [folded-merged]
 bitmap-use-memcmp-optimisation-in-more-situations-fix.patch removed from
 -mm tree
Date: Mon, 10 Jul 2017 15:35:02 -0700
Message-ID: <59640116.MmkdUA3Vm67J6+ud%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41312 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754041AbdGJWfD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, linux@armlinux.org.uk, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: decompressor: add a memcmp() declaration
has been removed from the -mm tree.  Its filename was
     bitmap-use-memcmp-optimisation-in-more-situations-fix.patch

This patch was dropped because it was folded into bitmap-use-memcmp-optimisation-in-more-situations.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ARM: decompressor: add a memcmp() declaration

A reference to memcmp() was added to bitmap.h, which causes another build
warning in the decompressor due to the incompatibility with the regular
kernel string functions:

In file included from /git/arm-soc/include/linux/nodemask.h:94:0,
                 from /git/arm-soc/include/linux/mmzone.h:16,
                 from /git/arm-soc/include/linux/gfp.h:5,
                 from /git/arm-soc/include/linux/kmod.h:22,
                 from /git/arm-soc/include/linux/module.h:13,
                 from /git/arm-soc/arch/arm/boot/compressed/../../../../lib/lz4/lz4_decompress.c:39,
                 from /git/arm-soc/arch/arm/boot/compressed/../../../../lib/decompress_unlz4.c:13,
                 from /git/arm-soc/arch/arm/boot/compressed/decompress.c:56:
include/linux/bitmap.h: In function 'bitmap_equal':
include/linux/bitmap.h:270:11: error: implicit declaration of function 'memcmp'; did you mean 'memchr'? [-Werror=implicit-function-declaration]

This adds one more declaration along with the existing ones.  It would be
nice to find a more generic solution here so we don't have to do this
again the next time, but I couldn't think of a good way to do that.

Fixes: 2118d3a701a8 ("bitmap: Use memcmp optimisation in more situations")
Link: http://lkml.kernel.org/r/20170630153908.3439707-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/compressed/decompress.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/boot/compressed/decompress.c~bitmap-use-memcmp-optimisation-in-more-situations-fix arch/arm/boot/compressed/decompress.c
--- a/arch/arm/boot/compressed/decompress.c~bitmap-use-memcmp-optimisation-in-more-situations-fix
+++ a/arch/arm/boot/compressed/decompress.c
@@ -33,6 +33,7 @@ extern void error(char *);
 /* Not needed, but used in some headers pulled in by decompressors */
 extern char * strstr(const char * s1, const char *s2);
 extern size_t strlen(const char *s);
+extern int memcmp(const void *cs, const void *ct, size_t count);
 
 #ifdef CONFIG_KERNEL_GZIP
 #include "../../../../lib/decompress_inflate.c"
_

Patches currently in -mm which might be from arnd@arndb.de are

bitmap-use-memcmp-optimisation-in-more-situations.patch


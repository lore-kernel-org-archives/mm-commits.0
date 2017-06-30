From: akpm@linux-foundation.org
Subject: + bitmap-use-memcmp-optimisation-in-more-situations-fix.patch
 added to -mm tree
Date: Fri, 30 Jun 2017 12:06:11 -0700
Message-ID: <5956a123.euX6aix1994vc2YH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34116 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752444AbdF3TGR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jun 2017 15:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, linux@armlinux.org.uk, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: decompressor: add a memcmp() declaration
has been added to the -mm tree.  Its filename is
     bitmap-use-memcmp-optimisation-in-more-situations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-use-memcmp-optimisation-in-more-situations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-use-memcmp-optimisation-in-more-situations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix.patch
mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration-fix.patch
kernelh-handle-pointers-to-arrays-better-in-container_of-fix.patch
bitmap-use-memcmp-optimisation-in-more-situations-fix.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2.patch
include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix.patch
kmod-add-test-driver-to-stress-test-the-module-loader-fix.patch


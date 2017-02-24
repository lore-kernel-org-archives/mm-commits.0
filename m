From: akpm@linux-foundation.org
Subject: [folded-merged] lib-update-lz4-compressor-module-fix.patch
 removed from -mm tree
Date: Fri, 24 Feb 2017 14:45:43 -0800
Message-ID: <58b0b797.g0C2CZoqkNu8iJDs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXWpo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:45:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, 4sschmid@informatik.uni-hamburg.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lz4: fix KERNEL_LZ4 support
has been removed from the -mm tree.  Its filename was
     lib-update-lz4-compressor-module-fix.patch

This patch was dropped because it was folded into lib-update-lz4-compressor-module.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: lz4: fix KERNEL_LZ4 support

The updated lz4 library removed the #ifdef guards around the various
EXPORT_SYMBOL statements in the original kernel lz4 support, which broke
CONFIG_KERNEL_LZ4 on x86:

x86_64-linux-ld: -r and -pie may not be used together
scripts/Makefile.build:308: recipe for target 'arch/x86/boot/compressed/misc.o' failed

This uses a simpler way to do the same thing, by overriding the
EXPORT_SYMBOL macro.

Link: http://lkml.kernel.org/r/20170208211946.2839649-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN lib/lz4/lz4_decompress.c~lib-update-lz4-compressor-module-fix lib/lz4/lz4_decompress.c
--- a/lib/lz4/lz4_decompress.c~lib-update-lz4-compressor-module-fix
+++ a/lib/lz4/lz4_decompress.c
@@ -40,6 +40,11 @@
 #include <linux/kernel.h>
 #include <asm/unaligned.h>
 
+#ifdef STATIC
+#undef EXPORT_SYMBOL
+#define EXPORT_SYMBOL(x)
+#endif
+
 /*-*****************************
  *	Decompression functions
  *******************************/
_

Patches currently in -mm which might be from arnd@arndb.de are

lib-update-lz4-compressor-module.patch


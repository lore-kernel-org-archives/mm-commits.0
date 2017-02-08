From: akpm@linux-foundation.org
Subject: + lib-update-lz4-compressor-module-fix.patch added to -mm tree
Date: Wed, 08 Feb 2017 13:37:50 -0800
Message-ID: <589b8fae.H7+H8yc/2INVZq8E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50150 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbdBHVh4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2017 16:37:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, 4sschmid@informatik.uni-hamburg.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lz4: fix KERNEL_LZ4 support
has been added to the -mm tree.  Its filename is
     lib-update-lz4-compressor-module-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-update-lz4-compressor-module-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-update-lz4-compressor-module-fix.patch

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

mm-track-active-portions-of-a-section-at-boot-fix-fix.patch
mm-support-section-unaligned-zone_device-memory-ranges-fix.patch
mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix-2.patch
lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch
lib-update-lz4-compressor-module-fix.patch


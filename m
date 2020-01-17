From: akpm@linux-foundation.org
Subject: + s390-boot-rename-heap_size-due-to-name-collision.patch
 added to -mm tree
Date: Thu, 16 Jan 2020 18:55:02 -0800
Message-ID: <20200117025502.YCu-i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387441AbgAQCzD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jan 2020 21:55:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, borntraeger@de.ibm.com, zaslonko@linux.ibm.com


The patch titled
     Subject: s390/boot: rename HEAP_SIZE due to name collision
has been added to the -mm tree.  Its filename is
     s390-boot-rename-heap_size-due-to-name-collision.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-boot-rename-heap_size-due-to-name-collision.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-boot-rename-heap_size-due-to-name-collision.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: s390/boot: rename HEAP_SIZE due to name collision

Change the conflicting macro name in preparation for zlib_inflate hardware
support.

Link: http://lkml.kernel.org/r/20200103223334.20669-3-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/boot/compressed/decompressor.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/s390/boot/compressed/decompressor.c~s390-boot-rename-heap_size-due-to-name-collision
+++ a/arch/s390/boot/compressed/decompressor.c
@@ -30,13 +30,13 @@ extern unsigned char _compressed_start[]
 extern unsigned char _compressed_end[];
 
 #ifdef CONFIG_HAVE_KERNEL_BZIP2
-#define HEAP_SIZE	0x400000
+#define BOOT_HEAP_SIZE	0x400000
 #else
-#define HEAP_SIZE	0x10000
+#define BOOT_HEAP_SIZE	0x10000
 #endif
 
 static unsigned long free_mem_ptr = (unsigned long) _end;
-static unsigned long free_mem_end_ptr = (unsigned long) _end + HEAP_SIZE;
+static unsigned long free_mem_end_ptr = (unsigned long) _end + BOOT_HEAP_SIZE;
 
 #ifdef CONFIG_KERNEL_GZIP
 #include "../../../../lib/decompress_inflate.c"
@@ -62,7 +62,7 @@ static unsigned long free_mem_end_ptr =
 #include "../../../../lib/decompress_unxz.c"
 #endif
 
-#define decompress_offset ALIGN((unsigned long)_end + HEAP_SIZE, PAGE_SIZE)
+#define decompress_offset ALIGN((unsigned long)_end + BOOT_HEAP_SIZE, PAGE_SIZE)
 
 unsigned long mem_safe_offset(void)
 {
_

Patches currently in -mm which might be from zaslonko@linux.ibm.com are

lib-zlib-add-s390-hardware-support-for-kernel-zlib_deflate.patch
s390-boot-rename-heap_size-due-to-name-collision.patch
lib-zlib-add-s390-hardware-support-for-kernel-zlib_inflate.patch
s390-boot-add-dfltcc=-kernel-command-line-parameter.patch
lib-zlib-add-zlib_deflate_dfltcc_enabled-function.patch
btrfs-use-larger-zlib-buffer-for-s390-hardware-compression.patch

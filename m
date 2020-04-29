From: akpm@linux-foundation.org
Subject: + initramfs-fix-another-section-mismatch.patch added to
 -mm tree
Date: Wed, 29 Apr 2020 14:10:32 -0700
Message-ID: <20200429211032.k5DycxHEc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgD2VKf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Apr 2020 17:10:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, catalin.marinas@arm.com, geert@linux-m68k.org, gxt@pku.edu.cn, hch@lst.de, linux@armlinux.org.uk, mm-commits@vger.kernel.org, rppt@linux.ibm.com, steven.price@arm.com, viro@zeniv.linux.org.uk, will.deacon@arm.com


The patch titled
     Subject: initramfs: fix another section mismatch
has been added to the -mm tree.  Its filename is
     initramfs-fix-another-section-mismatch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initramfs-fix-another-section-mismatch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initramfs-fix-another-section-mismatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: initramfs: fix another section mismatch

Building with gcc-10 causes a harmless warning, similar to the gcc-4.6
warning that Geert fixed last year:

WARNING: modpost: vmlinux.o(.text.unlikely+0xe69): Section mismatch in reference from the function kexec_free_initrd() to the function .init.text:free_initrd_mem()
The function kexec_free_initrd() references
the function __init free_initrd_mem().
This is often because kexec_free_initrd lacks a __init
annotation or the annotation of free_initrd_mem is wrong.

Add the missing __init annotations.

Link: http://lkml.kernel.org/r/20200429190135.66411-1-arnd@arndb.de
Fixes: 4ada1e810038 ("initramfs: fix populate_initrd_image() section mismatch")
Fixes: 23091e287355 ("initramfs: cleanup initrd freeing")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/init/initramfs.c~initramfs-fix-another-section-mismatch
+++ a/init/initramfs.c
@@ -542,7 +542,7 @@ void __weak free_initrd_mem(unsigned lon
 }
 
 #ifdef CONFIG_KEXEC_CORE
-static bool kexec_free_initrd(void)
+static bool __init kexec_free_initrd(void)
 {
 	unsigned long crashk_start = (unsigned long)__va(crashk_res.start);
 	unsigned long crashk_end   = (unsigned long)__va(crashk_res.end);
@@ -565,7 +565,7 @@ static bool kexec_free_initrd(void)
 	return true;
 }
 #else
-static inline bool kexec_free_initrd(void)
+static inline bool __init kexec_free_initrd(void)
 {
 	return false;
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

initramfs-fix-another-section-mismatch.patch

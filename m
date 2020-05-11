From: akpm@linux-foundation.org
Subject: [merged] initramfs-fix-another-section-mismatch.patch
 removed from -mm tree
Date: Mon, 11 May 2020 11:45:35 -0700
Message-ID: <20200511184535.L-xeDRcx-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbgEKSpg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 14:45:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, catalin.marinas@arm.com, geert@linux-m68k.org, gxt@pku.edu.cn, hch@lst.de, linux@armlinux.org.uk, mm-commits@vger.kernel.org, rppt@linux.ibm.com, steven.price@arm.com, viro@zeniv.linux.org.uk, will.deacon@arm.com


The patch titled
     Subject: initramfs: fix another section mismatch
has been removed from the -mm tree.  Its filename was
     initramfs-fix-another-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
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

arm64-add-support-for-folded-p4d-page-tables-fix.patch
bitops-avoid-clang-shift-count-overflow-warnings.patch
ubsan-fix-gcc-10-warnings.patch

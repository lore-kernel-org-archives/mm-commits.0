From: akpm@linux-foundation.org
Subject: + include-asm-xtensa-ioh-must-include.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:25:12 -0700
Message-ID: <200707232125.l6NLPCjT012567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34185 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760031AbXGWVZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, chris@zankel.net


The patch titled
     include/asm-xtensa/io.h must #include <asm/page.h>
has been added to the -mm tree.  Its filename is
     include-asm-xtensa-ioh-must-include.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: include/asm-xtensa/io.h must #include <asm/page.h>
From: Adrian Bunk <bunk@stusta.de>

  CC      kernel/time/clocksource.o
In file included from
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/clocksource.h:18,
                 from
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/kernel/time/clocksource.c:27:
include2/asm/io.h: In function 'virt_to_phys':
include2/asm/io.h:46: error: implicit declaration of function '__pa'
include2/asm/io.h: In function 'phys_to_virt':
include2/asm/io.h:51: error: implicit declaration of function '__va'
include2/asm/io.h:51: warning: return makes pointer from integer without a cast
make[3]: *** [kernel/time/clocksource.o] Error 1

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-xtensa/io.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/asm-xtensa/io.h~include-asm-xtensa-ioh-must-include include/asm-xtensa/io.h
--- a/include/asm-xtensa/io.h~include-asm-xtensa-ioh-must-include
+++ a/include/asm-xtensa/io.h
@@ -13,6 +13,7 @@
 
 #ifdef __KERNEL__
 #include <asm/byteorder.h>
+#include <asm/page.h>
 
 #include <linux/types.h>
 
_

Patches currently in -mm which might be from bunk@stusta.de are

include-asm-xtensa-ioh-must-include.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

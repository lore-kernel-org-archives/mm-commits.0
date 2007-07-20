From: akpm@linux-foundation.org
Subject: + fore200e_param_bs_queue-must-be-__devinit.patch added to -mm tree
Date: Thu, 19 Jul 2007 17:17:30 -0700
Message-ID: <200707200017.l6K0HU93030250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34255 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782AbXGTARo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 20:17:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     fore200e_param_bs_queue() must be __devinit
has been added to the -mm tree.  Its filename is
     fore200e_param_bs_queue-must-be-__devinit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fore200e_param_bs_queue() must be __devinit
From: Adrian Bunk <bunk@stusta.de>

WARNING: drivers/built-in.o(.text+0x6203bb): Section mismatch: reference to .init.text:fore200e_param_bs_queue (between 'fore200e_initialize' and 'fore200e_monitor_putc')

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/fore200e.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/atm/fore200e.c~fore200e_param_bs_queue-must-be-__devinit drivers/atm/fore200e.c
--- a/drivers/atm/fore200e.c~fore200e_param_bs_queue-must-be-__devinit
+++ a/drivers/atm/fore200e.c
@@ -2435,7 +2435,7 @@ fore200e_init_cmd_queue(struct fore200e*
 }
 
 
-static void __init
+static void __devinit
 fore200e_param_bs_queue(struct fore200e* fore200e,
 			enum buffer_scheme scheme, enum buffer_magn magn,
 			int queue_length, int pool_size, int supply_blksize)
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
fix-x86_64-mm-xen-xen-event-channels.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
i386-intel_cacheinfocfind_num_cache_leaves-should.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
introduce-i_sync-fix.patch
spicscan_boardinfo-mustnt-be-__init_or_module.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

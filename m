From: akpm@linux-foundation.org
Subject: + rivafb_setup-must-be-__devinit.patch added to -mm tree
Date: Thu, 19 Jul 2007 17:18:14 -0700
Message-ID: <200707200018.l6K0IENY030270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38306 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757063AbXGTASb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 20:18:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, adaplas@pol.net


The patch titled
     rivafb_setup() must be __devinit
has been added to the -mm tree.  Its filename is
     rivafb_setup-must-be-__devinit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rivafb_setup() must be __devinit
From: Adrian Bunk <bunk@stusta.de>

WARNING: drivers/built-in.o(.text+0x57106): Section mismatch: reference to .init.text:rivafb_setup (between 'rivafb_init' and 'nv3Busy')

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/riva/fbdev.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/riva/fbdev.c~rivafb_setup-must-be-__devinit drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~rivafb_setup-must-be-__devinit
+++ a/drivers/video/riva/fbdev.c
@@ -2146,7 +2146,7 @@ static void __devexit rivafb_remove(stru
  * ------------------------------------------------------------------------- */
 
 #ifndef MODULE
-static int __init rivafb_setup(char *options)
+static int __devinit rivafb_setup(char *options)
 {
 	char *this_opt;
 
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
rivafb_setup-must-be-__devinit.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

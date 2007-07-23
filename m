From: akpm@linux-foundation.org
Subject: - rivafb_setup-must-be-__devinit.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:13 -0700
Message-ID: <200707230935.l6N9ZDEw016466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759452AbXGWJpe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     rivafb_setup() must be __devinit
has been removed from the -mm tree.  Its filename was
     rivafb_setup-must-be-__devinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rivafb_setup() must be __devinit
From: Adrian Bunk <bunk@stusta.de>

WARNING: drivers/built-in.o(.text+0x57106): Section mismatch: reference to .init.text:rivafb_setup (between 'rivafb_init' and 'nv3Busy')

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/riva/fbdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

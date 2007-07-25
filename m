From: akpm@linux-foundation.org
Subject: + xenbus_xsc-fix-a-use-after-free.patch added to -mm tree
Date: Tue, 24 Jul 2007 23:18:48 -0700
Message-ID: <200707250618.l6P6Imjv020628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761526AbXGYGTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2007 02:19:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, jeremy@goop.org


The patch titled
     xenbus_xs.c: fix a use-after-free
has been added to the -mm tree.  Its filename is
     xenbus_xsc-fix-a-use-after-free.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xenbus_xs.c: fix a use-after-free
From: Adrian Bunk <bunk@stusta.de>

This patch fixes an obvious use-after-free spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/xenbus/xenbus_xs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/xen/xenbus/xenbus_xs.c~xenbus_xsc-fix-a-use-after-free drivers/xen/xenbus/xenbus_xs.c
--- a/drivers/xen/xenbus/xenbus_xs.c~xenbus_xsc-fix-a-use-after-free
+++ a/drivers/xen/xenbus/xenbus_xs.c
@@ -782,8 +782,8 @@ static int process_msg(void)
 		msg->u.watch.vec = split(body, msg->hdr.len,
 					 &msg->u.watch.vec_size);
 		if (IS_ERR(msg->u.watch.vec)) {
-			kfree(msg);
 			err = PTR_ERR(msg->u.watch.vec);
+			kfree(msg);
 			goto out;
 		}
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
use-ldflags_module-only-for-ko-links.patch
x86_powernow_k8_acpi-must-depend-on-acpi.patch
xenbus_xsc-fix-a-use-after-free.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-drm.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

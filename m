From: akpm@linux-foundation.org
Subject: - xenbus_xsc-fix-a-use-after-free.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:03 -0700
Message-ID: <200707290612.l6T6C3jd011097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758030AbXG2GXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     xenbus_xs.c: fix a use-after-free
has been removed from the -mm tree.  Its filename was
     xenbus_xsc-fix-a-use-after-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
git-drm.patch
git-dvb.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
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
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

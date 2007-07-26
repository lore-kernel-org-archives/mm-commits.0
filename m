From: akpm@linux-foundation.org
Subject: + nsp32_restart_autoscsi-remove-error-check.patch added to -mm tree
Date: Thu, 26 Jul 2007 15:21:00 -0700
Message-ID: <200707262221.l6QML0Lg023551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384AbXGZWVZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 18:21:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, yokota@netlab.is.tsukuba.ac.jp


The patch titled
     nsp32_restart_autoscsi(): remove error check
has been added to the -mm tree.  Its filename is
     nsp32_restart_autoscsi-remove-error-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nsp32_restart_autoscsi(): remove error check
From: Adrian Bunk <bunk@stusta.de>

The Coverity checker noted that we'll anyway Oops later when we ran into
this condition - and the error check didn't prevent that.

Considering that the error condition shouldn't be possible, and we are
not able to handle it easily, this patch simply removes the pointless
error check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: <yokota@netlab.is.tsukuba.ac.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/nsp32.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/scsi/nsp32.c~nsp32_restart_autoscsi-remove-error-check drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c~nsp32_restart_autoscsi-remove-error-check
+++ a/drivers/scsi/nsp32.c
@@ -1905,10 +1905,6 @@ static void nsp32_restart_autoscsi(struc
 
 	nsp32_dbg(NSP32_DEBUG_RESTART, "enter");
 
-	if (data->cur_target == NULL || data->cur_lunt == NULL) {
-		nsp32_msg(KERN_ERR, "Target or Lun is invalid");
-	}
-
 	/*
 	 * set SYNC_REG
 	 * Don't set BM_START_ADR before setting this register.
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
x86_powernow_k8_acpi-must-depend-on-acpi.patch
xenbus_xsc-fix-a-use-after-free.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
git-drm.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
dvb-usb-af9005-fec-error-check-fixes.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
net-bluetooth-rfcomm-ttyc-use-after-free.patch
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

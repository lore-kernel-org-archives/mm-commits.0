From: akpm@linux-foundation.org
Subject: - remove-mm-backing-devccongestion_wait_interruptible.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:21 -0700
Message-ID: <200707162059.l6GKxLBZ002421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762708AbXGPVPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     remove mm/backing-dev.c:congestion_wait_interruptible()
has been removed from the -mm tree.  Its filename was
     remove-mm-backing-devccongestion_wait_interruptible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove mm/backing-dev.c:congestion_wait_interruptible()
From: Adrian Bunk <bunk@stusta.de>

congestion_wait_interruptible() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 -
 mm/backing-dev.c            |   16 ----------------
 2 files changed, 17 deletions(-)

diff -puN include/linux/backing-dev.h~remove-mm-backing-devccongestion_wait_interruptible include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~remove-mm-backing-devccongestion_wait_interruptible
+++ a/include/linux/backing-dev.h
@@ -93,7 +93,6 @@ static inline int bdi_rw_congested(struc
 void clear_bdi_congested(struct backing_dev_info *bdi, int rw);
 void set_bdi_congested(struct backing_dev_info *bdi, int rw);
 long congestion_wait(int rw, long timeout);
-long congestion_wait_interruptible(int rw, long timeout);
 void congestion_end(int rw);
 
 #define bdi_cap_writeback_dirty(bdi) \
diff -puN mm/backing-dev.c~remove-mm-backing-devccongestion_wait_interruptible mm/backing-dev.c
--- a/mm/backing-dev.c~remove-mm-backing-devccongestion_wait_interruptible
+++ a/mm/backing-dev.c
@@ -55,22 +55,6 @@ long congestion_wait(int rw, long timeou
 }
 EXPORT_SYMBOL(congestion_wait);
 
-long congestion_wait_interruptible(int rw, long timeout)
-{
-	long ret;
-	DEFINE_WAIT(wait);
-	wait_queue_head_t *wqh = &congestion_wqh[rw];
-
-	prepare_to_wait(wqh, &wait, TASK_INTERRUPTIBLE);
-	if (signal_pending(current))
-		ret = -ERESTARTSYS;
-	else
-		ret = io_schedule_timeout(timeout);
-	finish_wait(wqh, &wait);
-	return ret;
-}
-EXPORT_SYMBOL(congestion_wait_interruptible);
-
 /**
  * congestion_end - wake up sleepers on a congested backing_dev_info
  * @rw: READ or WRITE
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-xen-xen-event-channels.patch
arch-i386-xen-mmuc-must-include-linux-schedh.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
xen-cant-support-numa-yet.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
handle-kernelcore=-generic.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
mm-slubc-make-code-static.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
proper-prototype-for-proc_nr_files.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
fbdev-move-arch-specific-bits-to-their-respective.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
drivers-video-macmodescmac_find_mode-mustnt-be.patch
intel-iommu-intel-iommu-driver.patch
mm-variable-length-argument-support.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
kernel-relayc-make-functions-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

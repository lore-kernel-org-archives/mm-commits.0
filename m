From: akpm@linux-foundation.org
Subject: + remove-mm-backing-devccongestion_wait_interruptible.patch added to -mm tree
Date: Thu, 05 Jul 2007 13:56:18 -0700
Message-ID: <200707052056.l65KuIL7018873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759775AbXGEU4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 16:56:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, trond.myklebust@fys.uio.no


The patch titled
     remove mm/backing-dev.c:congestion_wait_interruptible()
has been added to the -mm tree.  Its filename is
     remove-mm-backing-devccongestion_wait_interruptible.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
make-drivers-acpi-oslcosi_linux-static.patch
drivers-acpi-processor_throttlingc-make-2-functions.patch
drivers-cpuidle-governors-menuc-make-a-struct-static.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-input.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-md-accel.patch
git-mmc.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-netdev-all.patch
bonding-bond_mainc-make-2-functions-static.patch
net-make-struct-dccp_li_cachep-static.patch
git-battery.patch
git-selinux.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
remove-the-dead-cyberstormiii_scsi-option.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=-generic-fix.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
mm-slubc-make-code-static.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
init-wait-for-asynchronously-scanned-block-devices-fix.patch
kernel-utf-8-handling-fix.patch
remove-sonypi_camera_command.patch
fs-namespacec-should-include-internalh.patch
proper-prototype-for-proc_nr_files.patch
fs-reiserfs-cleanups.patch
remove-mm-backing-devccongestion_wait_interruptible.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
fbdev-move-arch-specific-bits-to-their-respective-fix-include-asm-m68k-fbh.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
intel-iommu-intel-iommu-driver-fix-duplicate-config_dmar-makefile-line.patch
mm-variable-length-argument-support-fix-2.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
kernel-relayc-make-functions-static.patch
immediate-value-add-kconfig-menus.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

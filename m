From: akpm@linux-foundation.org
Subject: + tc35815-fix-an-usage-of-streaming-dma-api-tidy.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:50:24 -0800
Message-ID: <200703151850.l2FIoQk3023313@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35520 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbXCOSub (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, anemo@mba.ocn.ne.jp


The patch titled
     tc35815-fix-an-usage-of-streaming-dma-api-tidy
has been added to the -mm tree.  Its filename is
     tc35815-fix-an-usage-of-streaming-dma-api-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tc35815-fix-an-usage-of-streaming-dma-api-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tc35815.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/net/tc35815.c~tc35815-fix-an-usage-of-streaming-dma-api-tidy drivers/net/tc35815.c
--- a/drivers/net/tc35815.c~tc35815-fix-an-usage-of-streaming-dma-api-tidy
+++ a/drivers/net/tc35815.c
@@ -58,7 +58,6 @@
  *	1.34	Fix netpoll locking.  "BH rule" for NAPI is not enough with
  *		netpoll, hard_start_xmit might be called from irq context.
  *		PM support.
- *	1.35	Fix an usage of streaming DMA API.
  */
 
 #ifdef TC35815_NAPI
@@ -1554,8 +1553,7 @@ tc35815_rx(struct net_device *dev)
 				memcpy(data + offset, rxbuf, len);
 #ifdef TC35815_DMA_SYNC_ONDEMAND
 				pci_dma_sync_single_for_device(lp->pci_dev,
-							       dma, len,
-							       PCI_DMA_FROMDEVICE);
+						dma, len, PCI_DMA_FROMDEVICE);
 #endif
 				offset += len;
 				cur_bd++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
software-suspend-fix-suspend-when-console-is-in-tidy.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ivtv-warning-fix.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fixup.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
tc35815-fix-an-usage-of-streaming-dma-api-tidy.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch

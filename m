From: akpm@linux-foundation.org
Subject: + freezer-make-kernel-threads-nonfreezable-by-default-fix.patch added to -mm tree
Date: Wed, 30 May 2007 18:26:31 -0700
Message-ID: <200705310129.l4V1Tukc009663@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886AbXEaBae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 21:30:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ego@in.ibm.com, nigel@nigel.suspend2.net, oleg@tv-sign.ru, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     freezer-make-kernel-threads-nonfreezable-by-default-fix
has been added to the -mm tree.  Its filename is
     freezer-make-kernel-threads-nonfreezable-by-default-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: freezer-make-kernel-threads-nonfreezable-by-default-fix
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "set_freezable" [drivers/media/video/msp3400.ko] undefined!

Make sure all affected fiels include freezer.h.  Might be overkill.

Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apm.c                 |    1 +
 drivers/block/loop.c                   |    1 +
 drivers/char/apm-emulation.c           |    1 +
 drivers/ieee1394/ieee1394_core.c       |    1 +
 drivers/media/video/msp3400-kthreads.c |    1 +
 drivers/mmc/card/queue.c               |    1 +
 drivers/mtd/mtd_blkdevs.c              |    1 +
 drivers/scsi/libsas/sas_scsi_host.c    |    1 +
 drivers/scsi/scsi_error.c              |    1 +
 kernel/exit.c                          |    1 +
 kernel/rcutorture.c                    |    1 +
 kernel/softirq.c                       |    1 +
 kernel/softlockup.c                    |    1 +
 net/bluetooth/bnep/core.c              |    1 +
 net/bluetooth/cmtp/core.c              |    1 +
 net/bluetooth/hidp/core.c              |    1 +
 net/bluetooth/rfcomm/core.c            |    1 +
 17 files changed, 17 insertions(+)

diff -puN arch/i386/kernel/apm.c~freezer-make-kernel-threads-nonfreezable-by-default-fix arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/arch/i386/kernel/apm.c
@@ -222,6 +222,7 @@
 #include <linux/capability.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/freezer.h>
 #include <linux/smp.h>
 #include <linux/dmi.h>
 #include <linux/suspend.h>
diff -puN drivers/block/loop.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/block/loop.c
--- a/drivers/block/loop.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/block/loop.c
@@ -68,6 +68,7 @@
 #include <linux/loop.h>
 #include <linux/compat.h>
 #include <linux/suspend.h>
+#include <linux/freezer.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>		/* for invalidate_bdev() */
 #include <linux/completion.h>
diff -puN drivers/char/apm-emulation.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/char/apm-emulation.c
--- a/drivers/char/apm-emulation.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/char/apm-emulation.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 #include <linux/pm.h>
 #include <linux/apm-emulation.h>
+#include <linux/freezer.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
diff -puN drivers/ieee1394/ieee1394_core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/ieee1394/ieee1394_core.c
--- a/drivers/ieee1394/ieee1394_core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/ieee1394/ieee1394_core.c
@@ -30,6 +30,7 @@
 #include <linux/moduleparam.h>
 #include <linux/bitops.h>
 #include <linux/kdev_t.h>
+#include <linux/freezer.h>
 #include <linux/suspend.h>
 #include <linux/kthread.h>
 #include <linux/preempt.h>
diff -puN drivers/media/video/msp3400-kthreads.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/media/video/msp3400-kthreads.c
--- a/drivers/media/video/msp3400-kthreads.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/media/video/msp3400-kthreads.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/freezer.h>
 #include <linux/videodev.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
diff -puN drivers/mmc/card/queue.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/mmc/card/queue.c
--- a/drivers/mmc/card/queue.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/mmc/card/queue.c
@@ -11,6 +11,7 @@
  */
 #include <linux/module.h>
 #include <linux/blkdev.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 
 #include <linux/mmc/card.h>
diff -puN drivers/mtd/mtd_blkdevs.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/mtd/mtd_blkdevs.c
--- a/drivers/mtd/mtd_blkdevs.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/mtd/mtd_blkdevs.c
@@ -16,6 +16,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
+#include <linux/freezer.h>
 #include <linux/spinlock.h>
 #include <linux/hdreg.h>
 #include <linux/init.h>
diff -puN drivers/scsi/libsas/sas_scsi_host.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -40,6 +40,7 @@
 
 #include <linux/err.h>
 #include <linux/blkdev.h>
+#include <linux/freezer.h>
 #include <linux/scatterlist.h>
 
 /* ---------- SCSI Host glue ---------- */
diff -puN drivers/scsi/scsi_error.c~freezer-make-kernel-threads-nonfreezable-by-default-fix drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/drivers/scsi/scsi_error.c
@@ -19,6 +19,7 @@
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
diff -puN kernel/exit.c~freezer-make-kernel-threads-nonfreezable-by-default-fix kernel/exit.c
--- a/kernel/exit.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/kernel/exit.c
@@ -31,6 +31,7 @@
 #include <linux/mempolicy.h>
 #include <linux/taskstats_kern.h>
 #include <linux/delayacct.h>
+#include <linux/freezer.h>
 #include <linux/cpuset.h>
 #include <linux/syscalls.h>
 #include <linux/signal.h>
diff -puN kernel/rcutorture.c~freezer-make-kernel-threads-nonfreezable-by-default-fix kernel/rcutorture.c
--- a/kernel/rcutorture.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/kernel/rcutorture.c
@@ -40,6 +40,7 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
+#include <linux/freezer.h>
 #include <linux/cpu.h>
 #include <linux/random.h>
 #include <linux/delay.h>
diff -puN kernel/softirq.c~freezer-make-kernel-threads-nonfreezable-by-default-fix kernel/softirq.c
--- a/kernel/softirq.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/kernel/softirq.c
@@ -14,6 +14,7 @@
 #include <linux/notifier.h>
 #include <linux/percpu.h>
 #include <linux/cpu.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
diff -puN kernel/softlockup.c~freezer-make-kernel-threads-nonfreezable-by-default-fix kernel/softlockup.c
--- a/kernel/softlockup.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/kernel/softlockup.c
@@ -10,6 +10,7 @@
 #include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
diff -puN net/bluetooth/bnep/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix net/bluetooth/bnep/core.c
--- a/net/bluetooth/bnep/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/net/bluetooth/bnep/core.c
@@ -36,6 +36,7 @@
 #include <linux/signal.h>
 #include <linux/init.h>
 #include <linux/wait.h>
+#include <linux/freezer.h>
 #include <linux/errno.h>
 #include <linux/net.h>
 #include <net/sock.h>
diff -puN net/bluetooth/cmtp/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix net/bluetooth/cmtp/core.c
--- a/net/bluetooth/cmtp/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/net/bluetooth/cmtp/core.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
+#include <linux/freezer.h>
 #include <linux/skbuff.h>
 #include <linux/socket.h>
 #include <linux/ioctl.h>
diff -puN net/bluetooth/hidp/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix net/bluetooth/hidp/core.c
--- a/net/bluetooth/hidp/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/net/bluetooth/hidp/core.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
+#include <linux/freezer.h>
 #include <linux/fcntl.h>
 #include <linux/skbuff.h>
 #include <linux/socket.h>
diff -puN net/bluetooth/rfcomm/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix net/bluetooth/rfcomm/core.c
--- a/net/bluetooth/rfcomm/core.c~freezer-make-kernel-threads-nonfreezable-by-default-fix
+++ a/net/bluetooth/rfcomm/core.c
@@ -33,6 +33,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/init.h>
+#include <linux/freezer.h>
 #include <linux/wait.h>
 #include <linux/device.h>
 #include <linux/net.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-more-documentation-fix.patch
ntfs_init_locked_inode-fix-array-indexing.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
git-mips-fixup.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
sh-support-older-gccs.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
git-xfs.patch
git-cryptodev.patch
fix-possible-leakage-of-blocks-in-udf-tidy.patch
potential-parse-error-in-ifdef.patch
potential-parse-error-in-ifdef-fix.patch
potential-parse-error-in-ifdef-update.patch
aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
nick-broke-stuff.patch
nick-broke-more-stuff.patch
nick-broke-even-more-stuff.patch
nick-really-did-it-this-time.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
reiser4.patch
reiser4-fix.patch
nick-broke-reiser4-too.patch
check_dirty_inode_list.patch
w1-build-fix.patch

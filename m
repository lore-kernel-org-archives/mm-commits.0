From: akpm@linux-foundation.org
Subject: - fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch removed from -mm tree
Date: Thu, 10 May 2007 22:35:34 -0700
Message-ID: <200705110535.l4B5ZYsu007349@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754640AbXEKFgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 01:36:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fix gregkh-driver-sysfs-fix-error-handling-in-binattr-write
has been removed from the -mm tree.  Its filename was
     fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fix gregkh-driver-sysfs-fix-error-handling-in-binattr-write
From: Andrew Morton <akpm@linux-foundation.org>

fs/sysfs/bin.c: In function 'read':
fs/sysfs/bin.c:58: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'int'

I made the local size_t, to force some fishy-looking arithmetic in there to
use unsigned arithmetic.

Cc: Greg KH <greg@kroah.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/bin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sysfs/bin.c~fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write fs/sysfs/bin.c
--- a/fs/sysfs/bin.c~fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write
+++ a/fs/sysfs/bin.c
@@ -74,7 +74,7 @@ read(struct file *file, char __user *use
 		goto out_unlock;
 	}
 
-	pr_debug("offs = %lld, *off = %lld, count = %zd\n", offs, *off, count);
+	pr_debug("offs = %lld, *off = %lld, count = %d\n", offs, *off, count);
 
 	*off = offs + count;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-hexdump.patch
stop_machine-now-uses-hard_irq_disable.patch
submitchecklist-add-W-help.patch
tty-add-compat_ioctl.patch
use-defines-in-sys_getpriority-sys_setpriority.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
pm3fb-preliminary-24-to-26-port.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
arm-stacktrace-fix.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-fix.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-printk-fixes.patch
git-hid-fixup.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-leds.patch
git-leds-fixup.patch
git-libata-all-sata_via-build-fix.patch
pata_acpi-restore-driver-fix.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
netxen_nic_main-dont-use-deprecated-irq-flags.patch
mlx4-dont-use-deprecated-irq-flags.patch
git-battery.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
git-wireless-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch
xfs-clean-up-shrinker-games.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
ntfs-use-zero_user_page.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch

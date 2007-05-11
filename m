From: akpm@linux-foundation.org
Subject: - i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-printk-fixes.patch removed from -mm tree
Date: Thu, 10 May 2007 22:40:02 -0700
Message-ID: <200705110540.l4B5e28s007435@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756110AbXEKFkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 01:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, grant.likely@secretlab.ca, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-printk-fixes
has been removed from the -mm tree.  Its filename was
     i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-printk-fixes.patch

This patch was dropped because it was folded into i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch

------------------------------------------------------
Subject: i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-printk-fixes
From: Andrew Morton <akpm@linux-foundation.org>

drivers/i2c/chips/ds1682.c: In function 'ds1682_store':
drivers/i2c/chips/ds1682.c:127: warning: format '%i' expects type 'int', but argument 5 has type 'size_t'
drivers/i2c/chips/ds1682.c: In function 'ds1682_user_data_store':
drivers/i2c/chips/ds1682.c:218: warning: format '%i' expects type 'int', but argument 4 has type 'size_t'

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/ds1682.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/i2c/chips/ds1682.c~i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-printk-fixes drivers/i2c/chips/ds1682.c
--- a/drivers/i2c/chips/ds1682.c~i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-printk-fixes
+++ a/drivers/i2c/chips/ds1682.c
@@ -124,7 +124,7 @@ static ssize_t ds1682_store(struct devic
 	reg = ds1682_attr_to_reg(attr, &regsize);
 
 	if ((reg < 0) || (count >= 16) || (buf[count] != '\0')) {
-		dev_dbg(dev, "insane input; reg=0x%i count=%i%s\n",
+		dev_dbg(dev, "insane input; reg=0x%i count=%zd%s\n",
 			reg, count, buf[count] == '\0' ? " unterminated" : "");
 		return -EIO;
 	}
@@ -215,7 +215,7 @@ static ssize_t ds1682_user_data_store(st
 
 	/* Check input for sanity */
 	if ((count >= 80) || (buf[count] != '\0')) {
-		dev_dbg(dev, "insane input; count=%i%s\n",
+		dev_dbg(dev, "insane input; count=%zd%s\n",
 			count, buf[count] == '\0' ? " unterminated" : "");
 		return -EIO;
 	}
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
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
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

From: akpm@linux-foundation.org
Subject: - ieee1394-iso-needs-schedh.patch removed from -mm tree
Date: Thu, 10 May 2007 23:29:49 -0700
Message-ID: <200705110629.l4B6Tncc008791@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754812AbXEKGaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 02:30:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     ieee1394/iso.c needs sched.h
has been removed from the -mm tree.  Its filename was
     ieee1394-iso-needs-schedh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ieee1394/iso.c needs sched.h
From: Andrew Morton <akpm@linux-foundation.org>

alpha:

drivers/ieee1394/iso.c: In function 'hpsb_iso_xmit_sync':
drivers/ieee1394/iso.c:440: error: invalid use of undefined type 'struct task_struct'
drivers/ieee1394/iso.c:440: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/ieee1394/iso.c:440: error: (Each undeclared identifier is reported only once
drivers/ieee1394/iso.c:440: error: for each function it appears in.)
drivers/ieee1394/iso.c:440: warning: implicit declaration of function 'signal_pending'
drivers/ieee1394/iso.c:440: error: invalid use of undefined type 'struct task_struct'
drivers/ieee1394/iso.c:440: warning: implicit declaration of function 'schedule'
drivers/ieee1394/iso.c: In function 'hpsb_iso_wake':
drivers/ieee1394/iso.c:562: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)

Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ieee1394/iso.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ieee1394/iso.c~ieee1394-iso-needs-schedh drivers/ieee1394/iso.c
--- a/drivers/ieee1394/iso.c~ieee1394-iso-needs-schedh
+++ a/drivers/ieee1394/iso.c
@@ -9,6 +9,7 @@
  * directory of the kernel sources for details.
  */
 
+#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
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
git-hid-fixup.patch
sn-validate-smp_affinity-mask-on-intr-redirect.patch
ieee1394-iso-needs-schedh.patch
git-leds.patch
git-leds-fixup.patch
git-libata-all-sata_via-build-fix.patch
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
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
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

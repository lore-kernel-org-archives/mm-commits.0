From: akpm@linux-foundation.org
Subject: + fix-race-condition-about-network-device-name-fix.patch added to -mm tree
Date: Thu, 10 May 2007 23:50:55 -0700
Message-ID: <200705110650.l4B6otFp009114@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbXEKGvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 02:51:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, kaneshige.kenji@jp.fujitsu.com


The patch titled
     fix-race-condition-about-network-device-name-fix
has been added to the -mm tree.  Its filename is
     fix-race-condition-about-network-device-name-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix-race-condition-about-network-device-name-fix
From: Andrew Morton <akpm@linux-foundation.org>

sneakily fix a spelling error

Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN net/core/dev.c~fix-race-condition-about-network-device-name-fix net/core/dev.c
--- a/net/core/dev.c~fix-race-condition-about-network-device-name-fix
+++ a/net/core/dev.c
@@ -229,7 +229,7 @@ extern void netdev_unregister_sysfs(stru
 #define	netdev_unregister_sysfs(dev)	do { } while(0)
 #endif
 
-/* Delayed registration/unregisteration */
+/* Delayed registration/unregistration */
 static DEFINE_SPINLOCK(net_todo_list_lock);
 static LIST_HEAD(net_todo_list);
 static LIST_HEAD(net_todo_snapshot_list);
@@ -718,7 +718,7 @@ int dev_alloc_name(struct net_device *de
 			if (i < 0 || i >= max_netdevices)
 				continue;
 
-			/*  avoid cases where sscanf is not exact inverse of printf */
+			/* avoid cases where sscanf is not exact inverse of printf */
 			snprintf(buf, sizeof(buf), name, i);
 			if (!strncmp(buf, d->name, IFNAMSIZ))
 				set_bit(i, inuse);
@@ -731,7 +731,7 @@ int dev_alloc_name(struct net_device *de
 			if (i < 0 || i >= max_netdevices)
 				continue;
 
-			/*  avoid cases where sscanf is not exact inverse of printf */
+			/* avoid cases where sscanf is not exact inverse of printf */
 			snprintf(buf, sizeof(buf), name, i);
 			if (!strncmp(buf, d->name, IFNAMSIZ))
 				set_bit(i, inuse);
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
git-leds.patch
git-leds-fixup.patch
git-libata-all-sata_via-build-fix.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
netxen_nic_main-dont-use-deprecated-irq-flags.patch
mlx4-dont-use-deprecated-irq-flags.patch
fix-race-condition-about-network-device-name-fix.patch
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

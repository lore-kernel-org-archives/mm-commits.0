From: akpm@linux-foundation.org
Subject: - declare-struct-ktime.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:30 -0700
Message-ID: <200705092153.l49LrUPr003087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758957AbXEIVyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     declare struct ktime
has been removed from the -mm tree.  Its filename was
     declare-struct-ktime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: declare struct ktime
From: Andrew Morton <akpm@linux-foundation.org>

Some smarty went and inflicted ktime_t as a typedef upon us, so we cannot
forward declare it.

Create a new `union ktime', map ktime_t onto that.  Now we need to kill off
this ktime_t thing.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ktime.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/ktime.h~declare-struct-ktime include/linux/ktime.h
--- a/include/linux/ktime.h~declare-struct-ktime
+++ a/include/linux/ktime.h
@@ -43,7 +43,7 @@
  * plain scalar nanosecond based representation can be selected by the
  * config switch CONFIG_KTIME_SCALAR.
  */
-typedef union {
+union ktime {
 	s64	tv64;
 #if BITS_PER_LONG != 64 && !defined(CONFIG_KTIME_SCALAR)
 	struct {
@@ -54,7 +54,9 @@ typedef union {
 # endif
 	} tv;
 #endif
-} ktime_t;
+};
+
+typedef union ktime ktime_t;		/* Kill this */
 
 #define KTIME_MAX			((s64)~((u64)1 << 63))
 #if (BITS_PER_LONG == 64)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
git-acpi.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
git-ia64-sa_interrupt-is-deprecated.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-battery.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
upper-32-bits.patch
lib-hexdump.patch
tty-add-compat_ioctl.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
ntfs-use-zero_user_page.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch

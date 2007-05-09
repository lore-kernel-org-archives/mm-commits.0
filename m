From: akpm@linux-foundation.org
Subject: - revert-rtc-add-rtc_merge_alarm.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:36 -0700
Message-ID: <200705090254.l492sa30009821@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032263AbXEICyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:54:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, david-b@pacbell.net, scottwood@freescale.com, mm-commits@vger.kernel.org


The patch titled
     revert "rtc: Add rtc_merge_alarm()"
has been removed from the -mm tree.  Its filename was
     revert-rtc-add-rtc_merge_alarm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: revert "rtc: Add rtc_merge_alarm()"
From: Andrew Morton <akpm@linux-foundation.org>

David says "884b4aaaa242a2db8c8252796f0118164a680ab5 should be reverted.  It
added an rtc_merge_alarm() call to the 2.6.20 kernel, which hasn't yet been
used by any in-tree driver; this patch obviates the need for that call, and
uses a more robust approach."

Cc: Scott Wood <scottwood@freescale.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-lib.c |   81 ----------------------------------------
 include/linux/rtc.h   |    1 
 2 files changed, 82 deletions(-)

diff -puN drivers/rtc/rtc-lib.c~revert-rtc-add-rtc_merge_alarm drivers/rtc/rtc-lib.c
--- a/drivers/rtc/rtc-lib.c~revert-rtc-add-rtc_merge_alarm
+++ a/drivers/rtc/rtc-lib.c
@@ -117,85 +117,4 @@ int rtc_tm_to_time(struct rtc_time *tm, 
 }
 EXPORT_SYMBOL(rtc_tm_to_time);
 
-
-/* Merge the valid (i.e. non-negative) fields of alarm into the current
- * time.  If the valid alarm fields are earlier than the equivalent
- * fields in the time, carry one into the least significant invalid
- * field, so that the alarm expiry is in the future.  It assumes that the
- * least significant invalid field is more significant than the most
- * significant valid field, and that the seconds field is valid.
- *
- * This is used by alarms that take relative (rather than absolute)
- * times, and/or have a simple binary second counter instead of
- * day/hour/minute/sec registers.
- */
-void rtc_merge_alarm(struct rtc_time *now, struct rtc_time *alarm)
-{
-	int *alarmp = &alarm->tm_sec;
-	int *timep = &now->tm_sec;
-	int carry_into, i;
-
-	/* Ignore everything past the 6th element (tm_year). */
-	for (i = 5; i > 0; i--) {
-		if (alarmp[i] < 0)
-			alarmp[i] = timep[i];
-		else
-			break;
-	}
-
-	/* No carry needed if all fields are valid. */
-	if (i == 5)
-		return;
-
-	for (carry_into = i + 1; i >= 0; i--) {
-		if (alarmp[i] < timep[i])
-			break;
-
-		if (alarmp[i] > timep[i])
-			return;
-	}
-
-	switch (carry_into) {
-		case 1:
-			alarm->tm_min++;
-
-			if (alarm->tm_min < 60)
-				return;
-
-			alarm->tm_min = 0;
-			/* fall-through */
-
-		case 2:
-			alarm->tm_hour++;
-
-			if (alarm->tm_hour < 60)
-				return;
-
-			alarm->tm_hour = 0;
-			/* fall-through */
-
-		case 3:
-			alarm->tm_mday++;
-
-			if (alarm->tm_mday <= rtc_days_in_month[alarm->tm_mon])
-				return;
-
-			alarm->tm_mday = 1;
-			/* fall-through */
-
-		case 4:
-			alarm->tm_mon++;
-
-			if (alarm->tm_mon <= 12)
-				return;
-
-			alarm->tm_mon = 1;
-			/* fall-through */
-
-		case 5:
-			alarm->tm_year++;
-	}
-}
-EXPORT_SYMBOL(rtc_merge_alarm);
-
 MODULE_LICENSE("GPL");
diff -puN include/linux/rtc.h~revert-rtc-add-rtc_merge_alarm include/linux/rtc.h
--- a/include/linux/rtc.h~revert-rtc-add-rtc_merge_alarm
+++ a/include/linux/rtc.h
@@ -106,7 +106,6 @@ extern int rtc_year_days(unsigned int da
 extern int rtc_valid_tm(struct rtc_time *tm);
 extern int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time);
 extern void rtc_time_to_tm(unsigned long time, struct rtc_time *tm);
-extern void rtc_merge_alarm(struct rtc_time *now, struct rtc_time *alarm);
 
 #include <linux/device.h>
 #include <linux/seq_file.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-kvm.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mtd.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-battery-fix.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
swsusp-clean-up-print.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
upper-32-bits.patch
lib-hexdump-fix.patch
pasemi-hardware-rng-driver-tidy.patch
nbd-check-the-return-value-of-sysfs_create_file-fix.patch
mutex_lock_interruptible-add-__must_check.patch
mutex_lock_interruptible-add-__must_check-must-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
make-vm-statistics-update-interval-configurable-fix.patch
rename-thread_info-to-stack-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch

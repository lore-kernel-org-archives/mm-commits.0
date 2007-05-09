From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-vs-futex-new-private-futexes.patch removed from -mm tree
Date: Wed, 09 May 2007 02:45:26 -0700
Message-ID: <200705090945.l499jQpx020290@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674AbXEIJqO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:46:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dada1@cosmosbay.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest-the-host-code-vs-futex-new-private-futexes
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-vs-futex-new-private-futexes.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

------------------------------------------------------
Subject: lguest-the-host-code-vs-futex-new-private-futexes
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/io.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/lguest/io.c~lguest-the-host-code-vs-futex-new-private-futexes drivers/lguest/io.c
--- a/drivers/lguest/io.c~lguest-the-host-code-vs-futex-new-private-futexes
+++ a/drivers/lguest/io.c
@@ -102,13 +102,14 @@ int bind_dma(struct lguest *lg,
 	unsigned int i;
 	int ret = 0;
 	union futex_key key;
+	struct rw_semaphore *fshared = &current->mm->mmap_sem;
 
 	if (interrupt >= LGUEST_IRQS)
 		return 0;
 
 	mutex_lock(&lguest_lock);
-	down_read(&current->mm->mmap_sem);
-	if (get_futex_key((u32 __user *)ukey, &key) != 0) {
+	down_read(fshared);
+	if (get_futex_key((u32 __user *)ukey, fshared, &key) != 0) {
 		kill_guest(lg, "bad dma key %#lx", ukey);
 		goto unlock;
 	}
@@ -134,7 +135,7 @@ int bind_dma(struct lguest *lg,
 	}
 	drop_futex_key_refs(&key);
 unlock:
- 	up_read(&current->mm->mmap_sem);
+ 	up_read(fshared);
 	mutex_unlock(&lguest_lock);
 	return ret;
 }
@@ -307,11 +308,12 @@ void send_dma(struct lguest *lg, unsigne
 {
 	union futex_key key;
 	int empty = 0;
+	struct rw_semaphore *fshared = &current->mm->mmap_sem;
 
 again:
 	mutex_lock(&lguest_lock);
-	down_read(&current->mm->mmap_sem);
-	if (get_futex_key((u32 __user *)ukey, &key) != 0) {
+	down_read(fshared);
+	if (get_futex_key((u32 __user *)ukey, fshared, &key) != 0) {
 		kill_guest(lg, "bad sending DMA key");
 		goto unlock;
 	}
@@ -342,7 +344,7 @@ again:
 		lg->pending_key = ukey;
 	}
 unlock:
-	up_read(&current->mm->mmap_sem);
+	up_read(fshared);
 	mutex_unlock(&lguest_lock);
 }
 
@@ -382,10 +384,11 @@ unsigned long get_dma_buffer(struct lgue
 	unsigned long ret = 0;
 	union futex_key key;
 	struct lguest_dma_info *i;
+	struct rw_semaphore *fshared = &current->mm->mmap_sem;
 
 	mutex_lock(&lguest_lock);
-	down_read(&current->mm->mmap_sem);
-	if (get_futex_key((u32 __user *)ukey, &key) != 0) {
+	down_read(fshared);
+	if (get_futex_key((u32 __user *)ukey, fshared, &key) != 0) {
 		kill_guest(lg, "bad registered DMA buffer");
 		goto unlock;
 	}
@@ -405,7 +408,7 @@ unsigned long get_dma_buffer(struct lgue
 		}
 	}
 unlock:
-	up_read(&current->mm->mmap_sem);
+	up_read(fshared);
 	mutex_unlock(&lguest_lock);
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmc-build-fix.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
mutex_lock_interruptible-add-__must_check.patch
afs-implement-basic-file-write-support.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
fs-convert-core-functions-to-zero_user_page.patch
rename-thread_info-to-stack.patch
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
git-mtd.patch
git-battery-fix.patch
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
lib-hexdump-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
ntfs-use-zero_user_page.patch
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

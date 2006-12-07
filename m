From: akpm@osdl.org
Subject: - new-scheme-to-preempt-swap-token-tidy.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:10:40 -0800
Message-ID: <200612070310.kB73Ae89026851@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41336 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967784AbWLGDKz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:10:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, a.p.zijlstra@chello.nl, ashwin.chaugule@celunite.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     new-scheme-to-preempt-swap-token-tidy
has been removed from the -mm tree.  Its filename was
     new-scheme-to-preempt-swap-token-tidy.patch

This patch was dropped because it was folded into new-scheme-to-preempt-swap-token.patch

------------------------------------------------------
Subject: new-scheme-to-preempt-swap-token-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: Ashwin Chaugule <ashwin.chaugule@celunite.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/thrash.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/thrash.c~new-scheme-to-preempt-swap-token-tidy mm/thrash.c
--- a/mm/thrash.c~new-scheme-to-preempt-swap-token-tidy
+++ a/mm/thrash.c
@@ -23,12 +23,12 @@
 #include <linux/swap.h>
 
 static DEFINE_SPINLOCK(swap_token_lock);
-struct mm_struct * swap_token_mm = NULL;
-unsigned int global_faults = 0;
+struct mm_struct *swap_token_mm;
+unsigned int global_faults;
 
 void grab_swap_token(void)
 {
-	int current_interval = 0;
+	int current_interval;
 
 	global_faults++;
 
@@ -53,14 +53,15 @@ void grab_swap_token(void)
 				current->mm->token_priority = 0;
 		}
 		/* Check if we deserve the token */
-		if (current->mm->token_priority > swap_token_mm->token_priority) {
-			current->mm->token_priority = current->mm->token_priority + 2;
+		if (current->mm->token_priority >
+				swap_token_mm->token_priority) {
+			current->mm->token_priority += 2;
 			swap_token_mm = current->mm;
 		}
-	}
-	else
+	} else {
 		/* Token holder came in again! */
-		current->mm->token_priority = current->mm->token_priority + 2;
+		current->mm->token_priority += 2;
+	}
 
 out:
 	current->mm->faultstamp = global_faults;
@@ -73,8 +74,7 @@ return;
 void __put_swap_token(struct mm_struct *mm)
 {
 	spin_lock(&swap_token_lock);
-	if (likely(mm == swap_token_mm)) {
+	if (likely(mm == swap_token_mm))
 		swap_token_mm = NULL;
-	}
 	spin_unlock(&swap_token_lock);
 }
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
add-bottom_half.h.patch
drm-sis-linkage-fix.patch
uml-workqueue-build-fix.patch
get-rid-of-zone_table.patch
new-scheme-to-preempt-swap-token.patch
new-scheme-to-preempt-swap-token-tidy.patch
balance_pdgat-cleanup.patch
leak-tracking-for-kmalloc_node-fix.patch
add-numa-node-information-to-struct-device-tidy.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
slab-deprecate-kmem_cache-t.patch
mm-make-compound-page-destructor-handling-explicit-tidy.patch
congestion-wait-dont-wait-when-there-are-no-pages-under-writeback.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
radix-tree-rcu-lockless-readside.patch
swsusp-add-resume_offset-command-line-parameter-rev-2.patch
add-include-linux-freezerh-and-move-definitions-from-ueagle-fix.patch
convert-pm_sem-to-a-mutex-fix.patch
cciss-set-sector_size-to-2048-for-performance-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
lockdep-annotate-nfs-nfsd-in-kernel-sockets-tidy.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
probe_kernel_address-needs-to-do-set_fs.patch
slab-use-probe_kernel_address.patch
exar-quad-port-serial-fix.patch
vfs_getattr-remove-dead-code.patch
ext3-uninline-large-functions.patch
ext4-uninline-large-functions.patch
sleep-profiling-fixes.patch
sleep-profiling-fix.patch
debug-workqueue-locking-sanity-fix.patch
pcengines-wrap-led-support-fix.patch
driver-base-memoryc-remove-warnings-of.patch
remove-kernel-syscalls-x86_64-fix.patch
protect-ext2-ioctl-modifying-append_only-immutable-etc-with-i_mutex.patch
remove-hash_highmem.patch
elf-fix-kcore-note-size-calculation-fix.patch
reiserfs-add-missing-d-cache-flushing-tweak.patch
smp_call_function_single-check-that-local-interrupts-are-enabled.patch
hotplug-cpu-clean-up-hotcpu_notifier-use-vs-gregkh-driver-cpu-topology-consider-sysfs_create_group-return-value.patch
add-return-value-checking-of-get_user-in-fix.patch
handle-per-subsystem-mutexes-for-config_hotplug_cpu-not-set-tidy.patch
dz-fixes-to-make-it-work-fix.patch
ext4-balloc-fix-_with_rsv-freeze-fix.patch
ide_scsi-allow-it-to-be-used-for-non-cd-only-fix.patch
make-8250_pnp-serial-driver-work-after-tidy.patch
gcc-4-1-0-is-bust.patch
cleanup-include-asm-generic-atomich-fix.patch
struct-seq_operations-and-struct-file_operations-constification-fix.patch
struct-seq_operations-and-struct-file_operations-constification-fix-2.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
io-accounting-core-statistics.patch
clean-up-__set_page_dirty_nobuffers.patch
io-accounting-write-accounting.patch
io-accounting-write-cancel-accounting.patch
io-accounting-read-accounting-2.patch
io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-cifs-fix.patch
io-accounting-direct-io.patch
io-accounting-report-in-procfs.patch
cleanup-taskstatsh.patch
io-accounting-via-taskstats.patch
getdelays-various-fixes.patch
io-accounting-add-to-getdelays.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch
bug-test-1.patch
net-use-bitrev8-tidy.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sched-add-option-to-serialize-load-balancing-fix.patch
kernel-schedc-whitespace-cleanups-more.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
round_jiffies-infrastructure-fix.patch
clocksource-small-cleanup-2-fix.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch


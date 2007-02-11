From: akpm@linux-foundation.org
Subject: - proc-zoneinfo-fix-vm-stats-display.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:07 -0800
Message-ID: <200702112246.l1BMk7gD015467@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59465 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606AbXBKWqK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clameter@engr.sgi.com, mm-commits@vger.kernel.org


The patch titled
     /proc/zoneinfo: fix vm stats display
has been removed from the -mm tree.  Its filename was
     proc-zoneinfo-fix-vm-stats-display.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: /proc/zoneinfo: fix vm stats display
From: Andrew Morton <akpm@osdl.org>

This early break prevents us from displaying info for the vm stats thresholds
if the zone doesn't have any pages in its per-cpu pagesets.

So my 800MB i386 box says:

Node 0, zone      DMA
  pages free     2365
        min      16
        low      20
        high     24
        active   0
        inactive 0
        scanned  0 (a: 0 i: 0)
        spanned  4096
        present  4044
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 868, 868)
  pagesets
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         0
Node 0, zone   Normal
  pages free     199713
        min      934
        low      1167
        high     1401
        active   10215
        inactive 4507
        scanned  0 (a: 0 i: 0)
        spanned  225280
        present  222420
    nr_anon_pages 2685
    nr_mapped    1110
    nr_file_pages 12055
    nr_slab_reclaimable 2216
    nr_slab_unreclaimable 1527
    nr_page_table_pages 213
    nr_dirty     0
    nr_writeback 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 0, 0)
  pagesets
    cpu: 0 pcp: 0
              count: 152
              high:  186
              batch: 31
    cpu: 0 pcp: 1
              count: 13
              high:  62
              batch: 15
  vm stats threshold: 16
    cpu: 1 pcp: 0
              count: 34
              high:  186
              batch: 31
    cpu: 1 pcp: 1
              count: 10
              high:  62
              batch: 15
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096

Just nuke all that search-for-the-first-non-empty-pageset code.  Dunno why it
was there in the first place..

Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/vmstat.c~proc-zoneinfo-fix-vm-stats-display mm/vmstat.c
--- a/mm/vmstat.c~proc-zoneinfo-fix-vm-stats-display
+++ a/mm/vmstat.c
@@ -563,12 +563,6 @@ static int zoneinfo_show(struct seq_file
 
 			pageset = zone_pcp(zone, i);
 			for (j = 0; j < ARRAY_SIZE(pageset->pcp); j++) {
-				if (pageset->pcp[j].count)
-					break;
-			}
-			if (j == ARRAY_SIZE(pageset->pcp))
-				continue;
-			for (j = 0; j < ARRAY_SIZE(pageset->pcp); j++) {
 				seq_printf(m,
 					   "\n    cpu: %i pcp: %i"
 					   "\n              count: %i"
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
add-an-rcu-version-of-list-splicing.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
git-agpgart.patch
git-dvb.patch
git-ia64.patch
git-ieee1394.patch
git-infiniband.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mtd.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
netfilter-warning-fix.patch
git-backlight.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-block-xfs-barriers-broke.patch
nokia-e70-is-an-unusual-device.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-generalize-metadata-read-write-fix.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
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
reiser4-test_clear_page_dirty.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

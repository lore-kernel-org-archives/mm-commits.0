From: akpm@linux-foundation.org
Subject: + local_t-powerpc-extension-fix-build-fix.patch added to -mm tree
Date: Sat, 17 Feb 2007 18:17:16 -0700
Message-ID: <200702180117.l1I1HHXg007405@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53764 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965534AbXBRBR3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 20:17:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca, paulus@samba.org


The patch titled
     local_t-powerpc-extension-fix-build-fix
has been added to the -mm tree.  Its filename is
     local_t-powerpc-extension-fix-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: local_t-powerpc-extension-fix-build-fix
From: Andrew Morton <akpm@osdl.org>

In file included from include/asm/pci.h:20,
                 from include/linux/pci.h:751,
                 from arch/powerpc/sysdev/dart_iommu.c:36:
include/asm/prom.h: In function `of_irq_to_resource':
include/asm/prom.h:341: warning: implicit declaration of function `irq_of_parse_and_map'
include/asm/prom.h:345: error: `NO_IRQ' undeclared (first use in this function)
include/asm/prom.h:345: error: (Each undeclared identifier is reported only once
include/asm/prom.h:345: error: for each function it appears in.)

Seems that prom.h has always wanted irq.h.

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-powerpc/prom.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/asm-powerpc/prom.h~local_t-powerpc-extension-fix-build-fix include/asm-powerpc/prom.h
--- a/include/asm-powerpc/prom.h~local_t-powerpc-extension-fix-build-fix
+++ a/include/asm-powerpc/prom.h
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <linux/proc_fs.h>
 #include <linux/platform_device.h>
+#include <asm/irq.h>
 #include <asm/atomic.h>
 
 /* Definitions used by the flattened device tree */
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
fix-missing-declaration-of-init_irq_proc.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
git-dvb.patch
git-ia64.patch
git-ieee1394.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
ide-fix-pmac-breakage.patch
git-lxdialog-fixup.patch
git-mtd.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-backlight.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-block-xfs-barriers-broke.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
factor-outstanding-i-o-error-handling-tidy.patch
consolidate-generic_writepages-and-mpage_writepages-tidy.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
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
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
rcu-preemptible-rcu.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix-2.patch
local_t-powerpc-extension-fix.patch
local_t-powerpc-extension-fix-build-fix.patch
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
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
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

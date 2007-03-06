From: akpm@linux-foundation.org
Subject: - readahead-context-based-method-locking-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:47:11 -0800
Message-ID: <200703060147.l261lBon008298@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45999 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933820AbXCFBrT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:47:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead-context-based-method-locking-fix
has been removed from the -mm tree.  Its filename was
     readahead-context-based-method-locking-fix.patch

This patch was dropped because it was folded into readahead-context-based-method.patch

------------------------------------------------------
Subject: readahead-context-based-method-locking-fix
From: Andrew Morton <akpm@osdl.org>

It is a bug to nest read_lock_irq() inside read_lock_irq().

Cc: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/readahead.c~readahead-context-based-method-locking-fix mm/readahead.c
--- a/mm/readahead.c~readahead-context-based-method-locking-fix
+++ a/mm/readahead.c
@@ -1178,10 +1178,10 @@ static inline unsigned long inactive_pag
 
 /*
  * Count/estimate cache hits in range [begin, end).
- * The estimation is simple and optimistic.
+ * The estimation is simple and optimistic.  The caller must hold tree_lock.
  */
 #define CACHE_HIT_HASH_KEY	29	/* some prime number */
-static int count_cache_hit(struct address_space *mapping,
+static int __count_cache_hit(struct address_space *mapping,
 						pgoff_t begin, pgoff_t end)
 {
 	int size = end - begin;
@@ -1194,14 +1194,12 @@ static int count_cache_hit(struct addres
 	 * behavior guarantees a readahead when (size < ra_max) and
 	 * (readahead_hit_rate >= 8).
 	 */
-	read_lock_irq(&mapping->tree_lock);
 	for (i = 0; i < 8;) {
 		struct page *page = radix_tree_lookup(&mapping->page_tree,
 			begin + size * ((i++ * CACHE_HIT_HASH_KEY) & 7) / 8);
 		if (inactive_page_refcnt(page) >= PAGE_REFCNT_1 && ++count >= 2)
 			break;
 	}
-	read_unlock_irq(&mapping->tree_lock);
 
 	return size * count / i;
 }
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
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
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
mm-implement-swap-prefetching.patch
rcu-preemptible-rcu.patch
readahead-kconfig-options.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-context-based-method.patch
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

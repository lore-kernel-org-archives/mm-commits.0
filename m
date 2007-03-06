From: akpm@linux-foundation.org
Subject: - readahead-call-scheme-build-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:49:42 -0800
Message-ID: <200703060150.l261oQ4q008388@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933831AbXCFBud (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:50:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead-call-scheme-build fix
has been removed from the -mm tree.  Its filename was
     readahead-call-scheme-build-fix.patch

This patch was dropped because it was folded into readahead-call-scheme.patch

------------------------------------------------------
Subject: readahead-call-scheme-build fix
From: Andrew Morton <akpm@osdl.org>

CONFIG_ADAPTIVE_READAHEAD=n:

mm/readahead.c: In function 'page_cache_readahead_adaptive':
mm/readahead.c:1606: warning: implicit declaration of function 'get_readahead_bounds'
mm/readahead.c:1618: warning: implicit declaration of function 'initial_readahead'
mm/readahead.c:1624: error: 'struct file_ra_state' has no member named 'lookahead_index'
mm/readahead.c:1626: warning: implicit declaration of function 'state_based_readahead'
mm/readahead.c:1632: warning: implicit declaration of function 'ra_has_index'
mm/readahead.c:1633: warning: implicit declaration of function 'thrashing_recovery_readahead'
mm/readahead.c:1639: warning: implicit declaration of function 'try_backward_prefetching'
mm/readahead.c:1640: warning: implicit declaration of function 'ra_submit'
mm/readahead.c:1645: warning: implicit declaration of function 'try_context_based_readahead'

Cc: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   14 ++++++++++++++
 mm/readahead.c     |    3 +--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~readahead-call-scheme-build-fix include/linux/mm.h
--- a/include/linux/mm.h~readahead-call-scheme-build-fix
+++ a/include/linux/mm.h
@@ -1108,6 +1108,8 @@ unsigned long page_cache_readahead(struc
 void handle_ra_miss(struct address_space *mapping, 
 		    struct file_ra_state *ra, pgoff_t offset);
 unsigned long max_sane_readahead(unsigned long nr);
+
+#ifdef CONFIG_ADAPTIVE_READAHEAD
 unsigned long
 page_cache_readahead_adaptive(struct address_space *mapping,
 				struct file_ra_state *ra,
@@ -1115,6 +1117,18 @@ page_cache_readahead_adaptive(struct add
 				struct page *page,
 				pgoff_t offset,
 				unsigned long size);
+#else
+static inline unsigned long
+page_cache_readahead_adaptive(struct address_space *mapping,
+				struct file_ra_state *ra,
+				struct file *filp,
+				struct page *page,
+				pgoff_t offset,
+				unsigned long size)
+{
+	return page_cache_readahead(mapping, ra, filp, offset, size);
+}
+#endif
 
 #if defined(CONFIG_DEBUG_READAHEAD)
 void readahead_cache_hit(struct file_ra_state *ra, struct page *page);
diff -puN mm/readahead.c~readahead-call-scheme-build-fix mm/readahead.c
--- a/mm/readahead.c~readahead-call-scheme-build-fix
+++ a/mm/readahead.c
@@ -1554,8 +1554,6 @@ thrashing_recovery_readahead(struct addr
 	return ra_submit(ra, mapping, filp);
 }
 
-#endif /* CONFIG_ADAPTIVE_READAHEAD */
-
 /**
  * page_cache_readahead_adaptive - thrashing safe adaptive read-ahead
  * @mapping, @ra, @filp, @offset, @req_size: the same as page_cache_readahead()
@@ -1668,6 +1666,7 @@ readit:
 	return ra_size;
 }
 EXPORT_SYMBOL_GPL(page_cache_readahead_adaptive);
+#endif /* CONFIG_ADAPTIVE_READAHEAD */
 
 #ifdef CONFIG_DEBUG_READAHEAD
 /**
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
readahead-call-scheme.patch
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

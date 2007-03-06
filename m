From: akpm@linux-foundation.org
Subject: - reiser4-get_sb_dev-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:34 -0800
Message-ID: <200703060159.l261xYi3008613@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46560 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965677AbXCFB7r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:59:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: get_sb_dev() fix
has been removed from the -mm tree.  Its filename was
     reiser4-get_sb_dev-fix.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: get_sb_dev() fix
From: Andrew Morton <akpm@osdl.org>

Update reiser4 for dhowells API changes

Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/super_ops.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff -puN fs/reiser4/super_ops.c~reiser4-get_sb_dev-fix fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-get_sb_dev-fix
+++ a/fs/reiser4/super_ops.c
@@ -287,7 +287,7 @@ static void reiser4_write_super(struct s
  *
  * Returns information about filesystem.
  */
-static int reiser4_statfs(struct super_block *super, struct kstatfs *statfs)
+static int reiser4_statfs(struct dentry *dentry, struct kstatfs *statfs)
 {
 	sector_t total;
 	sector_t reserved;
@@ -295,6 +295,7 @@ static int reiser4_statfs(struct super_b
 	sector_t forroot;
 	sector_t deleted;
 	reiser4_context *ctx;
+	struct super_block *super = dentry->d_sb;
 
 	assert("nikita-408", super != NULL);
 	assert("nikita-409", statfs != NULL);
@@ -567,12 +568,10 @@ static int fill_super(struct super_block
  *
  * Reiser4 mount entry.
  */
-static struct super_block *reiser4_get_sb(struct file_system_type *fs_type,
-					  int flags,
-					  const char *dev_name,
-					  void *data)
+static int reiser4_get_sb(struct file_system_type *fs_type, int flags,
+			const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	return get_sb_bdev(fs_type, flags, dev_name, data, fill_super);
+	return get_sb_bdev(fs_type, flags, dev_name, data, fill_super, mnt);
 }
 
 /* structure describing the reiser4 filesystem implementation */
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
readahead-nfsd-case.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
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

From: akpm@linux-foundation.org
Subject: - check_dirty_inode_list.patch removed from -mm tree
Date: Thu, 04 Oct 2007 14:13:28 -0700
Message-ID: <200710042113.l94LDSCC028983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757934AbXJDVNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 17:13:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mikew@google.com, mm-commits@vger.kernel.org


The patch titled
     writeback: add debugging code to check time-orderedness of s_dirty
has been removed from the -mm tree.  Its filename was
     check_dirty_inode_list.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: writeback: add debugging code to check time-orderedness of s_dirty
From: Andrew Morton <akpm@linux-foundation.org>

The per-superblock dirty-inode list super_block.s_dirty is supposed to be
sorted in reverse order of each inode's time-of-first-dirtying.  This is so
that the kupdate function can avoid having to walk all the dirty inodes on the
list: it terminates the search as soon as it finds an inode which was dirtied
less than 30 seconds ago (dirty_expire_centisecs).

We have a bunch of several-year-old bugs which cause that list to not be in
the correct reverse-time-order.  The result of this is that under certain
obscure circumstances, inodes get stuck and basically never get written back. 
It has been reported a couple of times, but nobody really cared much because
most people use ordered-mode journalling filesystems, which take care of the
writeback independently.  Plus we will _eventually_ get onto these inodes even
when the list is out of order, and a /bin/sync will still work OK.

However this is a pretty important data-integrity issue for filesystems such
as ext2.


As preparation for fixing these bugs, this patch adds a pile of fantastically
expensive debugging code which checks the sanity of the s_dirty list all over
the place, so we find out as soon as it goes bad.

The debugging code is controlled by /proc/sys/fs/inode_debug, which defaults
to off.  The debugging will disable itself whenever it detects a misordering,
to avoid log spew.

We can remove all this code later.

Cc: Mike Waychison <mikew@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |   62 +++++++++++++++++++++++++++++++++++-
 include/linux/writeback.h |    1 
 kernel/sysctl.c           |    8 ++++
 3 files changed, 70 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~check_dirty_inode_list fs/fs-writeback.c
--- a/fs/fs-writeback.c~check_dirty_inode_list
+++ a/fs/fs-writeback.c
@@ -25,6 +25,57 @@
 #include <linux/buffer_head.h>
 #include "internal.h"
 
+int sysctl_inode_debug __read_mostly;
+
+static int __check(struct super_block *sb, int print_stuff)
+{
+	struct list_head *cursor = &sb->s_dirty;
+	unsigned long dirtied_when = 0;
+
+	while ((cursor = cursor->prev) != &sb->s_dirty) {
+		struct inode *inode = list_entry(cursor, struct inode, i_list);
+		if (print_stuff) {
+			printk("%p:%lu\n", inode, inode->dirtied_when);
+		} else {
+			if (dirtied_when &&
+			    time_before(inode->dirtied_when, dirtied_when))
+				return 1;
+			dirtied_when = inode->dirtied_when;
+		}
+	}
+	return 0;
+}
+
+static void __check_dirty_inode_list(struct super_block *sb,
+			struct inode *inode, const char *file, int line)
+{
+	if (!sysctl_inode_debug)
+		return;
+
+	if (__check(sb, 0)) {
+		sysctl_inode_debug = 0;
+		if (inode)
+			printk("%s:%d: s_dirty got screwed up.  inode=%p:%lu\n",
+					file, line, inode, inode->dirtied_when);
+		else
+			printk("%s:%d: s_dirty got screwed up\n", file, line);
+		__check(sb, 1);
+	}
+}
+
+#define check_dirty_inode_list(sb)					\
+	do {								\
+		if (unlikely(sysctl_inode_debug))			\
+		__check_dirty_inode_list(sb, NULL, __FILE__, __LINE__);	\
+	} while (0)
+
+#define check_dirty_inode(inode)					\
+	do {								\
+		if (unlikely(sysctl_inode_debug))			\
+			__check_dirty_inode_list(inode->i_sb, inode,	\
+						__FILE__, __LINE__);	\
+	} while (0)
+
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -123,8 +174,10 @@ void __mark_inode_dirty(struct inode *in
 		 * reposition it (that would break s_dirty time-ordering).
 		 */
 		if (!was_dirty) {
+			check_dirty_inode(inode);
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &sb->s_dirty);
+			check_dirty_inode(inode);
 		}
 	}
 out:
@@ -153,6 +206,7 @@ static void redirty_tail(struct inode *i
 {
 	struct super_block *sb = inode->i_sb;
 
+	check_dirty_inode(inode);
 	if (!list_empty(&sb->s_dirty)) {
 		struct inode *tail_inode;
 
@@ -162,6 +216,7 @@ static void redirty_tail(struct inode *i
 			inode->dirtied_when = jiffies;
 	}
 	list_move(&inode->i_list, &sb->s_dirty);
+	check_dirty_inode(inode);
 }
 
 /*
@@ -375,8 +430,11 @@ int generic_sync_sb_inodes(struct super_
 
 	spin_lock(&inode_lock);
 
-	if (!wbc->for_kupdate || list_empty(&sb->s_io))
+	if (!wbc->for_kupdate || list_empty(&sb->s_io)) {
+		check_dirty_inode_list(sb);
 		list_splice_init(&sb->s_dirty, &sb->s_io);
+		check_dirty_inode_list(sb);
+	}
 
 	while (!list_empty(&sb->s_io)) {
 		int err;
@@ -441,8 +499,10 @@ int generic_sync_sb_inodes(struct super_
 		if (!ret)
 			ret = err;
 		if (wbc->sync_mode == WB_SYNC_HOLD) {
+			check_dirty_inode(inode);
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &sb->s_dirty);
+			check_dirty_inode(inode);
 		}
 		if (current_is_pdflush())
 			writeback_release(bdi);
diff -puN include/linux/writeback.h~check_dirty_inode_list include/linux/writeback.h
--- a/include/linux/writeback.h~check_dirty_inode_list
+++ a/include/linux/writeback.h
@@ -144,5 +144,6 @@ void writeback_set_ratelimit(void);
 extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
 				   read-only. */
 
+extern int sysctl_inode_debug;
 
 #endif		/* WRITEBACK_H */
diff -puN kernel/sysctl.c~check_dirty_inode_list kernel/sysctl.c
--- a/kernel/sysctl.c~check_dirty_inode_list
+++ a/kernel/sysctl.c
@@ -1206,6 +1206,14 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "inode_debug",
+		.data		= &sysctl_inode_debug,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{
 		.ctl_name	= CTL_UNNUMBERED,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slow-down-printk-during-boot.patch
acpi-add-reboot-mechanism.patch
acpi-suppress-uninitialized-var-warning.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-dvb.patch
git-hwmon-fixup.patch
git-infiniband.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
git-input-fixup.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-jg-misc-fix.patch
git-jg-warning-fixes.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-libata-all.patch
ide-arm-hack.patch
git-mips.patch
git-mmc.patch
git-mmc-fixup2.patch
mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-mtd-vs-powerpc.patch
git-net.patch
git-net-fixup.patch
git-net-more-bustage.patch
ipgc-doesnt-compile-with-with-config_highmem64g.patch
git-net-sctp-hack.patch
forcedeth-power-down-phy-when-interface-is-down-checkpatch-fixes.patch
git-net-vs-git-nfs.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-nfsd-fixup.patch
git-ocfs2.patch
git-r8169-fixup.patch
fix-ide-legacy-mode-resources.patch
git-s390.patch
git-sched.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
git-scsi-misc-arcmsr-build-fix.patch
advansys-printk-fix.patch
git-block.patch
git-block-fixup.patch
git-unionfs.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-net-vs-git-wireless.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
net-add-ath5k-wireless-driver-fix.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
x86_64-cleanup-apic-c.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
asm-i386-ioh-fix-constness.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
git-xfs.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
git-nfs-vs-nfs-convert-to-new-aops-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-do-not-take-callback_mutex-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
uml-clocksource-support-fix.patch
uml-tickless-support-fix.patch
uml-fix-stub-address-calculations-checkpatch-fixes.patch
uml-arch-um-drivers-formatting-checkpatch-fixes.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
keys-make-request_key-and-co-fundamentally-asynchronous-vs-git-mmc.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
userc-ifdef-mq_bytes-fix.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
binfmt_flat-minimum-support-for-the-blackfin-relocations-checkpatch-fixes.patch
f_dupfd_cloexec-implementation-fix-2.patch
ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
fbcon-logo-disable-logo-at-boot-fix.patch
md-software-raid-autodetect-dev-list-not-array.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch

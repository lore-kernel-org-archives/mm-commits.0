From: akpm@linux-foundation.org
Subject: + check_dirty_inode_list.patch added to -mm tree
Date: Sat, 12 May 2007 01:28:36 -0700
Message-ID: <200705120828.l4C8Scnd004769@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755066AbXELI2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 04:28:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mikew@google.com


The patch titled
     writeback: add debugging code to check time-orderedness of s_dirty
has been added to the -mm tree.  Its filename is
     check_dirty_inode_list.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 fs/fs-writeback.c         |   68 +++++++++++++++++++++++++++++++++++-
 include/linux/writeback.h |    1 
 kernel/sysctl.c           |    8 ++++
 3 files changed, 76 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~check_dirty_inode_list fs/fs-writeback.c
--- a/fs/fs-writeback.c~check_dirty_inode_list
+++ a/fs/fs-writeback.c
@@ -24,6 +24,49 @@
 #include <linux/buffer_head.h>
 #include "internal.h"
 
+int sysctl_inode_debug __read_mostly = 1;
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
+#define check_dirty_inode_list(sb)		\
+	__check_dirty_inode_list(sb, NULL, __FILE__, __LINE__)
+#define check_dirty_inode(inode)		\
+	__check_dirty_inode_list(inode->i_sb, inode, __FILE__, __LINE__)
+
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -122,8 +165,10 @@ void __mark_inode_dirty(struct inode *in
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
@@ -200,7 +245,9 @@ __sync_single_inode(struct inode *inode,
 				 * uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
+				check_dirty_inode(inode);
 				list_move_tail(&inode->i_list, &sb->s_dirty);
+				check_dirty_inode(inode);
 			} else {
 				/*
 				 * Otherwise fully redirty the inode so that
@@ -210,15 +257,19 @@ __sync_single_inode(struct inode *inode,
 				 * all the other files.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
+				check_dirty_inode(inode);
 				inode->dirtied_when = jiffies;
 				list_move(&inode->i_list, &sb->s_dirty);
+				check_dirty_inode(inode);
 			}
 		} else if (inode->i_state & I_DIRTY) {
 			/*
 			 * Someone redirtied the inode while were writing back
 			 * the pages.
 			 */
+			check_dirty_inode(inode);
 			list_move(&inode->i_list, &sb->s_dirty);
+			check_dirty_inode(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse
@@ -254,7 +305,9 @@ __writeback_single_inode(struct inode *i
 		struct address_space *mapping = inode->i_mapping;
 		int ret;
 
+		check_dirty_inode(inode);
 		list_move(&inode->i_list, &inode->i_sb->s_dirty);
+		check_dirty_inode(inode);
 
 		/*
 		 * Even if we don't actually write the inode itself here,
@@ -319,8 +372,11 @@ int generic_sync_sb_inodes(struct super_
 
 	spin_lock(&inode_lock);
 
-	if (!wbc->for_kupdate || list_empty(&sb->s_io))
+	if (!wbc->for_kupdate || list_empty(&sb->s_io)) {
+		check_dirty_inode_list(sb);
 		list_splice_init(&sb->s_dirty, &sb->s_io);
+		check_dirty_inode_list(sb);
+	}
 
 	while (!list_empty(&sb->s_io)) {
 		int err;
@@ -332,7 +388,9 @@ int generic_sync_sb_inodes(struct super_
 		long pages_skipped;
 
 		if (!bdi_cap_writeback_dirty(bdi)) {
+			check_dirty_inode(inode);
 			list_move(&inode->i_list, &sb->s_dirty);
+			check_dirty_inode(inode);
 			if (sb_is_blkdev_sb(sb)) {
 				/*
 				 * Dirty memory-backed blockdev: the ramdisk
@@ -352,14 +410,18 @@ int generic_sync_sb_inodes(struct super_
 			wbc->encountered_congestion = 1;
 			if (!sb_is_blkdev_sb(sb))
 				break;		/* Skip a congested fs */
+			check_dirty_inode(inode);
 			list_move(&inode->i_list, &sb->s_dirty);
+			check_dirty_inode(inode);
 			continue;		/* Skip a congested blockdev */
 		}
 
 		if (wbc->bdi && bdi != wbc->bdi) {
 			if (!sb_is_blkdev_sb(sb))
 				break;		/* fs has the wrong queue */
+			check_dirty_inode(inode);
 			list_move(&inode->i_list, &sb->s_dirty);
+			check_dirty_inode(inode);
 			continue;		/* blockdev has wrong queue */
 		}
 
@@ -383,8 +445,10 @@ int generic_sync_sb_inodes(struct super_
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
@@ -393,7 +457,9 @@ int generic_sync_sb_inodes(struct super_
 			 * writeback is not making progress due to locked
 			 * buffers.  Skip this inode for now.
 			 */
+			check_dirty_inode(inode);
 			list_move(&inode->i_list, &sb->s_dirty);
+			check_dirty_inode(inode);
 		}
 		spin_unlock(&inode_lock);
 		iput(inode);
diff -puN kernel/sysctl.c~check_dirty_inode_list kernel/sysctl.c
--- a/kernel/sysctl.c~check_dirty_inode_list
+++ a/kernel/sysctl.c
@@ -1079,6 +1079,14 @@ static ctl_table fs_table[] = {
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
diff -puN include/linux/writeback.h~check_dirty_inode_list include/linux/writeback.h
--- a/include/linux/writeback.h~check_dirty_inode_list
+++ a/include/linux/writeback.h
@@ -132,5 +132,6 @@ void writeback_set_ratelimit(void);
 extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
 				   read-only. */
 
+extern int sysctl_inode_debug;
 
 #endif		/* WRITEBACK_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ntfs-use-zero_user_page.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-arm.patch
git-avr32.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mips-fixup.patch
fix-race-condition-about-network-device-name-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
git-wireless-fixup.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
git-newsetup-fixup.patch
xfs-clean-up-shrinker-games.patch
remove-slab_ctor_constructor-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
crc7-support-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
check_dirty_inode_list.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch

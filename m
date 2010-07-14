From: akpm@linux-foundation.org
Subject: + revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped.patch added to -mm tree
Date: Wed, 14 Jul 2010 14:56:23 -0700
Message-ID: <201007142225.o6EMPgXZ026418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522Ab0GNWZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jul 2010 18:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk


The patch titled
     revert "Make ->drop_inode() just return whether inode needs to be dropped"
has been added to the -mm tree.  Its filename is
     revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "Make ->drop_inode() just return whether inode needs to be dropped"
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/pohmelfs/inode.c |    4 -
 fs/btrfs/ctree.h                 |    2 
 fs/btrfs/inode.c                 |   11 +-
 fs/cifs/cifsfs.c                 |    9 +-
 fs/gfs2/super.c                  |    4 -
 fs/inode.c                       |  113 ++++++++++++++++++++---------
 fs/logfs/inode.c                 |    4 -
 fs/ocfs2/inode.c                 |    8 --
 fs/ocfs2/inode.h                 |    2 
 include/linux/fs.h               |    6 -
 10 files changed, 103 insertions(+), 60 deletions(-)

diff -puN drivers/staging/pohmelfs/inode.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped drivers/staging/pohmelfs/inode.c
--- a/drivers/staging/pohmelfs/inode.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped
+++ a/drivers/staging/pohmelfs/inode.c
@@ -1223,7 +1223,7 @@ void pohmelfs_fill_inode(struct inode *i
 	}
 }
 
-static int pohmelfs_drop_inode(struct inode *inode)
+static void pohmelfs_drop_inode(struct inode *inode)
 {
 	struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
 	struct pohmelfs_inode *pi = POHMELFS_I(inode);
@@ -1232,7 +1232,7 @@ static int pohmelfs_drop_inode(struct in
 	list_del_init(&pi->inode_entry);
 	spin_unlock(&psb->ino_lock);
 
-	return generic_drop_inode(inode);
+	generic_drop_inode(inode);
 }
 
 static struct pohmelfs_inode *pohmelfs_get_inode_from_list(struct pohmelfs_sb *psb,
diff -puN fs/btrfs/ctree.h~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped
+++ a/fs/btrfs/ctree.h
@@ -2395,7 +2395,7 @@ int btrfs_write_inode(struct inode *inod
 void btrfs_dirty_inode(struct inode *inode);
 struct inode *btrfs_alloc_inode(struct super_block *sb);
 void btrfs_destroy_inode(struct inode *inode);
-int btrfs_drop_inode(struct inode *inode);
+void btrfs_drop_inode(struct inode *inode);
 int btrfs_init_cachep(void);
 void btrfs_destroy_cachep(void);
 long btrfs_ioctl_trans_end(struct file *file);
diff -puN fs/btrfs/inode.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped
+++ a/fs/btrfs/inode.c
@@ -3943,7 +3943,7 @@ again:
 			if (atomic_read(&inode->i_count) > 1)
 				d_prune_aliases(inode);
 			/*
-			 * btrfs_drop_inode will have it removed from
+			 * btrfs_drop_inode will remove it from
 			 * the inode cache when its usage count
 			 * hits zero.
 			 */
@@ -6337,14 +6337,13 @@ free:
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
 
-int btrfs_drop_inode(struct inode *inode)
+void btrfs_drop_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-
-	if (btrfs_root_refs(&root->root_item) == 0)
-		return 1;
+	if (inode->i_nlink > 0 && btrfs_root_refs(&root->root_item) == 0)
+		generic_delete_inode(inode);
 	else
-		return generic_drop_inode(inode);
+		generic_drop_inode(inode);
 }
 
 static void init_once(void *foo)
diff -puN fs/cifs/cifsfs.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped
+++ a/fs/cifs/cifsfs.c
@@ -473,13 +473,14 @@ static int cifs_remount(struct super_blo
 	return 0;
 }
 
-static int cifs_drop_inode(struct inode *inode)
+void cifs_drop_inode(struct inode *inode)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
-	/* no serverino => unconditional eviction */
-	return !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) ||
-		generic_drop_inode(inode);
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+		return generic_drop_inode(inode);
+
+	return generic_delete_inode(inode);
 }
 
 static const struct super_operations cifs_super_ops = {
diff -puN fs/gfs2/super.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped fs/gfs2/super.c
--- a/fs/gfs2/super.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped
+++ a/fs/gfs2/super.c
@@ -1188,7 +1188,7 @@ static int gfs2_remount_fs(struct super_
  * node for later deallocation.
  */
 
-static int gfs2_drop_inode(struct inode *inode)
+static void gfs2_drop_inode(struct inode *inode)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 
@@ -1197,7 +1197,7 @@ static int gfs2_drop_inode(struct inode 
 		if (gl && test_bit(GLF_DEMOTE, &gl->gl_flags))
 			clear_nlink(inode);
 	}
-	return generic_drop_inode(inode);
+	generic_drop_inode(inode);
 }
 
 static int is_ancestor(const struct dentry *d1, const struct dentry *d2)
diff -puN fs/inode.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped fs/inode.c
--- a/fs/inode.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped
+++ a/fs/inode.c
@@ -1174,51 +1174,58 @@ void remove_inode_hash(struct inode *ino
 }
 EXPORT_SYMBOL(remove_inode_hash);
 
-int generic_delete_inode(struct inode *inode)
-{
-	return 1;
-}
-EXPORT_SYMBOL(generic_delete_inode);
-
 /*
- * Normal UNIX filesystem behaviour: delete the
- * inode when the usage count drops to zero, and
- * i_nlink is zero.
+ * Tell the filesystem that this inode is no longer of any interest and should
+ * be completely destroyed.
+ *
+ * We leave the inode in the inode hash table until *after* the filesystem's
+ * ->delete_inode completes.  This ensures that an iget (such as nfsd might
+ * instigate) will always find up-to-date information either in the hash or on
+ * disk.
+ *
+ * I_FREEING is set so that no-one will take a new reference to the inode while
+ * it is being deleted.
  */
-int generic_drop_inode(struct inode *inode)
+void generic_delete_inode(struct inode *inode)
 {
-	return !inode->i_nlink || hlist_unhashed(&inode->i_hash);
+	list_del_init(&inode->i_list);
+	list_del_init(&inode->i_sb_list);
+	WARN_ON(inode->i_state & I_NEW);
+	inode->i_state |= I_FREEING;
+	inodes_stat.nr_inodes--;
+	spin_unlock(&inode_lock);
+
+	evict(inode);
+
+	spin_lock(&inode_lock);
+	hlist_del_init(&inode->i_hash);
+	spin_unlock(&inode_lock);
+	wake_up_inode(inode);
+	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
+	destroy_inode(inode);
 }
-EXPORT_SYMBOL_GPL(generic_drop_inode);
+EXPORT_SYMBOL(generic_delete_inode);
 
-/*
- * Called when we're dropping the last reference
- * to an inode.
+/**
+ *	generic_detach_inode - remove inode from inode lists
+ *	@inode: inode to remove
+ *
+ *	Remove inode from inode lists, write it if it's dirty. This is just an
+ *	internal VFS helper exported for hugetlbfs. Do not use!
  *
- * Call the FS "drop_inode()" function, defaulting to
- * the legacy UNIX filesystem behaviour.  If it tells
- * us to evict inode, do so.  Otherwise, retain inode
- * in cache if fs is alive, sync and evict if fs is
- * shutting down.
+ *	Returns 1 if inode should be completely destroyed.
  */
-static void iput_final(struct inode *inode)
+static int generic_detach_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
-	const struct super_operations *op = inode->i_sb->s_op;
-	int drop;
 
-	if (op && op->drop_inode)
-		drop = op->drop_inode(inode);
-	else
-		drop = generic_drop_inode(inode);
-
-	if (!drop) {
+	if (!hlist_unhashed(&inode->i_hash)) {
 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 			list_move(&inode->i_list, &inode_unused);
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode_lock);
-			return;
+			return 0;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
@@ -1236,15 +1243,53 @@ static void iput_final(struct inode *ino
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
 	spin_unlock(&inode_lock);
+	return 1;
+}
+
+static void generic_forget_inode(struct inode *inode)
+{
+	if (!generic_detach_inode(inode))
+		return;
 	evict(inode);
-	spin_lock(&inode_lock);
-	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode_lock);
 	wake_up_inode(inode);
-	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
 	destroy_inode(inode);
 }
 
+/*
+ * Normal UNIX filesystem behaviour: delete the
+ * inode when the usage count drops to zero, and
+ * i_nlink is zero.
+ */
+void generic_drop_inode(struct inode *inode)
+{
+	if (!inode->i_nlink)
+		generic_delete_inode(inode);
+	else
+		generic_forget_inode(inode);
+}
+EXPORT_SYMBOL_GPL(generic_drop_inode);
+
+/*
+ * Called when we're dropping the last reference
+ * to an inode.
+ *
+ * Call the FS "drop()" function, defaulting to
+ * the legacy UNIX filesystem behaviour..
+ *
+ * NOTE! NOTE! NOTE! We're called with the inode lock
+ * held, and the drop function is supposed to release
+ * the lock!
+ */
+static inline void iput_final(struct inode *inode)
+{
+	const struct super_operations *op = inode->i_sb->s_op;
+	void (*drop)(struct inode *) = generic_drop_inode;
+
+	if (op && op->drop_inode)
+		drop = op->drop_inode;
+	drop(inode);
+}
+
 /**
  *	iput	- put an inode
  *	@inode: inode to put
diff -puN fs/logfs/inode.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped fs/logfs/inode.c
--- a/fs/logfs/inode.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped
+++ a/fs/logfs/inode.c
@@ -287,7 +287,7 @@ static int logfs_write_inode(struct inod
 }
 
 /* called with inode_lock held */
-static int logfs_drop_inode(struct inode *inode)
+static void logfs_drop_inode(struct inode *inode)
 {
 	struct logfs_super *super = logfs_super(inode->i_sb);
 	struct logfs_inode *li = logfs_inode(inode);
@@ -295,7 +295,7 @@ static int logfs_drop_inode(struct inode
 	spin_lock(&logfs_inode_lock);
 	list_move(&li->li_freeing_list, &super->s_freeing_list);
 	spin_unlock(&logfs_inode_lock);
-	return generic_drop_inode(inode);
+	generic_drop_inode(inode);
 }
 
 static void logfs_set_ino_generation(struct super_block *sb,
diff -puN fs/ocfs2/inode.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped
+++ a/fs/ocfs2/inode.c
@@ -1194,10 +1194,9 @@ void ocfs2_evict_inode(struct inode *ino
 /* Called under inode_lock, with no more references on the
  * struct inode, so it's safe here to check the flags field
  * and to manipulate i_nlink without any other locks. */
-int ocfs2_drop_inode(struct inode *inode)
+void ocfs2_drop_inode(struct inode *inode)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	int res;
 
 	mlog_entry_void();
 
@@ -1205,12 +1204,11 @@ int ocfs2_drop_inode(struct inode *inode
 	     (unsigned long long)oi->ip_blkno, inode->i_nlink, oi->ip_flags);
 
 	if (oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)
-		res = 1;
+		generic_delete_inode(inode);
 	else
-		res = generic_drop_inode(inode);
+		generic_drop_inode(inode);
 
 	mlog_exit_void();
-	return res;
 }
 
 /*
diff -puN fs/ocfs2/inode.h~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped
+++ a/fs/ocfs2/inode.h
@@ -124,7 +124,7 @@ static inline struct ocfs2_caching_info 
 }
 
 void ocfs2_evict_inode(struct inode *inode);
-int ocfs2_drop_inode(struct inode *inode);
+void ocfs2_drop_inode(struct inode *inode);
 
 /* Flags for ocfs2_iget() */
 #define OCFS2_FI_FLAG_SYSFILE		0x1
diff -puN include/linux/fs.h~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped include/linux/fs.h
--- a/include/linux/fs.h~revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped
+++ a/include/linux/fs.h
@@ -1559,7 +1559,7 @@ struct super_operations {
 
    	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, struct writeback_control *wbc);
-	int (*drop_inode) (struct inode *);
+	void (*drop_inode) (struct inode *);
 	void (*evict_inode) (struct inode *);
 	void (*put_super) (struct super_block *);
 	void (*write_super) (struct super_block *);
@@ -2160,8 +2160,8 @@ extern void iput(struct inode *);
 extern struct inode * igrab(struct inode *);
 extern ino_t iunique(struct super_block *, ino_t);
 extern int inode_needs_sync(struct inode *inode);
-extern int generic_delete_inode(struct inode *inode);
-extern int generic_drop_inode(struct inode *inode);
+extern void generic_delete_inode(struct inode *inode);
+extern void generic_drop_inode(struct inode *inode);
 
 extern struct inode *ilookup5_nowait(struct super_block *sb,
 		unsigned long hashval, int (*test)(struct inode *, void *),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
mm-vmap-area-cache-fix.patch
x86-numa-fix-boot-without-ram-on-node0-again-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c.patch
revert-9652e31db6d841e291531547b3f4f12b5aeb42a9.patch
revert-fdc8302019d9bc10729cd3e8d348571e833388aa.patch
revert-324d76561842e551051e2a897b958b0539f6867b.patch
revert-e92e80797e7eaaf2a9bbd586c63f7c6bd3177276.patch
revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7.patch
revert-3ab7269a6058c136795ce9417f7051a0edde60db.patch
revert-4624469822455b4accc886557f6c997ccdd59066.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-make-drop_inode-just-return-whether-inode-needs-to-be-dropped.patch
acpi-fix-bogus-preemption-logic-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
acer-wmi-fix-memory-leaks-in-wmab_execute-error-path-v2-fix.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs-fix.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
serial-mmio32-support-for-8250_earlyc-fix-fix.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
mmc-add-jz4740-mmc-driver-checkpatch-fixes.patch
mmc-add-jz4740-mmc-driver-fix.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch


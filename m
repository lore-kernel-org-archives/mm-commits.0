From: akpm@linux-foundation.org
Subject: - git-block-vs-reiser4.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:13 -0700
Message-ID: <200710212347.l9LNlD6K000649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51284 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbXJUXzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, edward@namesys.com, jens.axboe@oracle.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     git-block-vs-reiser4
has been removed from the -mm tree.  Its filename was
     git-block-vs-reiser4.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: git-block-vs-reiser4
From: Andrew Morton <akpm@linux-foundation.org>

Hope this is right.

Hope you know what you're doing ;)

Cc: Vladimir Saveliev <vs@namesys.com>
Cc: Edward Shishkin <edward@namesys.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.c   |   30 -------------
 fs/reiser4/plugin/file/file.c            |   46 ---------------------
 fs/reiser4/plugin/file/file.h            |    6 --
 fs/reiser4/plugin/file/file_conversion.c |   10 ----
 fs/reiser4/plugin/object.c               |    2 
 5 files changed, 94 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~git-block-vs-reiser4 fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~git-block-vs-reiser4
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -3678,36 +3678,6 @@ int setattr_cryptcompress(struct dentry 
 	return result;
 }
 
-/* sendfile_cryptcompress - sendfile of struct file_operations */
-ssize_t
-sendfile_cryptcompress(struct file *file, loff_t *ppos, size_t count,
-		       read_actor_t actor, void *target)
-{
-	reiser4_context *ctx;
-	ssize_t result;
-	struct inode *inode;
-	struct cryptcompress_info *info;
-
-	inode = file->f_dentry->d_inode;
-	ctx = reiser4_init_context(inode->i_sb);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-	/*
-	 * generic_file_sndfile may want to call update_atime. Grab space for
-	 * stat data update
-	 */
-	result = reiser4_grab_space(estimate_update_common(inode),
-				    BA_CAN_COMMIT);
-	if (result)
-		goto exit;
-	info = cryptcompress_inode_data(inode);
-
-	result = generic_file_sendfile(file, ppos, count, actor, target);
- exit:
-	reiser4_exit_context(ctx);
-	return result;
-}
-
 /*
  * release_cryptcompress - release of struct file_operations
  * @inode: inode of released file
diff -puN fs/reiser4/plugin/file/file.c~git-block-vs-reiser4 fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~git-block-vs-reiser4
+++ a/fs/reiser4/plugin/file/file.c
@@ -2729,52 +2729,6 @@ int delete_object_unix_file(struct inode
 	return reiser4_delete_object_common(inode);
 }
 
-/**
- * sendfile_unix_file - sendfile of struct file_operations
- * @file: file to be sent
- * @ppos: position to start from
- * @count: number of bytes to send
- * @actor: function to copy data
- * @target: where to copy read data
- *
- * Reads @count bytes from @file and calls @actor for every page read. This is
- * needed for loop back devices support.
- */
-ssize_t
-sendfile_unix_file(struct file *file, loff_t *ppos, size_t count,
-		   read_actor_t actor, void *target)
-{
-	reiser4_context *ctx;
-	ssize_t result;
-	struct inode *inode;
-	struct unix_file_info *uf_info;
-
-	inode = file->f_dentry->d_inode;
-	ctx = reiser4_init_context(inode->i_sb);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-
-	/*
-	 * generic_file_sndfile may want to call update_atime. Grab space for
-	 * stat data update
-	 */
-	result = reiser4_grab_space(estimate_update_common(inode),
-				    BA_CAN_COMMIT);
-	if (result)
-		goto error;
-	mutex_lock(&inode->i_mutex);
-	reiser4_inode_set_flag(inode, REISER4_HAS_MMAP);
-	mutex_unlock(&inode->i_mutex);
-
-	uf_info = unix_file_inode_data(inode);
-	get_nonexclusive_access(uf_info);
-	result = generic_file_sendfile(file, ppos, count, actor, target);
-	drop_nonexclusive_access(uf_info);
- error:
-	reiser4_exit_context(ctx);
-	return result;
-}
-
 int
 prepare_write_unix_file(struct file *file, struct page *page,
 			unsigned from, unsigned to)
diff -puN fs/reiser4/plugin/file/file.h~git-block-vs-reiser4 fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~git-block-vs-reiser4
+++ a/fs/reiser4/plugin/file/file.h
@@ -24,8 +24,6 @@ int mmap_unix_file(struct file *, struct
 int open_unix_file(struct inode *, struct file *);
 int release_unix_file(struct inode *, struct file *);
 int sync_unix_file(struct file *, struct dentry *, int datasync);
-ssize_t sendfile_unix_file(struct file *, loff_t *ppos, size_t count,
-			   read_actor_t, void *target);
 
 /* address space operations */
 int readpage_unix_file(struct file *, struct page *);
@@ -209,10 +207,6 @@ ssize_t prot_write_cryptcompress(struct 
 				 loff_t * off);
 int mmap_cryptcompress(struct file *, struct vm_area_struct *);
 int prot_mmap_cryptcompress(struct file *, struct vm_area_struct *);
-ssize_t sendfile_cryptcompress(struct file *file, loff_t *ppos, size_t count,
-			       read_actor_t actor, void *target);
-ssize_t prot_sendfile_cryptcompress(struct file *file, loff_t *ppos, size_t count,
-				    read_actor_t actor, void *target);
 
 int release_cryptcompress(struct inode *, struct file *);
 int prot_release_cryptcompress(struct inode *, struct file *);
diff -puN fs/reiser4/plugin/file/file_conversion.c~git-block-vs-reiser4 fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~git-block-vs-reiser4
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -552,7 +552,6 @@ int prot_setattr_cryptcompress(struct de
    . read_cryptcomperess;
    . mmap_cryptcompress;
    . release_cryptcompress;
-   . sendfile_cryptcompress;
    . delete_object_cryptcompress.
 */
 ssize_t prot_read_cryptcompress(struct file * file, char __user * buf,
@@ -573,15 +572,6 @@ int prot_release_cryptcompress(struct in
 	return PROT_PASSIVE(int, release, (inode, file));
 }
 
-ssize_t prot_sendfile_cryptcompress(struct file *file, loff_t *ppos,
-				    size_t count, read_actor_t actor,
-				    void *target)
-{
-	struct inode * inode = file->f_dentry->d_inode;
-	return PROT_PASSIVE(ssize_t, sendfile,
-			    (file, ppos, count, actor, target));
-}
-
 /*
   Local variables:
   c-indentation-style: "K&R"
diff -puN fs/reiser4/plugin/object.c~git-block-vs-reiser4 fs/reiser4/plugin/object.c
--- a/fs/reiser4/plugin/object.c~git-block-vs-reiser4
+++ a/fs/reiser4/plugin/object.c
@@ -114,7 +114,6 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.open = open_unix_file,
 			.release = release_unix_file,
 			.fsync = sync_unix_file,
-			.sendfile = sendfile_unix_file
 		},
 		.as_ops = {
 			.writepage = reiser4_writepage,
@@ -321,7 +320,6 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.mmap = prot_mmap_cryptcompress,
 			.release = prot_release_cryptcompress,
 			.fsync = reiser4_sync_common,
-			.sendfile = prot_sendfile_cryptcompress
 		},
 		.as_ops = {
 			.writepage = reiser4_writepage,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
capabilities-clean-up-file-capability-reading.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
kexec-add-bss-to-resource-tree.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
fix-x86_64-mm-sched-clock-share.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch

From: akpm@linux-foundation.org
Subject: - git-block-fixup.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:05:44 -0700
Message-ID: <200710180705.l9I75iha031673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57548 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760067AbXJRHPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     git-block-fixup
has been removed from the -mm tree.  Its filename was
     git-block-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-block-fixup
From: Andrew Morton <akpm@linux-foundation.org>

fix git rejects...

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |  215 --------------------------------------------------
 1 file changed, 215 deletions(-)

diff -puN fs/splice.c~git-block-fixup fs/splice.c
--- a/fs/splice.c~git-block-fixup
+++ a/fs/splice.c
@@ -1208,218 +1208,6 @@ static int copy_from_user_mmap_sem(void 
 }
 
 /*
- * Just copy the data to user space
- */
-static int pipe_to_user_copy(struct pipe_inode_info *pipe,
-			     struct pipe_buffer *buf, struct splice_desc *sd)
-{
-	char *src;
-	int ret;
-
-	ret = buf->ops->confirm(pipe, buf);
-	if (unlikely(ret))
-		return ret;
-
-	/*
-	 * See if we can use the atomic maps, by prefaulting in the
-	 * pages and doing an atomic copy
-	 */
-	if (!fault_in_pages_writeable(sd->u.userptr, sd->len)) {
-		src = buf->ops->map(pipe, buf, 1);
-		ret = __copy_to_user_inatomic(sd->u.userptr, src + buf->offset,
-							sd->len);
-		buf->ops->unmap(pipe, buf, src);
-		if (!ret) {
-			ret = sd->len;
-			goto out;
-		}
-	}
-
-	/*
-	 * No dice, use slow non-atomic map and copy
-	 */
-	src = buf->ops->map(pipe, buf, 0);
-
-	ret = sd->len;
-	if (copy_to_user(sd->u.userptr, src + buf->offset, sd->len))
-		ret = -EFAULT;
-
-	buf->ops->unmap(pipe, buf, src);
-out:
-	if (ret > 0)
-		sd->u.userptr += ret;
-	return ret;
-}
-
-/*
- * This actor doesn't really do anything interesting, it merely settles
- * the pipe page and adds it to the work list for insertion when the entire
- * pipe has been processed.
- */
-static int pipe_to_user_map(struct pipe_inode_info *pipe,
-			    struct pipe_buffer *buf, struct splice_desc *sd)
-{
-	struct splice_pipe_desc *spd = sd->u.data;
-	int error;
-
-	if (buf->len & ~PAGE_MASK)
-		return -EINVAL;
-
-	error = buf->ops->confirm(pipe, buf);
-	if (!error) {
-		spd->pages[spd->nr_pages++] = buf->page;
-		return buf->len;
-	}
-
-	return error;
-}
-
-/*
- * Setup a vma for this address range, and let pipe_to_user_map() insert
- * pages into that.
- */
-static int vmsplice_pipe_map(struct pipe_inode_info *pipe,
-			     struct splice_desc *sd)
-{
-	struct mm_struct *mm = current->mm;
-	struct page *pages[PIPE_BUFFERS];
-	struct splice_pipe_desc spd = {
-		.pages = pages,
-	};
-	struct vm_area_struct *vma;
-	unsigned long addr;
-	int ret, i, err;
-
-	if (sd->total_len & ~PAGE_MASK)
-		return -EINVAL;
-
-	/*
-	 * Run through the pipe buffers and settle the contents. The number
-	 * of processed pages will be put in spd.nr_pages.
-	 */
-	addr = (unsigned long) sd->u.userptr;
-	sd->pos = 0;
-	sd->u.data = &spd;
-	err = __splice_from_pipe(pipe, sd, pipe_to_user_map);
-	if (unlikely(err <= 0))
-		return err;
-	else if (unlikely(!spd.nr_pages))
-		return 0;
-
-	/*
-	 * We have a non-zero number of pages available. Now find the
-	 * associated vma so we can establish pages mappings there.
-	 */
-	ret = -EINVAL;
-	down_read(&mm->mmap_sem);
-
-	vma = find_vma(mm, addr);
-	if (unlikely(!vma))
-		goto out;
-
-	for (i = ret = err = 0; i < spd.nr_pages; i++) {
-		err = vm_insert_page(vma, addr, spd.pages[i]);
-		if (unlikely(err))
-			break;
-
-		addr += PAGE_SIZE;
-		ret += PAGE_SIZE;
-	}
-
-out:
-	up_read(&mm->mmap_sem);
-
-	if (err && !ret)
-		ret = err;
-
-	return ret;
-}
-
-/*
- * vmsplice a pipe to user memory. If SPLICE_F_MOVE is set, we will attempt
- * to move the pipe pages to the user address space. Otherwise a simple
- * copy is done.
- */
-static long vmsplice_to_user(struct file *file, const struct iovec __user *iov,
-			     unsigned long nr_segs, unsigned int flags)
-{
-	struct pipe_inode_info *pipe;
-	struct splice_desc sd;
-	long spliced, ret;
-
-	pipe = pipe_info(file->f_path.dentry->d_inode);
-	if (!pipe)
-		return -EBADF;
-
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
-
-	spliced = ret = 0;
-	while (nr_segs) {
-		void __user *base;
-		size_t len;
-
-		/*
-		 * Get user address base and length for this iovec.
-		 */
-		ret = get_user(base, &iov->iov_base);
-		if (unlikely(ret))
-			break;
-		ret = get_user(len, &iov->iov_len);
-		if (unlikely(ret))
-			break;
-
-		/*
-		 * Sanity check this iovec. 0 read succeeds.
-		 */
-		if (unlikely(!len))
-			break;
-		if (unlikely(!base)) {
-			ret = -EFAULT;
-			break;
-		}
-
-		sd.len = 0;
-		sd.total_len = len;
-		sd.flags = flags;
-		sd.u.userptr = base;
-		sd.pos = 0;
-
-		/*
-		 * SPLICE_F_MOVE is set, don't copy the data but attempt
-		 * to map it into the app address space.
-		 */
-		if (flags & SPLICE_F_MOVE)
-			ret = vmsplice_pipe_map(pipe, &sd);
-		else
-			ret = __splice_from_pipe(pipe, &sd, pipe_to_user_copy);
-
-		if (ret < 0)
-			break;
-
-		spliced += ret;
-
-		/*
-		 * If we transferred less than a pipe buffer length, break
-		 * out of the loop and let the caller retry.
-		 */
-		if (ret < len)
-			break;
-
-		nr_segs--;
-		iov++;
-	}
-
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
-
-	if (!spliced)
-		spliced = ret;
-
-	return spliced;
-}
-
-/*
  * Map an iov into an array of pages and offset/length tupples. With the
  * partial_page structure, we can map several non-contiguous ranges into
  * our ones pages[] map instead of splitting that operation into pieces.
@@ -1525,7 +1313,6 @@ static int get_iovec_page_array(const st
 	return error;
 }
 
-<<<<<<< HEAD:fs/splice.c
 static int pipe_to_user(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 			struct splice_desc *sd)
 {
@@ -1644,8 +1431,6 @@ static long vmsplice_to_user(struct file
 	return ret;
 }
 
-=======
->>>>>>> FETCH_HEAD:fs/splice.c
 /*
  * vmsplice splices a user address range into a pipe. It can be thought of
  * as splice-from-memory, where the regular splice is splice-from-file (or
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-add-reboot-mechanism.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cifs.patch
console-keyboard-events-and-accessibility.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
qla2xxx-printk-fixes.patch
advansys-depends-on-virt_to_bus.patch
sparc-support-for-new-termios.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-nfs-vs-git-unionfs.patch
git-watchdog-fixup.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-checkpatch-fixes.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2-fix-3.patch
console-events-and-accessibility-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
stop-using-dma_xxbit_mask.patch
stop-using-dma_xxbit_mask-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
reiserfs-fix-up-lockdep-warnings-checkpatch-fixes.patch
reiserfs-use-is_reusable-to-catch-corruption-checkpatch-fixes.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch
reiserfs-remove-first_zero_hint-checkpatch-fixes.patch
reiserfs-ignore-on-disk-s_bmap_nr-value-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
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
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
i-oat-tighten-descriptor-setup-performance-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch
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

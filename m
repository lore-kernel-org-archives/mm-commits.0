From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 02 Jul 2013 12:29:51 -0700
Message-ID: <51d32a2f.3y1F3VaKft33dMp7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3GBT3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jul 2013 15:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 02 Jul 2013 12:29:51 -0700


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_vm.c |    4 ----
 fs/ecryptfs/file.c       |   16 ----------------
 fs/minix/dir.c           |    4 ----
 fs/ncpfs/dir.c           |    5 -----
 fs/proc/base.c           |   27 ---------------------------
 fs/proc/namespaces.c     |    4 ----
 6 files changed, 60 deletions(-)

diff -puN drivers/gpu/drm/drm_vm.c~linux-next-git-rejects drivers/gpu/drm/drm_vm.c
--- a/drivers/gpu/drm/drm_vm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/drm_vm.c
@@ -613,11 +613,7 @@ int drm_mmap_locked(struct file *filp, s
 	case _DRM_FRAME_BUFFER:
 	case _DRM_REGISTERS:
 		offset = drm_core_get_reg_ofs(dev);
-<<<<<<< HEAD
-		vma->vm_page_prot = drm_io_prot(map->type, vma);
-=======
 		vma->vm_page_prot = drm_io_prot(map, vma);
->>>>>>> linux-next/akpm-base
 		if (io_remap_pfn_range(vma, vma->vm_start,
 				       (map->offset + offset) >> PAGE_SHIFT,
 				       vma->vm_end - vma->vm_start,
diff -puN fs/ecryptfs/file.c~linux-next-git-rejects fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~linux-next-git-rejects
+++ a/fs/ecryptfs/file.c
@@ -70,11 +70,7 @@ static ssize_t ecryptfs_read_update_atim
 struct ecryptfs_getdents_callback {
 	struct dir_context ctx;
 	struct dir_context *caller;
-<<<<<<< HEAD
-	struct dentry *dentry;
-=======
 	struct super_block *sb;
->>>>>>> linux-next/akpm-base
 	int filldir_called;
 	int entries_written;
 };
@@ -118,17 +114,6 @@ static int ecryptfs_readdir(struct file
 {
 	int rc;
 	struct file *lower_file;
-<<<<<<< HEAD
-	struct inode *inode;
-	struct ecryptfs_getdents_callback buf = {
-		.ctx.actor = ecryptfs_filldir,
-		.caller = ctx,
-		.dentry = file->f_path.dentry
-	};
-	lower_file = ecryptfs_file_to_lower(file);
-	lower_file->f_pos = ctx->pos;
-	inode = file_inode(file);
-=======
 	struct inode *inode = file_inode(file);
 	struct ecryptfs_getdents_callback buf = {
 		.ctx.actor = ecryptfs_filldir,
@@ -137,7 +122,6 @@ static int ecryptfs_readdir(struct file
 	};
 	lower_file = ecryptfs_file_to_lower(file);
 	lower_file->f_pos = ctx->pos;
->>>>>>> linux-next/akpm-base
 	rc = iterate_dir(lower_file, &buf.ctx);
 	ctx->pos = buf.ctx.pos;
 	if (rc < 0)
diff -puN fs/minix/dir.c~linux-next-git-rejects fs/minix/dir.c
--- a/fs/minix/dir.c~linux-next-git-rejects
+++ a/fs/minix/dir.c
@@ -93,11 +93,7 @@ static int minix_readdir(struct file *fi
 	unsigned offset;
 	unsigned long n;
 
-<<<<<<< HEAD
-	ctx->pos = pos = (pos + chunk_size-1) & ~(chunk_size-1);
-=======
 	ctx->pos = pos = ALIGN(pos, chunk_size);
->>>>>>> linux-next/akpm-base
 	if (pos >= inode->i_size)
 		return 0;
 
diff -puN fs/ncpfs/dir.c~linux-next-git-rejects fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c~linux-next-git-rejects
+++ a/fs/ncpfs/dir.c
@@ -675,11 +675,6 @@ end_advance:
 	if (!valid)
 		ctl.valid = 0;
 	if (!ctl.filled && (ctl.fpos == ctx->pos)) {
-<<<<<<< HEAD
-		if (!ino)
-			ino = find_inode_number(dentry, &qname);
-=======
->>>>>>> linux-next/akpm-base
 		if (!ino)
 			ino = iunique(dir->i_sb, 2);
 		ctl.filled = !dir_emit(ctx, qname.name, qname.len,
diff -puN fs/proc/base.c~linux-next-git-rejects fs/proc/base.c
--- a/fs/proc/base.c~linux-next-git-rejects
+++ a/fs/proc/base.c
@@ -1686,10 +1686,7 @@ bool proc_fill_cache(struct file *file,
 	instantiate_t instantiate, struct task_struct *task, const void *ptr)
 {
 	struct dentry *child, *dir = file->f_path.dentry;
-<<<<<<< HEAD
-=======
 	struct qstr qname = QSTR_INIT(name, len);
->>>>>>> linux-next/akpm-base
 	struct inode *inode;
 	unsigned type;
 	ino_t ino;
@@ -1711,15 +1708,7 @@ bool proc_fill_cache(struct file *file,
 	return dir_emit(ctx, name, len, ino, type);
 
 end_instantiate:
-<<<<<<< HEAD
-	if (!ino)
-		ino = find_inode_number(dir, &qname);
-	if (!ino)
-		ino = 1;
-	return dir_emit(ctx, name, len, ino, type);
-=======
 	return dir_emit(ctx, name, len, 1, DT_UNKNOWN);
->>>>>>> linux-next/akpm-base
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
@@ -2195,11 +2184,7 @@ static struct dentry *proc_pident_lookup
 out:
 	put_task_struct(task);
 out_no_task:
-<<<<<<< HEAD
-	return error;
-=======
 	return ERR_PTR(error);
->>>>>>> linux-next/akpm-base
 }
 
 static int proc_pident_readdir(struct file *file, struct dir_context *ctx,
@@ -2885,33 +2870,21 @@ retry:
 int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct tgid_iter iter;
-<<<<<<< HEAD
-	struct pid_namespace *ns;
-=======
 	struct pid_namespace *ns = file->f_dentry->d_sb->s_fs_info;
->>>>>>> linux-next/akpm-base
 	loff_t pos = ctx->pos;
 
 	if (pos >= PID_MAX_LIMIT + TGID_OFFSET)
 		return 0;
 
 	if (pos == TGID_OFFSET - 1) {
-<<<<<<< HEAD
-		if (!proc_fill_cache(file, ctx, "self", 4, NULL, NULL, NULL))
-=======
 		struct inode *inode = ns->proc_self->d_inode;
 		if (!dir_emit(ctx, "self", 4, inode->i_ino, DT_LNK))
->>>>>>> linux-next/akpm-base
 			return 0;
 		iter.tgid = 0;
 	} else {
 		iter.tgid = pos - TGID_OFFSET;
 	}
 	iter.task = NULL;
-<<<<<<< HEAD
-	ns = file->f_dentry->d_sb->s_fs_info;
-=======
->>>>>>> linux-next/akpm-base
 	for (iter = next_tgid(ns, iter);
 	     iter.task;
 	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
diff -puN fs/proc/namespaces.c~linux-next-git-rejects fs/proc/namespaces.c
--- a/fs/proc/namespaces.c~linux-next-git-rejects
+++ a/fs/proc/namespaces.c
@@ -209,11 +209,7 @@ static int proc_ns_instantiate(struct in
 	if (pid_revalidate(dentry, 0))
 		return 0;
 out:
-<<<<<<< HEAD
-	return error;
-=======
 	return -ENOENT;
->>>>>>> linux-next/akpm-base
 }
 
 static int proc_ns_dir_readdir(struct file *file, struct dir_context *ctx)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-fix-possible-sleep-in-invalid-context-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
ocfs2-xattr-remove-useless-free-space-checking-fix.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix.patch
ocfs2-adjust-switch_case-syntax-at-o2net_state_change-fix.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix-fix-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch
include-linux-mmzoneh-cleanups.patch
drop_caches-add-some-documentation-and-info-messsge.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


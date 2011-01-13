From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 13 Jan 2011 11:54:32 -0800
Message-ID: <201101131957.p0DJvC23029233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616Ab1AMT5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 14:57:22 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p0DJvD3D031863
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 13 Jan 2011 11:57:13 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/main.c |   46 -------------------------------------------
 include/linux/fs.h |    3 --
 2 files changed, 49 deletions(-)

diff -puN fs/ecryptfs/main.c~linux-next-git-rejects fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~linux-next-git-rejects
+++ a/fs/ecryptfs/main.c
@@ -501,52 +501,6 @@ struct kmem_cache *ecryptfs_sb_info_cach
 static struct file_system_type ecryptfs_fs_type;
 
 /**
-<<<<<<< HEAD
-=======
- * ecryptfs_read_super
- * @sb: The ecryptfs super block
- * @dev_name: The path to mount over
- *
- * Read the super block of the lower filesystem, and use
- * ecryptfs_interpose to create our initial inode and super block
- * struct.
- */
-static int ecryptfs_read_super(struct super_block *sb, const char *dev_name)
-{
-	struct path path;
-	int rc;
-
-	rc = kern_path(dev_name, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path);
-	if (rc) {
-		ecryptfs_printk(KERN_WARNING, "path_lookup() failed\n");
-		goto out;
-	}
-	if (path.dentry->d_sb->s_type == &ecryptfs_fs_type) {
-		rc = -EINVAL;
-		printk(KERN_ERR "Mount on filesystem of type "
-			"eCryptfs explicitly disallowed due to "
-			"known incompatibilities\n");
-		goto out_free;
-	}
-	ecryptfs_set_superblock_lower(sb, path.dentry->d_sb);
-	sb->s_maxbytes = path.dentry->d_sb->s_maxbytes;
-	sb->s_blocksize = path.dentry->d_sb->s_blocksize;
-	sb->s_magic = ECRYPTFS_SUPER_MAGIC;
-	ecryptfs_set_dentry_lower(sb->s_root, path.dentry);
-	ecryptfs_set_dentry_lower_mnt(sb->s_root, path.mnt);
-	rc = ecryptfs_interpose(path.dentry, sb->s_root, sb, 0);
-	if (rc)
-		goto out_free;
-	rc = 0;
-	goto out;
-out_free:
-	path_put(&path);
-out:
-	return rc;
-}
-
-/**
->>>>>>> FETCH_HEAD
  * ecryptfs_get_sb
  * @fs_type
  * @flags
diff -puN include/linux/fs.h~linux-next-git-rejects include/linux/fs.h
--- a/include/linux/fs.h~linux-next-git-rejects
+++ a/include/linux/fs.h
@@ -1423,15 +1423,12 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char __rcu *s_options;
-<<<<<<< HEAD
 	const struct dentry_operations *s_d_op; /* default d_op for dentries */
-=======
 
 	/*
 	 * Saved pool identifier for cleancache (-1 means none)
 	 */
 	int cleancache_poolid;
->>>>>>> FETCH_HEAD
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-kvm-mmu-transparent-hugepage-support-bisection.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk-fix.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-fix.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


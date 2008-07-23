From: akpm@linux-foundation.org
Subject: - fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 15:56:55 -0700
Message-ID: <200807232309.m6NN9Wdg016751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbYGWXJ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:09:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bfields@fieldses.org, dgc@sgi.com, k-makita@np.css.fujitsu.com, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix
has been removed from the -mm tree.  Its filename was
     fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch

This patch was dropped because it was folded into fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix
From: Andrew Morton <akpm@linux-foundation.org>

- fix comments.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Chinner <dgc@sgi.com>
Cc: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c        |   39 +++++++++++++++++----------------------
 include/linux/fs.h |    1 +
 2 files changed, 18 insertions(+), 22 deletions(-)

diff -puN fs/dcache.c~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix fs/dcache.c
--- a/fs/dcache.c~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix
+++ a/fs/dcache.c
@@ -122,8 +122,7 @@ static void dentry_iput(struct dentry * 
 }
 
 /*
- * Following dentry_lru_(add|add_tail|del|del_init) is must
- * called with dcache_lock held.
+ * dentry_lru_(add|add_tail|del|del_init) must be called with dcache_lock held.
  */
 static void dentry_lru_add(struct dentry *dentry)
 {
@@ -248,7 +247,7 @@ repeat:
 unhash_it:
 	__d_drop(dentry);
 kill_it:
-	/* if dentry was on d_lru list delete it from there */
+	/* if dentry was on the d_lru list delete it from there */
 	dentry_lru_del(dentry);
 	dentry = d_kill(dentry);
 	if (dentry)
@@ -471,11 +470,11 @@ restart:
 			BUG_ON(dentry->d_sb != sb);
 
 			spin_lock(&dentry->d_lock);
-		/*
-		 * If we are honouring the DCACHE_REFERENCED flag and the
-		 * dentry has this flag set, don't free it. Clear the flag
-		 * and put it back on the LRU
-		 */
+			/*
+			 * If we are honouring the DCACHE_REFERENCED flag and
+			 * the dentry has this flag set, don't free it. Clear
+			 * the flag and put it back on the LRU.
+			 */
 			if ((flags & DCACHE_REFERENCED)
 				&& (dentry->d_flags & DCACHE_REFERENCED)) {
 				dentry->d_flags &= ~DCACHE_REFERENCED;
@@ -504,10 +503,10 @@ restart:
 			continue;
 		}
 		prune_one_dentry(dentry);
-		/* dentry->d_lock is dropped in prune_one_dentry() */
+		/* dentry->d_lock was dropped in prune_one_dentry() */
 		cond_resched_lock(&dcache_lock);
 	}
-	if ((count == NULL) && (!list_empty(&sb->s_dentry_lru)))
+	if (count == NULL && !list_empty(&sb->s_dentry_lru))
 		goto restart;
 	if (count != NULL)
 		*count = cnt;
@@ -518,17 +517,13 @@ restart:
 
 /**
  * prune_dcache - shrink the dcache
- * @count: number of entries to try and free
+ * @count: number of entries to try to free
  *
- * Shrink the dcache. This is done when we need
- * more memory, or simply when we need to unmount
- * something (at which point we need to unuse
- * all dentries).
+ * Shrink the dcache. This is done when we need more memory, or simply when we
+ * need to unmount something (at which point we need to unuse all dentries).
  *
- * This function may fail to free any resources if
- * all the dentries are in use.
+ * This function may fail to free any resources if all the dentries are in use.
  */
- 
 static void prune_dcache(int count)
 {
 	struct super_block *sb;
@@ -551,10 +546,10 @@ restart:
 			continue;
 		sb->s_count++;
 		/* Now, we reclaim unused dentrins with fairness.
-		 * we reclaim them same percentage on each superblocks.
-		 * we calculate number of dentries to scan on this sb
-		 * based on following way, but impelementation is arranged
-		 * to avoid overflow.
+		 * We reclaim them same percentage from each superblock.
+		 * We calculate number of dentries to scan on this sb
+		 * as follows, but the implementation is arranged to avoid
+		 * overflows:
 		 * number of dentries to scan on this sb =
 		 * count * (number of dentries on this sb /
 		 * number of dentries in the machine)
diff -puN include/linux/fs.h~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix include/linux/fs.h
--- a/include/linux/fs.h~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix
+++ a/include/linux/fs.h
@@ -1067,6 +1067,7 @@ struct super_block {
 	struct list_head	s_more_io;	/* parked for more writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
+	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
kill-generic_file_direct_io.patch
use-generic_access_phys-for-dev-mem-mappings.patch
spufs-use-the-new-vm_ops-access.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
vma-page-offset-has-no-callees-drop-it.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
vmallocinfo-add-numa-information-fix.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlb-override-default-huge-page-size-non-const-fix-fix.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-debugging-framework-fix.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-arm-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mips-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-dvb.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mtd-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core-checkpatch-fixes.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts-fix.patch
rtc-cmos-improve-hpet-irq-glue-build-fix.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size-fix.patch
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch


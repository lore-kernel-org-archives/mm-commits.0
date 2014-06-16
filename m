From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Mon, 16 Jun 2014 12:07:49 -0700
Message-ID: <539f4085.wk+PrxhjB7xX970+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbaFPTHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 15:07:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Jun 2014 12:07:49 -0700


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile        |    6 ++-
 fs/ocfs2/file.c |   79 ----------------------------------------------
 2 files changed, 4 insertions(+), 81 deletions(-)

diff -puN Makefile~linux-next-rejects Makefile
--- a/Makefile~linux-next-rejects
+++ a/Makefile
@@ -621,6 +621,10 @@ endif # $(dot-config)
 # Defaults to vmlinux, but the arch makefile usually adds further targets
 all: vmlinux
 
+include $(srctree)/arch/$(SRCARCH)/Makefile
+
+KBUILD_CFLAGS	+= $(call cc-option,-fno-delete-null-pointer-checks,)
+
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
 KBUILD_CFLAGS	+= -Os $(call cc-disable-warning,maybe-uninitialized,)
 else
@@ -630,8 +634,6 @@ endif
 # Tell gcc to never replace conditional load with a non-conditional one
 KBUILD_CFLAGS	+= $(call cc-option,--param allow-store-data-races=0)
 
-include $(srctree)/arch/$(SRCARCH)/Makefile
-
 ifdef CONFIG_READABLE_ASM
 # Disable optimizations that make assembler listings hard to read.
 # reorder blocks reorders the control in the function
diff -puN fs/ocfs2/file.c~linux-next-rejects fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~linux-next-rejects
+++ a/fs/ocfs2/file.c
@@ -2446,85 +2446,6 @@ out_sems:
 	return ret;
 }
 
-static int ocfs2_splice_to_file(struct pipe_inode_info *pipe,
-				struct file *out,
-				struct splice_desc *sd)
-{
-	int ret;
-
-	ret = ocfs2_prepare_inode_for_write(out, &sd->pos,
-					    sd->total_len, 0, NULL, NULL,
-					    NULL);
-	if (ret < 0) {
-		mlog_errno(ret);
-		return ret;
-	}
-
-	return splice_from_pipe_feed(pipe, sd, pipe_to_file);
-}
-
-static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
-				       struct file *out,
-				       loff_t *ppos,
-				       size_t len,
-				       unsigned int flags)
-{
-	int ret;
-	struct address_space *mapping = out->f_mapping;
-	struct inode *inode = mapping->host;
-	struct splice_desc sd = {
-		.total_len = len,
-		.flags = flags,
-		.pos = *ppos,
-		.u.file = out,
-	};
-
-
-	trace_ocfs2_file_splice_write(inode, out, out->f_path.dentry,
-			(unsigned long long)OCFS2_I(inode)->ip_blkno,
-			out->f_path.dentry->d_name.len,
-			out->f_path.dentry->d_name.name, len);
-
-	pipe_lock(pipe);
-
-	splice_from_pipe_begin(&sd);
-	do {
-		ret = splice_from_pipe_next(pipe, &sd);
-		if (ret <= 0)
-			break;
-
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
-		ret = ocfs2_rw_lock(inode, 1);
-		if (ret < 0)
-			mlog_errno(ret);
-		else {
-			ret = ocfs2_splice_to_file(pipe, out, &sd);
-			ocfs2_rw_unlock(inode, 1);
-		}
-		mutex_unlock(&inode->i_mutex);
-	} while (ret > 0);
-	splice_from_pipe_end(pipe, &sd);
-
-	pipe_unlock(pipe);
-
-	if (sd.num_spliced)
-		ret = sd.num_spliced;
-
-	if (ret > 0) {
-		int err;
-
-		err = generic_write_sync(out, *ppos, ret);
-		if (err)
-			ret = err;
-		else
-			*ppos += ret;
-
-		balance_dirty_pages_ratelimited(mapping);
-	}
-
-	return ret;
-}
-
 static ssize_t ocfs2_file_splice_read(struct file *in,
 				      loff_t *ppos,
 				      struct pipe_inode_info *pipe,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch
madvise-cleanup-swapin_walk_pmd_entry-fix.patch
memcg-separate-mem_cgroup_move_charge_pte_range-checkpatch-fixes.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code-checkpatch-fixes.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


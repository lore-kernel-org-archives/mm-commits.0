From: akpm@linux-foundation.org
Subject: - tmpfs-support-aio.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:22:45 -0700
Message-ID: <200807242322.m6ONMjI9010587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754782AbYGXXYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, hans-christoph.rohland@sap.com, leg@google.com, pbadari@us.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: support aio
has been removed from the -mm tree.  Its filename was
     tmpfs-support-aio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: support aio
From: Hugh Dickins <hugh@veritas.com>

We have a request for tmpfs to support the AIO interface: easily done, no
more than replacing the old shmem_file_read by shmem_file_aio_read,
cribbed from generic_file_aio_read.  (In 2.6.25 its write side was already
changed to use generic_file_aio_write.)

Incorporate cleanups from Andrew Morton and Harvey Harrison.

Tests out fine with LTP's ltp-aiodio.sh, given hacks (not included) to
support O_DIRECT.  tmpfs cannot honestly support O_DIRECT: its
cache-avoiding-IO nature is at odds with direct IO-avoiding-cache.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Tested-by: Lawrence Greenfield <leg@google.com>
Cc: Christoph Rohland <hans-christoph.rohland@sap.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   53 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff -puN mm/shmem.c~tmpfs-support-aio mm/shmem.c
--- a/mm/shmem.c~tmpfs-support-aio
+++ a/mm/shmem.c
@@ -1690,26 +1690,38 @@ static void do_shmem_file_read(struct fi
 	file_accessed(filp);
 }
 
-static ssize_t shmem_file_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
+static ssize_t shmem_file_aio_read(struct kiocb *iocb,
+		const struct iovec *iov, unsigned long nr_segs, loff_t pos)
 {
-	read_descriptor_t desc;
-
-	if ((ssize_t) count < 0)
-		return -EINVAL;
-	if (!access_ok(VERIFY_WRITE, buf, count))
-		return -EFAULT;
-	if (!count)
-		return 0;
-
-	desc.written = 0;
-	desc.count = count;
-	desc.arg.buf = buf;
-	desc.error = 0;
-
-	do_shmem_file_read(filp, ppos, &desc, file_read_actor);
-	if (desc.written)
-		return desc.written;
-	return desc.error;
+	struct file *filp = iocb->ki_filp;
+	ssize_t retval;
+	unsigned long seg;
+	size_t count;
+	loff_t *ppos = &iocb->ki_pos;
+
+	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
+	if (retval)
+		return retval;
+
+	for (seg = 0; seg < nr_segs; seg++) {
+		read_descriptor_t desc;
+
+		desc.written = 0;
+		desc.arg.buf = iov[seg].iov_base;
+		desc.count = iov[seg].iov_len;
+		if (desc.count == 0)
+			continue;
+		desc.error = 0;
+		do_shmem_file_read(filp, ppos, &desc, file_read_actor);
+		retval += desc.written;
+		if (desc.error) {
+			retval = retval ?: desc.error;
+			break;
+		}
+		if (desc.count > 0)
+			break;
+	}
+	return retval;
 }
 
 static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -2369,8 +2381,9 @@ static const struct file_operations shme
 	.mmap		= shmem_mmap,
 #ifdef CONFIG_TMPFS
 	.llseek		= generic_file_llseek,
-	.read		= shmem_file_read,
+	.read		= do_sync_read,
 	.write		= do_sync_write,
+	.aio_read	= shmem_file_aio_read,
 	.aio_write	= generic_file_aio_write,
 	.fsync		= simple_sync_file,
 	.splice_read	= generic_file_splice_read,
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
ahci-use-correct-type-for-cpu-flags.patch
git-unionfs.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
exec-remove-some-includes.patch
exec-remove-some-includes-fix.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
x86-implement-pte_special-fix.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
mmapc-deinline-a-few-functions.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
prio_tree-debugging-patch.patch


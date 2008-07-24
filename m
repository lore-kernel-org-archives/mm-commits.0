From: akpm@linux-foundation.org
Subject: - generic_file_aio_read-cleanups.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:22:42 -0700
Message-ID: <200807242322.m6ONMgnB010584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756427AbYGXXdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, hans-christoph.rohland@sap.com, leg@google.com, nickpiggin@yahoo.com.au, pbadari@us.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     generic_file_aio_read() cleanups
has been removed from the -mm tree.  Its filename was
     generic_file_aio_read-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic_file_aio_read() cleanups
From: Hugh Dickins <hugh@veritas.com>

As akpm points out, there's really no need for generic_file_aio_read to
make a special case of count 0: just loop through nr_segs doing nothing. 
And as Harvey Harrison points out, there's no need to reset retval to 0
where it's already 0.

Setting count (or ocount) to 0 before calling generic_segment_checks is
unnecessary too; but reluctantly I'll leave that removal to someone with a
wider range of gcc versions to hand - 4.1.2 and 4.2.1 don't warn about it,
but perhaps others do - I forget which are the warniest versions.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Tested-by: Lawrence Greenfield <leg@google.com>
Cc: Christoph Rohland <hans-christoph.rohland@sap.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff -puN mm/filemap.c~generic_file_aio_read-cleanups mm/filemap.c
--- a/mm/filemap.c~generic_file_aio_read-cleanups
+++ a/mm/filemap.c
@@ -1197,7 +1197,6 @@ generic_file_aio_read(struct kiocb *iocb
 
 		mapping = filp->f_mapping;
 		inode = mapping->host;
-		retval = 0;
 		if (!count)
 			goto out; /* skip atime */
 		size = i_size_read(inode);
@@ -1209,33 +1208,30 @@ generic_file_aio_read(struct kiocb *iocb
 			}
 			if (retval > 0)
 				*ppos = pos + retval;
-		}
-		if (likely(retval != 0)) {
-			file_accessed(filp);
-			goto out;
+			if (retval) {
+				file_accessed(filp);
+				goto out;
+			}
 		}
 	}
 
-	retval = 0;
-	if (count) {
-		for (seg = 0; seg < nr_segs; seg++) {
-			read_descriptor_t desc;
-
-			desc.written = 0;
-			desc.arg.buf = iov[seg].iov_base;
-			desc.count = iov[seg].iov_len;
-			if (desc.count == 0)
-				continue;
-			desc.error = 0;
-			do_generic_file_read(filp,ppos,&desc,file_read_actor);
-			retval += desc.written;
-			if (desc.error) {
-				retval = retval ?: desc.error;
-				break;
-			}
-			if (desc.count > 0)
-				break;
+	for (seg = 0; seg < nr_segs; seg++) {
+		read_descriptor_t desc;
+
+		desc.written = 0;
+		desc.arg.buf = iov[seg].iov_base;
+		desc.count = iov[seg].iov_len;
+		if (desc.count == 0)
+			continue;
+		desc.error = 0;
+		do_generic_file_read(filp, ppos, &desc, file_read_actor);
+		retval += desc.written;
+		if (desc.error) {
+			retval = retval ?: desc.error;
+			break;
 		}
+		if (desc.count > 0)
+			break;
 	}
 out:
 	return retval;
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


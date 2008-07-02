From: akpm@linux-foundation.org
Subject: + fsstack-fsstack_copy_inode_size-locking.patch added to -mm tree
Date: Tue, 01 Jul 2008 17:03:55 -0700
Message-ID: <200807020003.m6203tfT021788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202AbYGBAFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 20:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, ezk@cs.sunysb.edu, hch@lst.de, hooanon05@yahoo.co.jp, mhalcrow@us.ibm.com


The patch titled
     fsstack: fsstack_copy_inode_size locking
has been added to the -mm tree.  Its filename is
     fsstack-fsstack_copy_inode_size-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsstack: fsstack_copy_inode_size locking
From: Hugh Dickins <hugh@veritas.com>

LTP's iogen01 doio tests used to hang nicely on 32-bit SMP when /tmp was a
unionfs mount of a tmpfs, i_size_read spinning forever, waiting for a lost
seqcount update: fixed by taking i_lock around i_size_write when 32-bit
SMP.

But akpm was dissatisfied with the resulting patch: its lack of
commentary, the #ifs, the nesting around i_size_read, the lack of
attention to i_blocks.  I promised to redo it with the general
spin_lock_32bit() he proposed; but disliked the result, partly because
"32bit" obscures the real constraints, which are best commented within
fsstack_copy_inode_size itself.

This version adds those comments, and uses sizeof comparisons which the
compiler can optimize out, instead of CONFIG_SMP, CONFIG_LSF. 
BITS_PER_LONG.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: <hooanon05@yahoo.co.jp>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/stack.c               |   58 +++++++++++++++++++++++++++++++------
 include/linux/fs_stack.h |    3 -
 2 files changed, 50 insertions(+), 11 deletions(-)

diff -puN fs/stack.c~fsstack-fsstack_copy_inode_size-locking fs/stack.c
--- a/fs/stack.c~fsstack-fsstack_copy_inode_size-locking
+++ a/fs/stack.c
@@ -19,16 +19,56 @@
  * This function cannot be inlined since i_size_{read,write} is rather
  * heavy-weight on 32-bit systems
  */
-void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
+void fsstack_copy_inode_size(struct inode *dst, struct inode *src)
 {
-#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
-	spin_lock(&dst->i_lock);
-#endif
-	i_size_write(dst, i_size_read(src));
-	dst->i_blocks = src->i_blocks;
-#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
-	spin_unlock(&dst->i_lock);
-#endif
+	loff_t i_size;
+	blkcnt_t i_blocks;
+
+	/*
+	 * i_size_read() includes its own seqlocking and protection from
+	 * preemption (see include/linux/fs.h): we need nothing extra for
+	 * that here, and prefer to avoid nesting locks than attempt to
+	 * keep i_size and i_blocks in synch together.
+	 */
+	i_size = i_size_read(src);
+
+	/*
+	 * But if CONFIG_LSF (on 32-bit), we ought to make an effort to keep
+	 * the two halves of i_blocks in synch despite SMP or PREEMPT - though
+	 * stat's generic_fillattr() doesn't bother, and we won't be applying
+	 * quotas (where i_blocks does become important) at the upper level.
+	 *
+	 * We don't actually know what locking is used at the lower level; but
+	 * if it's a filesystem that supports quotas, it will be using i_lock
+	 * as in inode_add_bytes().  tmpfs uses other locking, and its 32-bit
+	 * is (just) able to exceed 2TB i_size with the aid of holes; but its
+	 * i_blocks cannot carry into the upper long without almost 2TB swap -
+	 * let's ignore that case.
+	 */
+	if (sizeof(i_blocks) > sizeof(long))
+		spin_lock(&src->i_lock);
+	i_blocks = src->i_blocks;
+	if (sizeof(i_blocks) > sizeof(long))
+		spin_unlock(&src->i_lock);
+
+	/*
+	 * If CONFIG_SMP on 32-bit, it's vital for fsstack_copy_inode_size()
+	 * to hold some lock around i_size_write(), otherwise i_size_read()
+	 * may spin forever (see include/linux/fs.h).  We don't necessarily
+	 * hold i_mutex when this is called, so take i_lock for that case.
+	 *
+	 * And if CONFIG_LSF (on 32-bit), continue our effort to keep the
+	 * two halves of i_blocks in synch despite SMP or PREEMPT: use i_lock
+	 * for that case too, and do both at once by combining the tests.
+	 *
+	 * There is none of this locking overhead in the 64-bit case.
+	 */
+	if (sizeof(i_size) > sizeof(long) || sizeof(i_blocks) > sizeof(long))
+		spin_lock(&dst->i_lock);
+	i_size_write(dst, i_size);
+	dst->i_blocks = i_blocks;
+	if (sizeof(i_size) > sizeof(long) || sizeof(i_blocks) > sizeof(long))
+		spin_unlock(&dst->i_lock);
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
 
diff -puN include/linux/fs_stack.h~fsstack-fsstack_copy_inode_size-locking include/linux/fs_stack.h
--- a/include/linux/fs_stack.h~fsstack-fsstack_copy_inode_size-locking
+++ a/include/linux/fs_stack.h
@@ -21,8 +21,7 @@
 
 /* externs for fs/stack.c */
 extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src);
-extern void fsstack_copy_inode_size(struct inode *dst,
-				    const struct inode *src);
+extern void fsstack_copy_inode_size(struct inode *dst, struct inode *src);
 
 /* inlines */
 static inline void fsstack_copy_attr_atime(struct inode *dest,
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-dirty-page-accounting-vs-vm_mixedmap.patch
git-unionfs.patch
fsstack-fsstack_copy_inode_size-locking.patch
mm-remove-nopfn-fix.patch
access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
generic_file_aio_read-cleanups.patch
tmpfs-support-aio.patch
hugetlb-modular-state-for-hugetlb-page-size-cleanup.patch
hugetlb-reservations-move-region-tracking-earlier.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
security-remove-unused-forwards.patch
exec-remove-some-includes.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
prio_tree-debugging-patch.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752D9C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbiHVTVW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238655AbiHVTUx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:20:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803C038A8
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:19:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33450B818AB
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB08C433D6;
        Mon, 22 Aug 2022 19:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661195991;
        bh=eor453XMrZPMigyC3VEHq2NA+BXuAoKnHlM46GdeI2k=;
        h=Date:To:From:Subject:From;
        b=qmU7Ig85C3+ZamlHlYwGri5qTtPgRXVyYLls5b5SXtDpCdd66AXzItRDJnGQ5EMBi
         en98jgJt527jegP6KsxxCfkOJRY8QzJml2Gk1v8A8NrQXUYjHQ4ej9u0UXOSrOxkye
         GdFBeDB+Vdjl7UpadqFhyz0SAZvk6KxhdQ3X5fGM=
Date:   Mon, 22 Aug 2022 12:19:51 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-fork-use-maple-tree-for-dup_mmap-during-forking.patch added to mm-unstable branch
Message-Id: <20220822191951.CDB08C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork: use maple tree for dup_mmap() during forking
has been added to the -mm mm-unstable branch.  Its filename is
     kernel-fork-use-maple-tree-for-dup_mmap-during-forking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-fork-use-maple-tree-for-dup_mmap-during-forking.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: kernel/fork: use maple tree for dup_mmap() during forking
Date: Mon, 22 Aug 2022 15:03:11 +0000

The maple tree was already tracking VMAs in this function by an earlier
commit, but the rbtree iterator was being used to iterate the list. 
Change the iterator to use a maple tree native iterator and switch to the
maple tree advanced API to avoid multiple walks of the tree during insert
operations.  Unexport the now-unused vma_store() function.

For performance reasons we bulk allocate the maple tree nodes.  The node
calculations are done internally to the tree and use the VMA count and
assume the worst-case node requirements.  The VM_DONT_COPY flag does not
allow for the most efficient copy method of the tree and so a bulk loading
algorithm is used.

Link: https://lkml.kernel.org/r/20220822150128.1562046-15-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 kernel/fork.c      |   15 +++++++++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~kernel-fork-use-maple-tree-for-dup_mmap-during-forking
+++ a/include/linux/mm.h
@@ -2603,8 +2603,6 @@ extern bool arch_has_descending_max_zone
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
 extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
-/* mmap.c */
-void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas);
 
 /* interval_tree.c */
 void vma_interval_tree_insert(struct vm_area_struct *node,
--- a/kernel/fork.c~kernel-fork-use-maple-tree-for-dup_mmap-during-forking
+++ a/kernel/fork.c
@@ -583,8 +583,9 @@ static __latent_entropy int dup_mmap(str
 	struct vm_area_struct *mpnt, *tmp, *prev, **pprev;
 	struct rb_node **rb_link, *rb_parent;
 	int retval;
-	unsigned long charge;
+	unsigned long charge = 0;
 	LIST_HEAD(uf);
+	MA_STATE(old_mas, &oldmm->mm_mt, 0, 0);
 	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
 	uprobe_start_dup_mmap();
@@ -620,7 +621,12 @@ static __latent_entropy int dup_mmap(str
 		goto out;
 
 	prev = NULL;
-	for (mpnt = oldmm->mmap; mpnt; mpnt = mpnt->vm_next) {
+
+	retval = mas_expected_entries(&mas, oldmm->map_count);
+	if (retval)
+		goto out;
+
+	mas_for_each(&old_mas, mpnt, ULONG_MAX) {
 		struct file *file;
 
 		if (mpnt->vm_flags & VM_DONTCOPY) {
@@ -703,6 +709,8 @@ static __latent_entropy int dup_mmap(str
 		mas.index = tmp->vm_start;
 		mas.last = tmp->vm_end - 1;
 		mas_store(&mas, tmp);
+		if (mas_is_err(&mas))
+			goto fail_nomem_mas_store;
 
 		mm->map_count++;
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
@@ -726,6 +734,9 @@ out:
 fail_uprobe_end:
 	uprobe_end_dup_mmap();
 	return retval;
+
+fail_nomem_mas_store:
+	unlink_anon_vmas(tmp);
 fail_nomem_anon_vma_fork:
 	mpol_put(vma_policy(tmp));
 fail_nomem_policy:
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple-tree-add-new-data-structure.patch
radix-tree-test-suite-add-pr_err-define.patch
radix-tree-test-suite-add-kmem_cache_set_non_kernel.patch
radix-tree-test-suite-add-allocation-counts-and-size-to-kmem_cache.patch
radix-tree-test-suite-add-support-for-slab-bulk-apis.patch
radix-tree-test-suite-add-lockdep_is_held-to-header.patch
lib-test_maple_tree-add-testing-for-maple-tree.patch
mm-start-tracking-vmas-with-maple-tree.patch
mm-mmap-use-the-maple-tree-in-find_vma-instead-of-the-rbtree.patch
mm-mmap-use-the-maple-tree-for-find_vma_prev-instead-of-the-rbtree.patch
mm-mmap-use-maple-tree-for-unmapped_area_topdown.patch
kernel-fork-use-maple-tree-for-dup_mmap-during-forking.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator.patch
mm-remove-rb-tree.patch
mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch
xen-use-vma_lookup-in-privcmd_ioctl_mmap.patch
mm-optimize-find_exact_vma-to-use-vma_lookup.patch
mm-khugepaged-optimize-collapse_pte_mapped_thp-by-using-vma_lookup.patch
mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap.patch
mm-use-maple-tree-operations-for-find_vma_intersection.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region.patch
mm-remove-vmacache.patch
mm-convert-vma_lookup-to-use-mtree_load.patch
mm-mmap-move-mmap_region-below-do_munmap.patch
mm-mmap-reorganize-munmap-to-use-maple-states.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap.patch
arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch
fs-proc-base-use-maple-tree-iterators-in-place-of-linked-list.patch
userfaultfd-use-maple-tree-iterator-to-iterate-vmas.patch
ipc-shm-use-vma-iterator-instead-of-linked-list.patch
bpf-remove-vma-linked-list.patch
mm-gup-use-maple-tree-navigation-instead-of-linked-list.patch
mm-madvise-use-vma_find-instead-of-vma-linked-list.patch
mm-memcontrol-stop-using-mm-highest_vm_end.patch
mm-mempolicy-use-vma-iterator-maple-state-instead-of-vma-linked-list.patch
mm-mprotect-use-maple-tree-navigation-instead-of-vma-linked-list.patch
mm-mremap-use-vma_find_intersection-instead-of-vma-linked-list.patch
mm-msync-use-vma_find-instead-of-vma-linked-list.patch
mm-oom_kill-use-maple-tree-iterators-instead-of-vma-linked-list.patch
mm-swapfile-use-vma-iterator-instead-of-vma-linked-list.patch
riscv-use-vma-iterator-for-vdso.patch
mm-remove-the-vma-linked-list.patch
mm-mmap-drop-range_has_overlap-function.patch
mm-mmapc-pass-in-mapping-to-__vma_link_file.patch


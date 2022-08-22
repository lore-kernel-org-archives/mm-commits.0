Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B2CC32774
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238576AbiHVTWF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238724AbiHVTU7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:20:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC8317E3D
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98979B818AB
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3A1C433C1;
        Mon, 22 Aug 2022 19:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196037;
        bh=7GwZb+d0AWKULDAufe866GfHxB1+I9qb8DF2v6oLxdw=;
        h=Date:To:From:Subject:From;
        b=nFWti/6UpVxWG0W97eBH0R+iGv2QD+A9Ttfp4eceIiH3OF0kdCAgGhT2n2GhUWzSx
         ZbOXusjarkegZ5eGVRO1kaIbbXIuhv5R5pZ4YI7MIULHqDT3F/FAkw7S5KHOMSNu1m
         ymjkdU4Zn3DVXLHwkyy08pWwRBIuiIJpmfl9aA9U=
Date:   Mon, 22 Aug 2022 12:20:36 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, Liam.Howlett@oracle.com, dhowells@redhat.com,
        david@redhat.com, catalin.marinas@arm.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch added to mm-unstable branch
Message-Id: <20220822192037.4E3A1C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: Change elfcore for_each_mte_vma() to use VMA iterator
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch

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
Subject: arm64: Change elfcore for_each_mte_vma() to use VMA iterator
Date: Mon, 22 Aug 2022 15:05:25 +0000

Rework for_each_mte_vma() to use a VMA iterator instead of an explicit
linked-list.

Link: https://lkml.kernel.org/r/20220822150128.1562046-32-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220218023650.672072-1-Liam.Howlett@oracle.com
Signed-off-by: Will Deacon <will@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/elfcore.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/elfcore.c~arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator
+++ a/arch/arm64/kernel/elfcore.c
@@ -8,9 +8,9 @@
 #include <asm/cpufeature.h>
 #include <asm/mte.h>
 
-#define for_each_mte_vma(tsk, vma)					\
+#define for_each_mte_vma(vmi, vma)					\
 	if (system_supports_mte())					\
-		for (vma = tsk->mm->mmap; vma; vma = vma->vm_next)	\
+		for_each_vma(vmi, vma)					\
 			if (vma->vm_flags & VM_MTE)
 
 static unsigned long mte_vma_tag_dump_size(struct vm_area_struct *vma)
@@ -81,8 +81,9 @@ Elf_Half elf_core_extra_phdrs(void)
 {
 	struct vm_area_struct *vma;
 	int vma_count = 0;
+	VMA_ITERATOR(vmi, current->mm, 0);
 
-	for_each_mte_vma(current, vma)
+	for_each_mte_vma(vmi, vma)
 		vma_count++;
 
 	return vma_count;
@@ -91,8 +92,9 @@ Elf_Half elf_core_extra_phdrs(void)
 int elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
 {
 	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, current->mm, 0);
 
-	for_each_mte_vma(current, vma) {
+	for_each_mte_vma(vmi, vma) {
 		struct elf_phdr phdr;
 
 		phdr.p_type = PT_AARCH64_MEMTAG_MTE;
@@ -116,8 +118,9 @@ size_t elf_core_extra_data_size(void)
 {
 	struct vm_area_struct *vma;
 	size_t data_size = 0;
+	VMA_ITERATOR(vmi, current->mm, 0);
 
-	for_each_mte_vma(current, vma)
+	for_each_mte_vma(vmi, vma)
 		data_size += mte_vma_tag_dump_size(vma);
 
 	return data_size;
@@ -126,8 +129,9 @@ size_t elf_core_extra_data_size(void)
 int elf_core_write_extra_data(struct coredump_params *cprm)
 {
 	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, current->mm, 0);
 
-	for_each_mte_vma(current, vma) {
+	for_each_mte_vma(vmi, vma) {
 		if (vma->vm_flags & VM_DONTDUMP)
 			continue;
 
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


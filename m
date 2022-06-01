Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70E9C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 20:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiFAUrr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 16:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiFAUrj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 16:47:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE453275585
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 13:44:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D018B81C3B
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 20:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A924C385A5;
        Wed,  1 Jun 2022 20:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654116252;
        bh=/eitr18UG9HdnRy2WKDrww/nGHMdPSVdxZKtRcDE1Ns=;
        h=Date:To:From:Subject:From;
        b=Hm343xhn3Tr6u8WSOMWXMbKYEIeCMPOxKVXg+AJbC2eYTWtbUI+lvVv9LRrLhxmVa
         19105kbrDT5iZw/avtz+5I4JrtukKsavv4/B+zWY9p6UzyBt9zkuAFhrAw4TGJWgAu
         n5/a4uKXacGeCavh5PPjyGLrSFE0Y+Jyh3TnOsMk=
Date:   Wed, 01 Jun 2022 13:44:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch added to mm-unstable branch
Message-Id: <20220601204412.3A924C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: reduce potential fragmentation in make_alloc_exact()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch

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
Subject: mm/page_alloc: reduce potential fragmentation in make_alloc_exact()
Date: Tue, 31 May 2022 09:20:51 -0400

Try to avoid using the left over split page on the next request for a page
by calling __free_pages_ok() with FPI_TO_TAIL.  This increases the
potential of defragmenting memory when it's used for a short period of
time.

Link: https://lkml.kernel.org/r/20220531185626.yvlmymbxyoe5vags@revolver
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact
+++ a/mm/page_alloc.c
@@ -5724,14 +5724,18 @@ static void *make_alloc_exact(unsigned l
 		size_t size)
 {
 	if (addr) {
-		unsigned long alloc_end = addr + (PAGE_SIZE << order);
-		unsigned long used = addr + PAGE_ALIGN(size);
+		unsigned long nr = DIV_ROUND_UP(size, PAGE_SIZE);
+		struct page *page = virt_to_page((void *)addr);
+		struct page *last = page + nr;
 
-		split_page(virt_to_page((void *)addr), order);
-		while (used < alloc_end) {
-			free_page(used);
-			used += PAGE_SIZE;
-		}
+		split_page_owner(page, 1 << order);
+		split_page_memcg(page, 1 << order);
+		while (page < --last)
+			set_page_refcounted(last);
+
+		last = page + (1UL << order);
+		for (page += nr; page < last; page++)
+			__free_pages_ok(page, 0, FPI_TO_TAIL);
 	}
 	return (void *)addr;
 }
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

mips-rename-mt_init-to-mips_mt_init.patch
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
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch
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
mm-page_alloc-reduce-potential-fragmentation-in-make_alloc_exact.patch


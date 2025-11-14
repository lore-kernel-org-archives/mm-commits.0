Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C5630F923
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 22:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763159142; cv=none; b=Kbyp9XsuAOHfl/FgEaMDvvWDri2mSXD5pmQ42qcyFjq4UU7UVmyvcqkgtM4KVxSOm269Z3oZ5v26bi68mRcNBzBVdjPj9bd4eMU56wUe8blESd7hY6XJxoNQERygzWpc3XY5wjcgG76tAlmTJkegE/XKZuR84yz5jBo0HGsIl8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763159142; c=relaxed/simple;
	bh=+qvfpoRa75UJ4eUo6wVnU2zQAlBlnUgw1ze/csiLS1s=;
	h=Date:To:From:Subject:Message-Id; b=gwkuS4zwcxnZF9FnMzy4ZG9SpWe0H91ycwO2VcQRNthno7bK689VrLaquft/RiEzT0tR9kVwjFc3Crfx9kkU7zhxrLDjyD1hrfWKUbPF3ysJNG1Zl3mlc0d+DCp5+ZUI3OKQaA5+N4NfXxRaVk469CD3Abewexh4+iqz2aKT2wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nm/2xAdN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nm/2xAdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B146CC4CEF1;
	Fri, 14 Nov 2025 22:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763159141;
	bh=+qvfpoRa75UJ4eUo6wVnU2zQAlBlnUgw1ze/csiLS1s=;
	h=Date:To:From:Subject:From;
	b=nm/2xAdNd4U1bGLP60U4/VGxWho9vY5JZN/+usygsstxoeu8Bb6DIKBStJ5nm2Msg
	 AbKF6bsPojA8SUKWzLc+X+VynPtLnLjQ0cTi9C7I/wzi+z/VTNdVCdqAISGsg+Aqhb
	 90G1NkRUidluk7k+w16uKYF++7m+Suj2yjs2Q+VE=
Date: Fri, 14 Nov 2025 14:25:41 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,weixugc@google.com,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,riel@surriel.com,rakie.kim@sk.com,peterz@infradead.org,peterx@redhat.com,osalvador@suse.de,ojeda@kernel.org,nphamcs@gmail.com,npache@redhat.com,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,matthew.brost@intel.com,lkp@intel.com,liam.howlett@oracle.com,leon@kernel.org,lance.yang@linux.dev,kees@kernel.org,kasong@tencent.com,juri.lelli@redhat.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,hannes@cmpxchg.org,gourry@gourry.net,gary@garyguo.net,dietmar.eggemann@arm.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,bsegall@google.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch added to mm-new branch
Message-Id: <20251114222541.B146CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: eliminate dependency on vma->__vm_flags
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/vma: eliminate dependency on vma->__vm_flags
Date: Fri, 14 Nov 2025 13:26:10 +0000

The userland VMA test code relied on an internal implementation detail -
the existence of vma->__vm_flags to directly access VMA flags. There is no
need to do so when we have the vm_flags_*() helper functions available.

This is both ugly, but also a subsequent commit will eliminate this field
altogether so this will shortly become broken.

This patch has us utilise the helper functions instead.

Link: https://lkml.kernel.org/r/fb709773edcaf13d7a2c4cede046e454b4e88b1e.1763126447.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/tools/testing/vma/vma.c~tools-testing-vma-eliminate-dependency-on-vma-__vm_flags
+++ a/tools/testing/vma/vma.c
@@ -69,18 +69,18 @@ static struct vm_area_struct *alloc_vma(
 					pgoff_t pgoff,
 					vm_flags_t vm_flags)
 {
-	struct vm_area_struct *ret = vm_area_alloc(mm);
+	struct vm_area_struct *vma = vm_area_alloc(mm);
 
-	if (ret == NULL)
+	if (vma == NULL)
 		return NULL;
 
-	ret->vm_start = start;
-	ret->vm_end = end;
-	ret->vm_pgoff = pgoff;
-	ret->__vm_flags = vm_flags;
-	vma_assert_detached(ret);
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+	vm_flags_reset(vma, vm_flags);
+	vma_assert_detached(vma);
 
-	return ret;
+	return vma;
 }
 
 /* Helper function to allocate a VMA and link it to the tree. */
@@ -713,7 +713,7 @@ static bool test_vma_merge_special_flags
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {
 		vm_flags_t special_flag = special_flags[i];
 
-		vma_left->__vm_flags = vm_flags | special_flag;
+		vm_flags_reset(vma_left, vm_flags | special_flag);
 		vmg.vm_flags = vm_flags | special_flag;
 		vma = merge_new(&vmg);
 		ASSERT_EQ(vma, NULL);
@@ -735,7 +735,7 @@ static bool test_vma_merge_special_flags
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {
 		vm_flags_t special_flag = special_flags[i];
 
-		vma_left->__vm_flags = vm_flags | special_flag;
+		vm_flags_reset(vma_left, vm_flags | special_flag);
 		vmg.vm_flags = vm_flags | special_flag;
 		vma = merge_existing(&vmg);
 		ASSERT_EQ(vma, NULL);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-vma-remove-unused-function-make-internal-functions-static.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-abstract-io_remap_pfn_range-based-on-pfn.patch
mm-introduce-io_remap_pfn_range_.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-vma-small-vma-lock-cleanups.patch
mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix.patch
mm-implement-sticky-vma-flags.patch
mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix.patch
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch
mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch
mm-rename-walk_page_range_mm.patch
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-propagate-vm_softdirty-on-merge.patch
testing-selftests-mm-add-soft-dirty-merge-self-test.patch
mm-declare-vma-flags-by-bit.patch
mm-declare-vma-flags-by-bit-fix.patch
mm-declare-vma-flags-by-bit-fix-2.patch
mm-simplify-and-rename-mm-flags-function-for-clarity.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch
mm-introduce-vma-flags-bitmap-type.patch


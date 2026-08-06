Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A1C425873
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 23:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786058913; cv=none; b=Lmd1b1SoaqOkaLsCWsQdCPat5pmThFq2zk7I9FG87MPraraccjI3c7Va3CCOqaY409w3TdP7i91nQAKktMZXDAPpYwavmVtwLTxZGQq0s2ZkT2vuWl1HIl3wO4gGpGoG29oWA6fWzCKrSjG9UKvCjoAoVgqA9zzOyHwtxXp0h/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786058913; c=relaxed/simple;
	bh=tHGQnmFWrMhTrfK9fTEKY5lFGOVjDnjyjj75b+TyE7s=;
	h=Date:To:From:Subject:Message-Id; b=c9CnDndd/aEk2Ijo+pcXavlSocZZ9OG/69j4p7TywoUqAUK9gqgAFwlNH6OBnsAdNcDLGttIOhWnItJVedogjQ3kpBUnZNmE8VP6yQWxttXUwElqyjzc+OKZOe0jVJiAAqiioF+VAk7Yj3lXNc6wDkD0/pqEI663SIDqElfcAi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SVhyCmd7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SVhyCmd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0606E1F000E9;
	Thu,  6 Aug 2026 23:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786058911;
	bh=0qZurm1bs18VAIiXjuxbBsOPaODD2tyRKzyIP1KgXR0=;
	h=Date:To:From:Subject;
	b=SVhyCmd7mHItOZqBfkdG8d5sgvugh0vi66y+rJfy3hw+CoOFScixk54VOcn8Gn+hI
	 6RDWeEslRw5rkTQEFjWPFMwvflUZs+q/3TnqC9khv8XXW/PGBJWcWKSBaulWzVNMgt
	 4N3yOsi79j6GUZaizVzFlkex3y1nf4Kzz2McZUZc=
Date: Thu, 06 Aug 2026 16:28:30 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-add-tests-for-copy_vma-self-merge.patch added to mm-unstable branch
Message-Id: <20260806232831.0606E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: add tests for copy_vma() self-merge
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-vma-add-tests-for-copy_vma-self-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-add-tests-for-copy_vma-self-merge.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: tools/testing/vma: add tests for copy_vma() self-merge
Date: Thu, 06 Aug 2026 21:21:33 +0100

Assert that a VMA can be moved backwards, forwards and between a preceding
VMA and its old self.

In the cases in which the VMA merges only with itself expect that to be
achieved by expanding its old self, so assert that these function
correctly.

However in the case of a merge between a preceding VMA and itself the
original VMA is removed, so assert that the preceding VMA replaces the one
passed in as vmap and the merge is as expected.

Link: https://lore.kernel.org/20260806-b4-scalable-cow-virt-pgoff-v4-8-ab318a350404@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Deucher <alexander.deucher@amd.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christan König <christian.koenig@amd.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price (Meta) <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ray <Ray.Huang@amd.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: <syzbot@syzkaller.appspotmail.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/tests/vma.c |   46 +++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

--- a/tools/testing/vma/tests/vma.c~tools-testing-vma-add-tests-for-copy_vma-self-merge
+++ a/tools/testing/vma/tests/vma.c
@@ -33,7 +33,51 @@ static bool test_copy_vma(void)
 	struct mm_struct mm = {};
 	bool need_locks = false;
 	VMA_ITERATOR(vmi, &mm, 0);
-	struct vm_area_struct *vma, *vma_new, *vma_next;
+	struct vm_area_struct *vma, *vma_prev, *vma_new, *vma_next, *vma_orig;
+
+	/* Move forwards, adjacent to old self - self-merge. */
+
+	vma = alloc_and_link_vma(&mm, 0x1000, 0x2000, 1, vma_flags);
+	vma_set_anonymous(vma);
+	vma_orig = vma;
+	vma_new = copy_vma(&vma, 0x2000, 0x1000, 1, &need_locks);
+	ASSERT_EQ(vma_new, vma_orig);
+	ASSERT_EQ(vma, vma_orig);
+	ASSERT_EQ(vma_new->vm_start, 0x1000);
+	ASSERT_EQ(vma_new->vm_end, 0x3000);
+
+	cleanup_mm(&mm, &vmi);
+
+	/* Move backwards, adjacent to old self - self-merge. */
+
+	vma = alloc_and_link_vma(&mm, 0x2000, 0x3000, 2, vma_flags);
+	vma_set_anonymous(vma);
+	vma_orig = vma;
+	vma_new = copy_vma(&vma, 0x1000, 0x1000, 2, &need_locks);
+	ASSERT_EQ(vma_new, vma_orig);
+	ASSERT_EQ(vma, vma_orig);
+	ASSERT_EQ(vma_new->vm_start, 0x1000);
+	ASSERT_EQ(vma_new->vm_end, 0x3000);
+
+	cleanup_mm(&mm, &vmi);
+
+	/*
+	 * Move backwards between prior VMA and old self - self-merge and vma
+	 * updated to a new VMA.
+	 */
+
+	vma_prev = alloc_and_link_vma(&mm, 0x1000, 0x2000, 1, vma_flags);
+	vma_set_anonymous(vma_prev);
+	vma = alloc_and_link_vma(&mm, 0x3000, 0x4000, 3, vma_flags);
+	vma_set_anonymous(vma);
+	vma_orig = vma;
+	vma_new = copy_vma(&vma, 0x2000, 0x1000, 3, &need_locks);
+	ASSERT_NE(vma_new, vma_orig);
+	ASSERT_EQ(vma_new, vma);
+	ASSERT_EQ(vma_new->vm_start, 0x1000);
+	ASSERT_EQ(vma_new->vm_end, 0x4000);
+
+	cleanup_mm(&mm, &vmi);
 
 	/* Move backwards and do not merge. */
 
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch


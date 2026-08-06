Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E8F47F783
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 23:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786058932; cv=none; b=tcCzJ5GILwknlS1MnsVcNDdBfSoqvmsjdFu+cniD5PAAhKPyijoxuDHrdarS5g7ZpfebKFBTPUsKzD2wL6KZuXDabHBIiKSdg8yvcWqMV6y784zPfnvE6WyVnXS8QfdElbJI6nkGlk2+AXpAebHot6eIlg0KuFZfb9vGMcPHkU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786058932; c=relaxed/simple;
	bh=Q2+cWKXNADr14zn3wRTQqEgRS+7XteCFNKN49FYHMiE=;
	h=Date:To:From:Subject:Message-Id; b=eMYb+lCoodATVXKCN4NtdkOq+1wJ3+6i/woz3zwsgmFaerbQsYNFgwhqFPkLqFQ1vWegb53fwu4jVoY6kpHP2NH59y7LoPLaCV1Ij60eef/K5NmhOzCVFlcqQUBy1FqMn5doR6JYicJW1H5SIj6jHxnNj9uPjEZuoEWEMIiAjDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ruYflz1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ruYflz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F19D1F000E9;
	Thu,  6 Aug 2026 23:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786058930;
	bh=mR0yn33PgkTy/9C0IO00QSBL81iZJIRrDG8/e/cKVak=;
	h=Date:To:From:Subject;
	b=1ruYflz1OiGRSia7l4NFwXmCgFpFIOuv15Y97Nm92mrgMD8D4IEEfnzBLzkGqcV28
	 hIobZm4BNKbGj/+teW6hhY71sEDeyKnDh+X8rYpxH402PfpWm3MauCwn8MeGqOQkG8
	 37i2mgqp3llg8edWScmdRO1qB0HkRi3DdksQLE2Q=
Date: Thu, 06 Aug 2026 16:28:49 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-calculate-large-folio-page-index-using-pfn.patch added to mm-unstable branch
Message-Id: <20260806232850.2F19D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: calculate large folio page index using PFN
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-calculate-large-folio-page-index-using-pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-calculate-large-folio-page-index-using-pfn.patch

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
Subject: mm/migrate: calculate large folio page index using PFN
Date: Thu, 06 Aug 2026 21:21:38 +0100

Rather than having to figure out the page index to use using
linear_page_index(), calculate it using PFN.

This is a more natural fit as the linear page index is immaterial to
determining the folio page index.

Derive the page index from the offset between migration entry PFN and
folio PFN - pvmw.pfn (set via DEFINE_FOLIO_VMA_WALK() which uses
folio_pfn() to obtain it).

Additionally remove a not so useful comment and clean the code layout up.

No functional change intended.

Link: https://lore.kernel.org/20260806-b4-scalable-cow-virt-pgoff-v4-13-ab318a350404@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
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

 mm/migrate.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/mm/migrate.c~mm-migrate-calculate-large-folio-page-index-using-pfn
+++ a/mm/migrate.c
@@ -356,16 +356,11 @@ static bool remove_migration_pte(struct
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		rmap_t rmap_flags = RMAP_NONE;
-		pte_t old_pte;
-		pte_t pte;
+		unsigned long idx = 0;
 		softleaf_t entry;
 		struct page *new;
-		unsigned long idx = 0;
-
-		/* pgoff is invalid for ksm pages, but they are never large */
-		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
-			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
-		new = folio_page(folio, idx);
+		pte_t old_pte;
+		pte_t pte;
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 		/* PMD-mapped THP migration entry */
@@ -381,14 +376,18 @@ static bool remove_migration_pte(struct
 						pvmw.pte);
 		else
 			old_pte = ptep_get(pvmw.pte);
+
+		entry = softleaf_from_pte(old_pte);
+		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
+			idx = softleaf_to_pfn(entry) - pvmw.pfn;
+
 		if (rmap_walk_arg->map_unused_to_zeropage &&
 		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
 			continue;
 
 		folio_get(folio);
+		new = folio_page(folio, idx);
 		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
-
-		entry = softleaf_from_pte(old_pte);
 		if (!softleaf_is_migration_young(entry))
 			pte = pte_mkold(pte);
 		if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
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


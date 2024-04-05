Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C2638F83
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 18:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712343109; cv=none; b=a1Madf24WDw+zErmAyN1rJToSkagvUKV0LVQP+w72QexCMMjrGBIAj43E683c05dfx+/zHfAS5rTRq/KQZswhpQUtWSrMmfobK67k5SHeNoCWlNAyoAOXid66g9pwmnKZYrR+GFlxUWiJf088aveVq/KpbssnII8JVF6p/r+1wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712343109; c=relaxed/simple;
	bh=OrCpGCyz8pvOpKP8awUb1zdpj7C8eEwoXJVrPPgsiJI=;
	h=Date:To:From:Subject:Message-Id; b=P/YAumCjLppridSsuEL8cgbvXQ12SpQT1RCQuAw9mg349RSCZBJGHGYSw88qRiiJM5Yxu8q+dk1U7kbVSZCjhiSXkXsvFcaacCqXqyb6epJRuiOk+PfDPD73ny0IKvcQC/f1jlx7pKcjd9Be4nlrZcwQgeFgFjurLSuOzh5BdOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MrgUGa2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MrgUGa2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE768C433F1;
	Fri,  5 Apr 2024 18:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712343108;
	bh=OrCpGCyz8pvOpKP8awUb1zdpj7C8eEwoXJVrPPgsiJI=;
	h=Date:To:From:Subject:From;
	b=MrgUGa2UXoFrfEz+PgoOnqSTqn0ynPO/iPSliXmqoEC3uQ3hJ5Fw5d6PlNFxVuCYF
	 Ksj4asygZZqlbNa6NkG4hdwIUsj8I2fTN2HVf95dxsVHE8lHE9A3oeyAqHQNnLjKP3
	 SJd4LwNTfYlDqOT32tBOwX6/IrhGIqz0rRR024Gw=
Date: Fri, 05 Apr 2024 11:51:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-free-non-hugetlb-large-folios-in-a-batch.patch added to mm-unstable branch
Message-Id: <20240405185148.BE768C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: free non-hugetlb large folios in a batch
has been added to the -mm mm-unstable branch.  Its filename is
     mm-free-non-hugetlb-large-folios-in-a-batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-free-non-hugetlb-large-folios-in-a-batch.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: free non-hugetlb large folios in a batch
Date: Fri, 5 Apr 2024 16:32:23 +0100

Patch series "Clean up __folio_put()".

With all the changes over the last few years, __folio_put_small and
__folio_put_large have become almost identical to each other ...  except
you can't tell because they're spread over two files.  Rearrange it all so
that you can tell, and then inline them both into __folio_put().


This patch (of 5):

free_unref_folios() can now handle non-hugetlb large folios, so keep
normal large folios in the batch.  hugetlb folios still need to be handled
specially.  I believe that folios freed using put_pages_list() cannot be
accounted to a memcg (or the small folios would trip the "page still
charged to cgroup" warning), but put an assertion in to check that.

Link: https://lkml.kernel.org/r/20240405153228.2563754-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240405153228.2563754-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/swap.c~mm-free-non-hugetlb-large-folios-in-a-batch
+++ a/mm/swap.c
@@ -158,10 +158,11 @@ void put_pages_list(struct list_head *pa
 	list_for_each_entry_safe(folio, next, pages, lru) {
 		if (!folio_put_testzero(folio))
 			continue;
-		if (folio_test_large(folio)) {
-			__folio_put_large(folio);
+		if (folio_test_hugetlb(folio)) {
+			free_huge_folio(folio);
 			continue;
 		}
+		VM_BUG_ON_FOLIO(folio_memcg(folio), folio);
 		/* LRU flag must be clear because it's passed using the lru */
 		if (folio_batch_add(&fbatch, folio) > 0)
 			continue;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
proc-rewrite-stable_page_flags-fix.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch
khugepaged-inline-hpage_collapse_alloc_folio.patch
khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch
khugepaged-remove-hpage-from-collapse_huge_page.patch
khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch
khugepaged-remove-hpage-from-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file.patch
khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch
proc-convert-clear_refs_pte_range-to-use-a-folio.patch
proc-convert-smaps_account-to-use-a-folio.patch
mm-remove-page_idle-and-page_young-wrappers.patch
mm-generate-page_idle_flag-definitions.patch
proc-convert-gather_stats-to-use-a-folio.patch
proc-convert-smaps_page_accumulate-to-use-a-folio.patch
proc-pass-a-folio-to-smaps_page_accumulate.patch
proc-convert-smaps_pmd_entry-to-use-a-folio.patch
mm-remove-struct-page-from-get_shadow_from_swap_cache.patch
hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch
mm-convert-pagecache_isize_extended-to-use-a-folio.patch
mm-free-non-hugetlb-large-folios-in-a-batch.patch
mm-combine-free_the_page-and-free_unref_page.patch
mm-inline-destroy_large_folio-into-__folio_put_large.patch
mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch
mm-convert-free_zone_device_page-to-free_zone_device_folio.patch


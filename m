Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364311DDD6
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 19:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712603727; cv=none; b=XPGwbZLSwM6WdgCe1EM062vjJmwK/7HnYHK6QJSpTGYNdB3hg1W/wOQO++PkxypabcgI2Hm9MTJ7W1BPJP5ZIbbUCyxrmkQ4ocP3PMoROyNGUnV7Kw+MaRrAr2bPwEXhg0y29++vppf31YifbafYXkShCxCVas5GXIDfHKDjDis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712603727; c=relaxed/simple;
	bh=NjAmnaxjkHD9DynWIo8S4c6aTWmJZuNQguXhDwyTKLk=;
	h=Date:To:From:Subject:Message-Id; b=aDcv2GHcuCQ4t6Qwmf39zJbzdTTcBjWx5attjgxs2NBGKdGueHwZsfJeWFLTgnwp0Fa8d6TCjp1xTh8flqm30kcIoU57ETd7pxEOF6AFZZcJTvrD8QBXFEzGHUjNwd2hoj5ag8yZt9LGkQwyRCR6Xg6HFs1B+Vo98Zz7KWNblw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c3rH8n35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c3rH8n35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D845FC433C7;
	Mon,  8 Apr 2024 19:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712603726;
	bh=NjAmnaxjkHD9DynWIo8S4c6aTWmJZuNQguXhDwyTKLk=;
	h=Date:To:From:Subject:From;
	b=c3rH8n35TcyS4pd6+cj8trqH1wjKXQh4mMnYuNI2J3TZlabCYlP0tYeTl5OOtik7T
	 0NoyFmBm+bavC0zDNA2nw69HMc2jLbI6QBCW9D8cVsatfkOXP925dYY/Woc2qkuP4d
	 FW7l+OZnRQInF29rS1Id1EyU8VjHeYm+A2MuDpcc=
Date: Mon, 08 Apr 2024 12:15:26 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-use-a-folio-throughout-collapse_file-fix.patch added to mm-unstable branch
Message-Id: <20240408191526.D845FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged-use-a-folio-throughout-collapse_file-fix
has been added to the -mm mm-unstable branch.  Its filename is
     khugepaged-use-a-folio-throughout-collapse_file-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-use-a-folio-throughout-collapse_file-fix.patch

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
From: Matthew Wilcox <willy@infradead.org>
Subject: khugepaged-use-a-folio-throughout-collapse_file-fix
Date: Sun, 7 Apr 2024 04:43:27 +0100

the unlikely() is embedded in IS_ERR() so no need to keep it here

Link: https://lkml.kernel.org/r/ZhIWX8K0E2tSyMSr@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Vishal Moola <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~khugepaged-use-a-folio-throughout-collapse_file-fix
+++ a/mm/khugepaged.c
@@ -1865,7 +1865,7 @@ static int collapse_file(struct mm_struc
 				/* drain lru cache to help isolate_lru_page() */
 				lru_add_drain();
 				folio = filemap_lock_folio(mapping, index);
-				if (unlikely(folio == NULL)) {
+				if (IS_ERR(folio)) {
 					result = SCAN_FAIL;
 					goto xa_unlocked;
 				}
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
proc-rewrite-stable_page_flags-fix-2.patch
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
khugepaged-use-a-folio-throughout-collapse_file-fix.patch
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


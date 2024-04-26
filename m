Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E077F7F2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104044; cv=none; b=BCzV0RyxwSV5pAzFUIA+AFF8vobjc6yKWTAh398gPP4QOkQA8Bfx+8qmYjd5whh7Lw7YnR64o/9wwlQgbDt3EUzsm8hkR30EUci7TUbLEDW+aAcFevSSlos07PcRrbUY1uH5fmv21w/z8XiUodJGjYCoY3N7FrbJEjCITcYTf4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104044; c=relaxed/simple;
	bh=YAKpo2UPQk06LeMfB7xu5jeTl4iXUGaqUouRlW9urfo=;
	h=Date:To:From:Subject:Message-Id; b=YVI01AfZpg2VgqGl3dYHDluss/wJ8f+0BQIC+A+ThNmtx76YasIBADoK0ONKvcQc/EfaQEZ/v0ZpU5hdJju+kgSRKijOEydIEwk6pY3Mq9PqeSlJZF1du+o/2Vdfae5CPkSedztyq+b7bhR19Q+Plaux9034HLYpevTkjrK8+M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iRjtDZo9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iRjtDZo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC69C116B1;
	Fri, 26 Apr 2024 04:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104044;
	bh=YAKpo2UPQk06LeMfB7xu5jeTl4iXUGaqUouRlW9urfo=;
	h=Date:To:From:Subject:From;
	b=iRjtDZo9k2Yj0EzjrkSwPPP1EmyHAv+aTk/kjOybjPUuNqdhigyI7dMfjqeMly7jv
	 TQHBN9qG3klnMU+PZOXyh1WCqgMkU8TAAvnr9AGky8H7+fzVf42igO1CwAKHYnIVjz
	 zUgBLWuIofjfxQ2ma35oN6Np/AHoHmOlv4NGpZfc=
Date: Thu, 25 Apr 2024 21:00:43 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240426040043.EDC69C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert migrate_vma_collect_pmd to use a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert migrate_vma_collect_pmd to use a folio
Date: Tue, 26 Mar 2024 20:28:24 +0000

Convert the pmd directly to a folio and use it.  Turns four calls to
compound_head() into one.

Link: https://lkml.kernel.org/r/20240326202833.523759-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/migrate_device.c~mm-convert-migrate_vma_collect_pmd-to-use-a-folio
+++ a/mm/migrate_device.c
@@ -71,7 +71,7 @@ again:
 		return migrate_vma_collect_hole(start, end, -1, walk);
 
 	if (pmd_trans_huge(*pmdp)) {
-		struct page *page;
+		struct folio *folio;
 
 		ptl = pmd_lock(mm, pmdp);
 		if (unlikely(!pmd_trans_huge(*pmdp))) {
@@ -79,21 +79,21 @@ again:
 			goto again;
 		}
 
-		page = pmd_page(*pmdp);
-		if (is_huge_zero_page(page)) {
+		folio = pmd_folio(*pmdp);
+		if (is_huge_zero_folio(folio)) {
 			spin_unlock(ptl);
 			split_huge_pmd(vma, pmdp, addr);
 		} else {
 			int ret;
 
-			get_page(page);
+			folio_get(folio);
 			spin_unlock(ptl);
-			if (unlikely(!trylock_page(page)))
+			if (unlikely(!folio_trylock(folio)))
 				return migrate_vma_collect_skip(start, end,
 								walk);
-			ret = split_huge_page(page);
-			unlock_page(page);
-			put_page(page);
+			ret = split_folio(folio);
+			folio_unlock(folio);
+			folio_put(folio);
 			if (ret)
 				return migrate_vma_collect_skip(start, end,
 								walk);
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch


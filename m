Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE9F403E9D
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525442; cv=none; b=eP4d7q8guKjdFc0GVi4LN55FYfl9af40R2azZcIYv4UIaZ5vghb2aSXn9CHmLU+oCYvCPlCd8chdjkWX5nQ6b3fEFhrBNTfOFQ/LV+mBrd1R2AFabTL0gGvJUY4T1O/ph9QwSmurwtZTJ9rclJdx+nnkKP/fXiSl/2iV8fdHiIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525442; c=relaxed/simple;
	bh=CRsZcRJirNTU16kQ0VMLbtWsLWrUBrt/Cyo5wndsDEY=;
	h=Date:To:From:Subject:Message-Id; b=EFsJlx6Ne9IIQhph/RhdpDZ3VnnDbykUnaN/mpUFl2gCnHL/D4Z/0ayUc6m15pkPa5YYxrIV9YnKk21G6lKbdcMkDHLV3Jwfd1F6mijJiESQa2DF+HoHp26jKSBReE0oaUq9MApEPSdUnFFEOEh7f+MSmlqMW/IF6n05OzGLXXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OvgaK80I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OvgaK80I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CCD1F00893;
	Fri,  9 Oct 2026 05:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525441;
	bh=c3XKATS9ADQLX1D8bqH8FtZ3e/6wPfTQB7MidXWP49Q=;
	h=Date:To:From:Subject;
	b=OvgaK80Ic42MzLts9BZdbIAin8XHS42DG498unOirEPoRYGIU2u9JVjC1jTdRzzVO
	 TFK/LLiqYZzxCmQSoy/K7m7fnCNjr64b31luQOGiaKhVLlmTzApi+nBKlI6AQ+/PLz
	 KSJCfZSe5S3sBH+auB6WP58vRG6yqJ30fUkWrZP4=
Date: Thu, 08 Oct 2026 22:57:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,vbabka@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,mark.rutland@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch removed from -mm tree
Message-Id: <20261009055721.51CCD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mte: pass the swap entry to mte_save_tags()
has been removed from the -mm tree.  Its filename was
     arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: arm64: mte: pass the swap entry to mte_save_tags()
Date: Tue, 08 Sep 2026 11:16:37 -0400

arch_prepare_to_swap() derives a page from the folio only for
mte_save_tags() to recompute the folio's swap entry from that page.  Pass
the entry in directly with folio_swap_entry(), matching
mte_restore_tags(), and move the page_mte_tagged() check into the caller
so we only compute the entry for tagged pages.

__mte_invalidate_tags() loses its only user, so remove it and call
mte_invalidate_tags() directly in the error path.  This removes two calls
to compound_head().

No functional change.

Link: https://lore.kernel.org/20260908-folio_swap_entry-v2-7-ee6d01dfa5e1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 arch/arm64/mm/mteswap.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/arch/arm64/mm/mteswap.c~arm64-mte-pass-the-swap-entry-to-mte_save_tags
+++ a/arch/arm64/mm/mteswap.c
@@ -20,22 +20,17 @@ void mte_free_tag_storage(char *storage)
 	kfree(storage);
 }
 
-static int mte_save_tags(struct page *page)
+static int mte_save_tags(swp_entry_t entry, struct page *page)
 {
 	void *tag_storage, *ret;
 
-	if (!page_mte_tagged(page))
-		return 0;
-
 	tag_storage = mte_allocate_tag_storage();
 	if (!tag_storage)
 		return -ENOMEM;
 
 	mte_save_page_tags(page_address(page), tag_storage);
 
-	/* lookup the swap entry.val from the page */
-	ret = xa_store(&mte_pages, page_swap_entry(page).val, tag_storage,
-		       GFP_KERNEL);
+	ret = xa_store(&mte_pages, entry.val, tag_storage, GFP_KERNEL);
 	if (WARN(xa_is_err(ret), "Failed to store MTE tags")) {
 		mte_free_tag_storage(tag_storage);
 		return xa_err(ret);
@@ -68,13 +63,6 @@ void mte_invalidate_tags(int type, pgoff
 	mte_free_tag_storage(tags);
 }
 
-static inline void __mte_invalidate_tags(struct page *page)
-{
-	swp_entry_t entry = page_swap_entry(page);
-
-	mte_invalidate_tags(swp_type(entry), swp_offset(entry));
-}
-
 void mte_invalidate_tags_area(int type)
 {
 	swp_entry_t entry = swp_entry(type, 0);
@@ -102,15 +90,23 @@ int arch_prepare_to_swap(struct folio *f
 	nr = folio_nr_pages(folio);
 
 	for (i = 0; i < nr; i++) {
-		err = mte_save_tags(folio_page(folio, i));
+		struct page *page = folio_page(folio, i);
+
+		if (!page_mte_tagged(page))
+			continue;
+
+		err = mte_save_tags(folio_swap_entry(folio, i), page);
 		if (err)
 			goto out;
 	}
 	return 0;
 
 out:
-	while (i--)
-		__mte_invalidate_tags(folio_page(folio, i));
+	while (i--) {
+		swp_entry_t swap = folio_swap_entry(folio, i);
+
+		mte_invalidate_tags(swp_type(swap), swp_offset(swap));
+	}
 	return err;
 }
 
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch


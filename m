Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7995125757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957091; cv=none; b=M7Ya7Mxy+XnlK+YP0+xJoGByKCyJwlrvaqIp5tVclV3ZSEaPHGSsFilyRiSspqJcVoLlVbxan+1uUfAfU/cdXuoDvULAuuppf6bEORf/TQ8dCg53CbIm+nopIbhRRNdhmSeg7pc9AK6fOQzXXtFwAwa+pW6Bl68rcRAIVW5NxIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957091; c=relaxed/simple;
	bh=qDX1YaIWHPtMXYB1qN+LkU8OW5RL8Fxy2bpqvCIC2oM=;
	h=Date:To:From:Subject:Message-Id; b=DL87gxPw3f0h51QyCIKeDe72jEYusMrr3ZZ9xhbFzBvhbIOhL+ifFOIbcUwZGBnxTKRSYbzrMJ+Tiba2h9bzC6p06Pm1Vs8KZ60u3maZw7AW/lML4NJqGie34nsSLKZwBWSYcvP5KhKJoNn8KBMumPK+Kw62jRE/o1U2YZT9QzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h1WMVkbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h1WMVkbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484C1C113CC;
	Mon,  6 May 2024 00:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957091;
	bh=qDX1YaIWHPtMXYB1qN+LkU8OW5RL8Fxy2bpqvCIC2oM=;
	h=Date:To:From:Subject:From;
	b=h1WMVkbIIcuBRIjgLSDY9+8Iqbvjit9hZdNcZvZ+X5zggium/FMgZ819prwPBHUGs
	 NZMgskPqLXNz2HWIB8XQpI+7esdtX8VuGzWZe6cL3stP3Hy8ofaISP6L13oe5myh74
	 3wfN/8MHC8hGfsX0tEydFJHo0P1LdKgAZQKf5htk=
Date: Sun, 05 May 2024 17:58:10 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch removed from -mm tree
Message-Id: <20240506005811.484C1C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: convert hwpoison_user_mappings to take a folio
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory-failure: convert hwpoison_user_mappings to take a folio
Date: Fri, 12 Apr 2024 20:35:05 +0100

Pass the folio from the callers, and use it throughout instead of hpage. 
Saves dozens of calls to compound_head().

Link: https://lkml.kernel.org/r/20240412193510.2356957-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio
+++ a/mm/memory-failure.c
@@ -1559,24 +1559,24 @@ static int get_hwpoison_page(struct page
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
  */
-static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
-				  int flags, struct page *hpage)
+static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
+		unsigned long pfn, int flags)
 {
-	struct folio *folio = page_folio(hpage);
 	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC | TTU_HWPOISON;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success;
 	int forcekill;
-	bool mlocked = PageMlocked(hpage);
+	bool mlocked = folio_test_mlocked(folio);
 
 	/*
 	 * Here we are interested only in user-mapped pages, so skip any
 	 * other types of pages.
 	 */
-	if (PageReserved(p) || PageSlab(p) || PageTable(p) || PageOffline(p))
+	if (folio_test_reserved(folio) || folio_test_slab(folio) ||
+	    folio_test_pgtable(folio) || folio_test_offline(folio))
 		return true;
-	if (!(PageLRU(hpage) || PageHuge(p)))
+	if (!(folio_test_lru(folio) || folio_test_hugetlb(folio)))
 		return true;
 
 	/*
@@ -1586,7 +1586,7 @@ static bool hwpoison_user_mappings(struc
 	if (!page_mapped(p))
 		return true;
 
-	if (PageSwapCache(p)) {
+	if (folio_test_swapcache(folio)) {
 		pr_err("%#lx: keeping poisoned page in swap cache\n", pfn);
 		ttu &= ~TTU_HWPOISON;
 	}
@@ -1597,11 +1597,11 @@ static bool hwpoison_user_mappings(struc
 	 * XXX: the dirty test could be racy: set_page_dirty() may not always
 	 * be called inside page lock (it's recommended but not enforced).
 	 */
-	mapping = page_mapping(hpage);
-	if (!(flags & MF_MUST_KILL) && !PageDirty(hpage) && mapping &&
+	mapping = folio_mapping(folio);
+	if (!(flags & MF_MUST_KILL) && !folio_test_dirty(folio) && mapping &&
 	    mapping_can_writeback(mapping)) {
-		if (page_mkclean(hpage)) {
-			SetPageDirty(hpage);
+		if (folio_mkclean(folio)) {
+			folio_set_dirty(folio);
 		} else {
 			ttu &= ~TTU_HWPOISON;
 			pr_info("%#lx: corrupted page was clean: dropped without side effects\n",
@@ -1616,7 +1616,7 @@ static bool hwpoison_user_mappings(struc
 	 */
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
 
-	if (PageHuge(hpage) && !PageAnon(hpage)) {
+	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
 		/*
 		 * For hugetlb pages in shared mappings, try_to_unmap
 		 * could potentially call huge_pmd_unshare.  Because of
@@ -1656,7 +1656,7 @@ static bool hwpoison_user_mappings(struc
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	forcekill = PageDirty(hpage) || (flags & MF_MUST_KILL) ||
+	forcekill = folio_test_dirty(folio) || (flags & MF_MUST_KILL) ||
 		    !unmap_success;
 	kill_procs(&tokill, forcekill, !unmap_success, pfn, flags);
 
@@ -2100,7 +2100,7 @@ retry:
 
 	page_flags = folio->flags;
 
-	if (!hwpoison_user_mappings(p, pfn, flags, &folio->page)) {
+	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
 		folio_unlock(folio);
 		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 	}
@@ -2367,7 +2367,7 @@ try_again:
 	 * Now take care of user space mappings.
 	 * Abort on fail: __filemap_remove_folio() assumes unmapped page.
 	 */
-	if (!hwpoison_user_mappings(p, pfn, flags, p)) {
+	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
 		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		goto unlock_page;
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch


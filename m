Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702FE29D08
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957090; cv=none; b=QzHVr8TTHJsHat/EvZsf++p9wDSicxWi26emRdB9uJ8CUKknjRY53a7BfRVMRnEHZ82xgeIeAh2Rfnj+/NHvwMdYwY9yHGZkQSZd/4hwaqKJJ+87CGsEzHt6PnmiijkI9LAoiW120lrsWUIh5bJoFv0ul+9KFCuT5TQLIEts4RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957090; c=relaxed/simple;
	bh=lxAdsyTTgBVJvEC1rCvjpVEMju1DqcxHvhcK0BsmnJY=;
	h=Date:To:From:Subject:Message-Id; b=reSDvOWV9+uVpO9Hz7HSMQNKx9rRKNH7fO0KmI4sTrAo9OIKAD1pXufli7St5bqtER4P/fWHoXS9cMFZ2pH3DhHYYaoiEt6wqtHwKJJL8uEXIQzukSAFlm5kFgX+KJfosC18iqBzJNrLuv5mIl419CwomRPqlGoeGsiKlkNEEts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y5Sq5C8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y5Sq5C8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A93C113CC;
	Mon,  6 May 2024 00:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957090;
	bh=lxAdsyTTgBVJvEC1rCvjpVEMju1DqcxHvhcK0BsmnJY=;
	h=Date:To:From:Subject:From;
	b=Y5Sq5C8PbO8+ilWR8IyTGIJOUCpbMJBRgzTKSI7Xz6YtwWeF6v+LgcWgnAuKEoZWr
	 rEK9EUzePp3/l4ufaYZjMjiWnsd81wPCd5kh8w/9I6MTnSYZO+LzL6Tm5RqUFBNHzI
	 8E58nkijc3yiIYZZsw8JI8aJzrw0PNivuXmyyTFE=
Date: Sun, 05 May 2024 17:58:09 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-convert-memory_failure-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240506005810.48A93C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: convert memory_failure() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-convert-memory_failure-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory-failure: convert memory_failure() to use a folio
Date: Fri, 12 Apr 2024 20:35:04 +0100

Saves dozens of calls to compound_head().

Link: https://lkml.kernel.org/r/20240412193510.2356957-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-convert-memory_failure-to-use-a-folio
+++ a/mm/memory-failure.c
@@ -2189,7 +2189,7 @@ out:
 int memory_failure(unsigned long pfn, int flags)
 {
 	struct page *p;
-	struct page *hpage;
+	struct folio *folio;
 	struct dev_pagemap *pgmap;
 	int res = 0;
 	unsigned long page_flags;
@@ -2277,8 +2277,8 @@ try_again:
 		}
 	}
 
-	hpage = compound_head(p);
-	if (PageTransHuge(hpage)) {
+	folio = page_folio(p);
+	if (folio_test_large(folio)) {
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
@@ -2292,12 +2292,13 @@ try_again:
 		 * or unhandlable page.  The refcount is bumped iff the
 		 * page is a valid handlable page.
 		 */
-		SetPageHasHWPoisoned(hpage);
+		folio_set_has_hwpoisoned(folio);
 		if (try_to_split_thp_page(p) < 0) {
 			res = action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
 			goto unlock_mutex;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
+		folio = page_folio(p);
 	}
 
 	/*
@@ -2308,9 +2309,9 @@ try_again:
 	 * The check (unnecessarily) ignores LRU pages being isolated and
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
-	shake_page(p);
+	shake_folio(folio);
 
-	lock_page(p);
+	folio_lock(folio);
 
 	/*
 	 * We're only intended to deal with the non-Compound page here.
@@ -2318,11 +2319,11 @@ try_again:
 	 * race window. If this happens, we could try again to hopefully
 	 * handle the page next round.
 	 */
-	if (PageCompound(p)) {
+	if (folio_test_large(folio)) {
 		if (retry) {
 			ClearPageHWPoison(p);
-			unlock_page(p);
-			put_page(p);
+			folio_unlock(folio);
+			folio_put(folio);
 			flags &= ~MF_COUNT_INCREASED;
 			retry = false;
 			goto try_again;
@@ -2338,29 +2339,29 @@ try_again:
 	 * folio_remove_rmap_*() in try_to_unmap_one(). So to determine page
 	 * status correctly, we save a copy of the page flags at this time.
 	 */
-	page_flags = p->flags;
+	page_flags = folio->flags;
 
 	if (hwpoison_filter(p)) {
 		ClearPageHWPoison(p);
-		unlock_page(p);
-		put_page(p);
+		folio_unlock(folio);
+		folio_put(folio);
 		res = -EOPNOTSUPP;
 		goto unlock_mutex;
 	}
 
 	/*
-	 * __munlock_folio() may clear a writeback page's LRU flag without
-	 * page_lock. We need wait writeback completion for this page or it
-	 * may trigger vfs BUG while evict inode.
+	 * __munlock_folio() may clear a writeback folio's LRU flag without
+	 * the folio lock. We need to wait for writeback completion for this
+	 * folio or it may trigger a vfs BUG while evicting inode.
 	 */
-	if (!PageLRU(p) && !PageWriteback(p))
+	if (!folio_test_lru(folio) && !folio_test_writeback(folio))
 		goto identify_page_state;
 
 	/*
 	 * It's very difficult to mess with pages currently under IO
 	 * and in many cases impossible, so we just avoid it here.
 	 */
-	wait_on_page_writeback(p);
+	folio_wait_writeback(folio);
 
 	/*
 	 * Now take care of user space mappings.
@@ -2374,7 +2375,8 @@ try_again:
 	/*
 	 * Torn down by someone else?
 	 */
-	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
+	if (folio_test_lru(folio) && !folio_test_swapcache(folio) &&
+	    folio->mapping == NULL) {
 		res = action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED);
 		goto unlock_page;
 	}
@@ -2384,7 +2386,7 @@ identify_page_state:
 	mutex_unlock(&mf_mutex);
 	return res;
 unlock_page:
-	unlock_page(p);
+	folio_unlock(folio);
 unlock_mutex:
 	mutex_unlock(&mf_mutex);
 	return res;
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch


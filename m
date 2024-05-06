Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6173025757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957088; cv=none; b=dcvBeH/+6B0R6J8EuDTuYc02D3v9uRO3RXP1Ghf2EPqOnwNJ7wT+kmsNv6VJTGPtX+JKeRwtQABgG+vlOM1f785EdbJwm9qct9yMu6tRd2pbiZ4etizYku6JMZF2rxdUP7Q9E9R7uL1aX434umWOB+5vDO0ta2rIFF8DnJ7iauY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957088; c=relaxed/simple;
	bh=cAYhRg5EWZFn36gXVsBvAS2kacNPRmwW3EtuEm6KGSM=;
	h=Date:To:From:Subject:Message-Id; b=Tx/YA5jq5r6fiVJLEhi/dmWAZt5/WuSda1uYFjzKzPGGZDQoDOaHjjwWOecmXW9PkXwjlebu0XkOOXEcxJQQ2nr5JJJ+OxGRXHXV0Y0TAOY9cFuLvxqiK5ZbhUODF9+u4DozEM8qtge0+nESgQvBoZ7A3vhczKqecat2PI7/UHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jnEDoyDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jnEDoyDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38685C113CC;
	Mon,  6 May 2024 00:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957088;
	bh=cAYhRg5EWZFn36gXVsBvAS2kacNPRmwW3EtuEm6KGSM=;
	h=Date:To:From:Subject:From;
	b=jnEDoyDgz5JQdK/O/tx798/7c8yxm2YLQ/0GrRFvRgK/lTG3a3HBeZ0rKnrtRZsQg
	 eQKAZJTuO8TY5FYzDUZH4Dfb7pRfi+HEH/2KQlKbobuyTRuoyX4+3tlTaUJqlvTztp
	 sN55V+uKT97kFqH2dApbQ6ZOWy2bH0mQfN9SyD3k=
Date: Sun, 05 May 2024 17:58:07 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-convert-shake_page-to-shake_folio.patch removed from -mm tree
Message-Id: <20240506005808.38685C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: convert shake_page() to shake_folio()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-convert-shake_page-to-shake_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory-failure: convert shake_page() to shake_folio()
Date: Fri, 12 Apr 2024 20:35:02 +0100

Removes two calls to compound_head().  Move the prototype to internal.h;
we definitely don't want code outside mm using it.

Link: https://lkml.kernel.org/r/20240412193510.2356957-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    1 -
 mm/hwpoison-inject.c |   11 ++++++-----
 mm/internal.h        |    1 +
 mm/memory-failure.c  |   15 ++++++++++-----
 4 files changed, 17 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h~mm-memory-failure-convert-shake_page-to-shake_folio
+++ a/include/linux/mm.h
@@ -4033,7 +4033,6 @@ int mf_dax_kill_procs(struct address_spa
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue_kick(int cpu);
 extern int unpoison_memory(unsigned long pfn);
-extern void shake_page(struct page *p);
 extern atomic_long_t num_poisoned_pages __read_mostly;
 extern int soft_offline_page(unsigned long pfn, int flags);
 #ifdef CONFIG_MEMORY_FAILURE
--- a/mm/hwpoison-inject.c~mm-memory-failure-convert-shake_page-to-shake_folio
+++ a/mm/hwpoison-inject.c
@@ -15,7 +15,7 @@ static int hwpoison_inject(void *data, u
 {
 	unsigned long pfn = val;
 	struct page *p;
-	struct page *hpage;
+	struct folio *folio;
 	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -25,16 +25,17 @@ static int hwpoison_inject(void *data, u
 		return -ENXIO;
 
 	p = pfn_to_page(pfn);
-	hpage = compound_head(p);
+	folio = page_folio(p);
 
 	if (!hwpoison_filter_enable)
 		goto inject;
 
-	shake_page(hpage);
+	shake_folio(folio);
 	/*
 	 * This implies unable to support non-LRU pages except free page.
 	 */
-	if (!PageLRU(hpage) && !PageHuge(p) && !is_free_buddy_page(p))
+	if (!folio_test_lru(folio) && !folio_test_hugetlb(folio) &&
+	    !is_free_buddy_page(p))
 		return 0;
 
 	/*
@@ -42,7 +43,7 @@ static int hwpoison_inject(void *data, u
 	 * the targeted owner (or on a free page).
 	 * memory_failure() will redo the check reliably inside page lock.
 	 */
-	err = hwpoison_filter(hpage);
+	err = hwpoison_filter(&folio->page);
 	if (err)
 		return 0;
 
--- a/mm/internal.h~mm-memory-failure-convert-shake_page-to-shake_folio
+++ a/mm/internal.h
@@ -1037,6 +1037,7 @@ static inline int find_next_best_node(in
 /*
  * mm/memory-failure.c
  */
+void shake_folio(struct folio *folio);
 extern int hwpoison_filter(struct page *p);
 
 extern u32 hwpoison_filter_dev_major;
--- a/mm/memory-failure.c~mm-memory-failure-convert-shake_page-to-shake_folio
+++ a/mm/memory-failure.c
@@ -369,20 +369,25 @@ static int kill_proc(struct to_kill *tk,
  * Unknown page type encountered. Try to check whether it can turn PageLRU by
  * lru_add_drain_all.
  */
-void shake_page(struct page *p)
+void shake_folio(struct folio *folio)
 {
-	if (PageHuge(p))
+	if (folio_test_hugetlb(folio))
 		return;
 	/*
 	 * TODO: Could shrink slab caches here if a lightweight range-based
 	 * shrinker will be available.
 	 */
-	if (PageSlab(p))
+	if (folio_test_slab(folio))
 		return;
 
 	lru_add_drain_all();
 }
-EXPORT_SYMBOL_GPL(shake_page);
+EXPORT_SYMBOL_GPL(shake_folio);
+
+static void shake_page(struct page *page)
+{
+	shake_folio(page_folio(page));
+}
 
 static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
 		unsigned long address)
@@ -1639,7 +1644,7 @@ static bool hwpoison_user_mappings(struc
 	 * shake_page() again to ensure that it's flushed.
 	 */
 	if (mlocked)
-		shake_page(hpage);
+		shake_folio(folio);
 
 	/*
 	 * Now that the dirty bit has been propagated to the
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch


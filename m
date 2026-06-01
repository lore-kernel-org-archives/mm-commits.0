Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E5227BF79;
	Mon,  1 Jun 2026 04:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780289462; cv=none; b=HqQdQb+QF0eYdkHOXRt0v73BqkZZAvD3N3A92rLMu7uQsI+YBhQihwmI8C37Q0JvPsuoSh3Y9L+y4pEqDfwzpA8jYLQLecGzYBR+sfTkDfkLQv1Y3vqeipTeXrbbObqsS6x1KszV9rwt4OraxtrB4799lCTtxu2wbGd1IN2etvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780289462; c=relaxed/simple;
	bh=wHDSIy4U0YFtXI4GjT5RkPZpoV7AB7ooAPTLpoVR1aI=;
	h=Date:To:From:Subject:Message-Id; b=iGCLleFA2M5kEz/QblUKctnU1vnKgeB8EdasD+DbmRUEVe+SaoIrf2ZA02bYjd6UDZUpdg5qiRvYKeGH3y1QHDW55tp12wiz22IP5EI6fjNjb7yCTyX3La2HsSXZfH/uXDzBUrW7/CNEGnpfzYwVYLqE76amk1lldgDMyQYOhrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xLYecqbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xLYecqbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DBF1F00898;
	Mon,  1 Jun 2026 04:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780289461;
	bh=sUkj/hLAjN1XhZJ/LwAt8/JifKMopChP7k3jeWdiaO4=;
	h=Date:To:From:Subject;
	b=xLYecqbxiAy+FYBjTNr1VFxC6Q1qCQZfOgDPenIdHjXp1xbYzYiHSS21daz4xaKbo
	 eWdZwUbYNVm3Bu7fN5/6J63AQEVjkUleo1yIxbw9+OA5iuel979BX11ypuQBDgBq6U
	 7IRW32DmqLJ/3ljdgyyLGa1hbQYK7WjxxyF2RH+U=
Date: Sun, 31 May 2026 21:51:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@kernel.org,kas@kernel.org,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch removed from -mm tree
Message-Id: <20260601045101.72DBF1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_vmemmap: fix incorrect vmemmap restore in rollback
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb_vmemmap: fix incorrect vmemmap restore in rollback
Date: Mon, 25 May 2026 10:52:13 +0800

vmemmap_restore_pte() rebuilds restored vmemmap pages from a tail-page
template derived from compound_head().  This is wrong when the current PTE
already maps a page whose contents are not tail-page metadata.

In the rollback path of vmemmap_remap_free(), the first restored PTE is
backed by vmemmap_head and contains head-page metadata.  Reconstructing
that page from a tail-page template overwrites the head-page state and
corrupts the restored vmemmap page.

Fix this by copying the full page from the page currently mapped by the
PTE.  Also pass vmemmap_tail to the rollback walk so only PTEs backed by
the shared tail page are restored, while the head PTE remains mapped to
vmemmap_head.  Add VM_WARN_ON_ONCE() checks for unexpected cases.

Link: https://lore.kernel.org/20260525025213.2229628-1-songmuchun@bytedance.com
Fixes: c0b495b91a47 ("mm/hugetlb: refactor code around vmemmap_walk")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback
+++ a/mm/hugetlb_vmemmap.c
@@ -207,6 +207,8 @@ static void vmemmap_remap_pte(pte_t *pte
 
 	/* Remapping the head page requires r/w */
 	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
+		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
+
 		list_del(&walk->vmemmap_head->lru);
 
 		/*
@@ -218,6 +220,8 @@ static void vmemmap_remap_pte(pte_t *pte
 
 		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
 	} else {
+		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
+
 		/*
 		 * Remap the tail pages as read-only to catch illegal write
 		 * operation to the tail pages.
@@ -232,33 +236,28 @@ static void vmemmap_remap_pte(pte_t *pte
 static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 				struct vmemmap_remap_walk *walk)
 {
-	struct page *page;
-	struct page *from, *to;
-
-	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
-	list_del(&page->lru);
+	struct page *src = pte_page(ptep_get(pte)), *dst;
 
 	/*
-	 * Initialize tail pages in the newly allocated vmemmap page.
-	 *
-	 * There is folio-scope metadata that is encoded in the first few
-	 * tail pages.
-	 *
-	 * Use the value last tail page in the page with the head page
-	 * to initialize the rest of tail pages.
+	 * When rolling back vmemmap_remap_free(), keep the copied head page
+	 * mapping and restore only PTEs currently pointing at the shared tail
+	 * page.
 	 */
-	from = compound_head((struct page *)addr) +
-		PAGE_SIZE / sizeof(struct page) - 1;
-	to = page_to_virt(page);
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++, to++)
-		*to = *from;
+	if (walk->vmemmap_tail && walk->vmemmap_tail != src)
+		return;
+
+	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
+
+	dst = list_first_entry(walk->vmemmap_pages, struct page, lru);
+	list_del(&dst->lru);
+	copy_page(page_to_virt(dst), page_to_virt(src));
 
 	/*
 	 * Makes sure that preceding stores to the page contents become visible
 	 * before the set_pte_at() write.
 	 */
 	smp_wmb();
-	set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
+	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
 }
 
 /**
@@ -324,6 +323,7 @@ static int vmemmap_remap_free(unsigned l
 	 */
 	walk = (struct vmemmap_remap_walk) {
 		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= 0,
 	};
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch


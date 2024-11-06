Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF6A17B50B
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854758; cv=none; b=YYu9Ehda3QflvJBspklEhI7gqilXsTRjJArtI1q9UXytilWcG7Yx7mOFC/UBynlnMzLv5UtlLBFQzhMRmMoWJXN1CMYbBL1dmsousgQzh+gtLzH4jnyGoFGQP0lqqzDY1Aqn3SRuB8LqHmjp42NloeoRvqtCse+Hr00frLgjinc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854758; c=relaxed/simple;
	bh=x1pYTgRadDXgqqR0Pwt6UWe0AM/qqlZ/QLElJMs6GOw=;
	h=Date:To:From:Subject:Message-Id; b=QRZtHGvUoovleB1AN/wH1ERY8ytlLLiAdLXJhDxVcbre2VmMDa4oNmKFpMyHSjUI9r3culENb2W/ye9E9SIac5X5V5f2h0R1X0PwpUcYuLUfRtmr/nfWBXrk33uIK/w+/9B6BEoh1KJ5MaRHKyvAfCtZWhlu6Ku3jH7huq18uZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K5nFR8aw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K5nFR8aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66741C4CECF;
	Wed,  6 Nov 2024 00:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854758;
	bh=x1pYTgRadDXgqqR0Pwt6UWe0AM/qqlZ/QLElJMs6GOw=;
	h=Date:To:From:Subject:From;
	b=K5nFR8awHa2ZEq1xF3dDukDp7aCPosV9SbvoZIVH6B49jdzGSjyMv+kw6CrEaZ/Ef
	 LCraUJzA54W1y0oFfx8QXNxu3amtlbJRO0LVQc1bP0wY+SDrh5f/eX3XuVy+w50pRO
	 u4zBLlZPlZraL+/sCUnQAbzwH5QO6W9qiP9HgOCo=
Date: Tue, 05 Nov 2024 16:59:17 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,cuigaosheng1@huawei.com,alexs@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-convert-cmp_and_merge_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20241106005918.66741C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm: convert cmp_and_merge_page() to use a folio
has been removed from the -mm tree.  Its filename was
     ksm-convert-cmp_and_merge_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ksm: convert cmp_and_merge_page() to use a folio
Date: Wed, 2 Oct 2024 16:25:28 +0100

By making try_to_merge_two_pages() and stable_tree_search() return a
folio, we can replace kpage with kfolio.  This replaces 7 calls to
compound_head() with one.

[cuigaosheng1@huawei.com: add IS_ERR_OR_NULL check for stable_tree_search()]
  Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lkml.kernel.org/r/20241002152533.1350629-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   51 ++++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

--- a/mm/ksm.c~ksm-convert-cmp_and_merge_page-to-use-a-folio
+++ a/mm/ksm.c
@@ -1582,7 +1582,7 @@ out:
  * Note that this function upgrades page to ksm page: if one of the pages
  * is already a ksm page, try_to_merge_with_ksm_page should be used.
  */
-static struct page *try_to_merge_two_pages(struct ksm_rmap_item *rmap_item,
+static struct folio *try_to_merge_two_pages(struct ksm_rmap_item *rmap_item,
 					   struct page *page,
 					   struct ksm_rmap_item *tree_rmap_item,
 					   struct page *tree_page)
@@ -1600,7 +1600,7 @@ static struct page *try_to_merge_two_pag
 		if (err)
 			break_cow(rmap_item);
 	}
-	return err ? NULL : page;
+	return err ? NULL : page_folio(page);
 }
 
 static __always_inline
@@ -1787,9 +1787,9 @@ static __always_inline struct folio *cha
  * with identical content to the page that we are scanning right now.
  *
  * This function returns the stable tree node of identical content if found,
- * NULL otherwise.
+ * -EBUSY if the stable node's page is being migrated, NULL otherwise.
  */
-static struct page *stable_tree_search(struct page *page)
+static struct folio *stable_tree_search(struct page *page)
 {
 	int nid;
 	struct rb_root *root;
@@ -1804,7 +1804,7 @@ static struct page *stable_tree_search(s
 	if (page_node && page_node->head != &migrate_nodes) {
 		/* ksm page forked */
 		folio_get(folio);
-		return &folio->page;
+		return folio;
 	}
 
 	nid = get_kpfn_nid(folio_pfn(folio));
@@ -1899,7 +1899,7 @@ again:
 				folio_put(tree_folio);
 				goto replace;
 			}
-			return &tree_folio->page;
+			return tree_folio;
 		}
 	}
 
@@ -1913,7 +1913,7 @@ again:
 out:
 	if (is_page_sharing_candidate(page_node)) {
 		folio_get(folio);
-		return &folio->page;
+		return folio;
 	} else
 		return NULL;
 
@@ -1963,7 +1963,7 @@ replace:
 	}
 	stable_node_dup->head = &migrate_nodes;
 	list_add(&stable_node_dup->list, stable_node_dup->head);
-	return &folio->page;
+	return folio;
 
 chain_append:
 	/*
@@ -2217,7 +2217,7 @@ static void cmp_and_merge_page(struct pa
 	struct ksm_rmap_item *tree_rmap_item;
 	struct page *tree_page = NULL;
 	struct ksm_stable_node *stable_node;
-	struct page *kpage;
+	struct folio *kfolio;
 	unsigned int checksum;
 	int err;
 	bool max_page_sharing_bypass = false;
@@ -2259,31 +2259,32 @@ static void cmp_and_merge_page(struct pa
 			return;
 	}
 
-	/* We first start with searching the page inside the stable tree */
-	kpage = stable_tree_search(page);
-	if (kpage == page && rmap_item->head == stable_node) {
-		put_page(kpage);
+	/* Start by searching for the folio in the stable tree */
+	kfolio = stable_tree_search(page);
+	if (!IS_ERR_OR_NULL(kfolio) && &kfolio->page == page &&
+	    rmap_item->head == stable_node) {
+		folio_put(kfolio);
 		return;
 	}
 
 	remove_rmap_item_from_tree(rmap_item);
 
-	if (kpage) {
-		if (PTR_ERR(kpage) == -EBUSY)
+	if (kfolio) {
+		if (kfolio == ERR_PTR(-EBUSY))
 			return;
 
-		err = try_to_merge_with_ksm_page(rmap_item, page, kpage);
+		err = try_to_merge_with_ksm_page(rmap_item, page, &kfolio->page);
 		if (!err) {
 			/*
 			 * The page was successfully merged:
 			 * add its rmap_item to the stable tree.
 			 */
-			lock_page(kpage);
-			stable_tree_append(rmap_item, page_stable_node(kpage),
+			folio_lock(kfolio);
+			stable_tree_append(rmap_item, folio_stable_node(kfolio),
 					   max_page_sharing_bypass);
-			unlock_page(kpage);
+			folio_unlock(kfolio);
 		}
-		put_page(kpage);
+		folio_put(kfolio);
 		return;
 	}
 
@@ -2292,7 +2293,7 @@ static void cmp_and_merge_page(struct pa
 	if (tree_rmap_item) {
 		bool split;
 
-		kpage = try_to_merge_two_pages(rmap_item, page,
+		kfolio = try_to_merge_two_pages(rmap_item, page,
 						tree_rmap_item, tree_page);
 		/*
 		 * If both pages we tried to merge belong to the same compound
@@ -2307,20 +2308,20 @@ static void cmp_and_merge_page(struct pa
 		split = PageTransCompound(page)
 			&& compound_head(page) == compound_head(tree_page);
 		put_page(tree_page);
-		if (kpage) {
+		if (kfolio) {
 			/*
 			 * The pages were successfully merged: insert new
 			 * node in the stable tree and add both rmap_items.
 			 */
-			lock_page(kpage);
-			stable_node = stable_tree_insert(page_folio(kpage));
+			folio_lock(kfolio);
+			stable_node = stable_tree_insert(kfolio);
 			if (stable_node) {
 				stable_tree_append(tree_rmap_item, stable_node,
 						   false);
 				stable_tree_append(rmap_item, stable_node,
 						   false);
 			}
-			unlock_page(kpage);
+			folio_unlock(kfolio);
 
 			/*
 			 * If we fail to insert the page into the stable tree,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch
nilfs2-remove-nilfs_writepage.patch
nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch
nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch
nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E73215F7B
	for <mm-commits@vger.kernel.org>; Wed,  2 Oct 2024 20:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727902531; cv=none; b=gnpdbm3/4rRxhZSwSbnn/zmSRuQ5x6QlH4aQIkrRnr6GylwjbwhmBqVM6aE6FvVNpbZuAJnBSPP9iKXZWPr52EVAQE3JiuQSSPh/z6VXKxfFyVcsmFpiD7+kCMQ2/xlk/9oclxT4keu5pTxgEJ7Xf3KtdfWToVVreycRyqRK0vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727902531; c=relaxed/simple;
	bh=VF3O2i+Niugh3A/xfEoyqJaMUK/7R+CBTy1BSMBeFaA=;
	h=Date:To:From:Subject:Message-Id; b=NJZhoE/7QE1I/Ox5EkgVu7DFhqFqklwQ4ZnSUJ4iWbT9tT+fpX1/7njHZ7iAUo6U4zQJByu5EMk7V+dEmIFbG2X0lsaXiWVvwJgyLEDTSgBAA9ayiU3r+rV1DbfDEYMCtRbKkY0JbFNDn5RhqF417wsi/RLD8UozfnpeRtAVepE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jDCf1VS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jDCf1VS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A71C4CEC2;
	Wed,  2 Oct 2024 20:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727902531;
	bh=VF3O2i+Niugh3A/xfEoyqJaMUK/7R+CBTy1BSMBeFaA=;
	h=Date:To:From:Subject:From;
	b=jDCf1VS7Xes9qe0HF0Jpm1JMvoXSnakAMukgqXhncX54HbsJ0OYkQAV2Rb3VTHXZU
	 kZkyE6JEWkt5y5CS3sZoSbiQRZDma1kCwkBRIm8XMbB5FwuQEj1X4mYIjDJdDztMBe
	 1Uov2/SRjTbax4E1YyK+oK0cHvaZYUwRZ284mDFk=
Date: Wed, 02 Oct 2024 13:55:30 -0700
To: mm-commits@vger.kernel.org,alexs@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-convert-cmp_and_merge_page-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20241002205530.E3A71C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: convert cmp_and_merge_page() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-convert-cmp_and_merge_page-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-convert-cmp_and_merge_page-to-use-a-folio.patch

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
Subject: ksm: convert cmp_and_merge_page() to use a folio
Date: Wed, 2 Oct 2024 16:25:28 +0100

By making try_to_merge_two_pages() and stable_tree_search() return a
folio, we can replace kpage with kfolio.  This replaces 7 calls to
compound_head() with one.

Link: https://lkml.kernel.org/r/20241002152533.1350629-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alex Shi <alexs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

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
@@ -1789,7 +1789,7 @@ static __always_inline struct folio *cha
  * This function returns the stable tree node of identical content if found,
  * NULL otherwise.
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
@@ -2259,31 +2259,31 @@ static void cmp_and_merge_page(struct pa
 			return;
 	}
 
-	/* We first start with searching the page inside the stable tree */
-	kpage = stable_tree_search(page);
-	if (kpage == page && rmap_item->head == stable_node) {
-		put_page(kpage);
+	/* Start by searching for the folio in the stable tree */
+	kfolio = stable_tree_search(page);
+	if (&kfolio->page == page && rmap_item->head == stable_node) {
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
 
@@ -2292,7 +2292,7 @@ static void cmp_and_merge_page(struct pa
 	if (tree_rmap_item) {
 		bool split;
 
-		kpage = try_to_merge_two_pages(rmap_item, page,
+		kfolio = try_to_merge_two_pages(rmap_item, page,
 						tree_rmap_item, tree_page);
 		/*
 		 * If both pages we tried to merge belong to the same compound
@@ -2307,20 +2307,20 @@ static void cmp_and_merge_page(struct pa
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

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-remove-pageksm.patch


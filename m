Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C45376026
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 20:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724532131; cv=none; b=jqrIIgESHann6AM0wtjKg5u3DqCu7WlaAlst1PyySIrq6XCT+OVJ/7aLRjZiQnOyDaGxJaA+7xSyt7NQfkarR5x7+JJbhF4rLCN7K2Wh5DaV5fpBo8jpBfpBD7qH4aRxjVtCB9aWS/Y3PzaYOt5RANwShCdUIP46fKBzODXxHn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724532131; c=relaxed/simple;
	bh=e8X/4LpX7dDuNKOqJaReTZxRjY74UDLSYHzNYqawcic=;
	h=Date:To:From:Subject:Message-Id; b=YeOYmZd21q65fx017MAEmmveUZOkQmBOz7W0gmOIeay3mvULP93Rq0spPeTfWUaD6wBvSFAylv6ZcuhVh7OO7upvLTbM5S9dkateLTumjg3/cbYzOfscxqHo7dxWKrkL/p47UQmDfdybM8dE4tMcU/gl91HTzXrMz29k0gIE+5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dYMoXFof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dYMoXFof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6F8C32781;
	Sat, 24 Aug 2024 20:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724532130;
	bh=e8X/4LpX7dDuNKOqJaReTZxRjY74UDLSYHzNYqawcic=;
	h=Date:To:From:Subject:From;
	b=dYMoXFofawh7oCP1IwvWWKczA0vzlPC3pS4r3MedZyqEbxMfgmMM/sN8XxgcHLXlo
	 NP2Cuu0uXzRguPTRDDTm+oQ+pCoSOroR5C5pyLXFh29W82jbsMn6E/nlV8pd3opSY9
	 z1nrr7bBRKocZl5UZSz96Bt22DgXexXbfvSyd5fU=
Date: Sat, 24 Aug 2024 13:42:09 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,justinjiang@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] vma-remove-the-unneeded-avc-bound-with-non-cowed-folio.patch removed from -mm tree
Message-Id: <20240824204210.8C6F8C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vma remove the unneeded avc bound with non-CoWed folio
has been removed from the -mm tree.  Its filename was
     vma-remove-the-unneeded-avc-bound-with-non-cowed-folio.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Zhiguo Jiang <justinjiang@vivo.com>
Subject: vma remove the unneeded avc bound with non-CoWed folio
Date: Fri, 23 Aug 2024 23:02:06 +0800

After CoWed by do_wp_page, the vma established a new mapping relationship
with the CoWed folio instead of the non-CoWed folio.  However, regarding
the situation where vma->anon_vma and the non-CoWed folio's anon_vma are
not same, the avc binding relationship between them will no longer be
needed, so it is issue for the avc binding relationship still existing
between them.

This patch will remove the avc binding relationship between vma and the
non-CoWed folio's anon_vma, which each has their own independent anon_vma.
It can also alleviates rmap overhead simultaneously.

Link: https://lkml.kernel.org/r/20240823150206.565-1-justinjiang@vivo.com
Signed-off-by: Zhiguo Jiang <justinjiang@vivo.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 
 mm/memory.c          |    8 ++++++
 mm/rmap.c            |   53 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)

--- a/include/linux/rmap.h~vma-remove-the-unneeded-avc-bound-with-non-cowed-folio
+++ a/include/linux/rmap.h
@@ -257,6 +257,7 @@ void folio_remove_rmap_ptes(struct folio
 	folio_remove_rmap_ptes(folio, page, 1, vma)
 void folio_remove_rmap_pmd(struct folio *, struct page *,
 		struct vm_area_struct *);
+void folio_remove_anon_avc(struct folio *, struct vm_area_struct *);
 
 void hugetlb_add_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
--- a/mm/memory.c~vma-remove-the-unneeded-avc-bound-with-non-cowed-folio
+++ a/mm/memory.c
@@ -3428,6 +3428,14 @@ static vm_fault_t wp_page_copy(struct vm
 			 * old page will be flushed before it can be reused.
 			 */
 			folio_remove_rmap_pte(old_folio, vmf->page, vma);
+
+			/*
+			 * If the new_folio's anon_vma is different from the
+			 * old_folio's anon_vma, the avc binding relationship
+			 * between vma and the old_folio's anon_vma is removed,
+			 * avoiding rmap redundant overhead.
+			 */
+			folio_remove_anon_avc(old_folio, vma);
 		}
 
 		/* Free the old page.. */
--- a/mm/rmap.c~vma-remove-the-unneeded-avc-bound-with-non-cowed-folio
+++ a/mm/rmap.c
@@ -1522,6 +1522,59 @@ void folio_add_file_rmap_pmd(struct foli
 #endif
 }
 
+/**
+ * folio_remove_anon_avc - remove the avc binding relationship between
+ * folio and vma with different anon_vmas.
+ * @folio:	The folio with anon_vma to remove the binded avc from
+ * @vma:	The vm area to remove the binded avc with folio's anon_vma
+ *
+ * The caller is currently used for CoWed scene.
+ */
+void folio_remove_anon_avc(struct folio *folio,
+		struct vm_area_struct *vma)
+{
+	struct anon_vma *anon_vma = folio_anon_vma(folio);
+	pgoff_t pgoff_start, pgoff_end;
+	struct anon_vma_chain *avc;
+
+	/*
+	 * Ensure that the vma's anon_vma and the folio's
+	 * anon_vma exist and are not same.
+	 */
+	if (!folio_test_anon(folio) || unlikely(!anon_vma) ||
+	    anon_vma == vma->anon_vma)
+		return;
+
+	pgoff_start = folio_pgoff(folio);
+	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
+
+	if (!anon_vma_trylock_write(anon_vma))
+		return;
+
+	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
+			pgoff_start, pgoff_end) {
+		/*
+		 * Find the avc associated with vma from the folio's
+		 * anon_vma and remove it.
+		 */
+		if (avc->vma == vma) {
+			anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+			/*
+			 * When removing the avc with anon_vma that is
+			 * different from the parent anon_vma from parent
+			 * anon_vma->rb_root, the parent num_children
+			 * count value is needed to reduce one.
+			 */
+			anon_vma->num_children--;
+
+			list_del(&avc->same_vma);
+			anon_vma_chain_free(avc);
+			break;
+		}
+	}
+	anon_vma_unlock_write(anon_vma);
+}
+
 static __always_inline void __folio_remove_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		enum rmap_level level)
_

Patches currently in -mm which might be from justinjiang@vivo.com are

mm-shrink-skip-folio-mapped-by-an-exiting-process.patch


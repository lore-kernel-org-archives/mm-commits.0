Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB9A23E356
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343282; cv=none; b=Pcy25ZDp+0Bra7yNvAk27s8FTjM9Bus9LSrY2mIAs2XYzadBHTrnpMhR26pMPt+iaFN855uzNcyRRAJTo8jzw5pq8OO0eTGYMpDIalQai+2IBUEx+JXAtYC8YOBEY4zL5gM5faq8dNhuS+Z/GuXvsnpCWQXrSbmud86h1mE5KnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343282; c=relaxed/simple;
	bh=JUxvMXf0YS4Z+zZ8S/iz0y0EfudSRAPK/vjkQ02rkxs=;
	h=Date:To:From:Subject:Message-Id; b=OXfroHbnC3gK+Ee3A0CCRP3bNtyTEz0+uRZTBLYeZz/mHBXG7JIbzydVyl6HsOlLT5rZXbzZ1ISdeN9ANHR3pyqydi3WBJ8zG52RVUBgnboiA7Vc3w1329dhzVRybJFll8DMAsFL1htyEDD4Fmo0+2JcEQcHgxCg7YftG4uZ1Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yvUQ72aR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yvUQ72aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450C0C4CEF1;
	Mon, 17 Nov 2025 01:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343282;
	bh=JUxvMXf0YS4Z+zZ8S/iz0y0EfudSRAPK/vjkQ02rkxs=;
	h=Date:To:From:Subject:From;
	b=yvUQ72aRF+ovn11uqFYFNAoXDvJXaCfqeEQZNwelq1iyuFDnOmTddGzJUyYwsW7v/
	 XCGOwpjYVPSpCGDixRaeYNC5o9wDrnyPx7zS+8R7qQWMrM+rm3+SfUqF9MqtazcLb0
	 goD7YvPLRYJcrpZhy6nhLgo0RnSz3CwFSIbYYlCw=
Date: Sun, 16 Nov 2025 17:34:41 -0800
To: mm-commits@vger.kernel.org,david@kernel.org,pedrodemargomes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-replace-function-unmerge_ksm_pages-with-break_ksm.patch removed from -mm tree
Message-Id: <20251117013442.450C0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm: replace function unmerge_ksm_pages with break_ksm
has been removed from the -mm tree.  Its filename was
     ksm-replace-function-unmerge_ksm_pages-with-break_ksm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: ksm: replace function unmerge_ksm_pages with break_ksm
Date: Wed, 5 Nov 2025 15:49:12 -0300

Function unmerge_ksm_pages() is unnecessary since now break_ksm() walks an
address range.  So replace it with break_ksm().

Link: https://lkml.kernel.org/r/20251105184912.186329-4-pedrodemargomes@gmail.com
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

--- a/mm/ksm.c~ksm-replace-function-unmerge_ksm_pages-with-break_ksm
+++ a/mm/ksm.c
@@ -665,6 +665,18 @@ static const struct mm_walk_ops break_ks
 };
 
 /*
+ * Though it's very tempting to unmerge rmap_items from stable tree rather
+ * than check every pte of a given vma, the locking doesn't quite work for
+ * that - an rmap_item is assigned to the stable tree after inserting ksm
+ * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
+ * rmap_items from parent to child at fork time (so as not to waste time
+ * if exit comes before the next scan reaches it).
+ *
+ * Similarly, although we'd like to remove rmap_items (so updating counts
+ * and freeing memory) when unmerging an area, it's easier to leave that
+ * to the next pass of ksmd - consider, for example, how ksmd might be
+ * in cmp_and_merge_page on one of the rmap_items we would be removing.
+ *
  * We use break_ksm to break COW on a ksm page by triggering unsharing,
  * such that the ksm page will get replaced by an exclusive anonymous page.
  *
@@ -1071,25 +1083,6 @@ static void remove_trailing_rmap_items(s
 	}
 }
 
-/*
- * Though it's very tempting to unmerge rmap_items from stable tree rather
- * than check every pte of a given vma, the locking doesn't quite work for
- * that - an rmap_item is assigned to the stable tree after inserting ksm
- * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
- * rmap_items from parent to child at fork time (so as not to waste time
- * if exit comes before the next scan reaches it).
- *
- * Similarly, although we'd like to remove rmap_items (so updating counts
- * and freeing memory) when unmerging an area, it's easier to leave that
- * to the next pass of ksmd - consider, for example, how ksmd might be
- * in cmp_and_merge_page on one of the rmap_items we would be removing.
- */
-static int unmerge_ksm_pages(struct vm_area_struct *vma,
-			     unsigned long start, unsigned long end, bool lock_vma)
-{
-	return break_ksm(vma, start, end, lock_vma);
-}
-
 static inline
 struct ksm_stable_node *folio_stable_node(const struct folio *folio)
 {
@@ -1227,8 +1220,7 @@ static int unmerge_and_remove_all_rmap_i
 		for_each_vma(vmi, vma) {
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
-			err = unmerge_ksm_pages(vma,
-						vma->vm_start, vma->vm_end, false);
+			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
 			if (err)
 				goto error;
 		}
@@ -2855,7 +2847,7 @@ static int __ksm_del_vma(struct vm_area_
 		return 0;
 
 	if (vma->anon_vma) {
-		err = unmerge_ksm_pages(vma, vma->vm_start, vma->vm_end, true);
+		err = break_ksm(vma, vma->vm_start, vma->vm_end, true);
 		if (err)
 			return err;
 	}
@@ -3007,7 +2999,7 @@ int ksm_madvise(struct vm_area_struct *v
 			return 0;		/* just ignore the advice */
 
 		if (vma->anon_vma) {
-			err = unmerge_ksm_pages(vma, start, end, true);
+			err = break_ksm(vma, start, end, true);
 			if (err)
 				return err;
 		}
@@ -3389,7 +3381,7 @@ static int ksm_memory_callback(struct no
 		 * Prevent ksm_do_scan(), unmerge_and_remove_all_rmap_items()
 		 * and remove_all_stable_nodes() while memory is going offline:
 		 * it is unsafe for them to touch the stable tree at this time.
-		 * But unmerge_ksm_pages(), rmap lookups and other entry points
+		 * But break_ksm(), rmap lookups and other entry points
 		 * which do not need the ksm_thread_mutex are all safe.
 		 */
 		mutex_lock(&ksm_thread_mutex);
_

Patches currently in -mm which might be from pedrodemargomes@gmail.com are



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AB22FFFAC
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 20:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761944207; cv=none; b=R5fs3vI1UAzlm2EU3lvdtGdewbfSb/4E6okKKnYep/Z3vgEH4tet5/Im9pQndylwvAFepCESKtiDNBM3xVSolZOLfYpQIGv4NG48GWdNzdID8b3+Wug2nxm0NLone4lDADJvCxJjmUDmP2USMYbXYgZrn1xoMkDDoCPMiP/X1yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761944207; c=relaxed/simple;
	bh=uQbJlOTePxe8TTeyBFOoAEtOJ6HQNIW2eDbRz4BnSac=;
	h=Date:To:From:Subject:Message-Id; b=LmqdTHUEF7rQBDQS+id674w6MR6yiKUWJSoDIk/rEjB85xvRVjkGSoukXB6yfAb/fAVtDeTQEcm/BiyeoJ2VJx0GxhEhb2EVmJFoWMWlkGkBFB0hUsN/Jl8rCkUBcpFx2PTKlKC9g94utXQmyhkIhN/IbLxZrrsSb5HoKTlOUrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=so5Ko9Mr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="so5Ko9Mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A78C4CEE7;
	Fri, 31 Oct 2025 20:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761944207;
	bh=uQbJlOTePxe8TTeyBFOoAEtOJ6HQNIW2eDbRz4BnSac=;
	h=Date:To:From:Subject:From;
	b=so5Ko9MrR801IiYpvHBciWdhQS37cUag1rX5Z4B2Iip6+lTIUU3LSZcmU/7+FoqEC
	 zLsPNwe5Qsp6ym/PR/uVXqyWkiEqPJfaqHkYdnS1SqLaRXa+R4UopmogyXPbw2Qziw
	 dL9ZU/nXSXUqfmMS0ligtEeVbr3+rbP+bqkZ/qzg=
Date: Fri, 31 Oct 2025 13:56:46 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,david@redhat.com,chengming.zhou@linux.dev,pedrodemargomes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-replace-function-unmerge_ksm_pages-with-break_ksm.patch added to mm-new branch
Message-Id: <20251031205647.27A78C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: replace function unmerge_ksm_pages with break_ksm
has been added to the -mm mm-new branch.  Its filename is
     ksm-replace-function-unmerge_ksm_pages-with-break_ksm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-replace-function-unmerge_ksm_pages-with-break_ksm.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: ksm: replace function unmerge_ksm_pages with break_ksm
Date: Fri, 31 Oct 2025 14:46:25 -0300

Function unmerge_ksm_pages() is unnecessary since now break_ksm() walks an
address range.  So replace it with break_ksm().

Link: https://lkml.kernel.org/r/20251031174625.127417-4-pedrodemargomes@gmail.com
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

--- a/mm/ksm.c~ksm-replace-function-unmerge_ksm_pages-with-break_ksm
+++ a/mm/ksm.c
@@ -669,6 +669,18 @@ static const struct mm_walk_ops break_ks
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
@@ -1075,25 +1087,6 @@ static void remove_trailing_rmap_items(s
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
@@ -1231,8 +1224,7 @@ static int unmerge_and_remove_all_rmap_i
 		for_each_vma(vmi, vma) {
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
-			err = unmerge_ksm_pages(vma,
-						vma->vm_start, vma->vm_end, false);
+			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
 			if (err)
 				goto error;
 		}
@@ -2859,7 +2851,7 @@ static int __ksm_del_vma(struct vm_area_
 		return 0;
 
 	if (vma->anon_vma) {
-		err = unmerge_ksm_pages(vma, vma->vm_start, vma->vm_end, true);
+		err = break_ksm(vma, vma->vm_start, vma->vm_end, true);
 		if (err)
 			return err;
 	}
@@ -3011,7 +3003,7 @@ int ksm_madvise(struct vm_area_struct *v
 			return 0;		/* just ignore the advice */
 
 		if (vma->anon_vma) {
-			err = unmerge_ksm_pages(vma, start, end, true);
+			err = break_ksm(vma, start, end, true);
 			if (err)
 				return err;
 		}
@@ -3393,7 +3385,7 @@ static int ksm_memory_callback(struct no
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

ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item.patch
revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch
ksm-perform-a-range-walk-in-break_ksm.patch
ksm-replace-function-unmerge_ksm_pages-with-break_ksm.patch


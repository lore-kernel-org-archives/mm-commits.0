Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11ACEC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbjDFCs4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbjDFCru (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:47:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358BBA26D
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D30DF64217
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F8AC433EF;
        Thu,  6 Apr 2023 02:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749137;
        bh=Gq2xbz7N5TWXWPXbFO3AiOnBJ+P9R/55Q5s2QLOhdh8=;
        h=Date:To:From:Subject:From;
        b=vRUALWK84eVIKWBUst9kO+/jr3UsGgZzldG041UaVo7eKxHxJ0unqvRs4Q9zAJSMa
         Ib0hvM7sLmuSK9HnPYBs55D126ayZQqNXQXOGb2SVirtyueQuuJjANWGinWN8/tssz
         Ji3s3zIbJSOlYSPULzr5gT43/H/1Bd3yUNRXTuKY=
Date:   Wed, 05 Apr 2023 19:45:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vernon2gm@gmail.com, vbabka@suse.cz, liam.howlett@oracle.com,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-vma_merge-further-improve-prev-next-vma-naming.patch removed from -mm tree
Message-Id: <20230406024537.39F8AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: further improve prev/next VMA naming
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-further-improve-prev-next-vma-naming.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/mmap/vma_merge: further improve prev/next VMA naming
Date: Tue, 21 Mar 2023 20:45:55 +0000

Patch series "further cleanup of vma_merge()", v2.

Following on from Vlastimil Babka's patch series "cleanup vma_merge() and
improve mergeability tests" which was in turn based on Liam's prior
cleanups, this patch series introduces changes discussed in review of
Vlastimil's series and goes further in attempting to make the logic as
clear as possible.

Nearly all of this should have absolutely no functional impact, however it
does add a singular VM_WARN_ON() case.

With many thanks to Vernon for helping kick start the discussion around
simplification - abstract use of vma did indeed turn out not to be
necessary - and to Liam for his excellent suggestions which greatly
simplified things.


This patch (of 4):

Previously the ASCII diagram above vma_merge() and the accompanying
variable naming was rather confusing, however recent efforts by Liam
Howlett and Vlastimil Babka have significantly improved matters.

This patch goes a little further - replacing 'X' with 'N' which feels a
lot more natural and replacing what was 'N' with 'C' which stands for
'concurrent' VMA.

No word quite describes a VMA that has coincident start as the input span,
concurrent, abbreviated to 'curr' (and which can be thought of also as
'current') however fits intuitions well alongside prev and next.

This has no functional impact.

Link: https://lkml.kernel.org/r/cover.1679431180.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/6001e08fa7e119470cbb1d2b6275ad8d742ff9a7.1679431180.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   86 ++++++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-further-improve-prev-next-vma-naming
+++ a/mm/mmap.c
@@ -848,44 +848,44 @@ can_vma_merge_after(struct vm_area_struc
  * this area are about to be changed to vm_flags - and the no-change
  * case has already been eliminated.
  *
- * The following mprotect cases have to be considered, where AAAA is
+ * The following mprotect cases have to be considered, where **** is
  * the area passed down from mprotect_fixup, never extending beyond one
- * vma, PPPP is the previous vma, NNNN is a vma that starts at the same
- * address as AAAA and is of the same or larger span, and XXXX the next
- * vma after AAAA:
+ * vma, PPPP is the previous vma, CCCC is a concurrent vma that starts
+ * at the same address as **** and is of the same or larger span, and
+ * NNNN the next vma after ****:
  *
- *     AAAA             AAAA                   AAAA
- *    PPPPPPXXXXXX    PPPPPPXXXXXX       PPPPPPNNNNNN
+ *     ****             ****                   ****
+ *    PPPPPPNNNNNN    PPPPPPNNNNNN       PPPPPPCCCCCC
  *    cannot merge    might become       might become
- *                    PPXXXXXXXXXX       PPPPPPPPPPNN
+ *                    PPNNNNNNNNNN       PPPPPPPPPPCC
  *    mmap, brk or    case 4 below       case 5 below
  *    mremap move:
- *                        AAAA               AAAA
- *                    PPPP    XXXX       PPPPNNNNXXXX
+ *                        ****               ****
+ *                    PPPP    NNNN       PPPPCCCCNNNN
  *                    might become       might become
  *                    PPPPPPPPPPPP 1 or  PPPPPPPPPPPP 6 or
- *                    PPPPPPPPXXXX 2 or  PPPPPPPPXXXX 7 or
- *                    PPPPXXXXXXXX 3     PPPPXXXXXXXX 8
+ *                    PPPPPPPPNNNN 2 or  PPPPPPPPNNNN 7 or
+ *                    PPPPNNNNNNNN 3     PPPPNNNNNNNN 8
  *
- * It is important for case 8 that the vma NNNN overlapping the
- * region AAAA is never going to extended over XXXX. Instead XXXX must
- * be extended in region AAAA and NNNN must be removed. This way in
+ * It is important for case 8 that the vma CCCC overlapping the
+ * region **** is never going to extended over NNNN. Instead NNNN must
+ * be extended in region **** and CCCC must be removed. This way in
  * all cases where vma_merge succeeds, the moment vma_merge drops the
  * rmap_locks, the properties of the merged vma will be already
  * correct for the whole merged range. Some of those properties like
  * vm_page_prot/vm_flags may be accessed by rmap_walks and they must
  * be correct for the whole merged range immediately after the
- * rmap_locks are released. Otherwise if XXXX would be removed and
- * NNNN would be extended over the XXXX range, remove_migration_ptes
+ * rmap_locks are released. Otherwise if NNNN would be removed and
+ * CCCC would be extended over the NNNN range, remove_migration_ptes
  * or other rmap walkers (if working on addresses beyond the "end"
- * parameter) may establish ptes with the wrong permissions of NNNN
- * instead of the right permissions of XXXX.
+ * parameter) may establish ptes with the wrong permissions of CCCC
+ * instead of the right permissions of NNNN.
  *
  * In the code below:
  * PPPP is represented by *prev
- * NNNN is represented by *mid or not represented at all (NULL)
- * XXXX is represented by *next or not represented at all (NULL)
- * AAAA is not represented - it will be merged and the vma containing the
+ * CCCC is represented by *curr or not represented at all (NULL)
+ * NNNN is represented by *next or not represented at all (NULL)
+ * **** is not represented - it will be merged and the vma containing the
  *      area is returned, or the function will return NULL
  */
 struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
@@ -898,7 +898,7 @@ struct vm_area_struct *vma_merge(struct
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	pgoff_t vma_pgoff;
-	struct vm_area_struct *mid, *next, *res = NULL;
+	struct vm_area_struct *curr, *next, *res = NULL;
 	struct vm_area_struct *vma, *adjust, *remove, *remove2;
 	int err = -1;
 	bool merge_prev = false;
@@ -917,19 +917,19 @@ struct vm_area_struct *vma_merge(struct
 	if (vm_flags & VM_SPECIAL)
 		return NULL;
 
-	mid = find_vma(mm, prev ? prev->vm_end : 0);
-	if (mid && mid->vm_end == end)			/* cases 6, 7, 8 */
-		next = find_vma(mm, mid->vm_end);
+	curr = find_vma(mm, prev ? prev->vm_end : 0);
+	if (curr && curr->vm_end == end)		/* cases 6, 7, 8 */
+		next = find_vma(mm, curr->vm_end);
 	else
-		next = mid;
+		next = curr;
 
-	/* In cases 1 - 4 there's no NNNN vma */
-	if (mid && end <= mid->vm_start)
-		mid = NULL;
+	/* In cases 1 - 4 there's no CCCC vma */
+	if (curr && end <= curr->vm_start)
+		curr = NULL;
 
 	/* verify some invariant that must be enforced by the caller */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
-	VM_WARN_ON(mid && end > mid->vm_end);
+	VM_WARN_ON(curr && end > curr->vm_end);
 	VM_WARN_ON(addr >= end);
 
 	if (prev) {
@@ -961,21 +961,21 @@ struct vm_area_struct *vma_merge(struct
 		remove = next;				/* case 1 */
 		vma_end = next->vm_end;
 		err = dup_anon_vma(prev, next);
-		if (mid) {				/* case 6 */
-			remove = mid;
+		if (curr) {				/* case 6 */
+			remove = curr;
 			remove2 = next;
 			if (!next->anon_vma)
-				err = dup_anon_vma(prev, mid);
+				err = dup_anon_vma(prev, curr);
 		}
 	} else if (merge_prev) {
 		err = 0;				/* case 2 */
-		if (mid) {
-			err = dup_anon_vma(prev, mid);
-			if (end == mid->vm_end) {	/* case 7 */
-				remove = mid;
+		if (curr) {
+			err = dup_anon_vma(prev, curr);
+			if (end == curr->vm_end) {	/* case 7 */
+				remove = curr;
 			} else {			/* case 5 */
-				adjust = mid;
-				adj_start = (end - mid->vm_start);
+				adjust = curr;
+				adj_start = (end - curr->vm_start);
 			}
 		}
 	} else if (merge_next) {
@@ -991,10 +991,10 @@ struct vm_area_struct *vma_merge(struct
 			vma_end = next->vm_end;
 			vma_pgoff = next->vm_pgoff;
 			err = 0;
-			if (mid) {			/* case 8 */
-				vma_pgoff = mid->vm_pgoff;
-				remove = mid;
-				err = dup_anon_vma(next, mid);
+			if (curr) {			/* case 8 */
+				vma_pgoff = curr->vm_pgoff;
+				remove = curr;
+				err = dup_anon_vma(next, curr);
 			}
 		}
 	}
_

Patches currently in -mm which might be from lstoakes@gmail.com are



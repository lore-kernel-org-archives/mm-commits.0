Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354D0C77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbjDFCpX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbjDFCo4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746368A5A
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA03364266
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E751C433D2;
        Thu,  6 Apr 2023 02:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749094;
        bh=wndE/XIl5c4v+wavy0VTOAOTn41EQPIy7g/raNeUFpM=;
        h=Date:To:From:Subject:From;
        b=I6kWC6wgFNe1xW5Wh7UxqAIQ3Iqyz/Ip7ygzbydT0D9I5fcumDCDkIICppPlDOofW
         yoocS5dpNgZRE1LefjZdT1l49RX1UgMvYhPTzX1bghCr6qSFMxFU223nxzS530c5HL
         mgqcpy2Gczkb2D7GMa5JYYZgLN1/AlaAtzy7f5SI=
Date:   Wed, 05 Apr 2023 19:44:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch removed from -mm tree
Message-Id: <20230406024454.4E751C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: set mid to NULL if not applicable
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mmap/vma_merge: set mid to NULL if not applicable
Date: Thu, 9 Mar 2023 12:12:54 +0100

There are several places where we test if 'mid' is really the area NNNN in
the diagram and the tests have two variants and are non-obvious to follow.
Instead, set 'mid' to NULL up-front if it's not the NNNN area, and
simplify the tests.

Also update the description in comment accordingly.

[vbabka@suse.cz: adjust/add comments as suggested by Lorenzo]
  Link: https://lkml.kernel.org/r/def43190-53f7-a607-d1b0-b657565f4288@suse.cz
Link: https://lkml.kernel.org/r/20230309111258.24079-7-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-set-mid-to-null-if-not-applicable
+++ a/mm/mmap.c
@@ -848,10 +848,12 @@ can_vma_merge_after(struct vm_area_struc
  *
  * The following mprotect cases have to be considered, where AAAA is
  * the area passed down from mprotect_fixup, never extending beyond one
- * vma, PPPPPP is the prev vma specified, and NNNNNN the next vma after:
+ * vma, PPPP is the previous vma, NNNN is a vma that starts at the same
+ * address as AAAA and is of the same or larger span, and XXXX the next
+ * vma after AAAA:
  *
  *     AAAA             AAAA                   AAAA
- *    PPPPPPNNNNNN    PPPPPPXXXXXX       PPPPPPNNNNNN
+ *    PPPPPPXXXXXX    PPPPPPXXXXXX       PPPPPPNNNNNN
  *    cannot merge    might become       might become
  *                    PPXXXXXXXXXX       PPPPPPPPPPNN
  *    mmap, brk or    case 4 below       case 5 below
@@ -879,9 +881,10 @@ can_vma_merge_after(struct vm_area_struc
  *
  * In the code below:
  * PPPP is represented by *prev
- * NNNN is represented by *mid (and possibly equal to *next)
- * XXXX is represented by *next or not represented at all.
- * AAAA is not represented - it will be merged or the function will return NULL
+ * NNNN is represented by *mid or not represented at all (NULL)
+ * XXXX is represented by *next or not represented at all (NULL)
+ * AAAA is not represented - it will be merged and the vma containing the
+ *      area is returned, or the function will return NULL
  */
 struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
 			struct vm_area_struct *prev, unsigned long addr,
@@ -918,6 +921,10 @@ struct vm_area_struct *vma_merge(struct
 	else
 		next = mid;
 
+	/* In cases 1 - 4 there's no NNNN vma */
+	if (mid && end <= mid->vm_start)
+		mid = NULL;
+
 	/* verify some invariant that must be enforced by the caller */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
 	VM_WARN_ON(mid && end > mid->vm_end);
@@ -952,7 +959,7 @@ struct vm_area_struct *vma_merge(struct
 		remove = next;				/* case 1 */
 		vma_end = next->vm_end;
 		err = dup_anon_vma(prev, next);
-		if (mid != next) {			/* case 6 */
+		if (mid) {				/* case 6 */
 			remove = mid;
 			remove2 = next;
 			if (!next->anon_vma)
@@ -960,7 +967,7 @@ struct vm_area_struct *vma_merge(struct
 		}
 	} else if (merge_prev) {
 		err = 0;				/* case 2 */
-		if (mid && end > mid->vm_start) {
+		if (mid) {
 			err = dup_anon_vma(prev, mid);
 			if (end == mid->vm_end) {	/* case 7 */
 				remove = mid;
@@ -982,7 +989,7 @@ struct vm_area_struct *vma_merge(struct
 			vma_end = next->vm_end;
 			vma_pgoff = next->vm_pgoff;
 			err = 0;
-			if (mid != next) {		/* case 8 */
+			if (mid) {			/* case 8 */
 				vma_pgoff = mid->vm_pgoff;
 				remove = mid;
 				err = dup_anon_vma(next, mid);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986B2C61DA4
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 20:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjCOURc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 16:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbjCOUR3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 16:17:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36801C589
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 13:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D42261D90
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 20:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B23BC433D2;
        Wed, 15 Mar 2023 20:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678911446;
        bh=Wl/nR+WqM/ZnTH1k/+nrPFTOvE4hv3Oqo3VJ1FDDCbQ=;
        h=Date:To:From:Subject:From;
        b=M8veGxN0r6vLHilWpl/AKKw+/q7PrCIEormpkqWOkBZHQZThRZo3reFr7VvDTTqo1
         BGHgBS71EUmTpGF+S7u0MNroCXDQ16eCTgjZej1oJNydRfaKnvPYT/2Q1M32SIxNHM
         tTXz8TrK965Ijwny/3FSmRMEDi8gFWMIOPGKnXa0=
Date:   Wed, 15 Mar 2023 13:17:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch added to mm-unstable branch
Message-Id: <20230315201726.9B23BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: set mid to NULL if not applicable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mmap/vma_merge: set mid to NULL if not applicable
Date: Thu, 9 Mar 2023 12:12:54 +0100

There are several places where we test if 'mid' is really the area NNNN in
the diagram and the tests have two variants and are non-obvious to follow.
Instead, set 'mid' to NULL up-front if it's not the NNNN area, and
simplify the tests.

Also update the description in comment accordingly.

Link: https://lkml.kernel.org/r/20230309111258.24079-7-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-set-mid-to-null-if-not-applicable
+++ a/mm/mmap.c
@@ -861,10 +861,11 @@ can_vma_merge_after(struct vm_area_struc
  *
  * The following mprotect cases have to be considered, where AAAA is
  * the area passed down from mprotect_fixup, never extending beyond one
- * vma, PPPPPP is the prev vma specified, and NNNNNN the next vma after:
+ * vma, PPPPPP is the prev vma specified, NNNN is a vma that overlaps
+ * the area AAAA and XXXXXX the next vma after AAAA:
  *
  *     AAAA             AAAA                   AAAA
- *    PPPPPPNNNNNN    PPPPPPXXXXXX       PPPPPPNNNNNN
+ *    PPPPPPXXXXXX    PPPPPPXXXXXX       PPPPPPNNNNNN
  *    cannot merge    might become       might become
  *                    PPXXXXXXXXXX       PPPPPPPPPPNN
  *    mmap, brk or    case 4 below       case 5 below
@@ -892,9 +893,10 @@ can_vma_merge_after(struct vm_area_struc
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
@@ -931,6 +933,9 @@ struct vm_area_struct *vma_merge(struct
 	else
 		next = mid;
 
+	if (mid && end <= mid->vm_start)
+		mid = NULL;
+
 	/* verify some invariant that must be enforced by the caller */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
 	VM_WARN_ON(mid && end > mid->vm_end);
@@ -965,7 +970,7 @@ struct vm_area_struct *vma_merge(struct
 		remove = next;				/* case 1 */
 		vma_end = next->vm_end;
 		err = dup_anon_vma(prev, next);
-		if (mid != next) {			/* case 6 */
+		if (mid) {				/* case 6 */
 			remove = mid;
 			remove2 = next;
 			if (!next->anon_vma)
@@ -973,7 +978,7 @@ struct vm_area_struct *vma_merge(struct
 		}
 	} else if (merge_prev) {
 		err = 0;				/* case 2 */
-		if (mid && end > mid->vm_start) {
+		if (mid) {
 			err = dup_anon_vma(prev, mid);
 			if (end == mid->vm_end) {	/* case 7 */
 				remove = mid;
@@ -995,7 +1000,7 @@ struct vm_area_struct *vma_merge(struct
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

mm-page_alloc-reduce-page-alloc-free-sanity-checks.patch
mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch
mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch
mm-mmap-vma_merge-initialize-mid-and-next-in-natural-order.patch
mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch
mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch
mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch
mm-mremap-simplify-vma-expansion-again.patch


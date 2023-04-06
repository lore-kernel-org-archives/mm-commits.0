Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40FFC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbjDFCqn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbjDFCo5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77C58A5F
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54ADB64217
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0953C433D2;
        Thu,  6 Apr 2023 02:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749095;
        bh=M44DeMhsCe+USgVIrnuXc3Wxx+U5PpbOwq7z5AcH62U=;
        h=Date:To:From:Subject:From;
        b=rGYubXUvd0JT6tzNY4DvGmTuqg6nKPgNm9i6U1px98DYIE6iX472O8BB6BLYXkbDX
         iXzQElpfmP4x/u5rlvUWG7vOnkpk+5DRk1iPpVp3NkzGfhCMqYk90p7L7NrEFyZGC0
         AD8hbfVKiCIVTD7RIuYTtrnRVtVf/L5YgfOGTOh8=
Date:   Wed, 05 Apr 2023 19:44:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch removed from -mm tree
Message-Id: <20230406024455.B0953C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: rename adj_next to adj_start
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mmap/vma_merge: rename adj_next to adj_start
Date: Thu, 9 Mar 2023 12:12:55 +0100

The variable 'adj_next' holds the value by which we adjust vm_start of a
vma in variable 'adjust', that's either 'next' or 'mid', so the current
name is inaccurate.  Rename it to 'adj_start'.

Link: https://lkml.kernel.org/r/20230309111258.24079-8-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-rename-adj_next-to-adj_start
+++ a/mm/mmap.c
@@ -904,7 +904,7 @@ struct vm_area_struct *vma_merge(struct
 	bool vma_expanded = false;
 	struct vma_prepare vp;
 	unsigned long vma_end = end;
-	long adj_next = 0;
+	long adj_start = 0;
 	unsigned long vma_start = addr;
 
 	validate_mm(mm);
@@ -973,7 +973,7 @@ struct vm_area_struct *vma_merge(struct
 				remove = mid;
 			} else {			/* case 5 */
 				adjust = mid;
-				adj_next = (end - mid->vm_start);
+				adj_start = (end - mid->vm_start);
 			}
 		}
 	} else if (merge_next) {
@@ -981,7 +981,7 @@ struct vm_area_struct *vma_merge(struct
 		if (prev && addr < prev->vm_end) {	/* case 4 */
 			vma_end = addr;
 			adjust = next;
-			adj_next = -(prev->vm_end - addr);
+			adj_start = -(prev->vm_end - addr);
 			err = dup_anon_vma(next, prev);
 		} else {
 			vma = next;			/* case 3 */
@@ -1004,7 +1004,7 @@ struct vm_area_struct *vma_merge(struct
 	if (vma_iter_prealloc(vmi))
 		return NULL;
 
-	vma_adjust_trans_huge(vma, vma_start, vma_end, adj_next);
+	vma_adjust_trans_huge(vma, vma_start, vma_end, adj_start);
 	init_multi_vma_prep(&vp, vma, adjust, remove, remove2);
 	VM_WARN_ON(vp.anon_vma && adjust && adjust->anon_vma &&
 		   vp.anon_vma != adjust->anon_vma);
@@ -1020,10 +1020,10 @@ struct vm_area_struct *vma_merge(struct
 	if (vma_expanded)
 		vma_iter_store(vmi, vma);
 
-	if (adj_next) {
-		adjust->vm_start += adj_next;
-		adjust->vm_pgoff += adj_next >> PAGE_SHIFT;
-		if (adj_next < 0) {
+	if (adj_start) {
+		adjust->vm_start += adj_start;
+		adjust->vm_pgoff += adj_start >> PAGE_SHIFT;
+		if (adj_start < 0) {
 			WARN_ON(vma_expanded);
 			vma_iter_store(vmi, next);
 		}
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch


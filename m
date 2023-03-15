Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5604C7618D
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 20:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbjCOURk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 16:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbjCOURc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 16:17:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6721C589
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 13:17:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0ED2B81F1B
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 20:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0F2C433D2;
        Wed, 15 Mar 2023 20:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678911448;
        bh=IhIWuIfY5xsb6Hbrw6sfYdhSYsd/O5+73YIfDmCyhio=;
        h=Date:To:From:Subject:From;
        b=U4+ZYfZpcAYocuOOLDyP/Jhz7VeHMhoS0/5JgMhTKPO+Fy1jS1jpMcvBeBDHnItu7
         0ftIffw14MoYpRvtSOING0Lvl194ezX0AhkHR1VLGIs7J4VmPVm+J72X8adDQFWabP
         /tufxJ8auR2oAlnxEK/3tCq493+sPAgfu0aVtQ+Q=
Date:   Wed, 15 Mar 2023 13:17:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch added to mm-unstable branch
Message-Id: <20230315201728.7F0F2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: rename adj_next to adj_start
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch

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
Subject: mm/mmap/vma_merge: rename adj_next to adj_start
Date: Thu, 9 Mar 2023 12:12:55 +0100

The variable 'adj_next' holds the value by which we adjust vm_start of a
vma in variable 'adjust', that's either 'next' or 'mid', so the current
name is inaccurate.  Rename it to 'adj_start'.

Link: https://lkml.kernel.org/r/20230309111258.24079-8-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-rename-adj_next-to-adj_start
+++ a/mm/mmap.c
@@ -916,7 +916,7 @@ struct vm_area_struct *vma_merge(struct
 	bool vma_expanded = false;
 	struct vma_prepare vp;
 	unsigned long vma_end = end;
-	long adj_next = 0;
+	long adj_start = 0;
 	unsigned long vma_start = addr;
 
 	validate_mm(mm);
@@ -984,7 +984,7 @@ struct vm_area_struct *vma_merge(struct
 				remove = mid;
 			} else {			/* case 5 */
 				adjust = mid;
-				adj_next = (end - mid->vm_start);
+				adj_start = (end - mid->vm_start);
 			}
 		}
 	} else if (merge_next) {
@@ -992,7 +992,7 @@ struct vm_area_struct *vma_merge(struct
 		if (prev && addr < prev->vm_end) {	/* case 4 */
 			vma_end = addr;
 			adjust = next;
-			adj_next = -(prev->vm_end - addr);
+			adj_start = -(prev->vm_end - addr);
 			err = dup_anon_vma(next, prev);
 		} else {
 			vma = next;			/* case 3 */
@@ -1020,7 +1020,7 @@ struct vm_area_struct *vma_merge(struct
 		   vp.anon_vma != adjust->anon_vma);
 
 	vma_prepare(&vp);
-	vma_adjust_trans_huge(vma, vma_start, vma_end, adj_next);
+	vma_adjust_trans_huge(vma, vma_start, vma_end, adj_start);
 	if (vma_start < vma->vm_start || vma_end > vma->vm_end)
 		vma_expanded = true;
 
@@ -1031,10 +1031,10 @@ struct vm_area_struct *vma_merge(struct
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


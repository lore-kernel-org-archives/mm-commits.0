Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B128EC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbjDFCtE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235087AbjDFCsN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:48:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48F17683
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8575F642B8
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA6FC433EF;
        Thu,  6 Apr 2023 02:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749141;
        bh=477lBmca4/3y5sw/uY/GY88SiNXHl2fRLqQqTxgRtNo=;
        h=Date:To:From:Subject:From;
        b=XVBlv34NslPD4213htPO2atPWW+Wf8GF5jNf+ah2aWdF4TyGfsWJhP1cq7t/7jfE7
         sXFOIX+Tf4y9RN4DQwNtw/sOV66NrnnuBa+Gt/7LKINr8qyLrbFoD8sZ774lg1rrZo
         O1VefpmVP08/sdVPZPVu39e0EVoUM/doQIQD5VoM=
Date:   Wed, 05 Apr 2023 19:45:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vernon2gm@gmail.com, vbabka@suse.cz, Liam.Howlett@oracle.com,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case.patch removed from -mm tree
Message-Id: <20230406024540.DBA6FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: init cleanup, be explicit about the non-mergeable case
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/mmap/vma_merge: init cleanup, be explicit about the non-mergeable case
Date: Wed, 22 Mar 2023 20:19:00 +0000

Rather than setting err = -1 and only resetting if we hit merge cases,
explicitly check the non-mergeable case to make it abundantly clear that
we only proceed with the rest if something is mergeable, default err to 0
and only update if an error might occur.

Move the merge_prev, merge_next cases closer to the logic determining
curr, next and reorder initial variables so they are more logically
grouped.

This has no functional impact.

Link: https://lkml.kernel.org/r/99259fbc6403e80e270e1cc4612abbc8620b121b.1679516210.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case
+++ a/mm/mmap.c
@@ -896,18 +896,18 @@ struct vm_area_struct *vma_merge(struct
 			struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
 			struct anon_vma_name *anon_name)
 {
-	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
-	pgoff_t vma_pgoff;
 	struct vm_area_struct *curr, *next, *res;
 	struct vm_area_struct *vma, *adjust, *remove, *remove2;
-	int err = -1;
+	struct vma_prepare vp;
+	pgoff_t vma_pgoff;
+	int err = 0;
 	bool merge_prev = false;
 	bool merge_next = false;
 	bool vma_expanded = false;
-	struct vma_prepare vp;
+	unsigned long vma_start = addr;
 	unsigned long vma_end = end;
+	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	long adj_start = 0;
-	unsigned long vma_start = addr;
 
 	validate_mm(mm);
 	/*
@@ -926,24 +926,14 @@ struct vm_area_struct *vma_merge(struct
 	else
 		next = NULL;		/* case 5 */
 
-	/*
-	 * By default, we return prev. Cases 3, 4, 8 will instead return next
-	 * and cases 3, 8 will also update vma to point at next.
-	 */
-	res = vma = prev;
-
-	/* Verify some invariant that must be enforced by the caller. */
-	VM_WARN_ON(prev && addr <= prev->vm_start);
-	VM_WARN_ON(curr && (addr != curr->vm_start || end > curr->vm_end));
-	VM_WARN_ON(addr >= end);
-
 	if (prev) {
 		vma_start = prev->vm_start;
 		vma_pgoff = prev->vm_pgoff;
+
 		/* Can we merge the predecessor? */
-		if (prev->vm_end == addr && mpol_equal(vma_policy(prev), policy)
+		if (addr == prev->vm_end && mpol_equal(vma_policy(prev), policy)
 		    && can_vma_merge_after(prev, vm_flags, anon_vma, file,
-				   pgoff, vm_userfaultfd_ctx, anon_name)) {
+					   pgoff, vm_userfaultfd_ctx, anon_name)) {
 			merge_prev = true;
 			vma_prev(vmi);
 		}
@@ -951,13 +941,22 @@ struct vm_area_struct *vma_merge(struct
 
 	/* Can we merge the successor? */
 	if (next && mpol_equal(policy, vma_policy(next)) &&
-	    can_vma_merge_before(next, vm_flags,
-				 anon_vma, file, pgoff+pglen,
+	    can_vma_merge_before(next, vm_flags, anon_vma, file, pgoff+pglen,
 				 vm_userfaultfd_ctx, anon_name)) {
 		merge_next = true;
 	}
 
+	if (!merge_prev && !merge_next)
+		return NULL; /* Not mergeable. */
+
+	res = vma = prev;
 	remove = remove2 = adjust = NULL;
+
+	/* Verify some invariant that must be enforced by the caller. */
+	VM_WARN_ON(prev && addr <= prev->vm_start);
+	VM_WARN_ON(curr && (addr != curr->vm_start || end > curr->vm_end));
+	VM_WARN_ON(addr >= end);
+
 	/* Can we merge both the predecessor and the successor? */
 	if (merge_prev && merge_next &&
 	    is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL)) {
@@ -970,8 +969,7 @@ struct vm_area_struct *vma_merge(struct
 			if (!next->anon_vma)
 				err = dup_anon_vma(prev, curr);
 		}
-	} else if (merge_prev) {
-		err = 0;				/* case 2 */
+	} else if (merge_prev) {			/* case 2 */
 		if (curr) {
 			err = dup_anon_vma(prev, curr);
 			if (end == curr->vm_end) {	/* case 7 */
@@ -981,7 +979,7 @@ struct vm_area_struct *vma_merge(struct
 				adj_start = (end - curr->vm_start);
 			}
 		}
-	} else if (merge_next) {
+	} else { /* merge_next */
 		res = next;
 		if (prev && addr < prev->vm_end) {	/* case 4 */
 			vma_end = addr;
@@ -997,7 +995,6 @@ struct vm_area_struct *vma_merge(struct
 			vma_start = addr;
 			vma_end = next->vm_end;
 			vma_pgoff = next->vm_pgoff;
-			err = 0;
 			if (curr) {			/* case 8 */
 				vma_pgoff = curr->vm_pgoff;
 				remove = curr;
@@ -1006,7 +1003,7 @@ struct vm_area_struct *vma_merge(struct
 		}
 	}
 
-	/* Cannot merge or error in anon_vma clone */
+	/* Error in anon_vma clone. */
 	if (err)
 		return NULL;
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are



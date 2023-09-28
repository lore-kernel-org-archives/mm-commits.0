Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C564ACE7AFC
	for <mm-commits@archiver.kernel.org>; Thu, 28 Sep 2023 17:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjI1RaO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Sep 2023 13:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjI1RaM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2023 13:30:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D411A5;
        Thu, 28 Sep 2023 10:30:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E69C433C9;
        Thu, 28 Sep 2023 17:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695922206;
        bh=jXvSDRKMLltIn4c0oMq0mM/6OU4Eg9P2bUNhe3fMx4o=;
        h=Date:To:From:Subject:From;
        b=QzvV/m0T00kBgHDVc3OsjsSKVpN5KAQR8mdN4uta9Onpl8OR+f/7W3j2QgtujvaPS
         n5XRaFcnIn+xnBxWoOiYAfZ0zjmUxalU7cp+zE5fUCN+H2auRA4NgA+EAmp+qj7xqZ
         EcmfbSjGyoQE9IcWf8l2wKHtjfSQN8yblKxC3iQU=
Date:   Thu, 28 Sep 2023 10:30:06 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        jannh@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mmap-fix-error-paths-with-dup_anon_vma.patch removed from -mm tree
Message-Id: <20230928173006.D5E69C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: fix error paths with dup_anon_vma()
has been removed from the -mm tree.  Its filename was
     mmap-fix-error-paths-with-dup_anon_vma.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mmap: fix error paths with dup_anon_vma()
Date: Wed, 27 Sep 2023 12:07:45 -0400

When the calling function fails after the dup_anon_vma(), the duplication
of the anon_vma is not being undone.  Add the necessary unlink_anon_vma()
call to the error paths that are missing them.

This issue showed up during inspection of the error path in vma_merge()
for an unrelated vma iterator issue.

Users may experience increased memory usage, which may be problematic as
the failure would likely be caused by a low memory situation.

Link: https://lkml.kernel.org/r/20230927160746.1928098-3-Liam.Howlett@oracle.com
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/mm/mmap.c~mmap-fix-error-paths-with-dup_anon_vma
+++ a/mm/mmap.c
@@ -587,7 +587,7 @@ again:
  * Returns: 0 on success.
  */
 static inline int dup_anon_vma(struct vm_area_struct *dst,
-			       struct vm_area_struct *src)
+		struct vm_area_struct *src, struct vm_area_struct **dup)
 {
 	/*
 	 * Easily overlooked: when mprotect shifts the boundary, make sure the
@@ -597,6 +597,7 @@ static inline int dup_anon_vma(struct vm
 	if (src->anon_vma && !dst->anon_vma) {
 		vma_assert_write_locked(dst);
 		dst->anon_vma = src->anon_vma;
+		*dup = dst;
 		return anon_vma_clone(dst, src);
 	}
 
@@ -624,6 +625,7 @@ int vma_expand(struct vma_iterator *vmi,
 	       unsigned long start, unsigned long end, pgoff_t pgoff,
 	       struct vm_area_struct *next)
 {
+	struct vm_area_struct *anon_dup = NULL;
 	bool remove_next = false;
 	struct vma_prepare vp;
 
@@ -633,7 +635,7 @@ int vma_expand(struct vma_iterator *vmi,
 
 		remove_next = true;
 		vma_start_write(next);
-		ret = dup_anon_vma(vma, next);
+		ret = dup_anon_vma(vma, next, &anon_dup);
 		if (ret)
 			return ret;
 	}
@@ -661,6 +663,8 @@ int vma_expand(struct vma_iterator *vmi,
 	return 0;
 
 nomem:
+	if (anon_dup)
+		unlink_anon_vmas(anon_dup);
 	return -ENOMEM;
 }
 
@@ -860,6 +864,7 @@ struct vm_area_struct *vma_merge(struct
 {
 	struct vm_area_struct *curr, *next, *res;
 	struct vm_area_struct *vma, *adjust, *remove, *remove2;
+	struct vm_area_struct *anon_dup = NULL;
 	struct vma_prepare vp;
 	pgoff_t vma_pgoff;
 	int err = 0;
@@ -927,18 +932,18 @@ struct vm_area_struct *vma_merge(struct
 		vma_start_write(next);
 		remove = next;				/* case 1 */
 		vma_end = next->vm_end;
-		err = dup_anon_vma(prev, next);
+		err = dup_anon_vma(prev, next, &anon_dup);
 		if (curr) {				/* case 6 */
 			vma_start_write(curr);
 			remove = curr;
 			remove2 = next;
 			if (!next->anon_vma)
-				err = dup_anon_vma(prev, curr);
+				err = dup_anon_vma(prev, curr, &anon_dup);
 		}
 	} else if (merge_prev) {			/* case 2 */
 		if (curr) {
 			vma_start_write(curr);
-			err = dup_anon_vma(prev, curr);
+			err = dup_anon_vma(prev, curr, &anon_dup);
 			if (end == curr->vm_end) {	/* case 7 */
 				remove = curr;
 			} else {			/* case 5 */
@@ -954,7 +959,7 @@ struct vm_area_struct *vma_merge(struct
 			vma_end = addr;
 			adjust = next;
 			adj_start = -(prev->vm_end - addr);
-			err = dup_anon_vma(next, prev);
+			err = dup_anon_vma(next, prev, &anon_dup);
 		} else {
 			/*
 			 * Note that cases 3 and 8 are the ONLY ones where prev
@@ -1018,6 +1023,9 @@ struct vm_area_struct *vma_merge(struct
 	return res;
 
 prealloc_fail:
+	if (anon_dup)
+		unlink_anon_vmas(anon_dup);
+
 anon_vma_fail:
 	if (merge_prev)
 		vma_next(vmi);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-mas_active-to-detect-in-tree-walks.patch
maple_tree-add-mas_underflow-and-mas_overflow-states.patch
mmap-add-clarifying-comment-to-vma_merge-code.patch


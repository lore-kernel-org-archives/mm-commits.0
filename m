Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDC5E732FD
	for <mm-commits@archiver.kernel.org>; Thu, 28 Sep 2023 17:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjI1Riw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Sep 2023 13:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjI1Ris (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2023 13:38:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC996C0;
        Thu, 28 Sep 2023 10:38:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650CAC433C8;
        Thu, 28 Sep 2023 17:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695922726;
        bh=c9pSPMBuSJIZOWSu5rcT6G8kbgck/D3DUgdksNgZKK8=;
        h=Date:To:From:Subject:From;
        b=GL6/r8OK5kKaIpthHDu0Wk/jkk+zIPBLuNi564b05fM8Q+JM8HM3Rg//NA6uojBXw
         ivyI2yv5b4WWJOg1YD/HMAqXWo6QpO99imEJsUbGTsoE2yFzkUd7cyqZKxugDLECa9
         6ylnDML2l4tqGNtN0QuPsmr3Lm8/7M5UrIesLxSw=
Date:   Thu, 28 Sep 2023 10:38:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, stable@vger.kernel.org, lstoakes@gmail.com,
        jannh@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-fix-error-paths-with-dup_anon_vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20230928173846.650CAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: fix error paths with dup_anon_vma()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmap-fix-error-paths-with-dup_anon_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmap-fix-error-paths-with-dup_anon_vma.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mmap: fix error paths with dup_anon_vma()
Date: Thu, 28 Sep 2023 13:16:33 -0400

When the calling function fails after the dup_anon_vma(), the duplication
of the anon_vma is not being undone.  Add the necessary unlink_anon_vma()
call to the error paths that are missing them.

This issue showed up during inspection of the error path in vma_merge()
for an unrelated vma iterator issue.

Users may experience increased memory usage, which may be problematic as
the failure would likely be caused by a low memory situation.

Link: https://lkml.kernel.org/r/20230928171634.2245042-3-Liam.Howlett@oracle.com
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

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
@@ -968,7 +973,7 @@ struct vm_area_struct *vma_merge(struct
 				vma_pgoff = curr->vm_pgoff;
 				vma_start_write(curr);
 				remove = curr;
-				err = dup_anon_vma(next, curr);
+				err = dup_anon_vma(next, curr, &anon_dup);
 			}
 		}
 	}
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
mmap-fix-vma_iterator-in-error-path-of-vma_merge.patch
mmap-fix-error-paths-with-dup_anon_vma.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8CBC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjBJAyW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjBJAxq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A526F8D0
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C366B82399
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB0EC433D2;
        Fri, 10 Feb 2023 00:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990388;
        bh=B9uD9l9WUd0IOM/rxwuydqibSL5/T1Of61LC19ILGCg=;
        h=Date:To:From:Subject:From;
        b=h6N2R0BbVbglOFMCVTqn1VcrtjWy6JlbyZ1w5DvkXKEo9EJYVVMaU/X9WSAQ6CIiv
         leYAjQbTo6a7qYQlpLFV0DyLpJMs5qV3mmg9rWN+Xyg68McSrd3neG0z98m9Ebc/oW
         oEGjNcH5TAtYo1+/rqW9xX7G9cxklCd8BdeJEaoM=
Date:   Thu, 09 Feb 2023 16:53:08 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pass-through-vma-iterator-to-__vma_adjust.patch removed from -mm tree
Message-Id: <20230210005308.AAB0EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: pass through vma iterator to __vma_adjust()
has been removed from the -mm tree.  Its filename was
     mm-pass-through-vma-iterator-to-__vma_adjust.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: pass through vma iterator to __vma_adjust()
Date: Fri, 20 Jan 2023 11:26:33 -0500

Pass the vma iterator through to __vma_adjust() so the state can be
updated.

Link: https://lkml.kernel.org/r/20230120162650.984577-33-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++++--
 mm/mmap.c          |   31 +++++++++++++++----------------
 2 files changed, 19 insertions(+), 18 deletions(-)

--- a/include/linux/mm.h~mm-pass-through-vma-iterator-to-__vma_adjust
+++ a/include/linux/mm.h
@@ -2831,13 +2831,15 @@ void anon_vma_interval_tree_verify(struc
 
 /* mmap.c */
 extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
-extern int __vma_adjust(struct vm_area_struct *vma, unsigned long start,
+extern int __vma_adjust(struct vma_iterator *vmi, struct vm_area_struct *vma, unsigned long start,
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert,
 	struct vm_area_struct *expand);
 static inline int vma_adjust(struct vm_area_struct *vma, unsigned long start,
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert)
 {
-	return __vma_adjust(vma, start, end, pgoff, insert, NULL);
+	VMA_ITERATOR(vmi, vma->vm_mm, start);
+
+	return __vma_adjust(&vmi, vma, start, end, pgoff, insert, NULL);
 }
 extern struct vm_area_struct *vma_merge(struct vma_iterator *vmi,
 	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
--- a/mm/mmap.c~mm-pass-through-vma-iterator-to-__vma_adjust
+++ a/mm/mmap.c
@@ -576,9 +576,9 @@ nomem:
  * are necessary.  The "insert" vma (if any) is to be inserted
  * before we drop the necessary locks.
  */
-int __vma_adjust(struct vm_area_struct *vma, unsigned long start,
-	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert,
-	struct vm_area_struct *expand)
+int __vma_adjust(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	unsigned long start, unsigned long end, pgoff_t pgoff,
+	struct vm_area_struct *insert, struct vm_area_struct *expand)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *next_next = NULL;	/* uninit var warning */
@@ -591,7 +591,6 @@ int __vma_adjust(struct vm_area_struct *
 	bool vma_changed = false;
 	long adjust_next = 0;
 	int remove_next = 0;
-	VMA_ITERATOR(vmi, mm, 0);
 	struct vm_area_struct *exporter = NULL, *importer = NULL;
 
 	if (next && !insert) {
@@ -676,7 +675,7 @@ int __vma_adjust(struct vm_area_struct *
 		}
 	}
 
-	if (vma_iter_prealloc(&vmi))
+	if (vma_iter_prealloc(vmi))
 		return -ENOMEM;
 
 	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
@@ -722,7 +721,7 @@ int __vma_adjust(struct vm_area_struct *
 	if (start != vma->vm_start) {
 		if ((vma->vm_start < start) &&
 		    (!insert || (insert->vm_end != start))) {
-			vma_iter_clear(&vmi, vma->vm_start, start);
+			vma_iter_clear(vmi, vma->vm_start, start);
 			VM_WARN_ON(insert && insert->vm_start > vma->vm_start);
 		} else {
 			vma_changed = true;
@@ -732,8 +731,8 @@ int __vma_adjust(struct vm_area_struct *
 	if (end != vma->vm_end) {
 		if (vma->vm_end > end) {
 			if (!insert || (insert->vm_start != end)) {
-				vma_iter_clear(&vmi, end, vma->vm_end);
-				vma_iter_set(&vmi, vma->vm_end);
+				vma_iter_clear(vmi, end, vma->vm_end);
+				vma_iter_set(vmi, vma->vm_end);
 				VM_WARN_ON(insert &&
 					   insert->vm_end < vma->vm_end);
 			}
@@ -744,13 +743,13 @@ int __vma_adjust(struct vm_area_struct *
 	}
 
 	if (vma_changed)
-		vma_iter_store(&vmi, vma);
+		vma_iter_store(vmi, vma);
 
 	vma->vm_pgoff = pgoff;
 	if (adjust_next) {
 		next->vm_start += adjust_next;
 		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
-		vma_iter_store(&vmi, next);
+		vma_iter_store(vmi, next);
 	}
 
 	if (file) {
@@ -770,7 +769,7 @@ int __vma_adjust(struct vm_area_struct *
 		 * us to insert it before dropping the locks
 		 * (it may either follow vma or precede it).
 		 */
-		vma_iter_store(&vmi, insert);
+		vma_iter_store(vmi, insert);
 		mm->map_count++;
 	}
 
@@ -816,7 +815,7 @@ again:
 	if (insert && file)
 		uprobe_mmap(insert);
 
-	vma_iter_free(&vmi);
+	vma_iter_free(vmi);
 	validate_mm(mm);
 
 	return 0;
@@ -1010,20 +1009,20 @@ struct vm_area_struct *vma_merge(struct
 	if (merge_prev && merge_next &&
 			is_mergeable_anon_vma(prev->anon_vma,
 				next->anon_vma, NULL)) {	 /* cases 1, 6 */
-		err = __vma_adjust(prev, prev->vm_start,
+		err = __vma_adjust(vmi, prev, prev->vm_start,
 					next->vm_end, prev->vm_pgoff, NULL,
 					prev);
 		res = prev;
 	} else if (merge_prev) {			/* cases 2, 5, 7 */
-		err = __vma_adjust(prev, prev->vm_start,
+		err = __vma_adjust(vmi, prev, prev->vm_start,
 					end, prev->vm_pgoff, NULL, prev);
 		res = prev;
 	} else if (merge_next) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
-			err = __vma_adjust(prev, prev->vm_start,
+			err = __vma_adjust(vmi, prev, prev->vm_start,
 					addr, prev->vm_pgoff, NULL, next);
 		else					/* cases 3, 8 */
-			err = __vma_adjust(mid, addr, next->vm_end,
+			err = __vma_adjust(vmi, mid, addr, next->vm_end,
 					next->vm_pgoff - pglen, NULL, next);
 		res = next;
 	}
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are



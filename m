Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B90CCA479
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383584AbiFQXIi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383377AbiFQXIT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:08:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB48A2BB0A
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:08:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CD90B82C02
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EF3C3411B;
        Fri, 17 Jun 2022 23:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655507295;
        bh=KPL6hqlJwGKo9X9xYF2td2rezPZqHnhWhpaDJ6/mrsY=;
        h=Date:To:From:Subject:From;
        b=ZRXuVJIxmbp3XkUdW76vOW10OI6S2fVzVBN8gB1b8T1caMZYd33a8JGsoRlAi4691
         5xslYwSkXh8yx5M0KzspE75YKXC1QbdlqBCpvvxC1VXVT6pxW/mMqtpUjuarzA1G6/
         38mTVqUCVzLBSkJeToXq7AeEtv8D6iElpkFq0UY4=
Date:   Fri, 17 Jun 2022 16:08:14 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        quic_qiancai@quicinc.com, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-vma-linked-list-fix-4.patch added to mm-unstable branch
Message-Id: <20220617230815.39EF3C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: change do_mas_align_munmap() to avoid preallocations for sidetree
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-vma-linked-list-fix-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-vma-linked-list-fix-4.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap: change do_mas_align_munmap() to avoid preallocations for sidetree
Date: Fri, 17 Jun 2022 13:46:42 +0000

Recording the VMAs to be removed in the sidetree does not require a
preallocation - after all, split allocates with GFP_KERNEL.  Changing to a
regular maple tree write means we can avoid issues when there are a large
number of VMAs.  Using mas_store_gfp() instead of preallocations also
means that the maple state does not need to be destroyed (freeing unused
nodes).  At the same time, switch the tree flags to just
MT_FLAGS_LOCK_EXTERN since gaps do not need to be tracked in the side
tree.  This will allow more VMAs per node.

Also reorganize the goto statements and split them up for better
unwinding.

Link: https://lkml.kernel.org/r/20220617134637.1771711-1-Liam.Howlett@oracle.com
Fixes: e34b4addc263 (mm/mmap: fix potential leak on do_mas_align_munmap())
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

--- a/mm/mmap.c~mm-remove-the-vma-linked-list-fix-4
+++ a/mm/mmap.c
@@ -2377,13 +2377,17 @@ int split_vma(struct mm_struct *mm, stru
 	return __split_vma(mm, vma, addr, new_below);
 }
 
-static inline void munmap_sidetree(struct vm_area_struct *vma,
+static inline int munmap_sidetree(struct vm_area_struct *vma,
 				   struct ma_state *mas_detach)
 {
 	mas_set_range(mas_detach, vma->vm_start, vma->vm_end - 1);
-	mas_store(mas_detach, vma);
+	if (mas_store_gfp(mas_detach, vma, GFP_KERNEL))
+		return -ENOMEM;
+
 	if (vma->vm_flags & VM_LOCKED)
 		vma->vm_mm->locked_vm -= vma_pages(vma);
+
+	return 0;
 }
 
 /*
@@ -2407,16 +2411,13 @@ do_mas_align_munmap(struct ma_state *mas
 	struct maple_tree mt_detach;
 	int count = 0;
 	int error = -ENOMEM;
-	MA_STATE(mas_detach, &mt_detach, start, end - 1);
-	mt_init_flags(&mt_detach, MM_MT_FLAGS);
+	MA_STATE(mas_detach, &mt_detach, 0, 0);
+	mt_init_flags(&mt_detach, MT_FLAGS_LOCK_EXTERN);
 	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
 
 	if (mas_preallocate(mas, vma, GFP_KERNEL))
 		return -ENOMEM;
 
-	if (mas_preallocate(&mas_detach, vma, GFP_KERNEL))
-		goto detach_alloc_fail;
-
 	mas->last = end - 1;
 	/*
 	 * If we need to split any vma, do it now to save pain later.
@@ -2443,7 +2444,7 @@ do_mas_align_munmap(struct ma_state *mas
 		 */
 		error = __split_vma(mm, vma, start, 0);
 		if (error)
-			goto split_failed;
+			goto start_split_failed;
 
 		mas_set(mas, start);
 		vma = mas_walk(mas);
@@ -2464,26 +2465,28 @@ do_mas_align_munmap(struct ma_state *mas
 
 			error = __split_vma(mm, next, end, 1);
 			if (error)
-				goto split_failed;
+				goto end_split_failed;
 
 			mas_set(mas, end);
 			split = mas_prev(mas, 0);
-			munmap_sidetree(split, &mas_detach);
+			if (munmap_sidetree(split, &mas_detach))
+				goto munmap_sidetree_failed;
+
 			count++;
 			if (vma == next)
 				vma = split;
 			break;
 		}
+		if (munmap_sidetree(next, &mas_detach))
+			goto munmap_sidetree_failed;
+
 		count++;
-		munmap_sidetree(next, &mas_detach);
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
 		BUG_ON(next->vm_start < start);
 		BUG_ON(next->vm_start > end);
 #endif
 	}
 
-	mas_destroy(&mas_detach);
-
 	if (!next)
 		next = mas_next(mas, ULONG_MAX);
 
@@ -2544,18 +2547,18 @@ do_mas_align_munmap(struct ma_state *mas
 	/* Statistics and freeing VMAs */
 	mas_set(&mas_detach, start);
 	remove_mt(mm, &mas_detach);
-	validate_mm(mm);
 	__mt_destroy(&mt_detach);
 
 
 	validate_mm(mm);
 	return downgrade ? 1 : 0;
 
-map_count_exceeded:
-split_failed:
 userfaultfd_error:
-	mas_destroy(&mas_detach);
-detach_alloc_fail:
+munmap_sidetree_failed:
+end_split_failed:
+	__mt_destroy(&mt_detach);
+start_split_failed:
+map_count_exceeded:
 	mas_destroy(mas);
 	return error;
 }
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
maple-tree-add-new-data-structure-fix-7.patch
maple-tree-add-new-data-structure-fix-8.patch
maple-tree-add-new-data-structure-fix-8-fix.patch
maple-tree-add-new-data-structure-fix-9.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-3.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-3.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch
mm-remove-the-vma-linked-list-fix.patch
mm-remove-the-vma-linked-list-fix-4.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch


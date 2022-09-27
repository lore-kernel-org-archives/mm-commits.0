Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268E3C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiI0CzJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiI0CxO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:53:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5962B1E8
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 502F5B8190D
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04119C433C1;
        Tue, 27 Sep 2022 02:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246986;
        bh=LiXzxOoSW4/BTBI/YROKzKwoKDTrYl+LVlgQDTyHPtw=;
        h=Date:To:From:Subject:From;
        b=Xsi+ktqmbqOVIs2V0ctE7dJ0Yaby3aVPgZMvcIExKlTN+wMi7ULW5+rRSObzutzq6
         JAAW7dq3j0wEZdip1FO77RSri9VV2HzanpjqWeQEonDN9pOt5Yy6/iSAXOFtMaet59
         Vg/xUEgQABvTUGqdXCF3bOQwYTlAnv++Cy7X5eOQ=
Date:   Mon, 26 Sep 2022 19:49:45 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-use-vma-iterator-maple-state-instead-of-vma-linked-list.patch removed from -mm tree
Message-Id: <20220927024946.04119C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: use vma iterator & maple state instead of vma linked list
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-vma-iterator-maple-state-instead-of-vma-linked-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mempolicy: use vma iterator & maple state instead of vma linked list
Date: Tue, 6 Sep 2022 19:49:02 +0000

Reworked the way mbind_range() finds the first VMA to reuse the maple
state and limit the number of tree walks needed.

Note, this drops the VM_BUG_ON(!vma) call, which would catch a start
address higher than the last VMA.  The code was written in a way that
allowed no VMA updates to occur and still return success.  There should be
no functional change to this scenario with the new code.

Link: https://lkml.kernel.org/r/20220906194824.2110408-57-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   56 ++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-vma-iterator-maple-state-instead-of-vma-linked-list
+++ a/mm/mempolicy.c
@@ -381,9 +381,10 @@ void mpol_rebind_task(struct task_struct
 void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
 {
 	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, mm, 0);
 
 	mmap_write_lock(mm);
-	for (vma = mm->mmap; vma; vma = vma->vm_next)
+	for_each_vma(vmi, vma)
 		mpol_rebind_policy(vma->vm_policy, new);
 	mmap_write_unlock(mm);
 }
@@ -654,7 +655,7 @@ static unsigned long change_prot_numa(st
 static int queue_pages_test_walk(unsigned long start, unsigned long end,
 				struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = walk->vma;
+	struct vm_area_struct *next, *vma = walk->vma;
 	struct queue_pages *qp = walk->private;
 	unsigned long endvma = vma->vm_end;
 	unsigned long flags = qp->flags;
@@ -669,9 +670,10 @@ static int queue_pages_test_walk(unsigne
 			/* hole at head side of range */
 			return -EFAULT;
 	}
+	next = find_vma(vma->vm_mm, vma->vm_end);
 	if (!(flags & MPOL_MF_DISCONTIG_OK) &&
 		((vma->vm_end < qp->end) &&
-		(!vma->vm_next || vma->vm_end < vma->vm_next->vm_start)))
+		(!next || vma->vm_end < next->vm_start)))
 		/* hole at middle or tail of range */
 		return -EFAULT;
 
@@ -785,26 +787,24 @@ static int vma_replace_policy(struct vm_
 static int mbind_range(struct mm_struct *mm, unsigned long start,
 		       unsigned long end, struct mempolicy *new_pol)
 {
+	MA_STATE(mas, &mm->mm_mt, start - 1, start - 1);
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
 	pgoff_t pgoff;
-	unsigned long vmstart;
-	unsigned long vmend;
-
-	vma = find_vma(mm, start);
-	VM_BUG_ON(!vma);
 
-	prev = vma->vm_prev;
-	if (start > vma->vm_start)
-		prev = vma;
+	prev = mas_find_rev(&mas, 0);
+	if (prev && (start < prev->vm_end))
+		vma = prev;
+	else
+		vma = mas_next(&mas, end - 1);
 
-	for (; vma && vma->vm_start < end; prev = vma, vma = vma->vm_next) {
-		vmstart = max(start, vma->vm_start);
-		vmend   = min(end, vma->vm_end);
+	for (; vma; vma = mas_next(&mas, end - 1)) {
+		unsigned long vmstart = max(start, vma->vm_start);
+		unsigned long vmend = min(end, vma->vm_end);
 
 		if (mpol_equal(vma_policy(vma), new_pol))
-			continue;
+			goto next;
 
 		pgoff = vma->vm_pgoff +
 			((vmstart - vma->vm_start) >> PAGE_SHIFT);
@@ -813,6 +813,8 @@ static int mbind_range(struct mm_struct
 				 new_pol, vma->vm_userfaultfd_ctx,
 				 anon_vma_name(vma));
 		if (prev) {
+			/* vma_merge() invalidated the mas */
+			mas_pause(&mas);
 			vma = prev;
 			goto replace;
 		}
@@ -820,19 +822,25 @@ static int mbind_range(struct mm_struct
 			err = split_vma(vma->vm_mm, vma, vmstart, 1);
 			if (err)
 				goto out;
+			/* split_vma() invalidated the mas */
+			mas_pause(&mas);
 		}
 		if (vma->vm_end != vmend) {
 			err = split_vma(vma->vm_mm, vma, vmend, 0);
 			if (err)
 				goto out;
+			/* split_vma() invalidated the mas */
+			mas_pause(&mas);
 		}
- replace:
+replace:
 		err = vma_replace_policy(vma, new_pol);
 		if (err)
 			goto out;
+next:
+		prev = vma;
 	}
 
- out:
+out:
 	return err;
 }
 
@@ -1049,6 +1057,7 @@ static int migrate_to_node(struct mm_str
 			   int flags)
 {
 	nodemask_t nmask;
+	struct vm_area_struct *vma;
 	LIST_HEAD(pagelist);
 	int err = 0;
 	struct migration_target_control mtc = {
@@ -1064,8 +1073,9 @@ static int migrate_to_node(struct mm_str
 	 * need migration.  Between passing in the full user address
 	 * space range and MPOL_MF_DISCONTIG_OK, this call can not fail.
 	 */
+	vma = find_vma(mm, 0);
 	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
-	queue_pages_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
+	queue_pages_range(mm, vma->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 
 	if (!list_empty(&pagelist)) {
@@ -1195,14 +1205,13 @@ static struct page *new_page(struct page
 	struct folio *dst, *src = page_folio(page);
 	struct vm_area_struct *vma;
 	unsigned long address;
+	VMA_ITERATOR(vmi, current->mm, start);
 	gfp_t gfp = GFP_HIGHUSER_MOVABLE | __GFP_RETRY_MAYFAIL;
 
-	vma = find_vma(current->mm, start);
-	while (vma) {
+	for_each_vma(vmi, vma) {
 		address = page_address_in_vma(page, vma);
 		if (address != -EFAULT)
 			break;
-		vma = vma->vm_next;
 	}
 
 	if (folio_test_hugetlb(src))
@@ -1480,6 +1489,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 	unsigned long vmend;
 	unsigned long end;
 	int err = -ENOENT;
+	VMA_ITERATOR(vmi, mm, start);
 
 	start = untagged_addr(start);
 	if (start & ~PAGE_MASK)
@@ -1505,9 +1515,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 	if (end == start)
 		return 0;
 	mmap_write_lock(mm);
-	vma = find_vma(mm, start);
-	for (; vma && vma->vm_start < end;  vma = vma->vm_next) {
-
+	for_each_vma_range(vmi, vma, end) {
 		vmstart = max(start, vma->vm_start);
 		vmend   = min(end, vma->vm_end);
 		new = mpol_dup(vma_policy(vma));
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are



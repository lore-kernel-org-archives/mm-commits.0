Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42C2C636D7
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjBJAwp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbjBJAwh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6017E6D8CF
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B78D2B822D1
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20D3C433D2;
        Fri, 10 Feb 2023 00:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990352;
        bh=PjB07UPexXeMQpz6xufNiOPCMtcDv0xsqDBv4rCuaZA=;
        h=Date:To:From:Subject:From;
        b=uG8L0mDZNpPhaDZWdyiw+prXFqyZxr9CAHITT9ajblzKO/A3BgO4MnvmAQTbm7eFO
         aC2HavhJg8hZC/CQ+XA2p6Z4tdKzUnyCoJ1WEGSs3ukBkoH6ofk8uYSzbf91aK8rSM
         DutJScReuS4p6brTvwQNNHgCgOgUu0h244LC7Xsk=
Date:   Thu, 09 Feb 2023 16:52:31 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-convert-brk-to-use-vma-iterator.patch removed from -mm tree
Message-Id: <20230210005231.F20D3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: convert brk to use vma iterator
has been removed from the -mm tree.  Its filename was
     mm-mmap-convert-brk-to-use-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: convert brk to use vma iterator
Date: Fri, 20 Jan 2023 11:26:09 -0500

Use the vma iterator API for the brk() system call.  This will provide
type safety at compile time.

Link: https://lkml.kernel.org/r/20230120162650.984577-9-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   48 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

--- a/mm/mmap.c~mm-mmap-convert-brk-to-use-vma-iterator
+++ a/mm/mmap.c
@@ -180,10 +180,10 @@ static int check_brk_limits(unsigned lon
 
 	return mlock_future_check(current->mm, current->mm->def_flags, len);
 }
-static int do_brk_munmap(struct ma_state *mas, struct vm_area_struct *vma,
+static int do_brk_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 			 unsigned long newbrk, unsigned long oldbrk,
 			 struct list_head *uf);
-static int do_brk_flags(struct ma_state *mas, struct vm_area_struct *brkvma,
+static int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *brkvma,
 		unsigned long addr, unsigned long request, unsigned long flags);
 SYSCALL_DEFINE1(brk, unsigned long, brk)
 {
@@ -194,7 +194,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	bool populate;
 	bool downgraded = false;
 	LIST_HEAD(uf);
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	struct vma_iterator vmi;
 
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
@@ -242,8 +242,8 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 		int ret;
 
 		/* Search one past newbrk */
-		mas_set(&mas, newbrk);
-		brkvma = mas_find(&mas, oldbrk);
+		vma_iter_init(&vmi, mm, newbrk);
+		brkvma = vma_find(&vmi, oldbrk);
 		if (!brkvma || brkvma->vm_start >= oldbrk)
 			goto out; /* mapping intersects with an existing non-brk vma. */
 		/*
@@ -252,7 +252,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 		 * before calling do_brk_munmap().
 		 */
 		mm->brk = brk;
-		ret = do_brk_munmap(&mas, brkvma, newbrk, oldbrk, &uf);
+		ret = do_brk_munmap(&vmi, brkvma, newbrk, oldbrk, &uf);
 		if (ret == 1)  {
 			downgraded = true;
 			goto success;
@@ -270,14 +270,14 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	 * Only check if the next VMA is within the stack_guard_gap of the
 	 * expansion area
 	 */
-	mas_set(&mas, oldbrk);
-	next = mas_find(&mas, newbrk - 1 + PAGE_SIZE + stack_guard_gap);
+	vma_iter_init(&vmi, mm, oldbrk);
+	next = vma_find(&vmi, newbrk + PAGE_SIZE + stack_guard_gap);
 	if (next && newbrk + PAGE_SIZE > vm_start_gap(next))
 		goto out;
 
-	brkvma = mas_prev(&mas, mm->start_brk);
+	brkvma = vma_prev_limit(&vmi, mm->start_brk);
 	/* Ok, looks good - let it rip. */
-	if (do_brk_flags(&mas, brkvma, oldbrk, newbrk - oldbrk, 0) < 0)
+	if (do_brk_flags(&vmi, brkvma, oldbrk, newbrk - oldbrk, 0) < 0)
 		goto out;
 
 	mm->brk = brk;
@@ -2917,8 +2917,8 @@ out:
 }
 
 /*
- * brk_munmap() - Unmap a partial vma.
- * @mas: The maple tree state.
+ * brk_munmap() - Unmap a full or partial vma.
+ * @vmi: The vma iterator
  * @vma: The vma to be modified
  * @newbrk: the start of the address to unmap
  * @oldbrk: The end of the address to unmap
@@ -2928,7 +2928,7 @@ out:
  * unmaps a partial VMA mapping.  Does not handle alignment, downgrades lock if
  * possible.
  */
-static int do_brk_munmap(struct ma_state *mas, struct vm_area_struct *vma,
+static int do_brk_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 			 unsigned long newbrk, unsigned long oldbrk,
 			 struct list_head *uf)
 {
@@ -2936,14 +2936,14 @@ static int do_brk_munmap(struct ma_state
 	int ret;
 
 	arch_unmap(mm, newbrk, oldbrk);
-	ret = do_mas_align_munmap(mas, vma, mm, newbrk, oldbrk, uf, true);
+	ret = do_mas_align_munmap(&vmi->mas, vma, mm, newbrk, oldbrk, uf, true);
 	validate_mm_mt(mm);
 	return ret;
 }
 
 /*
  * do_brk_flags() - Increase the brk vma if the flags match.
- * @mas: The maple tree state.
+ * @vmi: The vma iterator
  * @addr: The start address
  * @len: The length of the increase
  * @vma: The vma,
@@ -2953,7 +2953,7 @@ static int do_brk_munmap(struct ma_state
  * do not match then create a new anonymous VMA.  Eventually we may be able to
  * do some brk-specific accounting here.
  */
-static int do_brk_flags(struct ma_state *mas, struct vm_area_struct *vma,
+static int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		unsigned long addr, unsigned long len, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
@@ -2980,8 +2980,7 @@ static int do_brk_flags(struct ma_state
 	if (vma && vma->vm_end == addr && !vma_policy(vma) &&
 	    can_vma_merge_after(vma, flags, NULL, NULL,
 				addr >> PAGE_SHIFT, NULL_VM_UFFD_CTX, NULL)) {
-		mas_set_range(mas, vma->vm_start, addr + len - 1);
-		if (mas_preallocate(mas, GFP_KERNEL))
+		if (vma_iter_prealloc(vmi))
 			goto unacct_fail;
 
 		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
@@ -2991,7 +2990,7 @@ static int do_brk_flags(struct ma_state
 		}
 		vma->vm_end = addr + len;
 		vma->vm_flags |= VM_SOFTDIRTY;
-		mas_store_prealloc(mas, vma);
+		vma_iter_store(vmi, vma);
 
 		if (vma->anon_vma) {
 			anon_vma_interval_tree_post_update_vma(vma);
@@ -3012,8 +3011,7 @@ static int do_brk_flags(struct ma_state
 	vma->vm_pgoff = addr >> PAGE_SHIFT;
 	vma->vm_flags = flags;
 	vma->vm_page_prot = vm_get_page_prot(flags);
-	mas_set_range(mas, vma->vm_start, addr + len - 1);
-	if (mas_store_gfp(mas, vma, GFP_KERNEL))
+	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
 		goto mas_store_fail;
 
 	mm->map_count++;
@@ -3042,7 +3040,7 @@ int vm_brk_flags(unsigned long addr, uns
 	int ret;
 	bool populate;
 	LIST_HEAD(uf);
-	MA_STATE(mas, &mm->mm_mt, addr, addr);
+	VMA_ITERATOR(vmi, mm, addr);
 
 	len = PAGE_ALIGN(request);
 	if (len < request)
@@ -3061,12 +3059,12 @@ int vm_brk_flags(unsigned long addr, uns
 	if (ret)
 		goto limits_failed;
 
-	ret = do_mas_munmap(&mas, mm, addr, len, &uf, 0);
+	ret = do_mas_munmap(&vmi.mas, mm, addr, len, &uf, 0);
 	if (ret)
 		goto munmap_failed;
 
-	vma = mas_prev(&mas, 0);
-	ret = do_brk_flags(&mas, vma, addr, len, flags);
+	vma = vma_prev(&vmi);
+	ret = do_brk_flags(&vmi, vma, addr, len, flags);
 	populate = ((mm->def_flags & VM_LOCKED) != 0);
 	mmap_write_unlock(mm);
 	userfaultfd_unmap_complete(mm, &uf);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are



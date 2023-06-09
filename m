Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8866BC8300C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjFIXbm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjFIXbE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EF744A8
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 478A561AE1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5CCC433D2;
        Fri,  9 Jun 2023 23:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353341;
        bh=VylVTM1CmaGOBl4n9yREFHEMvGupjwy/HhH0ArJQ5X0=;
        h=Date:To:From:Subject:From;
        b=d26FHPbvtP5Xp+ULQyCZpVUr30kxkNl1U+38Rob43oOWip4fzueof++R5uJAO+7qG
         vAw0mFC2hwxa81OjLZDZrT5xyUynb+8IKeKsWj4HU7uzf9tdDxlcdwfdFUFXaykJP/
         3BB5IbZRy+EmsiA4DD2xLsn7w9V9Evq38NJiO5Ac=
Date:   Fri, 09 Jun 2023 16:29:01 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        liam.howlett@oracle.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-refactor-mlock_future_check.patch removed from -mm tree
Message-Id: <20230609232901.9D5CCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: refactor mlock_future_check()
has been removed from the -mm tree.  Its filename was
     mm-mmap-refactor-mlock_future_check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/mmap: refactor mlock_future_check()
Date: Mon, 22 May 2023 09:24:12 +0100

In all but one instance, mlock_future_check() is treated as a boolean
function despite returning an error code.  In one instance, this error
code is ignored and replaced with -ENOMEM.

This is confusing, and the inversion of true -> failure, false -> success
is not warranted.  Convert the function to a bool, lightly refactor and
return true if the check passes, false if not.

Link: https://lkml.kernel.org/r/20230522082412.56685-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |    4 ++--
 mm/mmap.c      |   33 +++++++++++++++++----------------
 mm/mremap.c    |    2 +-
 mm/secretmem.c |    2 +-
 4 files changed, 21 insertions(+), 20 deletions(-)

--- a/mm/internal.h~mm-mmap-refactor-mlock_future_check
+++ a/mm/internal.h
@@ -576,8 +576,8 @@ extern long populate_vma_page_range(stru
 extern long faultin_vma_page_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end,
 				   bool write, int *locked);
-extern int mlock_future_check(struct mm_struct *mm, unsigned long flags,
-			      unsigned long len);
+extern bool mlock_future_check(struct mm_struct *mm, unsigned long flags,
+			       unsigned long bytes);
 /*
  * mlock_vma_folio() and munlock_vma_folio():
  * should be called with vma's mmap_lock held for read or write,
--- a/mm/mmap.c~mm-mmap-refactor-mlock_future_check
+++ a/mm/mmap.c
@@ -182,7 +182,8 @@ static int check_brk_limits(unsigned lon
 	if (IS_ERR_VALUE(mapped_addr))
 		return mapped_addr;
 
-	return mlock_future_check(current->mm, current->mm->def_flags, len);
+	return mlock_future_check(current->mm, current->mm->def_flags, len)
+		? 0 : -EAGAIN;
 }
 static int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *brkvma,
 		unsigned long addr, unsigned long request, unsigned long flags);
@@ -1145,21 +1146,21 @@ static inline unsigned long round_hint_t
 	return hint;
 }
 
-int mlock_future_check(struct mm_struct *mm, unsigned long flags,
-		       unsigned long len)
+bool mlock_future_check(struct mm_struct *mm, unsigned long flags,
+			unsigned long bytes)
 {
-	unsigned long locked, lock_limit;
+	unsigned long locked_pages, limit_pages;
 
-	/*  mlock MCL_FUTURE? */
-	if (flags & VM_LOCKED) {
-		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
-		lock_limit = rlimit(RLIMIT_MEMLOCK);
-		lock_limit >>= PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			return -EAGAIN;
-	}
-	return 0;
+	if (!(flags & VM_LOCKED) || capable(CAP_IPC_LOCK))
+		return true;
+
+	locked_pages = bytes >> PAGE_SHIFT;
+	locked_pages += mm->locked_vm;
+
+	limit_pages = rlimit(RLIMIT_MEMLOCK);
+	limit_pages >>= PAGE_SHIFT;
+
+	return locked_pages <= limit_pages;
 }
 
 static inline u64 file_mmap_size_max(struct file *file, struct inode *inode)
@@ -1271,7 +1272,7 @@ unsigned long do_mmap(struct file *file,
 		if (!can_do_mlock())
 			return -EPERM;
 
-	if (mlock_future_check(mm, vm_flags, len))
+	if (!mlock_future_check(mm, vm_flags, len))
 		return -EAGAIN;
 
 	if (file) {
@@ -1889,7 +1890,7 @@ static int acct_stack_growth(struct vm_a
 		return -ENOMEM;
 
 	/* mlock limit tests */
-	if (mlock_future_check(mm, vma->vm_flags, grow << PAGE_SHIFT))
+	if (!mlock_future_check(mm, vma->vm_flags, grow << PAGE_SHIFT))
 		return -ENOMEM;
 
 	/* Check to ensure the stack will not grow into a hugetlb-only region */
--- a/mm/mremap.c~mm-mmap-refactor-mlock_future_check
+++ a/mm/mremap.c
@@ -775,7 +775,7 @@ static struct vm_area_struct *vma_to_res
 	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
 		return ERR_PTR(-EFAULT);
 
-	if (mlock_future_check(mm, vma->vm_flags, new_len - old_len))
+	if (!mlock_future_check(mm, vma->vm_flags, new_len - old_len))
 		return ERR_PTR(-EAGAIN);
 
 	if (!may_expand_vm(mm, vma->vm_flags,
--- a/mm/secretmem.c~mm-mmap-refactor-mlock_future_check
+++ a/mm/secretmem.c
@@ -125,7 +125,7 @@ static int secretmem_mmap(struct file *f
 	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
 		return -EINVAL;
 
-	if (mlock_future_check(vma->vm_mm, vma->vm_flags | VM_LOCKED, len))
+	if (!mlock_future_check(vma->vm_mm, vma->vm_flags | VM_LOCKED, len))
 		return -EAGAIN;
 
 	vm_flags_set(vma, VM_LOCKED | VM_DONTDUMP);
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch


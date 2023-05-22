Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26462C7EE29
	for <mm-commits@archiver.kernel.org>; Mon, 22 May 2023 20:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjEVU3e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 May 2023 16:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbjEVU3Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2023 16:29:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1CAB5
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 13:29:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B5EE62214
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 20:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4C5C4339B;
        Mon, 22 May 2023 20:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684787363;
        bh=jG4EJbT4cdLJkS/uSk4Sbt2sHcnMEH7MeTjRUk7um3g=;
        h=Date:To:From:Subject:From;
        b=vFfA9ac6eFoBZwfPa/1mH8OqvSWGmQNiVISiGWnM2+KMrJoi0akl2xJftsmFAQ0J0
         RlR4++hsu+sBIQD7Saqz1VefsG3zWl0YLRGUpCoyCnMme/jzneuI4hK7SEVRFC6UlV
         SCfKhp5UOTCUxI+yZRpB1etmoxgH23gfvQXiWmjY=
Date:   Mon, 22 May 2023 13:29:22 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        liam.howlett@oracle.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-refactor-mlock_future_check.patch added to mm-unstable branch
Message-Id: <20230522202922.DF4C5C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: refactor mlock_future_check()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-refactor-mlock_future_check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-refactor-mlock_future_check.patch

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
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -1148,21 +1149,21 @@ static inline unsigned long round_hint_t
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
@@ -1274,7 +1275,7 @@ unsigned long do_mmap(struct file *file,
 		if (!can_do_mlock())
 			return -EPERM;
 
-	if (mlock_future_check(mm, vm_flags, len))
+	if (!mlock_future_check(mm, vm_flags, len))
 		return -EAGAIN;
 
 	if (file) {
@@ -1926,7 +1927,7 @@ static int acct_stack_growth(struct vm_a
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

mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch
mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch
mm-gup-remove-unused-vmas-parameter-from-get_user_pages.patch
mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch
mm-gup-remove-vmas-parameter-from-get_user_pages_remote.patch
io_uring-rsrc-delegate-vma-file-backed-check-to-gup.patch
mm-gup-remove-vmas-parameter-from-pin_user_pages.patch
mm-gup-remove-vmas-array-from-internal-gup-functions.patch
mm-mmap-refactor-mlock_future_check.patch


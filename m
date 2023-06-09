Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E95C83005
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbjFIXbl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbjFIXbE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25DE3C0E
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8873D6169F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC603C433D2;
        Fri,  9 Jun 2023 23:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353343;
        bh=i8x12rIwvvGYDMd0QI3fT/cziuhLUGSj5C2uZv+W0yY=;
        h=Date:To:From:Subject:From;
        b=RTryVM8y9QO9QVYJyhuYmDKIPGcLEUZWP1M12zcSQ/ml8tYsTam58fBE+4BWY+jVZ
         eXhQoNhQTklEIp8O6x9AffmeX8TV+AoHo+8TnPnAMCd40eeuVZGjp0odg0mq+ipPhS
         UR8peT1A53Q1EgWxczrz1ou82KIP8s59vwCuw1s8=
Date:   Fri, 09 Jun 2023 16:29:02 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        lstoakes@gmail.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch removed from -mm tree
Message-Id: <20230609232902.DC603C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mlock: rename mlock_future_check() to mlock_future_ok()
has been removed from the -mm tree.  Its filename was
     mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/mlock: rename mlock_future_check() to mlock_future_ok()
Date: Mon May 22 01:52:10 PM PDT 2023

It is felt that the name mlock_future_check() is vague - it doesn't
particularly convey the function's operation.  mlock_future_ok() is a
clearer name for a predicate function.

Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |    2 +-
 mm/mmap.c      |    8 ++++----
 mm/mremap.c    |    2 +-
 mm/secretmem.c |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/mm/internal.h~mm-mlock-rename-mlock_future_check-to-mlock_future_ok
+++ a/mm/internal.h
@@ -576,7 +576,7 @@ extern long populate_vma_page_range(stru
 extern long faultin_vma_page_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end,
 				   bool write, int *locked);
-extern bool mlock_future_check(struct mm_struct *mm, unsigned long flags,
+extern bool mlock_future_ok(struct mm_struct *mm, unsigned long flags,
 			       unsigned long bytes);
 /*
  * mlock_vma_folio() and munlock_vma_folio():
--- a/mm/mmap.c~mm-mlock-rename-mlock_future_check-to-mlock_future_ok
+++ a/mm/mmap.c
@@ -182,7 +182,7 @@ static int check_brk_limits(unsigned lon
 	if (IS_ERR_VALUE(mapped_addr))
 		return mapped_addr;
 
-	return mlock_future_check(current->mm, current->mm->def_flags, len)
+	return mlock_future_ok(current->mm, current->mm->def_flags, len)
 		? 0 : -EAGAIN;
 }
 static int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *brkvma,
@@ -1146,7 +1146,7 @@ static inline unsigned long round_hint_t
 	return hint;
 }
 
-bool mlock_future_check(struct mm_struct *mm, unsigned long flags,
+bool mlock_future_ok(struct mm_struct *mm, unsigned long flags,
 			unsigned long bytes)
 {
 	unsigned long locked_pages, limit_pages;
@@ -1272,7 +1272,7 @@ unsigned long do_mmap(struct file *file,
 		if (!can_do_mlock())
 			return -EPERM;
 
-	if (!mlock_future_check(mm, vm_flags, len))
+	if (!mlock_future_ok(mm, vm_flags, len))
 		return -EAGAIN;
 
 	if (file) {
@@ -1890,7 +1890,7 @@ static int acct_stack_growth(struct vm_a
 		return -ENOMEM;
 
 	/* mlock limit tests */
-	if (!mlock_future_check(mm, vma->vm_flags, grow << PAGE_SHIFT))
+	if (!mlock_future_ok(mm, vma->vm_flags, grow << PAGE_SHIFT))
 		return -ENOMEM;
 
 	/* Check to ensure the stack will not grow into a hugetlb-only region */
--- a/mm/mremap.c~mm-mlock-rename-mlock_future_check-to-mlock_future_ok
+++ a/mm/mremap.c
@@ -775,7 +775,7 @@ static struct vm_area_struct *vma_to_res
 	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
 		return ERR_PTR(-EFAULT);
 
-	if (!mlock_future_check(mm, vma->vm_flags, new_len - old_len))
+	if (!mlock_future_ok(mm, vma->vm_flags, new_len - old_len))
 		return ERR_PTR(-EAGAIN);
 
 	if (!may_expand_vm(mm, vma->vm_flags,
--- a/mm/secretmem.c~mm-mlock-rename-mlock_future_check-to-mlock_future_ok
+++ a/mm/secretmem.c
@@ -125,7 +125,7 @@ static int secretmem_mmap(struct file *f
 	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
 		return -EINVAL;
 
-	if (!mlock_future_check(vma->vm_mm, vma->vm_flags | VM_LOCKED, len))
+	if (!mlock_future_ok(vma->vm_mm, vma->vm_flags | VM_LOCKED, len))
 		return -EAGAIN;
 
 	vm_flags_set(vma, VM_LOCKED | VM_DONTDUMP);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch


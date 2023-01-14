Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91592C3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 05:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjANFKK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Jan 2023 00:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjANFKJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Jan 2023 00:10:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6118530F7
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 21:10:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8C9760AFA
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 05:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492A4C433EF;
        Sat, 14 Jan 2023 05:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673673007;
        bh=x7US6lq4odkSBXWiuK9RRR493CBZM3xs2pEmESD8vMk=;
        h=Date:To:From:Subject:From;
        b=Iem0NDZUihlSSsguFU5zyQOMt7FHrPi8RMOcubaFu8grZlV/A1XTGch8SrU62NZG9
         WPgBwn78yUAt5Kv83WnMUqKNa5ylUeNwgp1FfPLJ3BQsBTdNLs2nmUZY486YkTYSHr
         xN+OXV9kVbKmSNNadr2yXDhloRgyNXmLgzF5jmII=
Date:   Fri, 13 Jan 2023 21:10:06 -0800
To:     mm-commits@vger.kernel.org, riel@surriel.com, hughd@google.com,
        stevensd@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-khugepaged-with-shmem_enabled=advise.patch added to mm-unstable branch
Message-Id: <20230114051007.492A4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix khugepaged with shmem_enabled=advise
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-khugepaged-with-shmem_enabled=advise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-khugepaged-with-shmem_enabled=advise.patch

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
From: David Stevens <stevensd@chromium.org>
Subject: mm: fix khugepaged with shmem_enabled=advise
Date: Fri, 13 Jan 2023 11:30:11 +0900

Pass vm_flags as a parameter to shmem_is_huge, rather than reading the
flags from the vm_area_struct in question.  This allows the updated flags
from hugepage_madvise to be passed to the check, which is necessary
because madvise does not update the vm_area_struct's flags until after
hugepage_madvise returns.

This fixes an issue when shmem_enabled=madvise, where MADV_HUGEPAGE on
shmem was not able to register the mm_struct with khugepaged.  Prior to
cd89fb065099, the mm_struct was registered by MADV_HUGEPAGE regardless of
the value of shmem_enabled (which was only checked when scanning vmas).

Link: https://lkml.kernel.org/r/20230113023011.1784015-1-stevensd@google.com
Fixes: cd89fb065099 ("mm,thp,shmem: make khugepaged obey tmpfs mount flags")
Signed-off-by: David Stevens <stevensd@chromium.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/shmem_fs.h~mm-fix-khugepaged-with-shmem_enabled=advise
+++ a/include/linux/shmem_fs.h
@@ -92,14 +92,8 @@ extern struct page *shmem_read_mapping_p
 extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 int shmem_unuse(unsigned int type);
 
-extern bool shmem_is_huge(struct vm_area_struct *vma, struct inode *inode,
-			  pgoff_t index, bool shmem_huge_force);
-static inline bool shmem_huge_enabled(struct vm_area_struct *vma,
-				      bool shmem_huge_force)
-{
-	return shmem_is_huge(vma, file_inode(vma->vm_file), vma->vm_pgoff,
-			     shmem_huge_force);
-}
+extern bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
+			  struct mm_struct *mm, unsigned long vm_flags);
 extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
 extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 						pgoff_t start, pgoff_t end);
--- a/mm/huge_memory.c~mm-fix-khugepaged-with-shmem_enabled=advise
+++ a/mm/huge_memory.c
@@ -119,7 +119,8 @@ bool hugepage_vma_check(struct vm_area_s
 	 * own flags.
 	 */
 	if (!in_pf && shmem_file(vma->vm_file))
-		return shmem_huge_enabled(vma, !enforce_sysfs);
+		return shmem_is_huge(file_inode(vma->vm_file), vma->vm_pgoff,
+				     !enforce_sysfs, vma->vm_mm, vm_flags);
 
 	/* Enforce sysfs THP requirements as necessary */
 	if (enforce_sysfs &&
--- a/mm/shmem.c~mm-fix-khugepaged-with-shmem_enabled=advise
+++ a/mm/shmem.c
@@ -468,15 +468,14 @@ static bool shmem_confirm_swap(struct ad
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-bool shmem_is_huge(struct vm_area_struct *vma, struct inode *inode,
-		   pgoff_t index, bool shmem_huge_force)
+bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
+		   struct mm_struct *mm, unsigned long vm_flags)
 {
 	loff_t i_size;
 
 	if (!S_ISREG(inode->i_mode))
 		return false;
-	if (vma && ((vma->vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
+	if (mm && ((vm_flags & VM_NOHUGEPAGE) || test_bit(MMF_DISABLE_THP, &mm->flags)))
 		return false;
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return false;
@@ -493,7 +492,7 @@ bool shmem_is_huge(struct vm_area_struct
 			return true;
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
-		if (vma && (vma->vm_flags & VM_HUGEPAGE))
+		if (mm && (vm_flags & VM_HUGEPAGE))
 			return true;
 		fallthrough;
 	default:
@@ -676,8 +675,8 @@ static long shmem_unused_huge_count(stru
 
 #define shmem_huge SHMEM_HUGE_DENY
 
-bool shmem_is_huge(struct vm_area_struct *vma, struct inode *inode,
-		   pgoff_t index, bool shmem_huge_force)
+bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
+		   struct mm_struct *mm, unsigned long vm_flags)
 {
 	return false;
 }
@@ -1068,7 +1067,7 @@ static int shmem_getattr(struct user_nam
 			STATX_ATTR_NODUMP);
 	generic_fillattr(&init_user_ns, inode, stat);
 
-	if (shmem_is_huge(NULL, inode, 0, false))
+	if (shmem_is_huge(inode, 0, false, NULL, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
 
 	if (request_mask & STATX_BTIME) {
@@ -1926,7 +1925,8 @@ repeat:
 		return 0;
 	}
 
-	if (!shmem_is_huge(vma, inode, index, false))
+	if (!shmem_is_huge(inode, index, false,
+			   vma ? vma->vm_mm : NULL, vma ? vma->vm_flags : 0))
 		goto alloc_nohuge;
 
 	huge_gfp = vma_thp_gfp_mask(vma);
_

Patches currently in -mm which might be from stevensd@chromium.org are

mm-fix-khugepaged-with-shmem_enabled=advise.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3338AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 21:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiEJVK1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 17:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiEJVKZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 17:10:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF70294495
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 14:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EEDB6170E
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 21:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5E1C385CD;
        Tue, 10 May 2022 21:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652217022;
        bh=chbXX/e2Z0iFrZKdlX8uOXTXztVV2FJ7qZtJ6NhwfAY=;
        h=Date:To:From:Subject:From;
        b=U37s/kebQfPVXwBuOrg5uUCidD+ud3uJBLkpFhp96zWjI0W+psxlRW3GAYaOJ53CF
         NM9x1qRCUs2CtC6d4ojtNzyWKG1H+ZvlDw+rFaGyQ+vMWiqenNoEiUsewOBPlFdvbp
         AJ2qF4fx+gpgOK1MWLJzbxL8LmdYC25HzYo4BvpU=
Date:   Tue, 10 May 2022 14:10:22 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, songliubraving@fb.com,
        song@kernel.org, riel@surriel.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch added to mm-unstable branch
Message-Id: <20220510211022.DA5E1C385CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: remove redundant check for VM_NO_KHUGEPAGED
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch

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
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: remove redundant check for VM_NO_KHUGEPAGED

The hugepage_vma_check() called by khugepaged_enter_vma_merge() does check
VM_NO_KHUGEPAGED.  Remove the check from caller and move the check in
hugepage_vma_check() up.

More checks may be run for VM_NO_KHUGEPAGED vmas, but MADV_HUGEPAGE is
definitely not a hot path, so cleaner code does outweigh.

Link: https://lkml.kernel.org/r/20220510203222.24246-3-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Song Liu <song@kernel.org>
Acked-by: Vlastmil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged
+++ a/mm/khugepaged.c
@@ -365,8 +365,7 @@ int hugepage_madvise(struct vm_area_stru
 		 * register it here without waiting a page fault that
 		 * may not happen any time soon.
 		 */
-		if (!(*vm_flags & VM_NO_KHUGEPAGED) &&
-				khugepaged_enter_vma_merge(vma, *vm_flags))
+		if (khugepaged_enter_vma_merge(vma, *vm_flags))
 			return -ENOMEM;
 		break;
 	case MADV_NOHUGEPAGE:
@@ -445,6 +444,9 @@ static bool hugepage_vma_check(struct vm
 	if (!transhuge_vma_enabled(vma, vm_flags))
 		return false;
 
+	if (vm_flags & VM_NO_KHUGEPAGED)
+		return false;
+
 	if (vma->vm_file && !IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) -
 				vma->vm_pgoff, HPAGE_PMD_NR))
 		return false;
@@ -470,7 +472,8 @@ static bool hugepage_vma_check(struct vm
 		return false;
 	if (vma_is_temporary_stack(vma))
 		return false;
-	return !(vm_flags & VM_NO_KHUGEPAGED);
+
+	return true;
 }
 
 int __khugepaged_enter(struct mm_struct *mm)
_

Patches currently in -mm which might be from shy828301@gmail.com are

sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch
mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch
mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-make-hugepage_vma_check-non-static.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch


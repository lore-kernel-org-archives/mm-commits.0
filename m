Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36853C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243546AbiESWZa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243582AbiESWZ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3055D6622A
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C928C6166C
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBBCC385B8;
        Thu, 19 May 2022 22:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999126;
        bh=uWzX9pD8wpZGz2NW09c4omzxHpDmo18ltjc23Dd1ynM=;
        h=Date:To:From:Subject:From;
        b=nyPnAPhtovBM+VqeB1FsxnLZYaEluo2bHOWvAZypXNE6Y7V5u09Q1kdEGCpXl10Io
         +QmEwWyH2BeHnbOCqlwPNRoQ4FQBfDt7HQYekzTQuqnCjuTJjbMAoEOp50JRFoPvAj
         MhMuYWxXuWT7+z/810OxGMYBIkGOT1b+G7vmOWmU=
Date:   Thu, 19 May 2022 15:25:25 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, songliubraving@fb.com,
        song@kernel.org, riel@surriel.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch removed from -mm tree
Message-Id: <20220519222526.2FBBCC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: khugepaged: remove redundant check for VM_NO_KHUGEPAGED
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch


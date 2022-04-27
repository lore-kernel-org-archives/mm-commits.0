Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09218C4167B
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 22:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239451AbiD0XAo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239418AbiD0W5x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 18:57:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8FB8D6B1
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 15:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D88B1B82ABE
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 22:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9340CC385AA;
        Wed, 27 Apr 2022 22:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651100025;
        bh=c0ucsRUYYxkbQv/L41pMPjq+rNT22z6twvJv3BfAsc0=;
        h=Date:To:From:Subject:From;
        b=fIXSED06Gh5ZXMgb9vDXElBsuZpR7cl8dPpQVRKS4j9bPNUSClf6qND4rFOPYkKQh
         04lVJFOZbq5VhNl3JivmKQwgftfDAPqAkojDb5gPbFzJRyL+0R2LewjCX2L3YhxKto
         EXW5QeQdfLfVUbNQIIV2xgYUDHlxb2u36mmbmj0c=
Date:   Wed, 27 Apr 2022 15:53:44 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, song@kernel.org, riel@surriel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch removed from -mm tree
Message-Id: <20220427225345.9340CC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: remove redundant check for VM_NO_KHUGEPAGED
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: remove redundant check for VM_NO_KHUGEPAGED

The hugepage_vma_check() called by khugepaged_enter_vma_merge() does check
VM_NO_KHUGEPAGED.  Remove the check from caller and move the check in
hugepage_vma_check() up.

More checks may be run for VM_NO_KHUGEPAGED vmas, but MADV_HUGEPAGE is
definitely not a hot path, so cleaner code does outweigh.

Link: https://lkml.kernel.org/r/20220404200250.321455-3-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Song Liu <song@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-move-some-khugepaged_-functions-to-khugepagedc.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch


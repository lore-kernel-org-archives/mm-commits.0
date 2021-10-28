Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50774C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 280BC610CA
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhJ1V0h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230404AbhJ1V0f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 17:26:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32CE461056;
        Thu, 28 Oct 2021 21:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635456248;
        bh=otU36Iw0C41t7h2lsu3D0LBqJN9JMmRJjch5GIR13ZA=;
        h=Date:From:To:Subject:From;
        b=1B25BR1rKQ2iayYKc5JYwjjb6avcxbHmfkxF6/q6KqL3O69E6UKBZaz1EmY3Eo0aX
         Cnke+OfV6g/ed2ajv5WplMRAcYMhOAKpUV05SbSjkGJHn1DPDWlspvnMqLldWkT8si
         wpHqbad3c9WcGKN4rd4sPVIwEeM6l1R8GInFqaFo=
Date:   Thu, 28 Oct 2021 14:24:07 -0700
From:   akpm@linux-foundation.org
To:     andrea.righi@canonical.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, songliubraving@fb.com, sunhao.th@gmail.com,
        willy@infradead.org
Subject:  [folded-merged]
 mm-khugepaged-skip-huge-page-collapse-for-special-files-fix.patch removed
 from -mm tree
Message-ID: <20211028212407.aeoar7tnN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-khugepaged-skip-huge-page-collapse-for-special-files-fix
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-skip-huge-page-collapse-for-special-files-fix.patch

This patch was dropped because it was folded into mm-khugepaged-skip-huge-page-collapse-for-special-files.patch

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm-khugepaged-skip-huge-page-collapse-for-special-files-fix

fix vm_file check

Link: https://lkml.kernel.org/r/CAHbLzkqTW9U3VvTu1Ki5v_cLRC9gHW+znBukg_ycergE0JWj-A@mail.gmail.com
Cc: Andrea Righi <andrea.righi@canonical.com>
Cc: Hao Sun <sunhao.th@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-skip-huge-page-collapse-for-special-files-fix
+++ a/mm/khugepaged.c
@@ -445,9 +445,9 @@ static bool hugepage_vma_check(struct vm
 	if (!transhuge_vma_enabled(vma, vm_flags))
 		return false;
 
-	if (vma->vm_file)
-		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
-				HPAGE_PMD_NR);
+	if (vma->vm_file && !IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) -
+				vma->vm_pgoff, HPAGE_PMD_NR))
+		return false;
 
 	/* Enabled via shmem mount options or sysfs settings. */
 	if (shmem_file(vma->vm_file))
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-hwpoison-remove-the-unnecessary-thp-check.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
mm-khugepaged-skip-huge-page-collapse-for-special-files.patch
mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
mm-hwpoison-refactor-refcount-check-handling.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
mm-hwpoison-handle-non-anonymous-thp-correctly.patch
mm-migrate-make-demotion-knob-depend-on-migration.patch


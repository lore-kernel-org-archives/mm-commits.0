Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33483C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 20:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ACE8610C7
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 20:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhJ0U7L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 16:59:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240845AbhJ0U7K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 16:59:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9F39610A3;
        Wed, 27 Oct 2021 20:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635368205;
        bh=TuOF+I2Kh9J0toApP+Jf0UK/YGN3Pbb/wJEeiMOWjLU=;
        h=Date:From:To:Subject:From;
        b=NEHTELZqc4/DntXaUnS4tcraDBjqmIiTDBIkfSfopC9wzQxVGT0rhFA140+g79KZO
         ID5yUChvxnUr9jN24/SaFSHaZe5pWM/mZy1eBKDXqVfP6ErWOLllukx4poVvM39zW7
         rfVTe2aPNXvnZQopZbVO7CdfvG5o+4wPqvaf4tYw=
Date:   Wed, 27 Oct 2021 13:56:44 -0700
From:   akpm@linux-foundation.org
To:     andrea.righi@canonical.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, songliubraving@fb.com, sunhao.th@gmail.com,
        willy@infradead.org
Subject:  +
 mm-khugepaged-skip-huge-page-collapse-for-special-files-fix.patch added to
 -mm tree
Message-ID: <20211027205644.y8vzhdalv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-khugepaged-skip-huge-page-collapse-for-special-files-fix
has been added to the -mm tree.  Its filename is
     mm-khugepaged-skip-huge-page-collapse-for-special-files-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-skip-huge-page-collapse-for-special-files-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-skip-huge-page-collapse-for-special-files-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-khugepaged-skip-huge-page-collapse-for-special-files-fix.patch
mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
mm-hwpoison-refactor-refcount-check-handling.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
mm-hwpoison-handle-non-anonymous-thp-correctly.patch
mm-migrate-make-demotion-knob-depend-on-migration.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED862CCA47A
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 18:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiFPSXP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiFPSXN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 14:23:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7864231936
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 11:23:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AAAFB82595
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 18:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BDEC34114;
        Thu, 16 Jun 2022 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655403788;
        bh=EqWqkM/FGzacgLB4azqhxQaFqB7GMcpZeO9dtChbuBc=;
        h=Date:To:From:Subject:From;
        b=Yvkzf6NWAdMvHUdtu+GxRU+/IUqMsgBrAreP5KLLS1oyb3dkRY3RFvpj/TU0JMxOk
         PMtPeOZsXWbsHhc8s+ZjYNnhUZsxwXJtCR6tPanT9jJXX9Fquqf8B2O9j1hx9jkCn2
         rfyqPmLOCXfkBp4cjBq1qJGz5/AkD9PXk1gwj6cs=
Date:   Thu, 16 Jun 2022 11:23:08 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch added to mm-unstable branch
Message-Id: <20220616182308.A1BDEC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: better comments for anon vma check in hugepage_vma_revalidate
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch

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
Subject: mm: khugepaged: better comments for anon vma check in hugepage_vma_revalidate
Date: Thu, 16 Jun 2022 10:48:36 -0700

The hugepage_vma_revalidate() needs to check if the vma is still anonymous
vma or not since the address may be unmapped then remapped to file before
khugepaged reaquired the mmap_lock.

The old comment is not quite helpful, elaborate this with better comment.

Link: https://lkml.kernel.org/r/20220616174840.1202070-4-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate
+++ a/mm/khugepaged.c
@@ -954,7 +954,13 @@ static int hugepage_vma_revalidate(struc
 		return SCAN_ADDRESS_RANGE;
 	if (!hugepage_vma_check(vma, vma->vm_flags))
 		return SCAN_VMA_CHECK;
-	/* Anon VMA expected */
+	/*
+	 * Anon VMA expected, the address may be unmapped then
+	 * remapped to file after khugepaged reaquired the mmap_lock.
+	 *
+	 * hugepage_vma_check may return true for qualified file
+	 * vmas.
+	 */
 	if (!vma->anon_vma || !vma_is_anonymous(vma))
 		return SCAN_VMA_CHECK;
 	return 0;
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch
mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch
mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch
mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch
mm-thp-kill-transparent_hugepage_active.patch
mm-thp-kill-__transhuge_page_enabled.patch
mm-khugepaged-reorg-some-khugepaged-helpers.patch
doc-proc-fix-the-description-to-thpeligible.patch


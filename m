Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD04C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245438AbiESWZe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245348AbiESWZ3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623E366237
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F199A61698
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5533AC385AA;
        Thu, 19 May 2022 22:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999127;
        bh=frfYly+NPTnGz86xHRK/1d3Dlwb3fITA75MRbE55Qlo=;
        h=Date:To:From:Subject:From;
        b=cyyAt4SPBkkcVS7VuAkL2hii3BpHzMTcWTQS+puJtZwD7RA4TigTEw0yweIt2JbR9
         sANvWo/hXyAIB1jPn7wD5ukNZcQ1JMTDz/GIvc3HrzFENyk154MtxeikL2E2NEu4Qe
         GX1ai5nIZWbK0sVkIYlF6nkRRx9Z/4x91iaL6qzM=
Date:   Thu, 19 May 2022 15:25:26 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, songliubraving@fb.com,
        song@kernel.org, riel@surriel.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-skip-dax-vma.patch removed from -mm tree
Message-Id: <20220519222527.5533AC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: khugepaged: skip DAX vma
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-skip-dax-vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: skip DAX vma

The DAX vma may be seen by khugepaged when the mm has other khugepaged
suitable vmas.  So khugepaged may try to collapse THP for DAX vma, but it
will fail due to page sanity check, for example, page is not on LRU.

So it is not harmful, but it is definitely pointless to run khugepaged
against DAX vma, so skip it in early check.

Link: https://lkml.kernel.org/r/20220510203222.24246-4-shy828301@gmail.com
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

 mm/khugepaged.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-skip-dax-vma
+++ a/mm/khugepaged.c
@@ -447,6 +447,10 @@ static bool hugepage_vma_check(struct vm
 	if (vm_flags & VM_NO_KHUGEPAGED)
 		return false;
 
+	/* Don't run khugepaged against DAX vma */
+	if (vma_is_dax(vma))
+		return false;
+
 	if (vma->vm_file && !IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) -
 				vma->vm_pgoff, HPAGE_PMD_NR))
 		return false;
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch


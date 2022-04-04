Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3214EC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 23:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiDDXka (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiDDXkZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 19:40:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C943633AA
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 16:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 792DA61766
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 23:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF04FC340F3;
        Mon,  4 Apr 2022 23:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649115482;
        bh=hCGM3px/Elt0YFA0QVVBIxAY6M9ghmxA6hPnBeeDwfk=;
        h=Date:To:From:Subject:From;
        b=D8jy9/YE5f5f8D1ysuY8S1MmmGSYvITj1QdaqmrxDtvRhtyyyamCM1kYF7HUONKKm
         n8N+QEGLWbjIdvWiUJgSrsWnhWOnIweN9c2y0Ut2lYCkkFNC/Z7SDpWk2oakgDWo0J
         tqzdYKjA4OW8wX0Yu9okx4mSPV49SCH2m9OX0Piw=
Date:   Mon, 04 Apr 2022 16:38:02 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, song@kernel.org, riel@surriel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-skip-dax-vma.patch added to -mm tree
Message-Id: <20220404233802.CF04FC340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: skip DAX vma
has been added to the -mm tree.  Its filename is
     mm-khugepaged-skip-dax-vma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-skip-dax-vma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-skip-dax-vma.patch

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
Subject: mm: khugepaged: skip DAX vma

The DAX vma may be seen by khugepaged when the mm has other khugepaged
suitable vmas.  So khugepaged may try to collapse THP for DAX vma, but it
will fail due to page sanity check, for example, page is not on LRU.

So it is not harmful, but it is definitely pointless to run khugepaged
against DAX vma, so skip it in early check.

Link: https://lkml.kernel.org/r/20220404200250.321455-4-shy828301@gmail.com
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

sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch
mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch
mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-move-some-khugepaged_-functions-to-khugepagedc.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch


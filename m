Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08864C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 22:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbiD0XAp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239400AbiD0W5x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 18:57:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618818D69F
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 15:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF2461E7A
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 22:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96E5C385A7;
        Wed, 27 Apr 2022 22:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651100026;
        bh=5iE1bNZhSIxkVtFJnaIfi/4dWc34qEhy+WcrDhQKbnw=;
        h=Date:To:From:Subject:From;
        b=UUKHvBo42jJfNO8f8aC6CqemJQeRlIE9IPs5LS/dm8RJyrczmRr7UfVQSHT8v8JbL
         cYc7PvbR97Cir3FNLQoxl7bAdL4QEgPUkVr6pXjx9QX5bBMKIexXw+qHwrnjLVxKwC
         PzVSYZnrJLzOWM8iXpFvvXDSsV6t2H0o6z/744iE=
Date:   Wed, 27 Apr 2022 15:53:46 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, song@kernel.org, riel@surriel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-khugepaged-skip-dax-vma.patch removed from -mm tree
Message-Id: <20220427225346.A96E5C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: skip DAX vma
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-skip-dax-vma.patch

This patch was dropped because it was nacked

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

mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-move-some-khugepaged_-functions-to-khugepagedc.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch


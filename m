Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC358C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B0DF64F18
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhBYThB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:37:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234948AbhBYTfO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ED7F64FBF;
        Thu, 25 Feb 2021 19:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280736;
        bh=z1R1kVgdbJnfDAMIxMdJSmUGcmuFcN1rlIVUOL8Ku2s=;
        h=Date:From:To:Subject:From;
        b=tlHI+B4+LWMlABXIXGt9N8J3fkvFryHdaUKcjfdWlR7S3bIo2uD0smh8X8tus3P65
         2DgQpZnM8qksvq2/VqEnzAKtdvFM1avtoyzScBAvb3FORG0TprFdcIS01l7A5I4sJ5
         fSlxBNqrkUEPlTYWJSnw/GkoSc+7AXLpEQtEsMdU=
Date:   Thu, 25 Feb 2021 11:18:56 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mempolicy-use-helper-range_in_vma-in-queue_pages_test_walk.patch removed
 from -mm tree
Message-ID: <20210225191856.KmaG3VeHy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: use helper range_in_vma() in queue_pages_test_walk()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-helper-range_in_vma-in-queue_pages_test_walk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mempolicy: use helper range_in_vma() in queue_pages_test_walk()

The helper range_in_vma() is introduced via commit 017b1660df89 ("mm:
migration: fix migration of huge PMD shared pages"). But we forgot to
use it in queue_pages_test_walk().

Link: https://lkml.kernel.org/r/20210130091352.20220-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-helper-range_in_vma-in-queue_pages_test_walk
+++ a/mm/mempolicy.c
@@ -677,7 +677,7 @@ static int queue_pages_test_walk(unsigne
 	unsigned long flags = qp->flags;
 
 	/* range check first */
-	VM_BUG_ON_VMA((vma->vm_start > start) || (vma->vm_end < end), vma);
+	VM_BUG_ON_VMA(!range_in_vma(vma, start, end), vma);
 
 	if (!qp->first) {
 		qp->first = vma;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch


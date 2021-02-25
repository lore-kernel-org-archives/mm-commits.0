Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838E4C433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AA3964F2A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbhBYTc7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:32:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234863AbhBYTaN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A00C864F2F;
        Thu, 25 Feb 2021 19:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280635;
        bh=CsJYfR2tYfsTcOjooLHLyVMNV1Vv1QFliM/FXOfRJNY=;
        h=Date:From:To:Subject:From;
        b=SKnDHt+2WuM6jnGIh4McAtr/9cQPV49Bhnhz0d/O57F6YLcs7VT8brnRPK+BdJRAQ
         RtuF2Kr0zZfMPt1OOPZpW7o2VLIoqxVxEto4RdxhpbOa9fGSQoQlGMZ+hlgjBxmeHZ
         QPEWZJcw6//aVoC974C8A2MjHxs115jF2YonM9+Q=
Date:   Thu, 25 Feb 2021 11:17:15 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-use-helper-function-range_in_vma-in-page_table_shareable.patch
 removed from -mm tree
Message-ID: <20210225191715.EueqgqvpJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use helper function range_in_vma() in page_table_shareable()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-helper-function-range_in_vma-in-page_table_shareable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: use helper function range_in_vma() in page_table_shareable()

We could use helper function range_in_vma() to check whether the vma is in
the desired range to simplify the code.

Link: https://lkml.kernel.org/r/20210204112949.43051-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-helper-function-range_in_vma-in-page_table_shareable
+++ a/mm/hugetlb.c
@@ -5282,7 +5282,7 @@ static unsigned long page_table_shareabl
 	 */
 	if (pmd_index(addr) != pmd_index(saddr) ||
 	    vm_flags != svm_flags ||
-	    sbase < svma->vm_start || svma->vm_end < s_end)
+	    !range_in_vma(svma, sbase, s_end))
 		return 0;
 
 	return saddr;
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


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1A4C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357386AbiCYBds (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357346AbiCYBc3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4868567D
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32565B82726
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBBAC340EE;
        Fri, 25 Mar 2022 01:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171853;
        bh=Ss3auQAbYCsrGmp1Xh51I+oHpT4QiAN/dsWqq0gQTkQ=;
        h=Date:To:From:Subject:From;
        b=wPZu8pLggs7pW/eJswcPvmum8dIi7XKrHtSng92vjWXS1gCX2FAQq0ufywJVIhYT9
         4saAIjfIR01wIOrOLrTonr1FrFS5VCxcbir7TOfXVYvcraU9omySbLAiFn3J6hxO8I
         Q2zMkMZvZXU+a+Pw0WYKO/zl7ISSrbr4i7+KfwiE=
Date:   Thu, 24 Mar 2022 18:30:53 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, rientjes@google.com,
        peterx@redhat.com, mike.kravetz@oracle.com, lars.persson@axis.com,
        kirill.shutemov@linux.intel.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, axelrasmussen@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch removed from -mm tree
Message-Id: <20220325013053.BEBBAC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix missing cache flush in hugetlb_mcopy_atomic_pte()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: fix missing cache flush in hugetlb_mcopy_atomic_pte()

folio_copy() will copy the data from one page to the target page, then the
target page will be mapped to the user space address, which might have an
alias issue with the kernel address used to copy the data from the page
to.  There are 2 ways to fix this issue.

 1) insert flush_dcache_page() after folio_copy().
 2) replace folio_copy() with copy_user_huge_page() which already
    considers the cache maintenance.

We chose 2) way to fix the issue since architectures can optimize this
situation.  It is also make backports easier.

Link: https://lkml.kernel.org/r/20220210123058.79206-5-songmuchun@bytedance.com
Fixes: 8cc5fcbb5be8 ("mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte
+++ a/mm/hugetlb.c
@@ -5816,7 +5816,8 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			*pagep = NULL;
 			goto out;
 		}
-		folio_copy(page_folio(page), page_folio(*pagep));
+		copy_user_huge_page(page, *pagep, dst_addr, dst_vma,
+				    pages_per_huge_page(h));
 		put_page(*pagep);
 		*pagep = NULL;
 	}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are



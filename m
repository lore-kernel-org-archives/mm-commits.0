Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175A2C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbiCVVnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiCVVnn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:43:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05025F4D0
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:42:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82A4AB81D9E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4160AC340EC;
        Tue, 22 Mar 2022 21:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985323;
        bh=CUWR0+8hDBfmEuWKrPR7y1DbelYcnQOgiVeFj9pX1Po=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=WZcXpGybdIqznUaKJACHWOlloWUkGpqNMF4Bq6GB0Ddi8heGmeAIa9LgZGhd1TzFM
         3WEmx8cvpKJdHYaeAbiIh4DTXKrY+Vnng3sCF1A+COE5g4W1p7H8mDXuBuSIqzGPHS
         ObIRNEKSTYC8g6cdIrMDMf6aC5eUNmQWuoNksgFU=
Date:   Tue, 22 Mar 2022 14:42:02 -0700
To:     ziy@nvidia.com, rientjes@google.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lars.persson@axis.com,
        kirill.shutemov@linux.intel.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, axelrasmussen@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 069/227] mm: hugetlb: fix missing cache flush in hugetlb_mcopy_atomic_pte()
Message-Id: <20220322214203.4160AC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

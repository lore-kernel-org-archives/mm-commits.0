Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD14C4321E
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387684AbiBHW0G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386826AbiBHVP6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 16:15:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBADBC0612B8
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 13:15:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A10961573
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 21:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4F5C004E1;
        Tue,  8 Feb 2022 21:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644354956;
        bh=R1eCsiwkj6jCaveJDtZUhEWMeABfVa3/HHu6x/VP7eQ=;
        h=Date:To:From:Subject:From;
        b=SXM6L/3KY5L+r48m0pg6FSKgX9xMONZ4PCHKmImof43eQXwtvS5DL4ZLnfkRhe/9P
         reL+NmJRVB7UTXVdNzMU7cEfrQHIAnW6haZAI/H5xgvZjX3WVeIwrPmaWIarWTKayb
         m+csJsVLuDw8+q/fAcMKBe7XiR21zI+Ti85p0oF8=
Date:   Tue, 08 Feb 2022 13:15:56 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        rientjes@google.com, mike.kravetz@oracle.com,
        lars.persson@axis.com, kirill.shutemov@linux.intel.com,
        duanxiongchun@bytedance.com, almasrymina@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch added to -mm tree
Message-Id: <20220208211556.CD4F5C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix missing cache flush in hugetlb_mcopy_atomic_pte()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

We chose 2) to fix the issue since architectures can optimize this
situation.

Link: https://lkml.kernel.org/r/20220208073617.70342-5-songmuchun@bytedance.com
Fixes: 8cc5fcbb5be8 ("mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte
+++ a/mm/hugetlb.c
@@ -5817,7 +5817,8 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
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

mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch
mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch
mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch
mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch
mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCE4C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 19:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377447AbiAaTvF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377468AbiAaTvD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 14:51:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37649C061714
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 11:51:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBA2DB82C0E
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 19:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EFEC340ED;
        Mon, 31 Jan 2022 19:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643658659;
        bh=nh2w1NIglhV9huGPUvqSCg5SbaVHexyLZA5ZdBBK3Bs=;
        h=Date:From:To:Subject:From;
        b=rOlLaG/UGM/jrd6hl81pct1rqbi+NGO7cmkwiT8mzwXxmIGicZwPk4kh1iABsXynQ
         4mYhmFFvnccCA783eZzJr6+1nB+lJ47fKB9Ru5i1RUR5Lzqul6GwoDrLR0oaZeFS6J
         Nd7jS27Wc+1Aeim6nQ7/Fj8t6Z0l87lS/3XhXw28=
Date:   Mon, 31 Jan 2022 11:50:58 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, duanxiongchun@bytedance.com,
        kirill.shutemov@linux.intel.com, lars.persson@axis.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rientjes@google.com, songmuchun@bytedance.com, willy@infradead.org,
        ziy@nvidia.com
Subject:  +
 mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch added
 to -mm tree
Message-ID: <20220131195058.l_s17xXCI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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
to.  Fix this issue by flushing dcache but not use flush_dcache_folio()
since it is not backportable.

Link: https://lkml.kernel.org/r/20220131160254.43211-5-songmuchun@bytedance.com
Fixes: 8cc5fcbb5be8 ("mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte
+++ a/mm/hugetlb.c
@@ -5804,6 +5804,8 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			goto out;
 		}
 	} else {
+		int i, nr;
+
 		if (vm_shared &&
 		    hugetlbfs_pagecache_present(h, dst_vma, dst_addr)) {
 			put_page(*pagep);
@@ -5819,6 +5821,9 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			goto out;
 		}
 		folio_copy(page_folio(page), page_folio(*pagep));
+		nr = compound_nr(page);
+		for (i = 0; i < nr; i++)
+			flush_dcache_page(page + i);
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


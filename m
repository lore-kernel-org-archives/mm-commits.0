Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4B3C4167B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386529AbiBHWZr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386819AbiBHVPy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 16:15:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E427BC0612BA
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 13:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80D6A61617
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 21:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC81C004E1;
        Tue,  8 Feb 2022 21:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644354952;
        bh=xiHYnC9NwTqCgST1OccFKRWCwhY0ZdbFtepWRm6soUs=;
        h=Date:To:From:Subject:From;
        b=tVd4SKHADs6eI3J3F8IMmDfzTwO0wMJyY+gf+A9R7yW5rZZAxFKLUWjwos/V9+3+D
         7LdGdNjssCz7f2aAd8Ku0rkCp9VAB7Z3+uFRanSa0jt8wp0sNduxUw4iWRk02nAoTw
         zA9jSeuAm2At2ycLXJgyDhKAIg2hCvrvc3uGa/Co=
Date:   Tue, 08 Feb 2022 13:15:52 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        rientjes@google.com, mike.kravetz@oracle.com,
        lars.persson@axis.com, kirill.shutemov@linux.intel.com,
        duanxiongchun@bytedance.com, almasrymina@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch added to -mm tree
Message-Id: <20220208211552.CFC81C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix missing cache flush for all tail pages of compound page
has been added to the -mm tree.  Its filename is
     mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch

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
Subject: mm: fix missing cache flush for all tail pages of compound page

The D-cache maintenance inside move_to_new_page() only consider one page,
there is still D-cache maintenance issue for tail pages of compound page
(e.g.  THP or HugeTLB).  THP migration is only enabled on x86_64, ARM64
and powerpc, while powerpc and arm64 need to maintain the consistency
between I-Cache and D-Cache, which depends on flush_dcache_page() to
maintain the consistency between I-Cache and D-Cache.

But there are no issues on arm64 and powerpc since they already consider
the compound page cache flushing in their icache flush function.  HugeTLB
migration is enabled on arm, arm64, mips, parisc, powerpc, riscv, s390 and
sh, while arm has handled the compound page cache flush in
flush_dcache_page(), but most others do not.

In theory, the issue exists on many architectures.  Fix this by not using
flush_dcache_folio() since it is not backportable.

Link: https://lkml.kernel.org/r/20220208073617.70342-3-songmuchun@bytedance.com
Fixes: 290408d4a250 ("hugetlb: hugepage migration core")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page
+++ a/mm/migrate.c
@@ -916,9 +916,12 @@ static int move_to_new_page(struct page
 		if (!PageMappingFlags(page))
 			page->mapping = NULL;
 
-		if (likely(!is_zone_device_page(newpage)))
-			flush_dcache_page(newpage);
+		if (likely(!is_zone_device_page(newpage))) {
+			int i, nr = compound_nr(newpage);
 
+			for (i = 0; i < nr; i++)
+				flush_dcache_page(newpage + i);
+		}
 	}
 out:
 	return rc;
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


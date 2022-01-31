Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C946CC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 19:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377530AbiAaTvD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiAaTvA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 14:51:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7695C061714
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 11:50:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78FA3B82C35
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 19:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7169C340ED;
        Mon, 31 Jan 2022 19:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643658657;
        bh=ffKmJ9ZtBGoi058MjHvgp9Rp3PAutfzjYHT0Ht5X8W0=;
        h=Date:From:To:Subject:From;
        b=Z4DI3PRdjuOfpv91zpXr3enQzOq0cEaNgWy0dIa7kRTUK2T//JhiuaMKmonYMvv/b
         L2C+0HQCQRnGqkiWF0UBOslPeACIjhm72EYoDxLgCG0/zxWaambYe26xX1/+eQG1nx
         xjGiEOIzC98nuFtcI9Ey0XBA2L9ecM+5P/lljlGw=
Date:   Mon, 31 Jan 2022 11:50:56 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, duanxiongchun@bytedance.com,
        kirill.shutemov@linux.intel.com, lars.persson@axis.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rientjes@google.com, songmuchun@bytedance.com, willy@infradead.org,
        ziy@nvidia.com
Subject:  +
 mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch added
 to -mm tree
Message-ID: <20220131195056.189btiZcV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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
maintain the consistency between I-Cache and D-Cache.  In theory, the
issue can be found on arm64 and powerpc.  HugeTLB migration is enabled on
arm, arm64, mips, parisc, powerpc, riscv, s390 and sh, while arm has
handled the compound page cache flush in flush_dcache_page(), but most
others do not.  In theory, the issue exists on many architectures.  Fix
this by not using flush_dcache_folio() since it is not backportable.

Link: https://lkml.kernel.org/r/20220131160254.43211-3-songmuchun@bytedance.com
Fixes: 616b8371539a ("mm: thp: enable thp migration in generic path")
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


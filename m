Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A46C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 19:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377468AbiAaTvG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377518AbiAaTvD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 14:51:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B649FC06173D
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 11:51:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AD0BB82C35
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 19:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B248BC340E8;
        Mon, 31 Jan 2022 19:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643658661;
        bh=JcUndqOXNeqHAV3JhtjeqhJs7lLzHg4iItz8+ZzXWbo=;
        h=Date:From:To:Subject:From;
        b=woKzGD3o8EPcEjxLQud0qo90z9Ov4ls7bdmoDQ6QbRvXjZMwHMhV71SVPEciVjy5j
         1F/AZsYElsZil83XaVbYU1HqwneGrYOnU3WVscHIt3ocRdCQpsddrpZ+6s2ctqdpnM
         E0GqKqYRENj/kfsQrYk0PD8Vhp22N+F9ZhYz6KHs=
Date:   Mon, 31 Jan 2022 11:51:00 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, duanxiongchun@bytedance.com,
        kirill.shutemov@linux.intel.com, lars.persson@axis.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rientjes@google.com, songmuchun@bytedance.com, willy@infradead.org,
        ziy@nvidia.com
Subject:  +
 mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch added to -mm
 tree
Message-ID: <20220131195100.0yTliWc-9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace multiple dcache flush with flush_dcache_folio()
has been added to the -mm tree.  Its filename is
     mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch

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
Subject: mm: replace multiple dcache flush with flush_dcache_folio()

Simplify the code by using flush_dcache_folio().

Link: https://lkml.kernel.org/r/20220131160254.43211-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +-----
 mm/migrate.c |    8 ++------
 2 files changed, 3 insertions(+), 11 deletions(-)

--- a/mm/hugetlb.c~mm-replace-multiple-dcache-flush-with-flush_dcache_folio
+++ a/mm/hugetlb.c
@@ -5804,8 +5804,6 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			goto out;
 		}
 	} else {
-		int i, nr;
-
 		if (vm_shared &&
 		    hugetlbfs_pagecache_present(h, dst_vma, dst_addr)) {
 			put_page(*pagep);
@@ -5821,9 +5819,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			goto out;
 		}
 		folio_copy(page_folio(page), page_folio(*pagep));
-		nr = compound_nr(page);
-		for (i = 0; i < nr; i++)
-			flush_dcache_page(page + i);
+		flush_dcache_folio(page_folio(page));
 		put_page(*pagep);
 		*pagep = NULL;
 	}
--- a/mm/migrate.c~mm-replace-multiple-dcache-flush-with-flush_dcache_folio
+++ a/mm/migrate.c
@@ -916,12 +916,8 @@ static int move_to_new_page(struct page
 		if (!PageMappingFlags(page))
 			page->mapping = NULL;
 
-		if (likely(!is_zone_device_page(newpage))) {
-			int i, nr = compound_nr(newpage);
-
-			for (i = 0; i < nr; i++)
-				flush_dcache_page(newpage + i);
-		}
+		if (likely(!is_zone_device_page(newpage)))
+			flush_dcache_folio(page_folio(newpage));
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


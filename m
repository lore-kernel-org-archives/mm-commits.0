Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3A6C35270
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386958AbiBHWZw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386829AbiBHVQA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 16:16:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB50C0612B8
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 13:15:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E8AD61573
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 21:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEFBC004E1;
        Tue,  8 Feb 2022 21:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644354958;
        bh=+XMsAmg960Jh/2p45KwBer9Qa3t5M/IR5oNQMsQnseM=;
        h=Date:To:From:Subject:From;
        b=bSMxOLYBOstGmRsYW78LMa0F50n78WwRiKepNuawU0TZFyiNGHrHEQWDuDNg6+e91
         HqyqtzE6/06W5wIfhNxxHLfnCIP308nejB2WLTurSM9dCZtFgNCFay7WOR2EZ+k5O3
         6M9AWn2EUysQcKNDj60GrwP084Ale2lU73BNiVbA=
Date:   Tue, 08 Feb 2022 13:15:58 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        rientjes@google.com, mike.kravetz@oracle.com,
        lars.persson@axis.com, kirill.shutemov@linux.intel.com,
        duanxiongchun@bytedance.com, almasrymina@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch added to -mm tree
Message-Id: <20220208211558.CBEFBC004E1@smtp.kernel.org>
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

Link: https://lkml.kernel.org/r/20220208073617.70342-6-songmuchun@bytedance.com
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

 mm/migrate.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

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


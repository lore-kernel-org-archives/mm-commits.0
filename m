Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC01C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8755C61C7A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhGFTWF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGFTWD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6AF061A14;
        Tue,  6 Jul 2021 19:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599165;
        bh=WHxGIoKuV99edrjJB6wVcLMZnvn5Otv7JIzojKZYBWQ=;
        h=Date:From:To:Subject:From;
        b=Su5Whqi6iFcveC6tXQZCPLySZmOUVA1kqsZA9/901YWOy11fgeCgY8UpYti5p8/15
         MjqbFRqB0IxxVvoRYtHLEwa4sJ3oeGnmx0+lpAEDTw0do5QXdCJP1iOA918x4Au1Gv
         QD+e1k599/To/A3swAqcOCwepCYMBzxB6JEdkqz4=
Date:   Tue, 06 Jul 2021 12:19:24 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com,
        duanxiongchun@bytedance.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, songmuchun@bytedance.com, willy@infradead.org
Subject:  [merged]
 mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool.patch
 removed from -mm tree
Message-ID: <20210706191924.NO6OlkvZO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix missing update page_private to hugetlb_page_subpool
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: migrate: fix missing update page_private to hugetlb_page_subpool

Since commit d6995da31122 ("hugetlb: use page.private for hugetlb specific
page flags") converts page.private for hugetlb specific page flags.  We
should use hugetlb_page_subpool() to get the subpool pointer instead of
page_private().

This 'could' prevent the migration of hugetlb pages.  page_private(hpage)
is now used for hugetlb page specific flags.  At migration time, the only
flag which could be set is HPageVmemmapOptimized.  This flag will only be
set if the new vmemmap reduction feature is enabled.  In addition,
!page_mapping() implies an anonymous mapping.  So, this will prevent
migration of hugetb pages in anonymous mappings if the vmemmap reduction
feature is enabled.

In addition, that if statement checked for the rare race condition of a
page being migrated while in the process of being freed.  Since that check
is now wrong, we could leak hugetlb subpool usage counts.

The commit forgot to update it in the page migration routine.  So fix it.

[songmuchun@bytedance.com: fix compiler error when !CONFIG_HUGETLB_PAGE reported by Randy]
  Link: https://lkml.kernel.org/r/20210521022747.35736-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20210520025949.1866-1-songmuchun@bytedance.com
Fixes: d6995da31122 ("hugetlb: use page.private for hugetlb specific page flags")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Tested-by: Anshuman Khandual <anshuman.khandual@arm.com>	[arm64]
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++++
 mm/migrate.c            |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool
+++ a/include/linux/hugetlb.h
@@ -898,6 +898,11 @@ static inline void huge_ptep_modify_prot
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
+static inline struct hugepage_subpool *hugetlb_page_subpool(struct page *hpage)
+{
+	return NULL;
+}
+
 static inline int isolate_or_dissolve_huge_page(struct page *page,
 						struct list_head *list)
 {
--- a/mm/migrate.c~mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool
+++ a/mm/migrate.c
@@ -1293,7 +1293,7 @@ static int unmap_and_move_huge_page(new_
 	 * page_mapping() set, hugetlbfs specific move page routine will not
 	 * be called and we could leak usage counts for subpools.
 	 */
-	if (page_private(hpage) && !page_mapping(hpage)) {
+	if (hugetlb_page_subpool(hpage) && !page_mapping(hpage)) {
 		rc = -EBUSY;
 		goto out_unlock;
 	}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are



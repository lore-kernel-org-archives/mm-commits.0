Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8633AC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 04:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 562D8611C2
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 04:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbhETE0y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 00:26:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhETE0x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 00:26:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9BDD6108C;
        Thu, 20 May 2021 04:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621484732;
        bh=RwVmf00s07sfdmi02OuQLuu67Clp8Vd0xhSYUbg3AhY=;
        h=Date:From:To:Subject:From;
        b=MBO3HwTf3zrSQkPAS10AEOkMUzz2Z7RdsziRND9hWX/74Q8MXaagCgClrLK3J5ib/
         K0duQgoNm+sqnYfYunTA4MzGRhfbpQMR8SVcm4MSqNh6WQcVb6+DdqagtyGpv4tKOV
         0FqIU5sDcg3AF9ng/AcoutKPF+5r+vz+elp157x8=
Date:   Wed, 19 May 2021 21:25:31 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com,
        duanxiongchun@bytedance.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, songmuchun@bytedance.com, willy@infradead.org
Subject:  +
 mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool.patch
 added to -mm tree
Message-ID: <20210520042531.04jJS51mE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix missing update page_private to hugetlb_page_subpool
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool.patch

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
Subject: mm: migrate: fix missing update page_private to hugetlb_page_subpool

Since commit d6995da31122 ("hugetlb: use page.private for hugetlb specific
page flags") converts page.private for hugetlb specific page flags.  We
should use hugetlb_page_subpool() to get the subpool pointer instead of
page_private().  The commit forgot to update it in the page migration
routine.  So fix it.

Link: https://lkml.kernel.org/r/20210520025949.1866-1-songmuchun@bytedance.com
Fixes: d6995da31122 ("hugetlb: use page.private for hugetlb specific page flags")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool
+++ a/mm/migrate.c
@@ -1292,7 +1292,7 @@ static int unmap_and_move_huge_page(new_
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

mm-memcontrol-fix-root_mem_cgroup-charging.patch
mm-memcontrol-fix-page-charging-in-page-replacement.patch
mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch
mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch
mm-memcontrol-simplify-lruvec_holds_page_lru_lock.patch
mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec.patch
mm-memcontrol-simplify-the-logic-of-objcg-pinning-memcg.patch
mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock.patch
mm-vmscan-remove-noinline_for_stack.patch
mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch
mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-defer-freeing-of-hugetlb-pages.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled.patch
mm-hugetlb-introduce-nr_free_vmemmap_pages-in-the-struct-hstate.patch
mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool.patch


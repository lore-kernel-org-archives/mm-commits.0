Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E9B3CDB465
	for <mm-commits@archiver.kernel.org>; Thu, 19 Oct 2023 16:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbjJSQlW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjJSQlV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2023 12:41:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E50811F
        for <mm-commits@vger.kernel.org>; Thu, 19 Oct 2023 09:41:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B8FC433C8;
        Thu, 19 Oct 2023 16:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697733679;
        bh=yAcNVhJMfiSaKOneU96Q89AHsAqGY2fQjBnvjFVofOE=;
        h=Date:To:From:Subject:From;
        b=Syf5KOvJ6e1ZBMQQR08Z5RaMBZkWdZJ8AK9PRsWxAU2nsEeBqovDZZLFrYBDb9d7i
         N1zlapoV+Tyqmq4b4bsnYkTyuhBEQJCX5uArHJ0Sc2IwwYOAl4EhcHolNi2Q/blV7A
         j9bzFCbfjagGmI5av2/kpXhjnKc53W8eGdxKFHgk=
Date:   Thu, 19 Oct 2023 09:41:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, rientjes@google.com,
        punit.agrawal@bytedance.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mike.kravetz@oracle.com,
        mhocko@suse.com, linmiaohe@huawei.com, konradybcio@kernel.org,
        jthoughton@google.com, joao.m.martins@oracle.com,
        fam.zheng@bytedance.com, duanxiongchun@bytedance.com,
        david@redhat.com, anshuman.khandual@arm.com, 21cnbao@gmail.com,
        usama.arif@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] hugetlb-restructure-pool-allocations-fix.patch removed from -mm tree
Message-Id: <20231019164119.94B8FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb: only prep and add allocated folios for non-gigantic pages
has been removed from the -mm tree.  Its filename was
     hugetlb-restructure-pool-allocations-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Usama Arif <usama.arif@bytedance.com>
Subject: mm: hugetlb: only prep and add allocated folios for non-gigantic pages
Date: Mon, 9 Oct 2023 15:56:05 +0100

Calling prep_and_add_allocated_folios when allocating gigantic pages at
boot time causes the kernel to crash as folio_list is empty and iterating
it causes a NULL pointer dereference.  Call this only for non-gigantic
pages when folio_list has entries.

Link: https://lkml.kernel.org/r/20231009145605.2150897-1-usama.arif@bytedance.com
Fixes: bfb41d6b2fe148 ("hugetlb: restructure pool allocations")
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-restructure-pool-allocations-fix
+++ a/mm/hugetlb.c
@@ -3478,7 +3478,8 @@ static void __init hugetlb_hstate_alloc_
 	}
 
 	/* list will be empty if hstate_is_gigantic */
-	prep_and_add_allocated_folios(h, &folio_list);
+	if (!hstate_is_gigantic(h))
+		prep_and_add_allocated_folios(h, &folio_list);
 
 	if (i < h->max_huge_pages) {
 		char buf[32];
_

Patches currently in -mm which might be from usama.arif@bytedance.com are

hugetlb_vmemmap-use-folio-argument-for-hugetlb_vmemmap_-functions.patch


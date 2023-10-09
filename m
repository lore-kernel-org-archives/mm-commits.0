Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D20E9371F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Oct 2023 23:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379030AbjJIXbe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 19:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379014AbjJIXbe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 19:31:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3719D
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 16:31:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16952C433C7;
        Mon,  9 Oct 2023 23:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696894292;
        bh=qcQFrN7A9SaDSY7ZTYtkAvr1nHqMtwQEF/O2Suq1MhE=;
        h=Date:To:From:Subject:From;
        b=ONBBEFWHKq7twq5dKsXmS2KARLQwn8TBhupA9gA/KoNjmViahGGHUF07it3ABf2eu
         xnlMk+n62FLYb4AJwReLNiGJk1aXAF2OAWGPTUnQv1FJyKzFcYZcEEspjBlpSdQGsq
         Llzz7MZXtruu76nVFRzbQj6d2buqzKAtD21xFF4U=
Date:   Mon, 09 Oct 2023 16:31:20 -0700
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
Subject: + hugetlb-restructure-pool-allocations-fix.patch added to mm-unstable branch
Message-Id: <20231009233130.16952C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: only prep and add allocated folios for non-gigantic pages
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-restructure-pool-allocations-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-restructure-pool-allocations-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Usama Arif <usama.arif@bytedance.com>
Subject: mm: hugetlb: only prep and add allocated folios for non-gigantic pages
Date: Mon, 9 Oct 2023 15:56:05 +0100

Calling prep_and_add_allocated_folios when allocating gigantic pages at
boot time causes the kernel to crash as folio_list is empty and iterating
it causes a NULL pointer dereference.  Call this only for non-gigantic
pages when folio_list has entires.

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
@@ -3307,7 +3307,8 @@ static void __init hugetlb_hstate_alloc_
 	}
 
 	/* list will be empty if hstate_is_gigantic */
-	prep_and_add_allocated_folios(h, &folio_list);
+	if (!hstate_is_gigantic(h))
+		prep_and_add_allocated_folios(h, &folio_list);
 
 	if (i < h->max_huge_pages) {
 		char buf[32];
_

Patches currently in -mm which might be from usama.arif@bytedance.com are

hugetlb-restructure-pool-allocations-fix.patch
hugetlb_vmemmap-use-folio-argument-for-hugetlb_vmemmap_-functions.patch


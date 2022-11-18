Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8E2C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 18 Nov 2022 21:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiKRVQ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Nov 2022 16:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiKRVQ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2022 16:16:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C40942D0
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 13:16:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9774362775
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 21:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E75C433D6;
        Fri, 18 Nov 2022 21:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668806186;
        bh=ZLpHElZiJF+dzEtDJBgOY+2P5dEO1flU69ZCcsYIGwg=;
        h=Date:To:From:Subject:From;
        b=YVWtTtua42VKeLc1nXS7XH8I3UTrn7/ej2w9sI63UXcqHZ7BsF7VEURGYEL+lXoYr
         yxUDQvHZrMrIWLDWL3Cx0gXjT9I01rokNdzBZEyGEeF43UAN4cs1K0Pbc8+6OzueFr
         AmjzDa3l/2EkFxGVhA0dLU4jy4K3rIvPKPnLgCqc=
Date:   Fri, 18 Nov 2022 13:16:25 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, sidhartha.kumar@oracle.com,
        peterx@redhat.com, osalvador@suse.de, naoya.horiguchi@nec.com,
        mhocko@suse.com, linmiaohe@huawei.com, joao.m.martins@oracle.com,
        aneesh.kumar@linux.ibm.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-fix-__prep_compound_gigantic_page-page-flag-setting.patch added to mm-hotfixes-unstable branch
Message-Id: <20221118211625.E5E75C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix __prep_compound_gigantic_page page flag setting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlb-fix-__prep_compound_gigantic_page-page-flag-setting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-fix-__prep_compound_gigantic_page-page-flag-setting.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: fix __prep_compound_gigantic_page page flag setting
Date: Fri, 18 Nov 2022 11:52:49 -0800

Commit 2b21624fc232 ("hugetlb: freeze allocated pages before creating
hugetlb pages") changed the order page flags were cleared and set in the
head page.  It moved the __ClearPageReserved after __SetPageHead. 
However, there is a check to make sure __ClearPageReserved is never done
on a head page.  If CONFIG_DEBUG_VM_PGFLAGS is enabled, the following BUG
will be hit when creating a hugetlb gigantic page:

    page dumped because: VM_BUG_ON_PAGE(1 && PageCompound(page))
    ------------[ cut here ]------------
    kernel BUG at include/linux/page-flags.h:500!
    Call Trace will differ depending on whether hugetlb page is created
    at boot time or run time.

Make sure to __ClearPageReserved BEFORE __SetPageHead.

Link: https://lkml.kernel.org/r/20221118195249.178319-1-mike.kravetz@oracle.com
Fixes: 2b21624fc232 ("hugetlb: freeze allocated pages before creating hugetlb pages")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-fix-__prep_compound_gigantic_page-page-flag-setting
+++ a/mm/hugetlb.c
@@ -1800,6 +1800,7 @@ static bool __prep_compound_gigantic_pag
 
 	/* we rely on prep_new_huge_page to set the destructor */
 	set_compound_order(page, order);
+	__ClearPageReserved(page);
 	__SetPageHead(page);
 	for (i = 0; i < nr_pages; i++) {
 		p = nth_page(page, i);
@@ -1816,7 +1817,8 @@ static bool __prep_compound_gigantic_pag
 		 * on the head page when they need know if put_page() is needed
 		 * after get_user_pages().
 		 */
-		__ClearPageReserved(p);
+		if (i != 0)	/* head page cleared above */
+			__ClearPageReserved(p);
 		/*
 		 * Subtle and very unlikely
 		 *
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

ipc-shm-call-underlying-open-close-vm_ops.patch
madvise-use-zap_page_range_single-for-madvise-dontneed.patch
hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch
hugetlb-fix-__prep_compound_gigantic_page-page-flag-setting.patch
selftests-vm-update-hugetlb-madvise.patch
hugetlb-remove-duplicate-mmu-notifications.patch


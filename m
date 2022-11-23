Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE0EC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbiKWCxu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbiKWCxc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:53:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F503E2B60
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:53:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E08B4B81E5C
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92417C433D7;
        Wed, 23 Nov 2022 02:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669172006;
        bh=3Y05gsixqs5fkrS97CHIqOVxtgiyp3TbOqHXJmDD+7A=;
        h=Date:To:From:Subject:From;
        b=RFzLmka3Zi4/mBW9N51hTXRwwKKOIKunpjSi0YHucdlV5VoftELLVna035N6WV1rf
         A5h0YDSzbcuaNeA4bZS4FX3TohBIZpIG3wK8T7W0HOSNu6nLV/TJuRDaid8U+1IIa/
         cTFy3et6Zp33UFnWF5/QTuGZhkp4Fojmd43yCBsI=
Date:   Tue, 22 Nov 2022 18:53:25 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsahu@linux.ibm.com, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, peterx@redhat.com, osalvador@suse.de,
        naoya.horiguchi@nec.com, mhocko@suse.com, linmiaohe@huawei.com,
        joao.m.martins@oracle.com, aneesh.kumar@linux.ibm.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hugetlb-fix-__prep_compound_gigantic_page-page-flag-setting.patch removed from -mm tree
Message-Id: <20221123025326.92417C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: fix __prep_compound_gigantic_page page flag setting
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-__prep_compound_gigantic_page-page-flag-setting.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Muchun Song <songmuchun@bytedance.com>
Tested-by: Tarun Sahu <tsahu@linux.ibm.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
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

madvise-use-zap_page_range_single-for-madvise-dontneed.patch
hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch
selftests-vm-update-hugetlb-madvise.patch
hugetlb-remove-duplicate-mmu-notifications.patch


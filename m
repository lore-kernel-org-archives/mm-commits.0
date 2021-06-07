Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C961C47095
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E7A5611AD
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhFGUnZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 16:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231517AbhFGUnW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 16:43:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96752610FB;
        Mon,  7 Jun 2021 20:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623098477;
        bh=NuIrPQ2L2cIJLdTixkbVJ9NkOWPrMf5egDg5JiwP1S8=;
        h=Date:From:To:Subject:From;
        b=gBVVO1dsBvv+oJhu6uqk0Rdb/wnNP8PSLyklEvfylCOjK5ZHPUT1+y8IYwe1SG15U
         j4Wy+36zDq0Ek8OITKa7zKyXqe5nCmhP+U9Jw096Q2MdhWvnmSoIGUfVKXUZlz7C0U
         23S/i7l7GTnBBOYlIuEJWi2m+Wu3PkXl5Yq2Kdv0=
Date:   Mon, 07 Jun 2021 13:41:17 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, songmuchun@bytedance.com, willy@infradead.org
Subject:  [merged]
 hugetlb-pass-head-page-to-remove_hugetlb_page.patch removed from -mm tree
Message-ID: <20210607204117.dgzD15JQn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: pass head page to remove_hugetlb_page()
has been removed from the -mm tree.  Its filename was
     hugetlb-pass-head-page-to-remove_hugetlb_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: hugetlb: pass head page to remove_hugetlb_page()

When memory_failure() or soft_offline_page() is called on a tail page of
some hugetlb page, "BUG: unable to handle page fault" error can be
triggered.

remove_hugetlb_page() dereferences page->lru, so it's assumed that the
page points to a head page, but one of the caller,
dissolve_free_huge_page(), provides remove_hugetlb_page() with 'page'
which could be a tail page.  So pass 'head' to it, instead.

Link: https://lkml.kernel.org/r/20210526235257.2769473-1-nao.horiguchi@gmail.com
Fixes: 6eb4e88a6d27 ("hugetlb: create remove_hugetlb_page() to separate functionality")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-pass-head-page-to-remove_hugetlb_page
+++ a/mm/hugetlb.c
@@ -1793,7 +1793,7 @@ retry:
 			SetPageHWPoison(page);
 			ClearPageHWPoison(head);
 		}
-		remove_hugetlb_page(h, page, false);
+		remove_hugetlb_page(h, head, false);
 		h->max_huge_pages--;
 		spin_unlock_irq(&hugetlb_lock);
 		update_and_free_page(h, head);
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoison-fix-race-with-hugetlb-page-allocation.patch
mmhwpoison-send-sigbus-with-error-virutal-address.patch
mmhwpoison-send-sigbus-with-error-virutal-address-fix.patch
mmhwpoison-make-get_hwpoison_page-call-get_any_page.patch


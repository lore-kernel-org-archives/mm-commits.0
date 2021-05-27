Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F36C4708A
	for <mm-commits@archiver.kernel.org>; Thu, 27 May 2021 00:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42AF4613D2
	for <mm-commits@archiver.kernel.org>; Thu, 27 May 2021 00:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbhE0AKw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 20:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234960AbhE0AKp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 20:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD342613CA;
        Thu, 27 May 2021 00:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622074153;
        bh=7GVborCB9buEHM6T9TmMB6KPVLTHpQ8E+59rZelSrys=;
        h=Date:From:To:Subject:From;
        b=Z6bErxSSdDjWIGiW5VppCVm8Ao1DJiuJXC9UXATgaH4y4l+uoAWUqyzAuKctUw8Rc
         12eetPxFui+JVGHNJZJ6s2GQ9tmTsQvWtsa8ufmp7gbI8J8qIFTapaC9SSXxOH0YKV
         e046q3Da+McIfMvhmR9yPWflNVIX+1+NHuLvbl5s=
Date:   Wed, 26 May 2021 17:09:12 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, songmuchun@bytedance.com
Subject:  + hugetlb-pass-head-page-to-remove_hugetlb_page.patch
 added to -mm tree
Message-ID: <20210527000912.bD73u60eA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: pass head page to remove_hugetlb_page()
has been added to the -mm tree.  Its filename is
     hugetlb-pass-head-page-to-remove_hugetlb_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-pass-head-page-to-remove_hugetlb_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-pass-head-page-to-remove_hugetlb_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-pass-head-page-to-remove_hugetlb_page
+++ a/mm/hugetlb.c
@@ -1832,7 +1832,7 @@ retry:
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

hugetlb-pass-head-page-to-remove_hugetlb_page.patch
mmhwpoison-send-sigbus-with-error-virutal-address.patch


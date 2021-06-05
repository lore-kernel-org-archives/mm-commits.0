Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E643DC4743D
	for <mm-commits@archiver.kernel.org>; Sat,  5 Jun 2021 03:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCFDB61414
	for <mm-commits@archiver.kernel.org>; Sat,  5 Jun 2021 03:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFEDD2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 23:03:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231643AbhFEDD1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 23:03:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3C5A61405;
        Sat,  5 Jun 2021 03:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622862088;
        bh=ozAlJRxaDWgKU79MQfpohMhmH135SyDBQiDKhYDwAHY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ui9zkiBvZeU0kmmdxSIvkp9OdBIaVoiAvmRlvd8Qat5Dz9Mk/ARhSmzopqa/oYvog
         mvW/BYKI5x03vRXAy1mTm3dLXT4MyG2BrbWRfcT89erawJRp2KW6dzY9MfuLWPA7O2
         HF2EhHF/oBKZ+QeNjuzQliRFzY6RPxQkGUu51P0w=
Date:   Fri, 04 Jun 2021 20:01:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 07/13] hugetlb: pass head page to
 remove_hugetlb_page()
Message-ID: <20210605030127.7uSeM1M5a%akpm@linux-foundation.org>
In-Reply-To: <20210604200040.d8d0406caf195525620c0f3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

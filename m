Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F014C433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EA0464FBA
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhBECdH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230218AbhBECcz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 21:32:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46F1664FB9;
        Fri,  5 Feb 2021 02:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492334;
        bh=5dF3wYRxUT7z1CH7ZhqlJ7Ak7R/4Qo16/DGhNKCIElE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lLzbEgtg/oBqWX+rtAt1bKwpwPd1BaorLa/tqn5G2J5Wd1tCDGaa3ioXhknlId2gU
         J9S8hzuI0/dqpdn/5dyEpFtnRE7/+rHbD08OWN95zvHkR3GKQqR1e0tEDbvJ3tHMHM
         sSWeGQLJr/R1Ylijv7Q5PWkI25VBjxL9ha/hUomE=
Date:   Thu, 04 Feb 2021 18:32:13 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, shy828301@gmail.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 04/18] mm: hugetlb: remove VM_BUG_ON_PAGE from
 page_huge_active
Message-ID: <20210205023213._BtpJL1s-%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active

The page_huge_active() can be called from scan_movable_pages() which do
not hold a reference count to the HugeTLB page.  So when we call
page_huge_active() from scan_movable_pages(), the HugeTLB page can be
freed parallel.  Then we will trigger a BUG_ON which is in the
page_huge_active() when CONFIG_DEBUG_VM is enabled.  Just remove the
VM_BUG_ON_PAGE.

Link: https://lkml.kernel.org/r/20210115124942.46403-6-songmuchun@bytedance.com
Fixes: 7e1f049efb86 ("mm: hugetlb: cleanup using paeg_huge_active()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active
+++ a/mm/hugetlb.c
@@ -1361,8 +1361,7 @@ struct hstate *size_to_hstate(unsigned l
  */
 bool page_huge_active(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
-	return PageHead(page) && PagePrivate(&page[1]);
+	return PageHeadHuge(page) && PagePrivate(&page[1]);
 }
 
 /* never called for tail page */
_

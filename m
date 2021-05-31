Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDEFC47082
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 23:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 318EA6128A
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 23:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEaXaQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 19:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231144AbhEaXaQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 19:30:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5D5E61263;
        Mon, 31 May 2021 23:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622503715;
        bh=n/8kwTmCi2zzfp55R7PGbTWNd7pidx1VY9ZM860ql3U=;
        h=Date:From:To:Subject:From;
        b=0/KAEyrNfErsBMo4MQ56xenbRjoIfkIlUfxWF6gXMnft6ZeIve9ASDzUKI3994kDR
         5veZNsd6h4wo5UQBnaYFuhz95okdUGGqVVKPATANphU4xdyDss3m+B60m26aRKvVPb
         4unuRW3OBeGRPB96MTwiEo6tUqRTF91rDnq8zXKw=
Date:   Mon, 31 May 2021 16:28:34 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, songmuchun@bytedance.com
Subject:  +
 =?US-ASCII?Q?mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hu?=
 =?US-ASCII?Q?getlb-page-fix.patch?= added to -mm tree
Message-ID: <20210531232834.UefpMgsbp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix dissolve_free_huge_page use of tail/head page
has been added to the -mm tree.  Its filename is
     mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm: hugetlb: fix dissolve_free_huge_page use of tail/head page

The routine dissolve_free_huge_page can be passed the tail page of a
hugetlb page.  The tail page is incorrectly passed on to the routines
alloc_huge_page_vmemmap and add_hugetlb_page which expect a hugetlb head
page.

Operating on a tail page instead of head page could result in addressing
exceptions or vmemmap corruption.

Link: https://lkml.kernel.org/r/20210527231225.226987-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix
+++ a/mm/hugetlb.c
@@ -1954,7 +1954,7 @@ retry:
 		 * Attempt to allocate vmemmmap here so that we can take
 		 * appropriate action on failure.
 		 */
-		rc = alloc_huge_page_vmemmap(h, page);
+		rc = alloc_huge_page_vmemmap(h, head);
 		if (!rc) {
 			/*
 			 * Move PageHWPoison flag from head page to the raw
@@ -1968,7 +1968,7 @@ retry:
 			update_and_free_page(h, head, false);
 		} else {
 			spin_lock_irq(&hugetlb_lock);
-			add_hugetlb_page(h, page, false);
+			add_hugetlb_page(h, head, false);
 			h->max_huge_pages++;
 			spin_unlock_irq(&hugetlb_lock);
 		}
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch


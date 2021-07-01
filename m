Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00FAC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B492861424
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238229AbhGAAt7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236734AbhGAAt7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:49:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4E5061090;
        Thu,  1 Jul 2021 00:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625100449;
        bh=kGjfleYph/1fTh4NkWoPoqXYHSpk2XGDpYsGwm5jORM=;
        h=Date:From:To:Subject:From;
        b=JzoN9+7hdICU5YRgDmA0gNkCM907Y8SfifhdTzZPCHfqBFt9DjgsVvNLeSjB3u1p7
         9P9jZc1sK4K2Et1+QlBb6/oIRk/Ia3C7DDu5ye0CDha+rddIZOF869RfsdulwI0Ry7
         BFudHNu+KJx8av4w0rkFOYYutfW8BjkzOGdyMYjU=
Date:   Wed, 30 Jun 2021 17:47:28 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, songmuchun@bytedance.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hu?=
 =?US-ASCII?Q?getlb-page-fix.patch?= removed from -mm tree
Message-ID: <20210701004728.6D6C3zDaY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix dissolve_free_huge_page use of tail/head page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch

This patch was dropped because it was folded into mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch

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
@@ -1912,7 +1912,7 @@ retry:
 		 * Attempt to allocate vmemmmap here so that we can take
 		 * appropriate action on failure.
 		 */
-		rc = alloc_huge_page_vmemmap(h, page);
+		rc = alloc_huge_page_vmemmap(h, head);
 		if (!rc) {
 			/*
 			 * Move PageHWPoison flag from head page to the raw
@@ -1926,7 +1926,7 @@ retry:
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

mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
hugetlb-remove-prep_compound_huge_page-cleanup.patch
hugetlb-address-ref-count-racing-in-prep_compound_gigantic_page.patch


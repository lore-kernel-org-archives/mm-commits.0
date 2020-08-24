Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED45C433E4
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 23:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FBC3207D3
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 23:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598312183;
	bh=4r0HwigQS3wE55uBEAxfM/gZjH+/iiTspr+Qp6yjOLI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HSP3ywqgf9FXb1P3c3oXlTkOIcaikn88ddoU5z6WOBBx6eCR8rAtEV1ajwHrwxbQL
	 SCdwWeJz1pBw3ntsJzg0Id+QdWRhiSLaDQnJUkmrcj2uBOLJQ4clE6OghEiB94z5ek
	 aCzf6M+xd/6i1VWw05QkU2ieUCPGWkbv5+PhxxfQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgHXXgW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 19:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgHXXgW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 19:36:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D4992074D;
        Mon, 24 Aug 2020 23:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598312181;
        bh=4r0HwigQS3wE55uBEAxfM/gZjH+/iiTspr+Qp6yjOLI=;
        h=Date:From:To:Subject:From;
        b=QYxIcZqZ2udJqxuNDJtjVYY2IvpX6S3WWJL6ELfBjk/fKmo9wK3GaKPwrkreW4/SW
         UzjfzJDugIBpzjTm9bYlaa8dNVhRN2fZgKA5YOwbt7KK/WdX6cfiw4rhSzjHPv1KGX
         dIjnijxwoHMX+by5SPqEx83MH8WTHAKsIoslYy5I=
Date:   Mon, 24 Aug 2020 16:36:20 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, sfr@canb.auug.org.au,
        vdavydov.dev@gmail.com, willy@infradead.org
Subject:  [to-be-updated]
 mm-thp-remove-code-path-which-never-got-into.patch removed from -mm tree
Message-ID: <20200824233620.r27E-4fiy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: remove code path which never got into
has been removed from the -mm tree.  Its filename was
     mm-thp-remove-code-path-which-never-got-into.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/thp: remove code path which never got into

split_huge_page() will never call on a page which isn't on lru list, so
this code never got a chance to run, and should not be run, to add tail
pages on a lru list which head page isn't there.

Although the bug was never triggered, it'better be removed for code
correctness, and add a warn for unexpected calling.

Link: http://lkml.kernel.org/r/1597144232-11370-5-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/mm/huge_memory.c~mm-thp-remove-code-path-which-never-got-into
+++ a/mm/huge_memory.c
@@ -2330,17 +2330,8 @@ static void lru_add_page_tail(struct pag
 		/* page reclaim is reclaiming a huge page */
 		get_page(page_tail);
 		list_add_tail(&page_tail->lru, list);
-	} else {
-		/*
-		 * Head page has not yet been counted, as an hpage,
-		 * so we must account for each subpage individually.
-		 *
-		 * Put page_tail on the list at the correct position
-		 * so they all end up in order.
-		 */
-		add_page_to_lru_list_tail(page_tail, lruvec,
-					  page_lru(page_tail));
-	}
+	} else
+		VM_WARN_ON(!PageLRU(head));
 }
 
 static void __split_huge_page_tail(struct page *head, int tail,
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-thp-narrow-lru-locking.patch


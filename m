Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E58C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93377207BB
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597809052;
	bh=lw+JtokCkA1EdIh/fJ6Uv/4V96ueyPRmyniNnlaBhH0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hbX63MB4+DRhYs1CctnkYVymmZorLpNWLSwnsMiWSQTDZ2ISwt06IRQv5crHS2vO6
	 mwufVcGyaY/WPjtBJXCtg15wsjfD4FESVmIfnBSxhD2LSVnuRjscBKqD86bS4TP5Y5
	 385sneNyLhBIwJFgpe6qvk1QgEEE4SkParxEskRs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgHSDuw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgHSDuv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:50:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF70D2078B;
        Wed, 19 Aug 2020 03:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597809050;
        bh=lw+JtokCkA1EdIh/fJ6Uv/4V96ueyPRmyniNnlaBhH0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=im4QTk4hjhfg0FtwDEygZQzkyPyLnn6ylWggi7xDl8PDYnD/nWLMDmKL7rhcIySuZ
         AzEn7DuLEa+Xht2/mOrbwJuBC8u7cMhxqlEZAoRK1iVzlOyBYduVvuEY5ADqhU8doB
         5aFDuUoTfZME6xLqGnvfCdw9UdznqXtGqlDuYYjA=
Date:   Tue, 18 Aug 2020 20:50:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  + mm-thp-remove-code-path-which-never-got-into.patch
 added to -mm tree
Message-ID: <20200819035049.jo7WttIy_%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: remove code path which never got into
has been added to the -mm tree.  Its filename is
     mm-thp-remove-code-path-which-never-got-into.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-remove-code-path-which-never-got-into.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-remove-code-path-which-never-got-into.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcg-remove-useless-check-on-page-mem_cgroup.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-clean-up-lru_add_page_tail.patch
mm-thp-remove-code-path-which-never-got-into.patch
mm-thp-narrow-lru-locking.patch


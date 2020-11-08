Return-Path: <SRS0=LO12=EO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48ECCC388F9
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 00:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 078182151B
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 00:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604797106;
	bh=FBr7aq7j7wF8H4uQRsGkHxqOCBZut9JENU34Rx8zuJk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=f/SwW0Z/KceoGuwKdvaEJBnhwsyyPAXAoHfMDu5RTs35AwLOReg1eQFYLa+536QJi
	 XKH7DofIWRQooYjhbg50JJ1sNl89b/57n3PvFTxFgXDHy5kiFINRB3XMutMLL4Yq1Y
	 uRO5li9mQ0P1sUjLauzStjdMuvySPuW6lP7rCBWY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgKHA6Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 19:58:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKHA6Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 19:58:25 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA2BA20885;
        Sun,  8 Nov 2020 00:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604797104;
        bh=FBr7aq7j7wF8H4uQRsGkHxqOCBZut9JENU34Rx8zuJk=;
        h=Date:From:To:Subject:From;
        b=AIWA3kLLlqK3hz03GOZia9mjOUlpZ8w8A3piU5Ip4rUcQlvz/kg6F5No8eJg5n2Tp
         KrDLAW8e59uMRx3Yk9ixjWldpPFI45FaIemmeXHbUH6Xr41Y7bvR+u0DgJrg0nrIku
         Y5kdmk9++79uP1AScL3ILO5otuaFas+vvPVxw99g=
Date:   Sat, 07 Nov 2020 16:58:24 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        vdavydov.dev@gmail.com
Subject:  + mm-memcg-update-page-struct-member-in-comments.patch
 added to -mm tree
Message-ID: <20201108005824.vu7xh6K3n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: update page struct member in comments
has been added to the -mm tree.  Its filename is
     mm-memcg-update-page-struct-member-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-update-page-struct-member-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-update-page-struct-member-in-comments.patch

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
Subject: mm/memcg: update page struct member in comments

The page->mem_cgroup member is replaced by memcg_data, and add a helper
page_memcg() for it.  Need to update comments to avoid confusing.

Link: https://lkml.kernel.org/r/1491c150-1cc0-6062-08ea-9c891548a3bc@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-update-page-struct-member-in-comments
+++ a/mm/memcontrol.c
@@ -1310,7 +1310,7 @@ int mem_cgroup_scan_tasks(struct mem_cgr
  * @page: the page
  * @pgdat: pgdat of the page
  *
- * This function relies on page->mem_cgroup being stable - see the
+ * This function relies on page's memcg being stable - see the
  * access rules in commit_charge().
  */
 struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
@@ -2862,7 +2862,7 @@ static void commit_charge(struct page *p
 {
 	VM_BUG_ON_PAGE(page_memcg(page), page);
 	/*
-	 * Any of the following ensures page->mem_cgroup stability:
+	 * Any of the following ensures page's memcg stability:
 	 *
 	 * - the page lock
 	 * - LRU isolation
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcg-update-page-struct-member-in-comments.patch


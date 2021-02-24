Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C87C43381
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 954CF64F14
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhBXUGS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235120AbhBXUFg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99A5B64F32;
        Wed, 24 Feb 2021 20:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197060;
        bh=b8z0jFYGhZJXgwfpm3qd1Qnj3LqjaHi5HU4vzHcmA/4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IKlOtRgJqR4hrwoFFiTiea8tUcTonCvTXKqzlR36HWl3pVc8oQDuxnFuarMG5wrVx
         wCvh/VP1XcTMCad9gSOmfnn0NJ1WjoKc3RviocJGf3x+S2R+EE2aT5PSjM+Z2yeXdh
         UvkGKUmMia0KYZKfwznkgiSKFRYtdqibrnJAdbXI=
Date:   Wed, 24 Feb 2021 12:04:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 073/173] mm: memcontrol: fix swap undercounting in
 cgroup2
Message-ID: <20210224200419.SKAB6Vl7M%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix swap undercounting in cgroup2

When pages are swapped in, the VM may retain the swap copy to avoid
repeated writes in the future.  It's also retained if shared pages are
faulted back in some processes, but not in others.  During that time we
have an in-memory copy of the page, as well as an on-swap copy.  Cgroup1
and cgroup2 handle these overlapping lifetimes slightly differently due to
the nature of how they account memory and swap:

Cgroup1 has a unified memory+swap counter that tracks a data page
regardless whether it's in-core or swapped out.  On swapin, we transfer
the charge from the swap entry to the newly allocated swapcache page, even
though the swap entry might stick around for a while.  That's why we have
a mem_cgroup_uncharge_swap() call inside mem_cgroup_charge().

Cgroup2 tracks memory and swap as separate, independent resources and thus
has split memory and swap counters.  On swapin, we charge the newly
allocated swapcache page as memory, while the swap slot in turn must
remain charged to the swap counter as long as its allocated too.

The cgroup2 logic was broken by commit 2d1c498072de ("mm: memcontrol: make
swap tracking an integral part of memory control"), because it
accidentally removed the do_memsw_account() check in the branch inside
mem_cgroup_uncharge() that was supposed to tell the difference between the
charge transfer in cgroup1 and the separate counters in cgroup2.

As a result, cgroup2 currently undercounts retained swap to varying
degrees: swap slots are cached up to 50% of the configured limit or total
available swap space; partially faulted back shared pages are only limited
by physical capacity.  This in turn allows cgroups to significantly
overconsume their alloted swap space.

Add the do_memsw_account() check back to fix this problem.

Link: https://lkml.kernel.org/r/20210217153237.92484-1-songmuchun@bytedance.com
Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>	[5.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-swap-undercounting-in-cgroup2
+++ a/mm/memcontrol.c
@@ -6748,7 +6748,19 @@ int mem_cgroup_charge(struct page *page,
 	memcg_check_events(memcg, page);
 	local_irq_enable();
 
-	if (PageSwapCache(page)) {
+	/*
+	 * Cgroup1's unified memory+swap counter has been charged with the
+	 * new swapcache page, finish the transfer by uncharging the swap
+	 * slot. The swap slot would also get uncharged when it dies, but
+	 * it can stick around indefinitely and we'd count the page twice
+	 * the entire time.
+	 *
+	 * Cgroup2 has separate resource counters for memory and swap,
+	 * so this is a non-issue here. Memory and swap charge lifetimes
+	 * correspond 1:1 to page and swap slot lifetimes: we charge the
+	 * page to memory here, and uncharge swap when the slot is freed.
+	 */
+	if (do_memsw_account() && PageSwapCache(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 		/*
 		 * The swap entry might not get freed for a long time,
_

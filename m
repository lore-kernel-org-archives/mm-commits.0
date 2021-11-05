Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0EAC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8A896125F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhKEUkb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232513AbhKEUka (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9018460174;
        Fri,  5 Nov 2021 20:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144670;
        bh=mQfLVeFky/wjvihXxWdCm3YwQNNOIc8OFRailCxRgaY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XLIS7WnvT6OGa1Pj4ukL0J8ai9VXu5qY0TFBftGYk9DTQtUM60R1L2UgOxR3F1ooT
         2rQUVwadEO91wHaxx1nUF0wDjPbv+HN3R1tRaGCHKhq0pCrc9BXxQRqIpnxbYhpMgU
         wp0AAXyGotM8M+khITkxWppPtt6YTgI0ydMhZpRM=
Date:   Fri, 05 Nov 2021 13:37:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 061/262] mm: list_lru: fix the return value of
 list_lru_count_one()
Message-ID: <20211105203750.6jGE4g6rW%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: list_lru: fix the return value of list_lru_count_one()

Since commit 2788cf0c401c ("memcg: reparent list_lrus and free kmemcg_id
on css offline"), ->nr_items can be negative during memory cgroup
reparenting.  In this case, list_lru_count_one() will return an unusual
and huge value, which can surprise users.  At least for now it hasn't
affected any users.  But it is better to let list_lru_count_ont() returns
zero when ->nr_items is negative.

Link: https://lkml.kernel.org/r/20211025124910.56433-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-fix-the-return-value-of-list_lru_count_one
+++ a/mm/list_lru.c
@@ -176,13 +176,16 @@ unsigned long list_lru_count_one(struct
 {
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
-	unsigned long count;
+	long count;
 
 	rcu_read_lock();
 	l = list_lru_from_memcg_idx(nlru, memcg_cache_id(memcg));
 	count = READ_ONCE(l->nr_items);
 	rcu_read_unlock();
 
+	if (unlikely(count < 0))
+		count = 0;
+
 	return count;
 }
 EXPORT_SYMBOL_GPL(list_lru_count_one);
_

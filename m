Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246F0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E16C610F7
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhKKCo5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhKKCo5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A31EA61284;
        Thu, 11 Nov 2021 02:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598528;
        bh=20gX2zVAy6I28WgJwZubncsPdGt71UVCaBTcfwa5Fa0=;
        h=Date:From:To:Subject:From;
        b=JmO/wz5MLzCgeF8fANMtOfsH0SO09j7uv5B/98/rir4FATOMjStkH/Ws/rEBGDypA
         N5GH3aLrRSZhcCANXXXgp4LuyPjL5wZf3fjjbzowIAyqPXe3hQB/3Jbi1mvz/91CJz
         2W/fLp/CcBX3xZavcCdKcVfYxAOc6az0s05+1Kyg=
Date:   Wed, 10 Nov 2021 18:42:08 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  [merged]
 mm-list_lru-fix-the-return-value-of-list_lru_count_one.patch removed from
 -mm tree
Message-ID: <20211111024208.4fuFe7Hgn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: list_lru: fix the return value of list_lru_count_one()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-fix-the-return-value-of-list_lru_count_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from songmuchun@bytedance.com are



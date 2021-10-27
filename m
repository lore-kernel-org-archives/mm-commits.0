Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A36C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF002610FC
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244549AbhJ0VVI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 17:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:32852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244358AbhJ0VUg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 17:20:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBA27610FF;
        Wed, 27 Oct 2021 21:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635369490;
        bh=hDvwGSDC5DOTOz98iSOB27o9T/QM7JcffBfxNtcUl3A=;
        h=Date:From:To:Subject:From;
        b=gdAda1lkF3txyYzxthDfnsmS6BlAvsNi+dpxQ/0nXCSI07eOQBiSKlsdPW7cyjw8g
         zan4HYsP3hfa3YTdpkr1J6XJCX5jvYKHFp4uisGwrRfZbCojGUjCvxsEKHRC9b28C+
         +kh7jmocZ1SL9E2s+BsVw8Orqy2Babcp7DnR52NM=
Date:   Wed, 27 Oct 2021 14:18:09 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  +
 mm-list_lru-fix-the-return-value-of-list_lru_count_one.patch added to -mm
 tree
Message-ID: <20211027211809.8QMcThTF_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: list_lru: fix the return value of list_lru_count_one()
has been added to the -mm tree.  Its filename is
     mm-list_lru-fix-the-return-value-of-list_lru_count_one.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-list_lru-fix-the-return-value-of-list_lru_count_one.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lru-fix-the-return-value-of-list_lru_count_one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-list_lru-remove-holding-lru-lock.patch
mm-list_lru-fix-the-return-value-of-list_lru_count_one.patch
mm-memcontrol-remove-kmemcg_id-reparenting.patch
mm-memcontrol-remove-the-kmem-states.patch


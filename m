Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB864C43219
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C28DB610EA
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244342AbhJ0VVH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 17:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244344AbhJ0VUe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 17:20:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2783610A6;
        Wed, 27 Oct 2021 21:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635369488;
        bh=X5gplo2i7piM7AtOoX1LwFxp3+o+v/BvexaOn0NLlPQ=;
        h=Date:From:To:Subject:From;
        b=FMOQ0hWfAvJIodDBnfsqOmYDZQMLcY8VO0S2kD1wF5FXS3EbSQJrVZlV6aKyyhZ9L
         Pocv6WVTLuO8k8TzroH7ev4zN1yzJ8BLqw0h9UqOIYZeZIbVUUOiXAo9tZVs08IGkc
         6AdXorwdlIAH9QJ39mWYxbyJ39PactznEjYlfFV0=
Date:   Wed, 27 Oct 2021 14:18:07 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  + mm-list_lru-remove-holding-lru-lock.patch added to -mm
 tree
Message-ID: <20211027211807.38d9EoZiF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: list_lru: remove holding lru lock
has been added to the -mm tree.  Its filename is
     mm-list_lru-remove-holding-lru-lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-list_lru-remove-holding-lru-lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lru-remove-holding-lru-lock.patch

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
Subject: mm: list_lru: remove holding lru lock

Since commit e5bc3af7734f ("rcu: Consolidate PREEMPT and !PREEMPT
synchronize_rcu()"), the critical section of spin lock can serve as an
RCU read-side critical section which already allows readers that hold
nlru->lock to avoid taking rcu lock.  So just remove holding lock.

Link: https://lkml.kernel.org/r/20211025124534.56345-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-remove-holding-lru-lock
+++ a/mm/list_lru.c
@@ -398,18 +398,7 @@ static int memcg_update_list_lru_node(st
 	}
 
 	memcpy(&new->lru, &old->lru, flex_array_size(new, lru, old_size));
-
-	/*
-	 * The locking below allows readers that hold nlru->lock avoid taking
-	 * rcu_read_lock (see list_lru_from_memcg_idx).
-	 *
-	 * Since list_lru_{add,del} may be called under an IRQ-safe lock,
-	 * we have to use IRQ-safe primitives here to avoid deadlock.
-	 */
-	spin_lock_irq(&nlru->lock);
 	rcu_assign_pointer(nlru->memcg_lrus, new);
-	spin_unlock_irq(&nlru->lock);
-
 	kvfree_rcu(old, rcu);
 	return 0;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-list_lru-remove-holding-lru-lock.patch
mm-list_lru-fix-the-return-value-of-list_lru_count_one.patch
mm-memcontrol-remove-kmemcg_id-reparenting.patch
mm-memcontrol-remove-the-kmem-states.patch


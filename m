Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A199C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 401A961354
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhKKCoy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhKKCoy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F2B2610F7;
        Thu, 11 Nov 2021 02:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598525;
        bh=Um5UbOuJd54SiYGTai4tRX6VHFtscg06dnFpGA0vhwM=;
        h=Date:From:To:Subject:From;
        b=u0AiGKNtUBNY4zQ69jS3kY80B/uzmCPTAx3lV6cb/bCwuNtckXPi0/dJQgMzs5f8A
         rlpMAUKn+3eJdXkZWDW8QM0LiwuBxHgWNfVZkaaVWlasFHNUOJPBkGlD3oVffh9sEv
         Y8vE4kbn1+s4sds3irsOljy+dVbBJgmL/h6wYBM8=
Date:   Wed, 10 Nov 2021 18:42:05 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  [merged] mm-list_lru-remove-holding-lru-lock.patch
 removed from -mm tree
Message-ID: <20211111024205.WFo-yZHG7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: list_lru: remove holding lru lock
has been removed from the -mm tree.  Its filename was
     mm-list_lru-remove-holding-lru-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE18C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E646361262
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhKEUk3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhKEUk1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8343B61252;
        Fri,  5 Nov 2021 20:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144667;
        bh=I3HMw03PdXao4xhAgGi9zClkcaC8ZMkFxxofAO2HuRM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mTTLJT5F0Y5SX9PJeCHjp5vC9WYuqPFed4A40PljPf0nfBRaIyP297c+VGB5eogFB
         C6ma27BZMh90v39YG08LCSg4Ca+K88mPunOEgZBXBBZvMEQ5lCHZvRx/zNiMKn4BrR
         igE4aXNtZaLW3CExg4cEXDYN2OyTmG3sOdwc/cjw=
Date:   Fri, 05 Nov 2021 13:37:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 060/262] mm: list_lru: remove holding lru lock
Message-ID: <20211105203747.qUrOzAFsm%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

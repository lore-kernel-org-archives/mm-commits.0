Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16834C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C60A764F25
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhBXUGI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235163AbhBXUFd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A022964F09;
        Wed, 24 Feb 2021 20:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197053;
        bh=rOl2K5A6xz5E0IsjoSbi2nB1NiYRwOQUTHn35o9C8zo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WA0lklzXX+iW3uL9sFIliMjch6fpqyYriAG10Tsw0iMSt71BD4a97YNXBKtQXNEZT
         jdNz7VgHniVnZ5nPF/pYRuybtHguTYMBCjhUaJRk0IkuYTdKM6JIBfcS5QVECSMS69
         2/7xTCwP6PLcBldJgo4zj3qbj4Okb5CGUxtxwCyw=
Date:   Wed, 24 Feb 2021 12:04:12 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ktkhai@virtuozzo.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org,
        urezki@gmail.com
Subject:  [patch 071/173] mm/list_lru.c: remove kvfree_rcu_local()
Message-ID: <20210224200412.eSiorwyiz%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Subject: mm/list_lru.c: remove kvfree_rcu_local()

The list_lru file used to have local kvfree_rcu() which was renamed by
commit e0feed08ab41 ("mm/list_lru.c: Rename kvfree_rcu() to local
variant") to introduce the globally visible kvfree_rcu().  Now we have
global kvfree_rcu(), so remove the local kvfree_rcu_local() and just use
the global one.

Link: https://lkml.kernel.org/r/20210207152148.1285842-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Uladzislau Rezki <urezki@gmail.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/mm/list_lru.c~mm-list_lruc-remove-kvfree_rcu_local
+++ a/mm/list_lru.c
@@ -373,21 +373,13 @@ static void memcg_destroy_list_lru_node(
 	struct list_lru_memcg *memcg_lrus;
 	/*
 	 * This is called when shrinker has already been unregistered,
-	 * and nobody can use it. So, there is no need to use kvfree_rcu_local().
+	 * and nobody can use it. So, there is no need to use kvfree_rcu().
 	 */
 	memcg_lrus = rcu_dereference_protected(nlru->memcg_lrus, true);
 	__memcg_destroy_list_lru_node(memcg_lrus, 0, memcg_nr_cache_ids);
 	kvfree(memcg_lrus);
 }
 
-static void kvfree_rcu_local(struct rcu_head *head)
-{
-	struct list_lru_memcg *mlru;
-
-	mlru = container_of(head, struct list_lru_memcg, rcu);
-	kvfree(mlru);
-}
-
 static int memcg_update_list_lru_node(struct list_lru_node *nlru,
 				      int old_size, int new_size)
 {
@@ -419,7 +411,7 @@ static int memcg_update_list_lru_node(st
 	rcu_assign_pointer(nlru->memcg_lrus, new);
 	spin_unlock_irq(&nlru->lock);
 
-	call_rcu(&old->rcu, kvfree_rcu_local);
+	kvfree_rcu(old, rcu);
 	return 0;
 }
 
_

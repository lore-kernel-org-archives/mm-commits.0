Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89632C433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4086F64E21
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhBYTZG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:25:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234407AbhBYTW6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:22:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0E1064F71;
        Thu, 25 Feb 2021 19:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280472;
        bh=RQHkFKpBWDzxoMwGM3/KAvAvWtRj5Rjoul1UU573Fuc=;
        h=Date:From:To:Subject:From;
        b=RDxbiFWjs9KKuMW1DKx1jgV3i/BZYEemFjFvqCPVVCjBaGM59LDB9zKtSuBizBQeI
         V36wIyP8O7YD9wzVQLb7av03NXcs0w+LDJrWpj+q5Rh25Jj6Gi3hHgnNGDzfnHe8qa
         DHr8SdELGgrdGrGZoMMJbfJIjPs8XfMl9zsnUDuw=
Date:   Thu, 25 Feb 2021 11:14:32 -0800
From:   akpm@linux-foundation.org
To:     ktkhai@virtuozzo.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, urezki@gmail.com
Subject:  [merged] mm-list_lruc-remove-kvfree_rcu_local.patch
 removed from -mm tree
Message-ID: <20210225191432.gQI1y8wAJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: remove kvfree_rcu_local()
has been removed from the -mm tree.  Its filename was
     mm-list_lruc-remove-kvfree_rcu_local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from shakeelb@google.com are



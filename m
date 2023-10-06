Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 683F5E94131
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbjJFVsR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbjJFVsQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2974BBD
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549A8C433C9;
        Fri,  6 Oct 2023 21:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628892;
        bh=TW6LtHse5hnXesfbjTThSCueC2FNByiya0eVDkwDv48=;
        h=Date:To:From:Subject:From;
        b=aIrl+w+g0rCYNUkpSVXnYLlgG5zvgfnGoKDx/opi8eEmBc0Q1kK29a9K44WhyKWup
         t88ImbJGuCV0rh+A/JTpO0eiopmZXLcbc4xgIALF1qo5kAtORKuGule5yEDw0VnjU5
         Uab5IYXmNwEXLkKZi5EyungZEXWE9w3VwBby2TlE=
Date:   Fri, 06 Oct 2023 14:48:10 -0700
To:     mm-commits@vger.kernel.org, abaci@linux.alibaba.com,
        jiapeng.chong@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-remove-unused-function.patch removed from -mm tree
Message-Id: <20231006214812.549A8C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/list_lru: remove unused function
has been removed from the -mm tree.  Its filename was
     mm-list_lru-remove-unused-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: mm/list_lru: remove unused function
Date: Fri, 22 Sep 2023 18:07:47 +0800

The function is defined in list_lru.c, but not called elsewhere, so delete
the unused function.

mm/list_lru.c:64:1: warning: unused function 'list_lru_from_kmem'.

Link: https://lkml.kernel.org/r/20230922100747.17045-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=6677
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-remove-unused-function
+++ a/mm/list_lru.c
@@ -60,27 +60,6 @@ list_lru_from_memcg_idx(struct list_lru
 	return &lru->node[nid].lru;
 }
 
-static inline struct list_lru_one *
-list_lru_from_kmem(struct list_lru *lru, int nid, void *ptr,
-		   struct mem_cgroup **memcg_ptr)
-{
-	struct list_lru_node *nlru = &lru->node[nid];
-	struct list_lru_one *l = &nlru->lru;
-	struct mem_cgroup *memcg = NULL;
-
-	if (!list_lru_memcg_aware(lru))
-		goto out;
-
-	memcg = mem_cgroup_from_slab_obj(ptr);
-	if (!memcg)
-		goto out;
-
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
-out:
-	if (memcg_ptr)
-		*memcg_ptr = memcg;
-	return l;
-}
 #else
 static void list_lru_register(struct list_lru *lru)
 {
@@ -105,15 +84,6 @@ list_lru_from_memcg_idx(struct list_lru
 {
 	return &lru->node[nid].lru;
 }
-
-static inline struct list_lru_one *
-list_lru_from_kmem(struct list_lru *lru, int nid, void *ptr,
-		   struct mem_cgroup **memcg_ptr)
-{
-	if (memcg_ptr)
-		*memcg_ptr = NULL;
-	return &lru->node[nid].lru;
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 bool list_lru_add(struct list_lru *lru, struct list_head *item)
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are



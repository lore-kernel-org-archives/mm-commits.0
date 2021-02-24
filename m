Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4D7C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D756464F23
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhBXUGO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234364AbhBXUFd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AF9364F0F;
        Wed, 24 Feb 2021 20:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197049;
        bh=5c8za154E5ZZs1Pe0YPwFgF4ghXJ/O1bpaJjs3eUP5A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jxs6EAW4b50ev3OUu2zJH/HgrNQ2gHhIk6ZP92Df0amnoJfoACQC23RwLJAHI1/Fs
         KtGiuPbRk8HJtCnW90z+rzdWd8Kpt/j8OpI6duke/Ckny7ksTo3N4K+WBchFdhmt2b
         7r5nP1b3THPM3huKc4uhmu5HGf0F72m0Qu35GMSA=
Date:   Wed, 24 Feb 2021 12:04:08 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linmiaohe@huawei.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        torvalds@linux-foundation.org
Subject:  [patch 070/173] mm: memcontrol: replace the loop with a
 list_for_each_entry()
Message-ID: <20210224200408.tuzvi2hBn%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: replace the loop with a list_for_each_entry()

The rule of list walk has gone since:

 commit a9d5adeeb4b2 ("mm/memcontrol: allow to uncharge page without using page->lru field")

So remove the strange comment and replace the loop with a
list_for_each_entry().

There is only one caller of the uncharge_list().  So just fold it into
mem_cgroup_uncharge_list() and remove it.

Link: https://lkml.kernel.org/r/20210204163055.56080-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-replace-the-loop-with-a-list_for_each_entry
+++ a/mm/memcontrol.c
@@ -6862,31 +6862,6 @@ static void uncharge_page(struct page *p
 	css_put(&ug->memcg->css);
 }
 
-static void uncharge_list(struct list_head *page_list)
-{
-	struct uncharge_gather ug;
-	struct list_head *next;
-
-	uncharge_gather_clear(&ug);
-
-	/*
-	 * Note that the list can be a single page->lru; hence the
-	 * do-while loop instead of a simple list_for_each_entry().
-	 */
-	next = page_list->next;
-	do {
-		struct page *page;
-
-		page = list_entry(next, struct page, lru);
-		next = page->lru.next;
-
-		uncharge_page(page, &ug);
-	} while (next != page_list);
-
-	if (ug.memcg)
-		uncharge_batch(&ug);
-}
-
 /**
  * mem_cgroup_uncharge - uncharge a page
  * @page: page to uncharge
@@ -6918,11 +6893,17 @@ void mem_cgroup_uncharge(struct page *pa
  */
 void mem_cgroup_uncharge_list(struct list_head *page_list)
 {
+	struct uncharge_gather ug;
+	struct page *page;
+
 	if (mem_cgroup_disabled())
 		return;
 
-	if (!list_empty(page_list))
-		uncharge_list(page_list);
+	uncharge_gather_clear(&ug);
+	list_for_each_entry(page, page_list, lru)
+		uncharge_page(page, &ug);
+	if (ug.memcg)
+		uncharge_batch(&ug);
 }
 
 /**
_

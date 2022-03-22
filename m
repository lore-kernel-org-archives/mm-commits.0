Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF72C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbiCVVqZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbiCVVqS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:46:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457DC5F8F4
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 001BFB81DAF
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C593C340EC;
        Tue, 22 Mar 2022 21:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985476;
        bh=aJvl14R3//yR6TUdAYyl92DPDqdsx+7yQr9sKRBh24I=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=kLB9x8YDFbqUP73qYGE2T9PxzKil09MTTjeOtYbrghLiBIsRHa18utt5TyvkZUKoe
         EXMUILpGMKqKTqW626JQfFgs63nU3jwKKvVYS7QS08OhF00Vvh/ePKpcmfLERr5eze
         xOYUaJ4BotQ6L5n27vY1YjxI7GWmvs9EmxrWT2z0=
Date:   Tue, 22 Mar 2022 14:44:35 -0700
To:     naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 120/227] mm/hwpoison-inject: support injecting hwpoison to free page
Message-Id: <20220322214436.8C593C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hwpoison-inject: support injecting hwpoison to free page

memory_failure() can handle free buddy page.  Support injecting hwpoison
to free page by adding is_free_buddy_page check when hwpoison filter is
disabled.

[akpm@linux-foundation.org: export is_free_buddy_page() to modules]
Link: https://lkml.kernel.org/r/20220218092052.3853-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    4 ++--
 mm/page_alloc.c      |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/mm/hwpoison-inject.c~mm-hwpoison-inject-support-injecting-hwpoison-to-free-page
+++ a/mm/hwpoison-inject.c
@@ -32,9 +32,9 @@ static int hwpoison_inject(void *data, u
 
 	shake_page(hpage);
 	/*
-	 * This implies unable to support non-LRU pages.
+	 * This implies unable to support non-LRU pages except free page.
 	 */
-	if (!PageLRU(hpage) && !PageHuge(p))
+	if (!PageLRU(hpage) && !PageHuge(p) && !is_free_buddy_page(p))
 		return 0;
 
 	/*
--- a/mm/page_alloc.c~mm-hwpoison-inject-support-injecting-hwpoison-to-free-page
+++ a/mm/page_alloc.c
@@ -9417,6 +9417,7 @@ bool is_free_buddy_page(struct page *pag
 
 	return order < MAX_ORDER;
 }
+EXPORT_SYMBOL(is_free_buddy_page);
 
 #ifdef CONFIG_MEMORY_FAILURE
 /*
_

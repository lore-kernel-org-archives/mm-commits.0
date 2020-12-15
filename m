Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C174FC2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A015B224BE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgLODHv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:07:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbgLODHj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:07:39 -0500
Date:   Mon, 14 Dec 2020 19:06:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001619;
        bh=FpdvWQ14XbLJZFBX0PzgmuFtx8SnJaF2BXWMwE10v7s=;
        h=From:To:Subject:In-Reply-To:From;
        b=QTQitkCFt6nYh9v8KrxqUrhI1uD7dx30zGa479KD/9bWjg/f2XKZQQi1wCw0kUSES
         Xb92nBkCE3y+AgvDy+7bqDOIwGPYGGcXzo9a4UHBx85kSp4uQ+LioLWnHGAzciQIEz
         KXOWfPXXe1WF7BBl2wk2wBAUZKNsE2/OkZ29Hktk=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pankaj.gupta@cloud.ionos.com,
        sh_def@163.com, torvalds@linux-foundation.org
Subject:  [patch 066/200] mm/page_counter: use page_counter_read in
 page_counter_set_max
Message-ID: <20201215030658.dSgSOYOYo%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hui Su <sh_def@163.com>
Subject: mm/page_counter: use page_counter_read in page_counter_set_max

Use page_counter_read() in page_counter_set_max().

Link: https://lkml.kernel.org/r/20201113141048.GA178922@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_counter.c~mm-page_counter-use-page_counter_read-in-page_counter_set_max
+++ a/mm/page_counter.c
@@ -183,14 +183,14 @@ int page_counter_set_max(struct page_cou
 		 * the limit, so if it sees the old limit, we see the
 		 * modified counter and retry.
 		 */
-		usage = atomic_long_read(&counter->usage);
+		usage = page_counter_read(counter);
 
 		if (usage > nr_pages)
 			return -EBUSY;
 
 		old = xchg(&counter->max, nr_pages);
 
-		if (atomic_long_read(&counter->usage) <= usage)
+		if (page_counter_read(counter) <= usage)
 			return 0;
 
 		counter->max = old;
_

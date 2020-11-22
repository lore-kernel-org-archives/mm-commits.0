Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15613C63697
	for <mm-commits@archiver.kernel.org>; Sun, 22 Nov 2020 06:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4D45208D5
	for <mm-commits@archiver.kernel.org>; Sun, 22 Nov 2020 06:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hlPTBijN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgKVGRB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Nov 2020 01:17:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbgKVGRB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Nov 2020 01:17:01 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F5822078B;
        Sun, 22 Nov 2020 06:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606025819;
        bh=uWADaYyeYKcRs6at9GSlEaWiFCG1Gj0qLK9DscaA098=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hlPTBijNll07tReOdurmD1gxGXBde2QbD4J3HUyvcTs1ZsbAAGyaEWvuVC5IU6y8m
         nBpomKFNNgyW/tV1lM/H3NhspVI4Fm34bYgfjWuei2hya097P9jbgnC9/pNkvr2Sm4
         OqIVjVoYD5hxjdF3i0ywNjPyoqNWvnYUs6tkrjhU=
Date:   Sat, 21 Nov 2020 22:16:58 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, edumazet@google.com, linux-mm@kvack.org,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 1/8] mm/madvise: fix memory leak from
 process_madvise
Message-ID: <20201122061658.gw1MzsmdE%akpm@linux-foundation.org>
In-Reply-To: <20201121221631.948ae4655e913a319d61700a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Subject: mm/madvise: fix memory leak from process_madvise

The early return in process_madvise() will produce a memory leak.  Fix it.

Link: https://lkml.kernel.org/r/20201116155132.GA3805951@google.com
Fixes: ecb8ac8b1f14 ("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-fix-memory-leak-from-process_madvise
+++ a/mm/madvise.c
@@ -1231,8 +1231,6 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 		ret = total_len - iov_iter_count(&iter);
 
 	mmput(mm);
-	return ret;
-
 release_task:
 	put_task_struct(task);
 put_pid:
_

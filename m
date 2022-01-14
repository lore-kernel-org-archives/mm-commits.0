Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53442C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiANWJ7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32812 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiANWJ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41056B825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04C8C36AEC;
        Fri, 14 Jan 2022 22:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198197;
        bh=ylEN43liLL2VFwNC4OUZNmfMB4yZIT74JoAXom6JfQI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lyWyKKMGMxRHkoeUq3Fx5DJs0tf9V1KIq2yxYa2eT734/mukiN0sCrp7dBjDfZx1y
         cnNkbxGBwj4ll3jQwgroK7DuK3NIhYfw3+P0YVZQpOvdpQmflqA04skTJVJ9YOZAxQ
         +ohPlJs73PzwSxzW63dE7Fb2+iro+RW0/uTiMB8M=
Date:   Fri, 14 Jan 2022 14:09:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org, xhao@linux.alibaba.com
Subject:  [patch 128/146] mm/damon: modify damon_rand() macro to
 static inline function
Message-ID: <20220114220956.eFS-asqP9%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: modify damon_rand() macro to static inline function

damon_rand() cannot be implemented as a macro.

Example:
	damon_rand(a++, b);

The value of 'a' will be incremented twice, This is obviously
unreasonable, So there fix it.

Link: https://lkml.kernel.org/r/110ffcd4e420c86c42b41ce2bc9f0fe6a4f32cd3.1638795127.git.xhao@linux.alibaba.com
Fixes: b9a6ac4e4ede ("mm/damon: adaptively adjust regions")
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-modify-damon_rand-macro-to-static-inline-function
+++ a/include/linux/damon.h
@@ -19,7 +19,10 @@
 #define DAMOS_MAX_SCORE		(99)
 
 /* Get a random number in [l, r) */
-#define damon_rand(l, r) (l + prandom_u32_max(r - l))
+static inline unsigned long damon_rand(unsigned long l, unsigned long r)
+{
+	return l + prandom_u32_max(r - l);
+}
 
 /**
  * struct damon_addr_range - Represents an address region of [@start, @end).
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF05EC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377897AbiATV2e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377891AbiATV2a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB0EC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:28:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6079160A3C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A408BC340E0;
        Thu, 20 Jan 2022 21:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714109;
        bh=8cMqpcjBAtsTuQrw9u98TFm6cFuzF0ZZJGugd8XG2+c=;
        h=Date:From:To:Subject:From;
        b=rxydNpLYrHiZbX+gyOhkxdsNgaTj6rCBIkwnC6kQz3uY0sZhXinUltswJS3znc/Fb
         pI7u32xh92S8MFum5HYdaclUTDEgYPdTahRCHOCSp2UaMk2jgNGkbSBX37BK9/dNQ7
         Nf/77y4Gk6GDrk2jLKiiZ8P7688Nae8ajc203Jlc=
Date:   Thu, 20 Jan 2022 13:28:29 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sj@kernel.org, xhao@linux.alibaba.com
Subject:  [merged]
 mm-damon-modify-damon_rand-macro-to-static-inline-function.patch removed
 from -mm tree
Message-ID: <20220120212829.yrxKyAnEo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: modify damon_rand() macro to static inline function
has been removed from the -mm tree.  Its filename was
     mm-damon-modify-damon_rand-macro-to-static-inline-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from xhao@linux.alibaba.com are



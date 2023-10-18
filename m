Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E6FCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbjJRVhh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235326AbjJRVgw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C400A1B2
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E270C433C9;
        Wed, 18 Oct 2023 21:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664957;
        bh=LNZdEJyA5cjtnD/R36ZYjd2IEvtwqYbkD3cIxxwPYnc=;
        h=Date:To:From:Subject:From;
        b=FTMq900gMQ/bxc+F0+pBltJ1dk2sG4pgDzB2qyZM7xfNJRza1MTcC/4myDLfsC7wA
         HaTkQQX5/NhTSdmhI2lmq18RUDKogEicbqVhsqN+Ns3dXTBoyILgC8zgJMqBb1oHph
         duK0U0odj4OQdykUzaDlU2eGIGGa3n6P9ndIgxPQ=
Date:   Wed, 18 Oct 2023 14:35:57 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        lucymielke@icloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-printf-attribute-to-shrinker_debugfs_name_alloc.patch removed from -mm tree
Message-Id: <20231018213557.8E270C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add printf attribute to shrinker_debugfs_name_alloc
has been removed from the -mm tree.  Its filename was
     mm-add-printf-attribute-to-shrinker_debugfs_name_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lucy Mielke <lucymielke@icloud.com>
Subject: mm: add printf attribute to shrinker_debugfs_name_alloc
Date: Fri, 6 Oct 2023 22:30:51 +0200

This fixes a compiler warning when compiling an allyesconfig with W=1:

mm/internal.h:1235:9: error: function might be a candidate for `gnu_printf'
format attribute [-Werror=suggest-attribute=format]

[akpm@linux-foundation.org: fix shrinker_alloc() as welll per Qi Zheng]
  Link: https://lkml.kernel.org/r/822387b7-4895-4e64-5806-0f56b5d6c447@bytedance.com
Link: https://lkml.kernel.org/r/ZSBue-3kM6gI6jCr@mainframe
Fixes: c42d50aefd17 ("mm: shrinker: add infrastructure for dynamically allocating shrinker")
Signed-off-by: Lucy Mielke <lucymielke@icloud.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |    1 +
 mm/internal.h            |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/shrinker.h~mm-add-printf-attribute-to-shrinker_debugfs_name_alloc
+++ a/include/linux/shrinker.h
@@ -131,6 +131,7 @@ struct shrinker {
  */
 #define SHRINKER_NONSLAB	BIT(4)
 
+__printf(2, 3)
 struct shrinker *shrinker_alloc(unsigned int flags, const char *fmt, ...);
 void shrinker_register(struct shrinker *shrinker);
 void shrinker_free(struct shrinker *shrinker);
--- a/mm/internal.h~mm-add-printf-attribute-to-shrinker_debugfs_name_alloc
+++ a/mm/internal.h
@@ -1219,8 +1219,8 @@ unsigned long shrink_slab(gfp_t gfp_mask
 			  int priority);
 
 #ifdef CONFIG_SHRINKER_DEBUG
-static inline int shrinker_debugfs_name_alloc(struct shrinker *shrinker,
-					      const char *fmt, va_list ap)
+static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
+			struct shrinker *shrinker, const char *fmt, va_list ap)
 {
 	shrinker->name = kvasprintf_const(GFP_KERNEL, fmt, ap);
 
_

Patches currently in -mm which might be from lucymielke@icloud.com are



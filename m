Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752D5C6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 19:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiILT0w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 15:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiILT0u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 15:26:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A6E4455E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 12:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65850B80882
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 19:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A93CC433C1;
        Mon, 12 Sep 2022 19:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663010807;
        bh=ZCzLyq3bTl+qiZG3kiy7JKrO9/mUo+Gu9rrvufWXzI0=;
        h=Date:To:From:Subject:From;
        b=v1ws4CXXv+yV3vOOfWMOJln3Yi8rT/X3nqtbkCr9THBUxfsZ7qDATeIDiPuZQPRnj
         KLTlsEnobjTTr87femCf2SnY4dqs3ul2Hq+gOeWq6V+xvMILMFfdgKW6mVVgGqXAhi
         ZX9itwGUZ9lReWgEAJbJF5M5DnMp7IWlrDBzc54w=
Date:   Mon, 12 Sep 2022 12:26:46 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, set_pte_at@outlook.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-improve-damon_new_region-strategy.patch added to mm-unstable branch
Message-Id: <20220912192647.0A93CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: improve damon_new_region strategy
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-improve-damon_new_region-strategy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-improve-damon_new_region-strategy.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dawei Li <set_pte_at@outlook.com>
Subject: mm/damon: improve damon_new_region strategy
Date: Mon, 12 Sep 2022 22:39:03 +0800

Kdamond is implemented as a periodical split-merge pattern, which will
create and destroy regions possibly at high frequency (hundreds or even
thousands of per sec), depending on the number of regions and aggregation
period.  In that case, kmalloc and kfree could bring speed and space
overheads, which can be improved by using a private kmem cache.

Link: https://lkml.kernel.org/r/TYCP286MB2323DA1894FA55BB9CF90978CA449@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Dawei Li <set_pte_at@outlook.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-improve-damon_new_region-strategy
+++ a/mm/damon/core.c
@@ -29,6 +29,8 @@ static bool running_exclusive_ctxs;
 static DEFINE_MUTEX(damon_ops_lock);
 static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
 
+static struct kmem_cache *damon_region_cache __ro_after_init;
+
 /* Should be called under damon_ops_lock with id smaller than NR_DAMON_OPS */
 static bool __damon_is_registered_ops(enum damon_ops_id id)
 {
@@ -119,7 +121,7 @@ struct damon_region *damon_new_region(un
 {
 	struct damon_region *region;
 
-	region = kmalloc(sizeof(*region), GFP_KERNEL);
+	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
 	if (!region)
 		return NULL;
 
@@ -148,7 +150,7 @@ static void damon_del_region(struct damo
 
 static void damon_free_region(struct damon_region *r)
 {
-	kfree(r);
+	kmem_cache_free(damon_region_cache, r);
 }
 
 void damon_destroy_region(struct damon_region *r, struct damon_target *t)
@@ -1279,4 +1281,18 @@ bool damon_find_biggest_system_ram(unsig
 	return true;
 }
 
+static int __init damon_init(void)
+{
+	damon_region_cache = kmem_cache_create("damon_region_cache", sizeof(struct damon_region),
+		0, 0, NULL);
+	if (unlikely(!damon_region_cache)) {
+		pr_err("creating damon_region_cache fails\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+subsys_initcall(damon_init);
+
 #include "core-test.h"
_

Patches currently in -mm which might be from set_pte_at@outlook.com are

mm-damon-improve-damon_new_region-strategy.patch


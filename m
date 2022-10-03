Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC19C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiJCVOP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A6E51A15
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D2FA611FB
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7441DC433C1;
        Mon,  3 Oct 2022 21:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831228;
        bh=FOYzAzYG7naBRW4AUmcFIZ1EDTNyfzQLR5opmuzrYqc=;
        h=Date:To:From:Subject:From;
        b=E6ZQH//A20An213vMB22xEIEtDk/3c8ddE96yrmJR4ChEhjwcyjx4H86w2kWwAs/t
         cD0I0WmxDuGdr54uSdmw4Y4dIKPfb83XcdUcOt66l8UpTwcN6OQi+gA5KLPNvqA0Bc
         eaZfFlMtVcZqMAsmBAx9VXEk0F0J5XRsNEtwJqFo=
Date:   Mon, 03 Oct 2022 14:07:07 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, set_pte_at@outlook.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-improve-damon_new_region-strategy.patch removed from -mm tree
Message-Id: <20221003210708.7441DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: improve damon_new_region strategy
has been removed from the -mm tree.  Its filename was
     mm-damon-improve-damon_new_region-strategy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dawei Li <set_pte_at@outlook.com>
Subject: mm/damon: improve damon_new_region strategy
Date: Mon, 12 Sep 2022 22:39:03 +0800

Kdamond is implemented as a periodical split-merge pattern, which will
create and destroy regions possibly at high frequency (hundreds or even
thousands of per sec), depending on the number of regions and aggregation
period.  In that case, kmalloc and kfree could bring speed and space
overheads, which can be improved by using a private kmem cache.

[set_pte_at@outlook.com: creating kmem cache for damon regions by KMEM_CACHE()]
  Link: https://lkml.kernel.org/r/Message-ID:
Link: https://lkml.kernel.org/r/TYCP286MB2323DA1894FA55BB9CF90978CA449@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Dawei Li <set_pte_at@outlook.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

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
@@ -1285,4 +1287,17 @@ bool damon_find_biggest_system_ram(unsig
 	return true;
 }
 
+static int __init damon_init(void)
+{
+	damon_region_cache = KMEM_CACHE(damon_region, 0);
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



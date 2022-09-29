Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE724C04A95
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiI2EFE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbiI2EFC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:05:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108533AE6A
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:05:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDCC9B82206
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F484C433D7;
        Thu, 29 Sep 2022 04:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424298;
        bh=XFE/RbYtxHhnxB6o84tNYXQVKSnpV82su+kzhlFT6+0=;
        h=Date:To:From:Subject:From;
        b=RN/Owot9Gooddw6IGbpqUyKMp0AFgVsfJ/1COi/fYgXFR22x9CBjaUmjaVKjBT42R
         vOSr68AapSJmNE2fkNd3Oikwe8OBs/LMtTLdiCf91OgMX3XIAL0Ys3+epIR6oWDqGl
         qZuwcimLjZgIycr6aSsxhfPcb0KtEGG3xsDCxGaQ=
Date:   Wed, 28 Sep 2022 21:04:57 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, set_pte_at@outlook.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-improve-damon_new_region-strategy-fix.patch removed from -mm tree
Message-Id: <20220929040458.3F484C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: creating kmem cache for damon regions by KMEM_CACHE()
has been removed from the -mm tree.  Its filename was
     mm-damon-improve-damon_new_region-strategy-fix.patch

This patch was dropped because it was folded into mm-damon-improve-damon_new_region-strategy.patch

------------------------------------------------------
From: Dawei Li <set_pte_at@outlook.com>
Subject: mm/damon: creating kmem cache for damon regions by KMEM_CACHE()
Date: Wed, 14 Sep 2022 00:21:58 +0800

Damon regions are dynamic objects which can be created and destroyed
frequently, a dedicated slab cache is created by KMEM_CACHE(), as
suggested by akpm.

Link: https://lkml.kernel.org/r/Message-ID:
Signed-off-by: Dawei Li <set_pte_at@outlook.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-improve-damon_new_region-strategy-fix
+++ a/mm/damon/core.c
@@ -1289,8 +1289,7 @@ bool damon_find_biggest_system_ram(unsig
 
 static int __init damon_init(void)
 {
-	damon_region_cache = kmem_cache_create("damon_region_cache", sizeof(struct damon_region),
-		0, 0, NULL);
+	damon_region_cache = KMEM_CACHE(damon_region, 0);
 	if (unlikely(!damon_region_cache)) {
 		pr_err("creating damon_region_cache fails\n");
 		return -ENOMEM;
_

Patches currently in -mm which might be from set_pte_at@outlook.com are

mm-damon-improve-damon_new_region-strategy.patch


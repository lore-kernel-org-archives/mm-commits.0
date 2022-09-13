Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE436ECAAD8
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 22:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiIMWJr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIMWJp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 18:09:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5353CE30
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 15:09:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DC899CE1276
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 22:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15D5C433D7;
        Tue, 13 Sep 2022 22:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106977;
        bh=YGTP6z0f/mEML/GxUDI8ygPnQBIjKVCZ6c8F82b2qP8=;
        h=Date:To:From:Subject:From;
        b=gIQN1tY/LWuuz0htRV+1ZVbaIX0B+8x7Cq9NlyxrFuVPappUar6CUyo7oXg0zM8KN
         Vo/3MdIpMxc4gjmU6XJ4dwL553VC3Tb+NHbR5YicGmlCFKdELmD7Y7+XIYmUPM2qEG
         /ZLiu2ueXzJgj//BaWN2c/HHM31yN7TCTXfYmbuk=
Date:   Tue, 13 Sep 2022 15:09:36 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, set_pte_at@outlook.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-improve-damon_new_region-strategy-fix.patch added to mm-unstable branch
Message-Id: <20220913220937.C15D5C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: creating kmem cache for damon regions by KMEM_CACHE()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-improve-damon_new_region-strategy-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-improve-damon_new_region-strategy-fix.patch

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
mm-damon-improve-damon_new_region-strategy-fix.patch


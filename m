Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA012C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF66061152
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhI3WXa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 18:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348660AbhI3WXZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 18:23:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B491361A51;
        Thu, 30 Sep 2021 22:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633040502;
        bh=zxSr6oUaXw40oA1QViHK7Cf23fTcu4+85QQqxDXc8cQ=;
        h=Date:From:To:Subject:From;
        b=au55WjbmomS0YM0FTpHAL9zcaoQ6UOuFnWksS+3Mwr/ZkIMgKZsGlsmamN8z2wwUR
         hkPmxHtCZnDnvkL1B1xnbHfJnK0BwxBNivvguLVLx3PizasHEwVgBs8DxMjEYhHfdV
         CSJApBzOJPwGPq9hfJwXZvVLkGi8uorGMXOkAfFw=
Date:   Thu, 30 Sep 2021 15:21:41 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, shi_lei@massclouds.com,
        vbabka@suse.cz
Subject:  + mm-remove-useless-lines-in-enable_cpucache.patch added
 to -mm tree
Message-ID: <20210930222141.dMCXEHNMK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: remove useless lines in enable_cpucache()
has been added to the -mm tree.  Its filename is
     mm-remove-useless-lines-in-enable_cpucache.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-useless-lines-in-enable_cpucache.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-useless-lines-in-enable_cpucache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shi Lei <shi_lei@massclouds.com>
Subject: mm/slab.c: remove useless lines in enable_cpucache()

These lines are useless, so remove them.

Link: https://lkml.kernel.org/r/20210930034845.2539-1-shi_lei@massclouds.com
Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
Signed-off-by: Shi Lei <shi_lei@massclouds.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/slab.c~mm-remove-useless-lines-in-enable_cpucache
+++ a/mm/slab.c
@@ -3900,8 +3900,6 @@ static int enable_cpucache(struct kmem_c
 	if (err)
 		goto end;
 
-	if (limit && shared && batchcount)
-		goto skip_setup;
 	/*
 	 * The head array serves three purposes:
 	 * - create a LIFO ordering, i.e. return objects that are cache-warm
@@ -3944,7 +3942,6 @@ static int enable_cpucache(struct kmem_c
 		limit = 32;
 #endif
 	batchcount = (limit + 1) / 2;
-skip_setup:
 	err = do_tune_cpucache(cachep, limit, batchcount, shared, gfp);
 end:
 	if (err)
_

Patches currently in -mm which might be from shi_lei@massclouds.com are

mm-remove-useless-lines-in-enable_cpucache.patch


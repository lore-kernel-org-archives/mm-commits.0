Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19ECC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C4EF61354
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhKKCmg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233571AbhKKCmg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3D24610F7;
        Thu, 11 Nov 2021 02:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598387;
        bh=Svy8Yg+MlWodadoLHWOMrdgTNSkyA+XZRqGit1uFUb8=;
        h=Date:From:To:Subject:From;
        b=zn23UQMZdcL9LssTvmFrv9xwP0L8sBBtLh/h7BjtoFDMffqU8p0ss/c69JElG1URx
         XdkKoNq9QGKrCDIcnOkuppACuC6ysAFcKsF0RLeXxfUIoIwQBbp6wGocVGTC/JOfQX
         KPy7hAASKvXrtXCZhGoHOujEmw2VQapbbuNmEjHk=
Date:   Wed, 10 Nov 2021 18:39:47 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, shi_lei@massclouds.com,
        vbabka@suse.cz
Subject:  [merged] mm-remove-useless-lines-in-enable_cpucache.patch
 removed from -mm tree
Message-ID: <20211111023947.etI4mHoF5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: remove useless lines in enable_cpucache()
has been removed from the -mm tree.  Its filename was
     mm-remove-useless-lines-in-enable_cpucache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shi Lei <shi_lei@massclouds.com>
Subject: mm/slab.c: remove useless lines in enable_cpucache()

These lines are useless, so remove them.

Link: https://lkml.kernel.org/r/20210930034845.2539-1-shi_lei@massclouds.com
Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
Signed-off-by: Shi Lei <shi_lei@massclouds.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
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



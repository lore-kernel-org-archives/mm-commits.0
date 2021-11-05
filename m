Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB589C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D641E6127B
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhKEUhw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232002AbhKEUhv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:37:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E2A46125F;
        Fri,  5 Nov 2021 20:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144511;
        bh=DCh7yJy6z4y7qRQcZROwHfmik69LdedH9RpmhvtpYrE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EDyQkK1xNAfJDzrAKp3XAnJgA9PLBfou5PIVij6W6cAn134gCZrfJRGgw2/o5+c6b
         BMYx0DNHD94rH6XbS9o7Cau55JjY3YvkmlTzyft3W8cHK+txx9Suf8E74YW9XG6aYZ
         NIUn9MQzhhMrlBwntJTW+QyG4hYorWPB2pSGFLag=
Date:   Fri, 05 Nov 2021 13:35:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shi_lei@massclouds.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 012/262] mm/slab.c: remove useless lines in
 enable_cpucache()
Message-ID: <20211105203510.kUPi_1np4%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

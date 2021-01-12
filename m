Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744F1C432C3
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5293C23131
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbhAMAmr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 19:42:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391912AbhALXtq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 18:49:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6547723130;
        Tue, 12 Jan 2021 23:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610495345;
        bh=e9BMBFEaSOKf0yTOMhrOd2Hj2FNsOt4O1JwdlSqxAR4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EDJ16x67znM1zbVVL3ZAZB26KfTcNT35T1YUpem+TmGZoLe45PMiWYQgk8Ac2TqBm
         INzAnAVxGYHKD7iJa2AQFD3P3h7vf7OxFHPV4tJujn+FtYn4r/YpzX0OIB1qT+solo
         saWPNJT3TfCMgQD0NSEtjrxNMyknMHA6IgA7HPPI=
Date:   Tue, 12 Jan 2021 15:49:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 01/10] mm, slub: consider rest of partial list if
 acquire_slab() fails
Message-ID: <20210112234904.X5Ka1PlfB%akpm@linux-foundation.org>
In-Reply-To: <20210112154839.abeb6e57de79480059fd9b0e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jann Horn <jannh@google.com>
Subject: mm, slub: consider rest of partial list if acquire_slab() fails

acquire_slab() fails if there is contention on the freelist of the page
(probably because some other CPU is concurrently freeing an object from
the page).  In that case, it might make sense to look for a different page
(since there might be more remote frees to the page from other CPUs, and
we don't want contention on struct page).

However, the current code accidentally stops looking at the partial list
completely in that case.  Especially on kernels without CONFIG_NUMA set,
this means that get_partial() fails and new_slab_objects() falls back to
new_slab(), allocating new pages.  This could lead to an unnecessary
increase in memory fragmentation.

Link: https://lkml.kernel.org/r/20201228130853.1871516-1-jannh@google.com
Fixes: 7ced37197196 ("slub: Acquire_slab() avoid loop")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-consider-rest-of-partial-list-if-acquire_slab-fails
+++ a/mm/slub.c
@@ -1973,7 +1973,7 @@ static void *get_partial_node(struct kme
 
 		t = acquire_slab(s, n, page, object == NULL, &objects);
 		if (!t)
-			break;
+			continue; /* cmpxchg raced */
 
 		available += objects;
 		if (!object) {
_

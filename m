Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AC3C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1924E20771
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgL2XPa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 18:15:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgL2XPa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 18:15:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08E4C22209;
        Tue, 29 Dec 2020 23:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609283708;
        bh=o9L4INN7jM+h/jWMta1csQDzdwUzM0efDVa+ZoGj9R8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RYAP45Fogb9iFA2he4PZRNFYHqoNVobEZo0lSpSt27ZfvooLO9evDiK/aJzZf25tV
         /BNIxiCJ0WAS2B1ESBVIyCvwJVk/0dmR60YplHivzZXOykY4BRERv23h8v/Ne9pt/t
         cVguk5vs/QhIaZawrymSnKBV1hWV93Nv6D4hIEO0=
Date:   Tue, 29 Dec 2020 15:15:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 16/16] mm: slub: call account_slab_page() after
 slab page initialization
Message-ID: <20201229231507.0MS9eCjiX%akpm@linux-foundation.org>
In-Reply-To: <20201229151349.3285926ec0d1f65a27ac8534@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: slub: call account_slab_page() after slab page initialization

It's convenient to have page->objects initialized before calling into
account_slab_page().  In particular, this information can be used to
pre-alloc the obj_cgroup vector.

Let's call account_slab_page() a bit later, after the initialization of
page->objects.

This commit doesn't bring any functional change, but is required for
further optimizations.

[akpm@linux-foundation.org: undo changes needed by forthcoming mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch]
Link: https://lkml.kernel.org/r/20201110195753.530157-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-call-account_slab_page-after-slab-page-initialization
+++ a/mm/slub.c
@@ -1619,9 +1619,6 @@ static inline struct page *alloc_slab_pa
 	else
 		page = __alloc_pages_node(node, flags, order);
 
-	if (page)
-		account_slab_page(page, order, s);
-
 	return page;
 }
 
@@ -1774,6 +1771,8 @@ static struct page *allocate_slab(struct
 
 	page->objects = oo_objects(oo);
 
+	account_slab_page(page, oo_order(oo), s);
+
 	page->slab_cache = s;
 	__SetPageSlab(page);
 	if (page_is_pfmemalloc(page))
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12475C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D77DE223E4
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgLaSYT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:24:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgLaSYT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 31 Dec 2020 13:24:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D5A8224D3;
        Thu, 31 Dec 2020 18:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438996;
        bh=1saSkaa2prwtCsDOiJZu2sxngbOgxIL4Esbarc+sEtI=;
        h=Date:From:To:Subject:From;
        b=ViYTie2RN0TZQvyvQmh4wJtOGLuiFFHaBAxtkL2DFFhLAq1M91GjNnNVCXWb4sfRy
         kqQtc6M5NgaTXn5lkjfUfEqWF4sgejRkSbEw6bogndg2mraYi65rCIsd3pPhQFAaXi
         EWm9ec1c++lSKfYq44C4R3HQkC2jOdP5aYelGWiU=
Date:   Thu, 31 Dec 2020 10:23:16 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged]
 mm-slub-call-account_slab_page-after-slab-page-initialization.patch removed
 from -mm tree
Message-ID: <20201231182316.Eae-t4vwY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: call account_slab_page() after slab page initialization
has been removed from the -mm tree.  Its filename was
     mm-slub-call-account_slab_page-after-slab-page-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-cma-allocate-cma-areas-bottom-up.patch
mm-cma-allocate-cma-areas-bottom-up-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-2.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3.patch
memblock-do-not-start-bottom-up-allocations-with-kernel_end.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch


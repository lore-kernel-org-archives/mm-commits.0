Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E966C388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 20:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 398242074B
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 20:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRnlZmxz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgKJUut (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 15:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKJUut (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 15:50:49 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00A3020674;
        Tue, 10 Nov 2020 20:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605041448;
        bh=r2xBAS5MP82KwF3MG/Q8Vr/L54p5vy0f8je+EctTplc=;
        h=Date:From:To:Subject:From;
        b=jRnlZmxz4h6V+JVTs+8LvtBSAvl+mHos6mPKHZMpjcW9rR1TOIjcl8rrKbJt85GWn
         QtrNlcvM3gXb26xegDG1TfY9YLJBZbbIs29WNjTlJoIjLwM5/lukDd1tVxM6cz/SIK
         cCt9qaoadfNdr3b12Kh0O2Xi9ineI9jFXLnSIFVQ=
Date:   Tue, 10 Nov 2020 12:50:47 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  +
 mm-slub-call-account_slab_page-after-slab-page-initialization.patch added
 to -mm tree
Message-ID: <20201110205047.YK1iGHmy8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: call account_slab_page() after slab page initialization
has been added to the -mm tree.  Its filename is
     mm-slub-call-account_slab_page-after-slab-page-initialization.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-call-account_slab_page-after-slab-page-initialization.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-call-account_slab_page-after-slab-page-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20201110195753.530157-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-call-account_slab_page-after-slab-page-initialization
+++ a/mm/slub.c
@@ -1616,9 +1616,6 @@ static inline struct page *alloc_slab_pa
 	else
 		page = __alloc_pages_node(node, flags, order);
 
-	if (page)
-		account_slab_page(page, order, s);
-
 	return page;
 }
 
@@ -1771,6 +1768,8 @@ static struct page *allocate_slab(struct
 
 	page->objects = oo_objects(oo);
 
+	account_slab_page(page, oo_order(oo), s, flags);
+
 	page->slab_cache = s;
 	__SetPageSlab(page);
 	if (page_is_pfmemalloc(page))
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
mm-introduce-page-memcg-flags.patch
mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
mm-memcg-fix-obsolete-code-comments.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch


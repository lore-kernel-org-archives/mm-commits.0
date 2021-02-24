Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8BAC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A65F64F25
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhBXUGU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235279AbhBXUFv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC04464F34;
        Wed, 24 Feb 2021 20:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197067;
        bh=ZM3i/IwR0/R6XZBVEpCe3w7JVAyigaLJFGrhMVLQt40=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Y7O7f3i2GzIa4txrrDQj0QZunST22mFHG5bZbVk4fdMh/TfeUej+BBGkSklhh2f0+
         sjCR+0a15xfOCbFFZA4pYeAPlFuzNVXQ7IasxXDcCn/IIy6REhPqPNdd3DSgHE7uZ2
         zW4Prw9QwP8SUEVOI4ykLJls1yFFzQEJXllI0MZA=
Date:   Wed, 24 Feb 2021 12:04:26 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 075/173] mm: memcontrol: fix slub memory
 accounting
Message-ID: <20210224200426.vEeBLOjbH%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix slub memory accounting

SLUB currently account kmalloc() and kmalloc_node() allocations larger
than order-1 page per-node.  But it forget to update the per-memcg
vmstats.  So it can lead to inaccurate statistics of "slab_unreclaimable"
which is from memory.stat.  Fix it by using mod_lruvec_page_state instead
of mod_node_page_state.

Link: https://lkml.kernel.org/r/20210223092423.42420-1-songmuchun@bytedance=
.com
Fixes: 6a486c0ad4dc ("mm, sl[ou]b: improve memory accounting")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    4 ++--
 mm/slub.c        |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/slab_common.c~mm-memcontrol-fix-slub-memory-accounting
+++ a/mm/slab_common.c
@@ -898,8 +898,8 @@ void *kmalloc_order(size_t size, gfp_t f
 	page =3D alloc_pages(flags, order);
 	if (likely(page)) {
 		ret =3D page_address(page);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
-				    PAGE_SIZE << order);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+				      PAGE_SIZE << order);
 	}
 	ret =3D kasan_kmalloc_large(ret, size, flags);
 	/* As ret might get tagged, call kmemleak hook after KASAN. */
--- a/mm/slub.c~mm-memcontrol-fix-slub-memory-accounting
+++ a/mm/slub.c
@@ -4042,8 +4042,8 @@ static void *kmalloc_large_node(size_t s
 	page =3D alloc_pages_node(node, flags, order);
 	if (page) {
 		ptr =3D page_address(page);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
-				    PAGE_SIZE << order);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+				      PAGE_SIZE << order);
 	}
=20
 	return kmalloc_large_node_hook(ptr, size, flags);
@@ -4174,8 +4174,8 @@ void kfree(const void *x)
=20
 		BUG_ON(!PageCompound(page));
 		kfree_hook(object);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
-				    -(PAGE_SIZE << order));
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+				      -(PAGE_SIZE << order));
 		__free_pages(page, order);
 		return;
 	}
_

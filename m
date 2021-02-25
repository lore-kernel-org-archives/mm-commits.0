Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB4DC43381
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 892BA64F47
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbhBYT2G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:28:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234222AbhBYTZi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0EB164F73;
        Thu, 25 Feb 2021 19:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280485;
        bh=I+t1fijU634sdBy5PI8RRayyKZw+NE7GjFsTUSOldJ0=;
        h=Date:From:To:Subject:From;
        b=i4/7iwhsBrLcIVsEt2i7jDatp8ZG6zcE9cpZPKX2L6lraErqIFFHPSTqmX36gfkE9
         talwdVdklKuKyqgkX70oU9BWlxpr8VWTQEmCMG7q1MjLQe4/I87IHnGacAamFwpzOX
         PXBK02adw/UsYiztv25JwxrogCpyeemoTq7+CQVY=
Date:   Thu, 25 Feb 2021 11:14:44 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mkoutny@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  [merged] mm-memcontrol-fix-slub-memory-accounting.patch
 removed from -mm tree
Message-ID: <20210225191444.atW89uzcM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix slub memory accounting
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-slub-memory-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
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

Patches currently in -mm which might be from songmuchun@bytedance.com are



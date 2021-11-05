Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7807C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1DC061131
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhKEShi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232528AbhKEShh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:37:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE8C06113B;
        Fri,  5 Nov 2021 18:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137297;
        bh=l0eTwYYUlEJ15Xcy25e2IddaxH4lXZQWA7//amNgmnw=;
        h=Date:From:To:Subject:From;
        b=jl+5gXiLFkGQWHco+Rdfvz79RFAG4TdACkwotT2vT6c/dVRvVEvdu6bXbouX8kEbh
         t6YntXm9Nu8CPoXS8m8IXAP7zaONsiyFEmvDyzZOrcY87AEjOZ+/X2pxUVD8cKzZqJ
         okj2zIgLjZfooHGyu8WuEhDBY+RKmWhJAF22dvbk=
Date:   Fri, 05 Nov 2021 11:34:56 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, guro@fb.com, hannes@cmpxchg.org, longman@redhat.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  [folded-merged]
 memcg-kmem-further-deprecate-kmemlimit_in_bytes-fix.patch removed from -mm
 tree
Message-ID: <20211105183456.MQad5IYZ3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, kmem: mark cancel_charge() inline
has been removed from the -mm tree.  Its filename was
     memcg-kmem-further-deprecate-kmemlimit_in_bytes-fix.patch

This patch was dropped because it was folded into memcg-kmem-further-deprecate-kmemlimit_in_bytes.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: memcg, kmem: mark cancel_charge() inline

cancel_charge() is no longer called for CONFIG_MEMCG_KMEM on NOMMU
targets, which causes a compiletime warning:

mm/memcontrol.c:2774:13: error: unused function 'cancel_charge' [-Werror,-Wunused-function]

Remove the now-incorrect #ifdef and just mark the function 'inline' like
the other related helpers.  This is simpler and means we no longer have to
match the #ifdef with the caller.

Link: https://lkml.kernel.org/r/20211022070542.679839-1-arnd@kernel.org
Fixes: 5f3345c17079 ("memcg, kmem: further deprecate kmem.limit_in_bytes")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Roman Gushchin <guro@fb.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memcontrol.c~memcg-kmem-further-deprecate-kmemlimit_in_bytes-fix
+++ a/mm/memcontrol.c
@@ -2771,8 +2771,7 @@ static inline int try_charge(struct mem_
 	return try_charge_memcg(memcg, gfp_mask, nr_pages);
 }
 
-#if defined(CONFIG_MEMCG_KMEM) || defined(CONFIG_MMU)
-static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
+static inline void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	if (mem_cgroup_is_root(memcg))
 		return;
@@ -2781,7 +2780,6 @@ static void cancel_charge(struct mem_cgr
 	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 }
-#endif
 
 static void commit_charge(struct page *page, struct mem_cgroup *memcg)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

posix-acl-avoid-wempty-body-warning.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-fix-2.patch
kasan-test-use-underlying-string-helpers.patch
hfs-hfsplus-use-warn_on-for-sanity-check.patch


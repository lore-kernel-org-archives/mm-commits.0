Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDC5C11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 593B461D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhF2CkJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhF2CkI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 962A161D07;
        Tue, 29 Jun 2021 02:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934262;
        bh=NAOfEe8KNEil83HGqFG2CtL9vj/da7xENsqmkyUm5rs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eThUkLOR/m0CE41Ob6qPMk06y8aLyYW6eWQlUw8r+9i+9XwF3CHv27r/1cNRIeqIx
         lKdAlOA3Y5F21FTwkjD90erUAfoQFyN0rqIUgZPoBpiVHlZwRt+nUhDiD8qe5Uw7Zk
         caZf0EN0OZvU+sfBxhR21lUYMwYSvwtoj7sCP9ps=
Date:   Mon, 28 Jun 2021 19:37:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        longman@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, shakeelb@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [patch 083/192] mm: memcg/slab: disable cache merging for
 KMALLOC_NORMAL caches
Message-ID: <20210629023741.PkHgTVlNZ%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Waiman Long <longman@redhat.com>
Subject: mm: memcg/slab: disable cache merging for KMALLOC_NORMAL caches

The KMALLOC_NORMAL (kmalloc-<n>) caches are for unaccounted objects only
when CONFIG_MEMCG_KMEM is enabled.  To make sure that this condition
remains true, we will have to prevent KMALOC_NORMAL caches to merge with
other kmem caches.  This is now done by setting its refcount to -1 right
after its creation.

Link: https://lkml.kernel.org/r/20210505200610.13943-4-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Suggested-by: Roman Gushchin <guro@fb.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/slab_common.c~mm-memcg-slab-disable-cache-merging-for-kmalloc_normal-caches
+++ a/mm/slab_common.c
@@ -856,6 +856,13 @@ new_kmalloc_cache(int idx, enum kmalloc_
 					kmalloc_info[idx].name[type],
 					kmalloc_info[idx].size, flags, 0,
 					kmalloc_info[idx].size);
+
+	/*
+	 * If CONFIG_MEMCG_KMEM is enabled, disable cache merging for
+	 * KMALLOC_NORMAL caches.
+	 */
+	if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_NORMAL))
+		kmalloc_caches[type][idx]->refcount = -1;
 }
 
 /*
_

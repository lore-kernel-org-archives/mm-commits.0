Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57924C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FD0161C7A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhGFTOM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhGFTOL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70D7261C6C;
        Tue,  6 Jul 2021 19:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598691;
        bh=JO+9rQ1RsoQrcc+AkwMmuTdrRrxS741fsAg/c3UaP9Q=;
        h=Date:From:To:Subject:From;
        b=MdTBZNO881RNN9oPR57SdJc6tukCTPw88pmVBWtnuv3QWQZFBsVOkkWvxvcT5TYb4
         KSiWM0V9Gncletw6xIKu5XApiUvK5uMMa/9gmtWyElCHWXF+1D/Rw7mProU8SVaJn2
         Vt7yxdO6ETaUxr9ESlzjiVh9C9fvaaK2im95r8HY=
Date:   Tue, 06 Jul 2021 12:11:31 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcg-slab-disable-cache-merging-for-kmalloc_normal-caches.patch removed
 from -mm tree
Message-ID: <20210706191131.j5lemrlCr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: disable cache merging for KMALLOC_NORMAL caches
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-disable-cache-merging-for-kmalloc_normal-caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from longman@redhat.com are



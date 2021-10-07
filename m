Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF1EC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE2761038
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhJGTmW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 15:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231825AbhJGTmW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Oct 2021 15:42:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D70F60FC2;
        Thu,  7 Oct 2021 19:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633635628;
        bh=Q8Vx2Tg7udFEuxk6TS7XLyYSbLaCzrwSF7q5RTxh4Ec=;
        h=Date:From:To:Subject:From;
        b=vKNfjNxhHqc9RgnyJdOZOdICHsmIqal24HWPui6qVkzPtVT0vKf7RbKwkIMBdy6ZK
         F3hNpxS8uOZJ3yjtgK3bEOMfoOQw4wjmY5EjCDfSdwUMG1Va2RK58U1KOvWA/S5moU
         2gxYdg0LGWHhNSH+jHjKHK5m+1QfXAQefGDsgzDQ=
Date:   Thu, 07 Oct 2021 12:40:27 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, cl@linux.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [to-be-updated]
 mm-dont-call-should_failslab-for-config_failslab.patch removed from -mm
 tree
Message-ID: <20211007194027.ewH_lpVjW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't call should_failslab() for !CONFIG_FAILSLAB
has been removed from the -mm tree.  Its filename was
     mm-dont-call-should_failslab-for-config_failslab.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: mm: don't call should_failslab() for !CONFIG_FAILSLAB

Allocations can be a very hot path, and this out-of-line function
call is noticeable.

Link: https://lkml.kernel.org/r/e01e5e40-692a-519c-4cba-e3331f173c82@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    2 +-
 mm/slab.h                    |    2 ++
 mm/slab_common.c             |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/fault-inject.h~mm-dont-call-should_failslab-for-config_failslab
+++ a/include/linux/fault-inject.h
@@ -64,8 +64,8 @@ static inline struct dentry *fault_creat
 
 struct kmem_cache;
 
-int should_failslab(struct kmem_cache *s, gfp_t gfpflags);
 #ifdef CONFIG_FAILSLAB
+int should_failslab(struct kmem_cache *s, gfp_t gfpflags);
 extern bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags);
 #else
 static inline bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
--- a/mm/slab_common.c~mm-dont-call-should_failslab-for-config_failslab
+++ a/mm/slab_common.c
@@ -1323,6 +1323,7 @@ EXPORT_TRACEPOINT_SYMBOL(kmem_cache_allo
 EXPORT_TRACEPOINT_SYMBOL(kfree);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
 
+#ifdef CONFIG_FAILSLAB
 int should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 {
 	if (__should_failslab(s, gfpflags))
@@ -1330,3 +1331,4 @@ int should_failslab(struct kmem_cache *s
 	return 0;
 }
 ALLOW_ERROR_INJECTION(should_failslab, ERRNO);
+#endif
--- a/mm/slab.h~mm-dont-call-should_failslab-for-config_failslab
+++ a/mm/slab.h
@@ -491,8 +491,10 @@ static inline struct kmem_cache *slab_pr
 
 	might_alloc(flags);
 
+#ifdef CONFIG_FAILSLAB
 	if (should_failslab(s, flags))
 		return NULL;
+#endif
 
 	if (!memcg_slab_pre_alloc_hook(s, objcgp, size, flags))
 		return NULL;
_

Patches currently in -mm which might be from axboe@kernel.dk are



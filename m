Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C4AC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A545F611CA
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbhJEVVE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 17:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236042AbhJEVVE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 17:21:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04A4861159;
        Tue,  5 Oct 2021 21:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633468753;
        bh=w6RFqh1z9Z1+WkzRke4L3wRUFPk8Q2dTRsjSOryXXxI=;
        h=Date:From:To:Subject:From;
        b=RE0q/RoKoU1gpzkdmdRzS3vY7BYbp/tJp9qwkPCxjlzD/GmTvf68t5AmL7IXj1/cR
         f6htA8DpWmj+wqDAs94QmtIhTnLA9SV5ZZNpSbN0qV4FH14rOFncidZ0pfI9abBOKH
         d9TJAL5a7ny+QSaUCulbu8SFufgYbDRm8cQB2m8o=
Date:   Tue, 05 Oct 2021 14:19:12 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, cl@linux.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  + mm-dont-call-should_failslab-for-config_failslab.patch
 added to -mm tree
Message-ID: <20211005211912.PKbB242SP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't call should_failslab() for !CONFIG_FAILSLAB
has been added to the -mm tree.  Its filename is
     mm-dont-call-should_failslab-for-config_failslab.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-call-should_failslab-for-config_failslab.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-call-should_failslab-for-config_failslab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-dont-call-should_failslab-for-config_failslab.patch


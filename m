Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85EB9C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D15222CB3
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781140;
	bh=bc48BL73VXwV/bxiX0u8KlfYKhcdsULjFa5h3rzwa/g=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Q1rCwad7Wm7r539LoEIiskT9EDeYvKkixXRlNsPK7t0cMl/1omwntMZss2XYKY06+
	 yYPAUjCidyToV/n9hN/jBeGNql9FO4GuQysSfvVF2iICz/SQVj9bSYrGalSHUqCoii
	 a004NvlvpuaR0EkLFQfkDS21Clw7hRTRpnv0D2zw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgHGGTA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:19:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGTA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:19:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC3F2177B;
        Fri,  7 Aug 2020 06:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781139;
        bh=bc48BL73VXwV/bxiX0u8KlfYKhcdsULjFa5h3rzwa/g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s3tUUtDqyjMcH4mF9j+ZpHeY1PtxjWeQWUyDlmwawgs6w2oyJGpq7teRL7arNLKBY
         v2FzHTK+3DGWznvJXPDaUJBmRIwKP0KMvtlhesVSUQLvqfjHmgM8p3hU3dSikYrIoK
         Df52xeRA5alhMfvZziB1ZqQNK1t4rHZgYUsDnrl8=
Date:   Thu, 06 Aug 2020 23:18:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, jannh@google.com, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        vjitta@codeaurora.org
Subject:  [patch 035/163] mm, slub: extend checks guarded by
 slub_debug static key
Message-ID: <20200807061858.P7bD7iz08%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: extend checks guarded by slub_debug static key

There are few more places in SLUB that could benefit from reduced overhead
of the static key introduced by a previous patch:

- setup_object_debug() called on each object in newly allocated slab page
- setup_page_debug() called on newly allocated slab page
- __free_slab() called on freed slab page

Link: http://lkml.kernel.org/r/20200610163135.17364-9-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-extend-checks-guarded-by-slub_debug-static-key
+++ a/mm/slub.c
@@ -1131,7 +1131,7 @@ static inline void dec_slabs_node(struct
 static void setup_object_debug(struct kmem_cache *s, struct page *page,
 								void *object)
 {
-	if (!(s->flags & (SLAB_STORE_USER|SLAB_RED_ZONE|__OBJECT_POISON)))
+	if (!kmem_cache_debug_flags(s, SLAB_STORE_USER|SLAB_RED_ZONE|__OBJECT_POISON))
 		return;
 
 	init_object(s, object, SLUB_RED_INACTIVE);
@@ -1141,7 +1141,7 @@ static void setup_object_debug(struct km
 static
 void setup_page_debug(struct kmem_cache *s, struct page *page, void *addr)
 {
-	if (!(s->flags & SLAB_POISON))
+	if (!kmem_cache_debug_flags(s, SLAB_POISON))
 		return;
 
 	metadata_access_enable();
@@ -1853,7 +1853,7 @@ static void __free_slab(struct kmem_cach
 	int order = compound_order(page);
 	int pages = 1 << order;
 
-	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
+	if (kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS)) {
 		void *p;
 
 		slab_pad_check(s, page);
_

Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F4BC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBD3A2073E
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026912;
	bh=DqomNW+IOC+1Daxpx8+laf0EeSVozqlgl2gLuYuxLvw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rrPZt/MZIwYhb3R6xqzEZ+fOslb0cRksR/WeK9By/OnXYEOHcM0KDQLJfKTUUTEX0
	 bOw2SCiEHLr81xZ8asmofPLNptjU6MN0gkoI7Xyx65wG4HXY/16b1iog4Diy1hfd87
	 FJiIzWenzOqFQh9JzyvxyGlKvvlod3p5VDxPdzpo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgHJCfM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99114206E9;
        Mon, 10 Aug 2020 02:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026911;
        bh=DqomNW+IOC+1Daxpx8+laf0EeSVozqlgl2gLuYuxLvw=;
        h=Date:From:To:Subject:From;
        b=hwv/13ueyoWf5NJMEbSTu+uOgUFz0HFcIwsY4G4WLxcOk10UKhSV028EY9a8EaOKa
         c+vVvZR6dKEuIQY4FlYZ/u2nzjm5y17vYS2YrVrCJXU+6xoN0m99fW1wShLUx7ZPEC
         kGsvqgpE8rFsYSirmGwb6V8NDWMozZ3gH7hMpc+o=
Date:   Sun, 09 Aug 2020 19:35:11 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vjitta@codeaurora.org
Subject:  [merged]
 mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch removed from
 -mm tree
Message-ID: <20200810023511.jmEQMwQBv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: extend checks guarded by slub_debug static key
has been removed from the -mm tree.  Its filename was
     mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vbabka@suse.cz are



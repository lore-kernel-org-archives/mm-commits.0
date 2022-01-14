Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 088A9C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiANWE6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiANWE5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE660C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:04:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DF50B82630
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0990C36AE9;
        Fri, 14 Jan 2022 22:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197895;
        bh=mkkkJ35mbtCFnAHFKOtKZhQFffsv0tDMjABiOPOBwlg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WsF6aaTBa7eRAoVxgyPiZp+99D5a2VdUbmWx4eJC++XLfdfRb1CAgklrXFhpfeZOC
         sg9wiOb6w3XCfCmRhWK9nQb8xYnO+BKFbipz07nx1+ZM7iGuldn2JSwhxu18rsZPyQ
         dOHOILNmGX16Oo8njYabzS+0Neb2jR8NNsDrDaN4=
Date:   Fri, 14 Jan 2022 14:04:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com, cl@linux.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 037/146] kasan: add ability to detect
 double-kmem_cache_destroy()
Message-ID: <20220114220454._y_b0o7I7%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kasan: add ability to detect double-kmem_cache_destroy()

Because mm/slab_common.c is not instrumented with software KASAN modes, it
is not possible to detect use-after-free of the kmem_cache passed into
kmem_cache_destroy().  In particular, because of the s->refcount-- and
subsequent early return if non-zero, KASAN would never be able to see the
double-free via kmem_cache_free(kmem_cache, s).  To be able to detect a
double-kmem_cache_destroy(), check accessibility of the kmem_cache, and in
case of failure return early.

While KASAN_HW_TAGS is able to detect such bugs, by checking accessibility
and returning early we fail more gracefully and also avoid corrupting
reused objects (where tags mismatch).

A recent case of a double-kmem_cache_destroy() was detected by KFENCE:
https://lkml.kernel.org/r/0000000000003f654905c168b09d@google.com, which
was not detectable by software KASAN modes.

Link: https://lkml.kernel.org/r/20211119142219.1519617-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab_common.c~kasan-add-ability-to-detect-double-kmem_cache_destroy
+++ a/mm/slab_common.c
@@ -489,7 +489,7 @@ void slab_kmem_cache_release(struct kmem
 
 void kmem_cache_destroy(struct kmem_cache *s)
 {
-	if (unlikely(!s))
+	if (unlikely(!s) || !kasan_check_byte(s))
 		return;
 
 	cpus_read_lock();
_

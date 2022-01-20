Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 173A6C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377815AbiATVY2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35592 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377814AbiATVY0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 895CE60B08
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95717C340E3;
        Thu, 20 Jan 2022 21:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713865;
        bh=FGtYnJw9QnB8j9qSsZkuYOweU/0nFxYqjck7E4EGZfU=;
        h=Date:From:To:Subject:From;
        b=DpMkA3vOxRQ74SkDPXamhcVKbkTHHFzei+NYh0Z2XLgaUJ9x+N+2KrEmkdu2xH7g8
         6qMRkniUHDTwylIg2/yGcNSg8pBL68JEHiob2SlejWapaTjPCfPvMUMfnabaty9o2X
         hwKjs9Vn6z0LjWMax8/uhDYIjRLoYI9TgcY1+nZI=
Date:   Thu, 20 Jan 2022 13:24:24 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com,
        elver@google.com, glider@google.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com, vbabka@suse.cz
Subject:  [merged]
 kasan-add-ability-to-detect-double-kmem_cache_destroy.patch removed from
 -mm tree
Message-ID: <20220120212424.jmtAfDiRm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add ability to detect double-kmem_cache_destroy()
has been removed from the -mm tree.  Its filename was
     kasan-add-ability-to-detect-double-kmem_cache_destroy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from elver@google.com are

lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch


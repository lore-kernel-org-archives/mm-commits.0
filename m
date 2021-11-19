Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86510C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 19 Nov 2021 22:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhKSWqE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Nov 2021 17:46:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:39802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhKSWqD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Nov 2021 17:46:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1982461A8A;
        Fri, 19 Nov 2021 22:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637361781;
        bh=WuQVopur6VFeia03pKBbGfdsqJd3Xf3sX96Fs+GmiBI=;
        h=Date:From:To:Subject:From;
        b=DXJR5DJdjTExOiBum8EQBOXNJtGrFKjCarTB5TrOmfp3m6SyYki7w4ocAnTsR1IFK
         r1tAYWt+vp9m/yvJHIMxgDZi8V6FQM5MAk/WuYk3j9DqpJgOG0v2uVZ7kWFPrO3TwG
         dotPDVmKlI2XtsJ8QGZvvPl5scrW9O1/LasjRW24=
Date:   Fri, 19 Nov 2021 14:43:00 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com,
        elver@google.com, glider@google.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com, vbabka@suse.cz
Subject:  +
 kasan-add-ability-to-detect-double-kmem_cache_destroy.patch added to -mm
 tree
Message-ID: <20211119224300.vVjMzDhHS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add ability to detect double-kmem_cache_destroy()
has been added to the -mm tree.  Its filename is
     kasan-add-ability-to-detect-double-kmem_cache_destroy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-add-ability-to-detect-double-kmem_cache_destroy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-ability-to-detect-double-kmem_cache_destroy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy.patch
kasan-test-add-globals-left-out-of-bounds-test.patch
kasan-add-ability-to-detect-double-kmem_cache_destroy.patch
kasan-test-add-test-case-for-double-kmem_cache_destroy.patch
panic-use-error_report_end-tracepoint-on-warnings.patch


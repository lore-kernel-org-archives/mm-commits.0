Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66155C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 509F861D03
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhF2ChR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhF2ChR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:37:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD8B061D00;
        Tue, 29 Jun 2021 02:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934090;
        bh=a1HOkAk4Hwux9tg4QntnQcykb0GO5wnFZ3oDKcvdWwk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zANPovGlTnFS3RgkLIGkXgFm3GY2QFXki7gNOs5T8j2ccoRqC+nHrc8jU5PNJAry3
         ZpRf3JmiWWop8obrtx5r3nyDgMa3gyXj4UFDN+orgZlUdGMUObl5N+0VYOQfjcxUJN
         wSDrfbe8s56styAMh+62dmIqJdrPl1xvn76cEG6g=
Date:   Mon, 28 Jun 2021 19:34:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, pmladek@suse.com, rientjes@google.com,
        songmuchun@bytedance.com, swboyd@chromium.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 029/192] slub: indicate slab_fix() uses printf
 formats
Message-ID: <20210629023449.zw0FfVRnV%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: slub: indicate slab_fix() uses printf formats

Ideally, slab_fix() would be marked with __printf and the format here
would not use \n as that's emitted by the slab_fix().  Make these changes.

Link: https://lkml.kernel.org/r/20210601182202.3011020-4-swboyd@chromium.org
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/slub.c~slub-indicate-slab_fix-uses-printf-formats
+++ a/mm/slub.c
@@ -692,6 +692,7 @@ static void slab_bug(struct kmem_cache *
 	va_end(args);
 }
 
+__printf(2, 3)
 static void slab_fix(struct kmem_cache *s, char *fmt, ...)
 {
 	struct va_format vaf;
@@ -806,7 +807,7 @@ static void init_object(struct kmem_cach
 static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
 						void *from, void *to)
 {
-	slab_fix(s, "Restoring %s 0x%p-0x%p=0x%x\n", message, from, to - 1, data);
+	slab_fix(s, "Restoring %s 0x%p-0x%p=0x%x", message, from, to - 1, data);
 	memset(from, data, to - from);
 }
 
@@ -1059,13 +1060,13 @@ static int on_freelist(struct kmem_cache
 		slab_err(s, page, "Wrong number of objects. Found %d but should be %d",
 			 page->objects, max_objects);
 		page->objects = max_objects;
-		slab_fix(s, "Number of objects adjusted.");
+		slab_fix(s, "Number of objects adjusted");
 	}
 	if (page->inuse != page->objects - nr) {
 		slab_err(s, page, "Wrong object count. Counter is %d but counted were %d",
 			 page->inuse, page->objects - nr);
 		page->inuse = page->objects - nr;
-		slab_fix(s, "Object count adjusted.");
+		slab_fix(s, "Object count adjusted");
 	}
 	return search == NULL;
 }
_

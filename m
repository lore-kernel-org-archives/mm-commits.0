Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A728C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3F96603E9
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhJJVaN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 17:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhJJVaM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 17:30:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7CF860F22;
        Sun, 10 Oct 2021 21:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633901294;
        bh=NmRWhuPm4W7gaWWf9YqlFL3vHfYrOZ+U/bidYirKhpQ=;
        h=Date:From:To:Subject:From;
        b=l2Wx05DuLg5GDeiUTDZoswP2hVMlbcaPckWpexrpaLsea6a1F/fj0deS+eJwjlY6x
         BdwA7YqzYzH5+BFg/1Ai4TcQPP0Yr7Im8RpRS65lTGv8IXmR24F7KfWSvX3ZlJBoNG
         AxWG8OLnU3wXLgjAlCKyFhWI47TI5B+VkQHy5jK8=
Date:   Sun, 10 Oct 2021 14:28:13 -0700
From:   akpm@linux-foundation.org
To:     42.hyeyoo@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  + mm-slub-use-prefetchw-instead-of-prefetch.patch added
 to -mm tree
Message-ID: <20211010212813.H2JOw7KyI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: Use prefetchw instead of prefetch
has been added to the -mm tree.  Its filename is
     mm-slub-use-prefetchw-instead-of-prefetch.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-use-prefetchw-instead-of-prefetch.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-use-prefetchw-instead-of-prefetch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm, slub: Use prefetchw instead of prefetch

It's certain that an object will be not only read, but also written after
allocation.

Use prefetchw instead of prefetch.  On supported architectures like x86,
it helps to invalidate cache line when the object exists in other
processors' cache.

Link: https://lkml.kernel.org/r/20211008133602.4963-1-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/slub.c~mm-slub-use-prefetchw-instead-of-prefetch
+++ a/mm/slub.c
@@ -352,9 +352,9 @@ static inline void *get_freepointer(stru
 	return freelist_dereference(s, object + s->offset);
 }
 
-static void prefetch_freepointer(const struct kmem_cache *s, void *object)
+static void prefetchw_freepointer(const struct kmem_cache *s, void *object)
 {
-	prefetch(object + s->offset);
+	prefetchw(object + s->offset);
 }
 
 static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
@@ -3202,10 +3202,9 @@ redo:
 			note_cmpxchg_failure("slab_alloc", s, tid);
 			goto redo;
 		}
-		prefetch_freepointer(s, next_object);
+		prefetchw_freepointer(s, next_object);
 		stat(s, ALLOC_FASTPATH);
 	}
-
 	maybe_wipe_obj_freeptr(s, object);
 	init = slab_want_init_on_alloc(gfpflags, s);
 
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-slub-use-prefetchw-instead-of-prefetch.patch


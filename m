Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE9CC47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 21:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C454B613AD
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 21:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhFHVFO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhFHVFM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 17:05:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 183E7611BD;
        Tue,  8 Jun 2021 21:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623186199;
        bh=e80+JvmpSn8VOFdV0lLuMmHpKi12TlXmnyGDoexMqhM=;
        h=Date:From:To:Subject:From;
        b=xhJRpha92xJHUNHYSK3HjjoRKjGsv5xVFJpFZ4SETlv10dL5TljsxJOcwiMIyOTKd
         uShwhT3popoyIeoCRGOsiPxgFvhxx6CNOavOPf/1pUteMvmgrbI+2x66Wek7peqrtp
         9KLwFmAkjCB6O2btXBoYknIGl9c+1abqPGzeFstk=
Date:   Tue, 08 Jun 2021 14:03:18 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, elver@google.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, zplin@psu.edu
Subject:  +
 mm-slub-actually-fix-freelist-pointer-vs-redzoning.patch added to -mm tree
Message-ID: <20210608210318.z9PEoAOtD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: actually fix freelist pointer vs redzoning
has been added to the -mm tree.  Its filename is
     mm-slub-actually-fix-freelist-pointer-vs-redzoning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-actually-fix-freelist-pointer-vs-redzoning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-actually-fix-freelist-pointer-vs-redzoning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm/slub: actually fix freelist pointer vs redzoning

It turns out that SLUB redzoning ("slub_debug=Z") checks from
s->object_size rather than from s->inuse (which is normally bumped to make
room for the freelist pointer), so a cache created with an object size
less than 24 would have the freelist pointer written beyond
s->object_size, causing the redzone to be corrupted by the freelist
pointer.  This was very visible with "slub_debug=ZF":

BUG test (Tainted: G    B            ): Right Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620

Redzone  (____ptrval____): bb bb bb bb bb bb bb bb               ........
Object   (____ptrval____): 00 00 00 00 00 f6 f4 a5               ........
Redzone  (____ptrval____): 40 1d e8 1a aa                        @....
Padding  (____ptrval____): 00 00 00 00 00 00 00 00               ........

Adjust the offset to stay within s->object_size.

(Note that no caches of in this size range are known to exist in the
kernel currently.)

Link: https://lkml.kernel.org/r/20210608183955.280836-4-keescook@chromium.org
Link: https://lore.kernel.org/linux-mm/20200807160627.GA1420741@elver.google.com/
Link: https://lore.kernel.org/lkml/0f7dd7b2-7496-5e2d-9488-2ec9f8e90441@suse.cz/Fixes: 89b83f282d8b (slub: avoid redzone when choosing freepointer location)
Link: https://lore.kernel.org/lkml/CANpmjNOwZ5VpKQn+SYWovTkFB4VsT-RPwyENBmaK0dLcpqStkA@mail.gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Marco Elver <elver@google.com>
Reported-by: "Lin, Zhenpeng" <zplin@psu.edu>
Tested-by: Marco Elver <elver@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/mm/slub.c~mm-slub-actually-fix-freelist-pointer-vs-redzoning
+++ a/mm/slub.c
@@ -3737,7 +3737,6 @@ static int calculate_sizes(struct kmem_c
 {
 	slab_flags_t flags = s->flags;
 	unsigned int size = s->object_size;
-	unsigned int freepointer_area;
 	unsigned int order;
 
 	/*
@@ -3746,13 +3745,6 @@ static int calculate_sizes(struct kmem_c
 	 * the possible location of the free pointer.
 	 */
 	size = ALIGN(size, sizeof(void *));
-	/*
-	 * This is the area of the object where a freepointer can be
-	 * safely written. If redzoning adds more to the inuse size, we
-	 * can't use that portion for writing the freepointer, so
-	 * s->offset must be limited within this for the general case.
-	 */
-	freepointer_area = size;
 
 #ifdef CONFIG_SLUB_DEBUG
 	/*
@@ -3778,7 +3770,7 @@ static int calculate_sizes(struct kmem_c
 
 	/*
 	 * With that we have determined the number of bytes in actual use
-	 * by the object. This is the potential offset to the free pointer.
+	 * by the object and redzoning.
 	 */
 	s->inuse = size;
 
@@ -3801,13 +3793,13 @@ static int calculate_sizes(struct kmem_c
 		 */
 		s->offset = size;
 		size += sizeof(void *);
-	} else if (freepointer_area > sizeof(void *)) {
+	} else {
 		/*
 		 * Store freelist pointer near middle of object to keep
 		 * it away from the edges of the object to avoid small
 		 * sized over/underflows from neighboring allocations.
 		 */
-		s->offset = ALIGN(freepointer_area / 2, sizeof(void *));
+		s->offset = ALIGN_DOWN(s->object_size / 2, sizeof(void *));
 	}
 
 #ifdef CONFIG_SLUB_DEBUG
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-slub-clarify-verification-reporting.patch
mm-slub-fix-redzoning-for-small-allocations.patch
mm-slub-actually-fix-freelist-pointer-vs-redzoning.patch


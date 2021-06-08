Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76C2C47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 21:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 929F4613AD
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 21:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFHVFK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhFHVFJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 17:05:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D82461352;
        Tue,  8 Jun 2021 21:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623186196;
        bh=cXZ9nJ+7otA5hqnnaCKp9F08fuZeMMTiglJAOoNdFXM=;
        h=Date:From:To:Subject:From;
        b=0WKa8uMaGuQoziDzlPruNxAJmaR0qa1Xf8OAFJLgo4SXygIckQs/+ZNgPcZrif8jm
         Ee1hytPjWhF5RPaTHsNswScMYy7xUizpJV3pU3x+q9jSQjI+aTpJlYvpWwnWyi9TnW
         2fAF0SF1A8SAHV9fc/jm2C7xreK4QaJvBvPI1FyA=
Date:   Tue, 08 Jun 2021 14:03:15 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, elver@google.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, zplin@psu.edu
Subject:  + mm-slub-fix-redzoning-for-small-allocations.patch added
 to -mm tree
Message-ID: <20210608210315.vJ8UORjSo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: fix redzoning for small allocations
has been added to the -mm tree.  Its filename is
     mm-slub-fix-redzoning-for-small-allocations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-redzoning-for-small-allocations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-redzoning-for-small-allocations.patch

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
Subject: mm/slub: fix redzoning for small allocations

The redzone area for SLUB exists between s->object_size and s->inuse
(which is at least the word-aligned object_size).  If a cache were created
with an object_size smaller than sizeof(void *), the in-object stored
freelist pointer would overwrite the redzone (e.g.  with boot param
"slub_debug=ZF"):

BUG test (Tainted: G    B            ): Right Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff957ead1c05de-0xffff957ead1c05df @offset=1502. First byte 0x1a instead of 0xbb
INFO: Slab 0xffffef3950b47000 objects=170 used=170 fp=0x0000000000000000 flags=0x8000000000000200
INFO: Object 0xffff957ead1c05d8 @offset=1496 fp=0xffff957ead1c0620

Redzone  (____ptrval____): bb bb bb bb bb bb bb bb    ........
Object   (____ptrval____): f6 f4 a5 40 1d e8          ...@..
Redzone  (____ptrval____): 1a aa                      ..
Padding  (____ptrval____): 00 00 00 00 00 00 00 00    ........

Store the freelist pointer out of line when object_size is smaller than
sizeof(void *) and redzoning is enabled.

Additionally remove the "smaller than sizeof(void *)" check under
CONFIG_DEBUG_VM in kmem_cache_sanity_check() as it is now redundant:
SLAB and SLOB both handle small sizes.

(Note that no caches within this size range are known to exist in the
kernel currently.)

Link: https://lkml.kernel.org/r/20210608183955.280836-3-keescook@chromium.org
Fixes: 81819f0fc828 ("SLUB core")
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Lin, Zhenpeng" <zplin@psu.edu>
Cc: Marco Elver <elver@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    3 +--
 mm/slub.c        |    8 +++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/mm/slab_common.c~mm-slub-fix-redzoning-for-small-allocations
+++ a/mm/slab_common.c
@@ -97,8 +97,7 @@ EXPORT_SYMBOL(kmem_cache_size);
 #ifdef CONFIG_DEBUG_VM
 static int kmem_cache_sanity_check(const char *name, unsigned int size)
 {
-	if (!name || in_interrupt() || size < sizeof(void *) ||
-		size > KMALLOC_MAX_SIZE) {
+	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
 		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
 		return -EINVAL;
 	}
--- a/mm/slub.c~mm-slub-fix-redzoning-for-small-allocations
+++ a/mm/slub.c
@@ -3782,15 +3782,17 @@ static int calculate_sizes(struct kmem_c
 	 */
 	s->inuse = size;
 
-	if (((flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)) ||
-		s->ctor)) {
+	if ((flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)) ||
+	    ((flags & SLAB_RED_ZONE) && s->object_size < sizeof(void *)) ||
+	    s->ctor) {
 		/*
 		 * Relocate free pointer after the object if it is not
 		 * permitted to overwrite the first word of the object on
 		 * kmem_cache_free.
 		 *
 		 * This is the case if we do RCU, have a constructor or
-		 * destructor or are poisoning the objects.
+		 * destructor, are poisoning the objects, or are
+		 * redzoning an object smaller than sizeof(void *).
 		 *
 		 * The assumption that s->offset >= s->inuse means free
 		 * pointer is outside of the object is used in the
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-slub-clarify-verification-reporting.patch
mm-slub-fix-redzoning-for-small-allocations.patch
mm-slub-actually-fix-freelist-pointer-vs-redzoning.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A56FC47094
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 23:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F38A461059
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 23:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhFGXq0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 19:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230333AbhFGXqY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 19:46:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5B5A6108C;
        Mon,  7 Jun 2021 23:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623109457;
        bh=rf8JxEcuuX2VLmFiemZXc4cLNoi/gaXemRqqJlE5z3w=;
        h=Date:From:To:Subject:From;
        b=J/yb6Led9Pw2DVN9721hJgu6Hcu+hBoOqZ9lbrynoEPtBSQPKG2GpFGdRXPyf+Fle
         MVvuwhWKJAZdv51jBN8h333reJQvz4ARZu1OBCIP66BS3eaR2RHW6CgiLa9HSWd+wh
         WjNcA9AT2f8Bh7B3NStOGbyqm3NqaSKR/cysdKkQ=
Date:   Mon, 07 Jun 2021 16:44:16 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, zplin@psu.edu
Subject:  +
 =?US-ASCII?Q?slub-choose-the-right-freelist-pointer-location-when-creatin?=
 =?US-ASCII?Q?g-small-caches.patch?= added to -mm tree
Message-ID: <20210607234416.z3j8WklxH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: choose the right freelist pointer location when  creating small caches
has been added to the -mm tree.  Its filename is
     slub-choose-the-right-freelist-pointer-location-when-creating-small-caches.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/slub-choose-the-right-freelist-pointer-location-when-creating-small-caches.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/slub-choose-the-right-freelist-pointer-location-when-creating-small-caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Lin, Zhenpeng" <zplin@psu.edu>
Subject: slub: choose the right freelist pointer location when  creating small caches

When enabling CONFIG_SLUB_DEBUG and booting with "slub_debug=Z", the
kernel crashes at creating caches if the object size is smaller than
2*sizeof(void*).  The problem is due to the wrong calculation of
freepointer_area.  The freelist pointer can be stored in the middle of
object only if the object size is not smaller than 2*sizeof(void*). 
Otherwise, the freelist pointer will be corrupted by SLUB_RED_ZONE.

Link: https://lkml.kernel.org/r/6746FEEA-FD69-4792-8DDA-C78F5FE7DA02@psu.edu
Fixes: 3202fa62fb43 ("slub: relocate freelist pointer to middle of object")
Fixes: 89b83f282d8b ("slub: avoid redzone when choosing freepointer location")
Signed-off-by: Zhenpeng Lin <zplin@psu.edu>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slub.c~slub-choose-the-right-freelist-pointer-location-when-creating-small-caches
+++ a/mm/slub.c
@@ -3752,7 +3752,7 @@ static int calculate_sizes(struct kmem_c
 	 * can't use that portion for writing the freepointer, so
 	 * s->offset must be limited within this for the general case.
 	 */
-	freepointer_area = size;
+	freepointer_area = s->object_size;
 
 #ifdef CONFIG_SLUB_DEBUG
 	/*
@@ -3799,7 +3799,7 @@ static int calculate_sizes(struct kmem_c
 		 */
 		s->offset = size;
 		size += sizeof(void *);
-	} else if (freepointer_area > sizeof(void *)) {
+	} else if (freepointer_area > 2 * sizeof(void *)) {
 		/*
 		 * Store freelist pointer near middle of object to keep
 		 * it away from the edges of the object to avoid small
_

Patches currently in -mm which might be from zplin@psu.edu are

slub-choose-the-right-freelist-pointer-location-when-creating-small-caches.patch


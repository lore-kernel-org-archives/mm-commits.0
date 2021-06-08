Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702E3C47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 20:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CE0D6139A
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 20:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhFHVB2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:01:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233988AbhFHVB2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 17:01:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F323C61285;
        Tue,  8 Jun 2021 20:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623185975;
        bh=PvUBshAj3PIxh4nmc/qOh+rUBU6i6NijQsW4JdRHwgM=;
        h=Date:From:To:Subject:From;
        b=eWx8vQYPG8tnXbtzpov2Pl5r2l95nev6xcxA2f8oTjuQCCBS/QSxdyQUReeXmG6rh
         TBcKXEeX+ePO8W9T7pwSGg5Vw069vcLEtjw6j8Z7rzkaSnq4dpk2tdheoYKv2z5CHA
         3A7/XmeEixXIIruLrsrt/zsYE6J0YvP9BFVn7c+E=
Date:   Tue, 08 Jun 2021 13:59:34 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, zplin@psu.edu
Subject:  [alternative-merged]
 =?US-ASCII?Q?slub-choose-the-right-freelist-pointer-location-when-creatin?=
 =?US-ASCII?Q?g-small-caches.patch?= removed from -mm tree
Message-ID: <20210608205934.WFkT9_pkE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: choose the right freelist pointer location when  creating small caches
has been removed from the -mm tree.  Its filename was
     slub-choose-the-right-freelist-pointer-location-when-creating-small-caches.patch

This patch was dropped because an alternative patch was merged

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



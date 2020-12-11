Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE788C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 05:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A51823EB3
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 05:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgLKFS0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 00:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgLKFR6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 00:17:58 -0500
Date:   Thu, 10 Dec 2020 21:17:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607663837;
        bh=lg8pN91foWCHPblJG+FazjMAxcfSyvCGkWavKIf1LEc=;
        h=From:To:Subject:From;
        b=crMyxfaQlbBdzwhsxoiRJR9I/y6QBDu4i1NBZ1ndQM85EWnRrVBff2i4z+vuzZxgG
         XFIQLFCmbtm2Hxgmzmev3lC4UqfhE6MQPgJJAKL/PRUl7SWf02W6qcPNzQWOUShcK8
         2Z8ooOat8eOBAJ9TTy+LmQlcpdRN2slNs3KsG77w=
From:   akpm@linux-foundation.org
To:     alex.popov@linux.com, cl@linux.com, glider@google.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com
Subject:  + mm-slab-perform-init_on_free-earlier.patch added to -mm
 tree
Message-ID: <20201211051717.Dl75jGFI_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: rerform init_on_free earlier
has been added to the -mm tree.  Its filename is
     mm-slab-perform-init_on_free-earlier.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slab-perform-init_on_free-earlier.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-perform-init_on_free-earlier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Popov <alex.popov@linux.com>
Subject: mm/slab: rerform init_on_free earlier

Currently in CONFIG_SLAB init_on_free happens too late, and heap objects
go to the heap quarantine not being erased.

Lets move init_on_free clearing before calling kasan_slab_free().  In that
case heap quarantine will store erased objects, similarly to CONFIG_SLUB=y
behavior.

Link: https://lkml.kernel.org/r/20201210183729.1261524-1-alex.popov@linux.com
Signed-off-by: Alexander Popov <alex.popov@linux.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/slab.c~mm-slab-perform-init_on_free-earlier
+++ a/mm/slab.c
@@ -3416,6 +3416,9 @@ free_done:
 static __always_inline void __cache_free(struct kmem_cache *cachep, void *objp,
 					 unsigned long caller)
 {
+	if (unlikely(slab_want_init_on_free(cachep)))
+		memset(objp, 0, cachep->object_size);
+
 	/* Put the object into the quarantine, don't touch it for now. */
 	if (kasan_slab_free(cachep, objp, _RET_IP_))
 		return;
@@ -3434,8 +3437,6 @@ void ___cache_free(struct kmem_cache *ca
 	struct array_cache *ac = cpu_cache_get(cachep);
 
 	check_irq_off();
-	if (unlikely(slab_want_init_on_free(cachep)))
-		memset(objp, 0, cachep->object_size);
 	kmemleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, caller);
 	memcg_slab_free_hook(cachep, &objp, 1);
_

Patches currently in -mm which might be from alex.popov@linux.com are

mm-slab-perform-init_on_free-earlier.patch


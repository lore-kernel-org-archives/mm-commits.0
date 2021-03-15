Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6853CC43619
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5038364EED
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbhCORtK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236547AbhCORsm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 890E564F4A;
        Mon, 15 Mar 2021 17:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830503;
        bh=LEOUsDOvgDPuEFUbgfTHl0I29peU695MhdjCwfSv1ow=;
        h=Date:From:To:Subject:From;
        b=MfLxs06yjm+mRPMB4xmNtgyzpDVXxoJxRPUW/frc9bpzDzBpmH5YMWiWhe2knbTu+
         TiXagFGLpKmXPN69RbpWIA4JDMvH5oG6JQD/Gh/sVmA04nBKlSMwhhVXelFBbtAum+
         QysXUEeAZe9SkYfiqby7euwcpOzL3Qs6IC59+qVw=
Date:   Mon, 15 Mar 2021 10:48:23 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org
Subject:  [merged]
 kfence-slab-fix-cache_alloc_debugcheck_after-for-bulk-allocations.patch
 removed from -mm tree
Message-ID: <20210315174823.8y5KUf5x9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence, slab: fix cache_alloc_debugcheck_after() for bulk allocations
has been removed from the -mm tree.  Its filename was
     kfence-slab-fix-cache_alloc_debugcheck_after-for-bulk-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence, slab: fix cache_alloc_debugcheck_after() for bulk allocations

cache_alloc_debugcheck_after() performs checks on an object, including
adjusting the returned pointer.  None of this should apply to KFENCE
objects.  While for non-bulk allocations, the checks are skipped when we
allocate via KFENCE, for bulk allocations cache_alloc_debugcheck_after()
is called via cache_alloc_debugcheck_after_bulk().

Fix it by skipping cache_alloc_debugcheck_after() for KFENCE objects.

Link: https://lkml.kernel.org/r/20210304205256.2162309-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.c~kfence-slab-fix-cache_alloc_debugcheck_after-for-bulk-allocations
+++ a/mm/slab.c
@@ -2992,7 +2992,7 @@ static void *cache_alloc_debugcheck_afte
 				gfp_t flags, void *objp, unsigned long caller)
 {
 	WARN_ON_ONCE(cachep->ctor && (flags & __GFP_ZERO));
-	if (!objp)
+	if (!objp || is_kfence_address(objp))
 		return objp;
 	if (cachep->flags & SLAB_POISON) {
 		check_poison_obj(cachep, objp);
_

Patches currently in -mm which might be from elver@google.com are



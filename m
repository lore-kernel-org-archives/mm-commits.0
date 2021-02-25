Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C65C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C8CD64F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhBYTUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234364AbhBYTRg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:17:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8F1C64F3C;
        Thu, 25 Feb 2021 19:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280317;
        bh=/KZviyHammtVlrHxKAifGdkuDMB3lVCNJBYefDxVUhs=;
        h=Date:From:To:Subject:From;
        b=0Qomcn2GQWJTBmVE9h8qq0qSHjjq1HgFjeLKC9xbZFeK+pHhdTUVvuyyILg7+pcgc
         yePiNBVQGFbz+GpByHipnPR+V0Y3UX6K+pqiNzuDt8ikEdC1Wh0xMgbOq0cuNB1f6X
         tAvw+LKco37ZBYyiwvBI//Cgy+o/ePkAE26dvM8k=
Date:   Thu, 25 Feb 2021 11:11:56 -0800
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, cl@linux.com, iamjoonsoo.kim@lge.com,
        johannes.berg@intel.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-slub-disable-user-tracing-for-kmemleak-caches-by-default.patch removed
 from -mm tree
Message-ID: <20210225191156.Qk1HoBOaS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: disable user tracing for kmemleak caches by default
has been removed from the -mm tree.  Its filename was
     mm-slub-disable-user-tracing-for-kmemleak-caches-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Berg <johannes.berg@intel.com>
Subject: mm/slub: disable user tracing for kmemleak caches by default

If kmemleak is enabled, it uses a kmem cache for its own objects.  These
objects are used to hold information kmemleak uses, including a stack
trace.  If slub_debug is also turned on, each of them has *another* stack
trace, so the overhead adds up, and on my tests (on ARCH=um, admittedly)
2/3rds of the allocations end up being doing the stack tracing.

Turn off SLAB_STORE_USER if SLAB_NOLEAKTRACE was given, to avoid storing
the essentially same data twice.

Link: https://lkml.kernel.org/r/20210113215114.d94efa13ba30.I117b6764e725b3192318bbcf4269b13b709539ae@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-disable-user-tracing-for-kmemleak-caches-by-default
+++ a/mm/slub.c
@@ -1413,6 +1413,15 @@ slab_flags_t kmem_cache_flags(unsigned i
 	size_t len;
 	char *next_block;
 	slab_flags_t block_flags;
+	slab_flags_t slub_debug_local = slub_debug;
+
+	/*
+	 * If the slab cache is for debugging (e.g. kmemleak) then
+	 * don't store user (stack trace) information by default,
+	 * but let the user enable it via the command line below.
+	 */
+	if (flags & SLAB_NOLEAKTRACE)
+		slub_debug_local &= ~SLAB_STORE_USER;
 
 	len = strlen(name);
 	next_block = slub_debug_string;
@@ -1447,7 +1456,7 @@ slab_flags_t kmem_cache_flags(unsigned i
 		}
 	}
 
-	return flags | slub_debug;
+	return flags | slub_debug_local;
 }
 #else /* !CONFIG_SLUB_DEBUG */
 static inline void setup_object_debug(struct kmem_cache *s,
_

Patches currently in -mm which might be from johannes.berg@intel.com are



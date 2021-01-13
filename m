Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01197C4321A
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 01:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4478206C0
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 01:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbhANBxj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729693AbhANAAH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Jan 2021 19:00:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB18923339;
        Wed, 13 Jan 2021 23:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610579049;
        bh=pe9551ur52WLYM83Xkl1oF/Oif1QbS4pSr12kDrImD8=;
        h=Date:From:To:Subject:From;
        b=oVNdzGLD9hFzvP5RiPQFeMOEeP3X4IkfbmJCojUAZA+uhZuTitOhA+S/QVJWc84yO
         q+k1jCd8MN/V82VaDp2mju458ujxZ2obGAB/ROMtUPeBRz6dsuVxtDramN19YEkGSW
         cT5PxUfEgQ+LWIqWo4V76NWcLJSscFNiDskXXUXA=
Date:   Wed, 13 Jan 2021 15:04:08 -0800
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, cl@linux.com, iamjoonsoo.kim@lge.com,
        johannes.berg@intel.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  +
 mm-slub-disable-user-tracing-for-kmemleak-caches-by-default.patch added to
 -mm tree
Message-ID: <20210113230408.zSWgXZL-V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: disable user tracing for kmemleak caches by default
has been added to the -mm tree.  Its filename is
     mm-slub-disable-user-tracing-for-kmemleak-caches-by-default.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-disable-user-tracing-for-kmemleak-caches-by-default.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-disable-user-tracing-for-kmemleak-caches-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-disable-user-tracing-for-kmemleak-caches-by-default
+++ a/mm/slub.c
@@ -1415,6 +1415,15 @@ slab_flags_t kmem_cache_flags(unsigned i
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
@@ -1449,7 +1458,7 @@ slab_flags_t kmem_cache_flags(unsigned i
 		}
 	}
 
-	return flags | slub_debug;
+	return flags | slub_debug_local;
 }
 #else /* !CONFIG_SLUB_DEBUG */
 static inline void setup_object_debug(struct kmem_cache *s,
_

Patches currently in -mm which might be from johannes.berg@intel.com are

mm-slub-disable-user-tracing-for-kmemleak-caches-by-default.patch


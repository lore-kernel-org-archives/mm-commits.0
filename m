Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0818AC3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 02:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjAFCGX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 21:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjAFCGW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 21:06:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A4AB7D6
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 18:06:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ABF8B81C1B
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 02:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A380EC433EF;
        Fri,  6 Jan 2023 02:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672970778;
        bh=Mfvzl7pnzioiqkLuYOwrqft1Mh0ppEwkk/DKOVb/DCo=;
        h=Date:To:From:Subject:From;
        b=kfMy17kBusQU8o9wZCQJHCBeZSgqvVNiNBK2j68IO/iHsejVHtQK3qJZL9dQCWBpb
         B7Rc8Gsn0cq9tPXiEsThMj1irPL09V13VK7++WhdXyIjhAoHv+bMJTDtp/BD5K7bqN
         zYgyT04+VBGg9x6CPpq7+Q79gati1SvrsN7ANWcc=
Date:   Thu, 05 Jan 2023 18:06:17 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        vbabka@suse.cz, ryabinin.a.a@gmail.com, roman.gushchin@linux.dev,
        rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        glider@google.com, dvyukov@google.com, cl@linux.com,
        andreyknvl@gmail.com, 42.hyeyoo@gmail.com, feng.tang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slab-add-is_kmalloc_cache-helper-function.patch added to mm-unstable branch
Message-Id: <20230106020618.A380EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: add is_kmalloc_cache() helper function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slab-add-is_kmalloc_cache-helper-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slab-add-is_kmalloc_cache-helper-function.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/slab: add is_kmalloc_cache() helper function
Date: Wed, 4 Jan 2023 14:06:04 +0800

commit 6edf2576a6cc ("mm/slub: enable debugging memory wasting of
kmalloc") introduces 'SLAB_KMALLOC' bit specifying whether a kmem_cache is
a kmalloc cache for slab/slub (slob doesn't have dedicated kmalloc
caches).

Add a helper inline function for other components like kasan to simplify
code.

Link: https://lkml.kernel.org/r/20230104060605.930910-1-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/slab.h~mm-slab-add-is_kmalloc_cache-helper-function
+++ a/mm/slab.h
@@ -323,6 +323,14 @@ static inline slab_flags_t kmem_cache_fl
 }
 #endif
 
+static inline bool is_kmalloc_cache(struct kmem_cache *s)
+{
+#ifndef CONFIG_SLOB
+	return (s->flags & SLAB_KMALLOC);
+#else
+	return false;
+#endif
+}
 
 /* Legal flag mask for kmem_cache_create(), for various configurations */
 #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-slab-add-is_kmalloc_cache-helper-function.patch
mm-kasan-simplify-and-refine-kasan_cache-code.patch


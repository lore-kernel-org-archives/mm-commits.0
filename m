Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28366C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjASBU3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjASBS6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F60B6C57C
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F08C6176F
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89C0C433D2;
        Thu, 19 Jan 2023 01:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090973;
        bh=ZE0KKfxY6G2GiNZduXZiz99J5Q5C6OgSsJIZ0OfR2gs=;
        h=Date:To:From:Subject:From;
        b=kPsjNz24e5T9ASzuZ5CuKX1amRJgpuOVn4oyigsNVluuJ9DP+8PSdrth8kr8vunhS
         Hy4RlwIOdq7bFvFHGZd9641TYOEYwh6z9yLQTzy/JFKRLi3kOLag1CxX4c+VjRGSDP
         chzWht/qc7+LAUbY03VEJeAWsCqM3yEHyWq/1uq4=
Date:   Wed, 18 Jan 2023 17:16:13 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        vbabka@suse.cz, ryabinin.a.a@gmail.com, roman.gushchin@linux.dev,
        rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        glider@google.com, dvyukov@google.com, cl@linux.com,
        andreyknvl@gmail.com, 42.hyeyoo@gmail.com, feng.tang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-slab-add-is_kmalloc_cache-helper-function.patch removed from -mm tree
Message-Id: <20230119011613.A89C0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/slab: add is_kmalloc_cache() helper function
has been removed from the -mm tree.  Its filename was
     mm-slab-add-is_kmalloc_cache-helper-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D174EC4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6F4661157
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbhHEXiW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237396AbhHEXiW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:38:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCF6060E53;
        Thu,  5 Aug 2021 23:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628206687;
        bh=umF3i5H5N3lEhj1YZTY3F00OIZVCBxuaZ91sZJgWmxU=;
        h=Date:From:To:Subject:From;
        b=lEfMBcmntQzxTlc87hI+01FAF9toZAErFKYuFrmQ/NyY7JBUkbAfJmhtP8l44VR3J
         B6bvs4zkBdBS/yCYsHa3cYtuJo4H53OSxpks9N6Wc6jOn7/4YZqNcmhJtjw1XpTci3
         a7COW+abf2OnejPyZ1ye/vtM7hPhW3kez/EBGSZE=
Date:   Thu, 05 Aug 2021 16:38:06 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tglx@linutronix.de,
        rientjes@google.com, penberg@kernel.org,
        mgorman@techsingularity.net, jannh@google.com,
        iamjoonsoo.kim@lge.com, efault@gmx.de, cl@linux.com,
        brouer@redhat.com, bigeasy@linutronix.de
Subject:  + mm-slub-make-object_map_lock-a-raw_spinlock_t.patch added
 to -mm tree
Message-ID: <20210805233806.O_7ss%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: make object_map_lock a raw_spinlock_t
has been added to the -mm tree.  Its filename is
     mm-slub-make-object_map_lock-a-raw_spinlock_t.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-make-object_map_lock-a-raw_spinlock_t.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-make-object_map_lock-a-raw_spinlock_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: slub: make object_map_lock a raw_spinlock_t

The variable object_map is protected by object_map_lock.  The lock is
always acquired in debug code and within already atomic context

Make object_map_lock a raw_spinlock_t.

Link: https://lkml.kernel.org/r/20210805152000.12817-31-vbabka@suse.cz
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-make-object_map_lock-a-raw_spinlock_t
+++ a/mm/slub.c
@@ -438,7 +438,7 @@ static inline bool cmpxchg_double_slab(s
 
 #ifdef CONFIG_SLUB_DEBUG
 static unsigned long object_map[BITS_TO_LONGS(MAX_OBJS_PER_PAGE)];
-static DEFINE_SPINLOCK(object_map_lock);
+static DEFINE_RAW_SPINLOCK(object_map_lock);
 
 static void __fill_map(unsigned long *obj_map, struct kmem_cache *s,
 		       struct page *page)
@@ -483,7 +483,7 @@ static unsigned long *get_map(struct kme
 {
 	VM_BUG_ON(!irqs_disabled());
 
-	spin_lock(&object_map_lock);
+	raw_spin_lock(&object_map_lock);
 
 	__fill_map(object_map, s, page);
 
@@ -493,7 +493,7 @@ static unsigned long *get_map(struct kme
 static void put_map(unsigned long *map) __releases(&object_map_lock)
 {
 	VM_BUG_ON(map != object_map);
-	spin_unlock(&object_map_lock);
+	raw_spin_unlock(&object_map_lock);
 }
 
 static inline unsigned int size_from_object(struct kmem_cache *s)
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context.patch
mm-slub-make-object_map_lock-a-raw_spinlock_t.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8590FC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CBA561100
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347381AbhIHCzm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347291AbhIHCzh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:55:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40902610C9;
        Wed,  8 Sep 2021 02:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069670;
        bh=TX/UXbP42Ra6IVH3C02K32UtejuoP1SZ3wnhLKiJ+gE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uJmoJIx90JlcJx9Li7QkedDzy2K5fATbnV34ya6GtBP8r0zBnGfw1iNnQmFr7+TYf
         zf9BWXXVOmWgRJV63ifo9fCH1Qde86XRhJGDw0JdDxTeXaLrBVQvw1VKIfwENaRIz2
         ki/CCBmTdwRzWojjCniu/mOY13Z1+xfTPH/eeu1k=
Date:   Tue, 07 Sep 2021 19:54:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 029/147] mm: slub: make object_map_lock a
 raw_spinlock_t
Message-ID: <20210908025429.aLnAwCvCs%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: slub: make object_map_lock a raw_spinlock_t

The variable object_map is protected by object_map_lock.  The lock is
always acquired in debug code and within already atomic context

Make object_map_lock a raw_spinlock_t.

Link: https://lkml.kernel.org/r/20210904105003.11688-30-vbabka@suse.cz
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
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-make-object_map_lock-a-raw_spinlock_t
+++ a/mm/slub.c
@@ -452,7 +452,7 @@ static inline bool cmpxchg_double_slab(s
 
 #ifdef CONFIG_SLUB_DEBUG
 static unsigned long object_map[BITS_TO_LONGS(MAX_OBJS_PER_PAGE)];
-static DEFINE_SPINLOCK(object_map_lock);
+static DEFINE_RAW_SPINLOCK(object_map_lock);
 
 static void __fill_map(unsigned long *obj_map, struct kmem_cache *s,
 		       struct page *page)
@@ -497,7 +497,7 @@ static unsigned long *get_map(struct kme
 {
 	VM_BUG_ON(!irqs_disabled());
 
-	spin_lock(&object_map_lock);
+	raw_spin_lock(&object_map_lock);
 
 	__fill_map(object_map, s, page);
 
@@ -507,7 +507,7 @@ static unsigned long *get_map(struct kme
 static void put_map(unsigned long *map) __releases(&object_map_lock)
 {
 	VM_BUG_ON(map != object_map);
-	spin_unlock(&object_map_lock);
+	raw_spin_unlock(&object_map_lock);
 }
 
 static inline unsigned int size_from_object(struct kmem_cache *s)
_

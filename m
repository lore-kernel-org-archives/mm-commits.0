Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17668C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 016A460724
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347611AbhIBVwt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347607AbhIBVws (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83FD9610E8;
        Thu,  2 Sep 2021 21:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619510;
        bh=G6rcLkiCGZ07cccdWqxDvdgtlWa7mwCRasGDKXwbgaI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lA5xJCz0hMKQHYmVe9owg0YVrVCz1LyuZ8TOfInoOS3Mq67vPOi2L6QnsnI0uinl7
         aWJfPXcqSns1Fu86V3MJ/abvy0vKgXpQfiE8mEa978znL/EWov+KtlzDUAftB3RGVl
         p3/LAElKh6aAG1vImarKEFNY+LRjFGRRq6gDqbXg=
Date:   Thu, 02 Sep 2021 14:51:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 035/212] mm, slub: don't disable irqs in
 slub_cpu_dead()
Message-ID: <20210902215149.jeb78gDFC%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: don't disable irqs in slub_cpu_dead()

slub_cpu_dead() cleans up for an offlined cpu from another cpu and calls
only functions that are now irq safe, so we don't need to disable irqs
anymore.

Link: https://lkml.kernel.org/r/20210805152000.12817-28-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/slub.c~mm-slub-dont-disable-irqs-in-slub_cpu_dead
+++ a/mm/slub.c
@@ -2540,14 +2540,10 @@ static void flush_all(struct kmem_cache
 static int slub_cpu_dead(unsigned int cpu)
 {
 	struct kmem_cache *s;
-	unsigned long flags;
 
 	mutex_lock(&slab_mutex);
-	list_for_each_entry(s, &slab_caches, list) {
-		local_irq_save(flags);
+	list_for_each_entry(s, &slab_caches, list)
 		__flush_cpu_slab(s, cpu);
-		local_irq_restore(flags);
-	}
 	mutex_unlock(&slab_mutex);
 	return 0;
 }
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D497C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20DEE610E8
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347552AbhIBVvd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232404AbhIBVvd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:51:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FDF8610A0;
        Thu,  2 Sep 2021 21:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619434;
        bh=K0rvabHm2VBJHlhwxiMZfeiTO4ikD1Q6hlKHVHFZSMI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XX7s3wTMoslIVyFhBh3YMAuGFpxofInFEKNNVpKjuHPFiRXsonCSOwCq6USTMUeyD
         QgfEGEK3y2pnXrZp0wcWwu0SxrOhQlxSvAP+OhZdorqoopeQlt3SOSjenmBd8onfmE
         Me1uZdmWbY0d+xWC0UiRqD5HAqllzi02SMwdflsA=
Date:   Thu, 02 Sep 2021 14:50:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 012/212] mm, slub: don't disable irq for
 debug_check_no_locks_freed()
Message-ID: <20210902215033.Luw0LjfCD%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: don't disable irq for debug_check_no_locks_freed()

In slab_free_hook() we disable irqs around the
debug_check_no_locks_freed() call, which is unnecessary, as irqs are
already being disabled inside the call.  This seems to be leftover from
the past where there were more calls inside the irq disabled sections. 
Remove the irq disable/enable operations.

Mel noted:
> Looks like it was needed for kmemcheck which went away back in 4.15

Link: https://lkml.kernel.org/r/20210805152000.12817-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/mm/slub.c~mm-slub-dont-disable-irq-for-debug_check_no_locks_freed
+++ a/mm/slub.c
@@ -1591,20 +1591,8 @@ static __always_inline bool slab_free_ho
 {
 	kmemleak_free_recursive(x, s->flags);
 
-	/*
-	 * Trouble is that we may no longer disable interrupts in the fast path
-	 * So in order to make the debug calls that expect irqs to be
-	 * disabled we need to disable interrupts temporarily.
-	 */
-#ifdef CONFIG_LOCKDEP
-	{
-		unsigned long flags;
+	debug_check_no_locks_freed(x, s->object_size);
 
-		local_irq_save(flags);
-		debug_check_no_locks_freed(x, s->object_size);
-		local_irq_restore(flags);
-	}
-#endif
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(x, s->object_size);
 
_

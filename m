Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A750C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45FE4611AD
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345859AbhIIVCP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345763AbhIIVCO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:02:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A89D56103E;
        Thu,  9 Sep 2021 21:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221265;
        bh=4huUtopJFCumQgsUj4xxDAeQ0Dqy8EwLgJ8EtQchESw=;
        h=Date:From:To:Subject:From;
        b=17nUGEUC4e//cqmRJ+gN7VKG7wMiWJxCPnGo/CBFw9EUxuKMUhEDHWVbAZ/+zmsS7
         h+K4EwFRMq+78FrSuPVlWhCpkT/2RJFYjynVvggS5HyCeR+k5RDjzF+PmqVxcmNzGs
         i5+0wOCSJXOWeGHiSGKsn+q4qEbH0CatuSuozk6Y=
Date:   Thu, 09 Sep 2021 14:01:04 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged] mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch
 removed from -mm tree
Message-ID: <20210909210104.5sS9naWbN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: don't disable irqs in slub_cpu_dead()
has been removed from the -mm tree.  Its filename was
     mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: don't disable irqs in slub_cpu_dead()

slub_cpu_dead() cleans up for an offlined cpu from another cpu and calls
only functions that are now irq safe, so we don't need to disable irqs
anymore.

Link: https://lkml.kernel.org/r/20210904105003.11688-27-vbabka@suse.cz
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
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/slub.c~mm-slub-dont-disable-irqs-in-slub_cpu_dead
+++ a/mm/slub.c
@@ -2554,14 +2554,10 @@ static void flush_all(struct kmem_cache
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

Patches currently in -mm which might be from vbabka@suse.cz are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30896C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C45661026
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345707AbhIIVCD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345513AbhIIVCC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:02:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0F1261179;
        Thu,  9 Sep 2021 21:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221253;
        bh=j7vxRNMe72KYXKvfDPZTccsupcU/F5cjGPM19xjkTCw=;
        h=Date:From:To:Subject:From;
        b=aQBMJhUhJLHWoWRXD0sGjcFQN0AHzS4qb+Zgsz6nxG77gpAOXuUv+1cziOovlSNKq
         E2w/6o6sS/MCNT40y32iHTWY6BIuUsV6XncTLyZHliNpEkKhcnvRy7j5dBz3Fvq4rb
         Ihbl+nXchhXjU2A9Q90dTikS5ivRYfNUpPGSibTk=
Date:   Thu, 09 Sep 2021 14:00:52 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-slub-call-deactivate_slab-without-disabling-irqs.patch removed from -mm
 tree
Message-ID: <20210909210052.nbajHrVqY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: call deactivate_slab() without disabling irqs
has been removed from the -mm tree.  Its filename was
     mm-slub-call-deactivate_slab-without-disabling-irqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: call deactivate_slab() without disabling irqs

The function is now safe to be called with irqs enabled, so move the calls
outside of irq disabled sections.

When called from ___slab_alloc() -> flush_slab() we have irqs disabled, so
to reenable them before deactivate_slab() we need to open-code
flush_slab() in ___slab_alloc() and reenable irqs after modifying the
kmem_cache_cpu fields.  But that means a IRQ handler meanwhile might have
assigned a new page to kmem_cache_cpu.page so we have to retry the whole
check.

The remaining callers of flush_slab() are the IPI handler which has
disabled irqs anyway, and slub_cpu_dead() which will be dealt with in the
following patch.

Link: https://lkml.kernel.org/r/20210904105003.11688-21-vbabka@suse.cz
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

 mm/slub.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/mm/slub.c~mm-slub-call-deactivate_slab-without-disabling-irqs
+++ a/mm/slub.c
@@ -2779,8 +2779,8 @@ deactivate_slab:
 	freelist = c->freelist;
 	c->page = NULL;
 	c->freelist = NULL;
-	deactivate_slab(s, page, freelist);
 	local_irq_restore(flags);
+	deactivate_slab(s, page, freelist);
 
 new_slab:
 
@@ -2848,18 +2848,32 @@ check_new_page:
 		 */
 		goto return_single;
 
+retry_load_page:
+
 	local_irq_save(flags);
-	if (unlikely(c->page))
-		flush_slab(s, c);
+	if (unlikely(c->page)) {
+		void *flush_freelist = c->freelist;
+		struct page *flush_page = c->page;
+
+		c->page = NULL;
+		c->freelist = NULL;
+		c->tid = next_tid(c->tid);
+
+		local_irq_restore(flags);
+
+		deactivate_slab(s, flush_page, flush_freelist);
+
+		stat(s, CPUSLAB_FLUSH);
+
+		goto retry_load_page;
+	}
 	c->page = page;
 
 	goto load_freelist;
 
 return_single:
 
-	local_irq_save(flags);
 	deactivate_slab(s, page, get_freepointer(s, freelist));
-	local_irq_restore(flags);
 	return freelist;
 }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are



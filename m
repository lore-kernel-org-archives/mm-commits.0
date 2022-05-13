Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE997C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383875AbiEMTZN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383764AbiEMTXZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8DD2C66F
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17127B83198
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC87C34100;
        Fri, 13 May 2022 19:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469740;
        bh=dYSHE1WC2nvefQS/nYMTvisR895q4ZLBvR70PPcScNk=;
        h=Date:To:From:Subject:From;
        b=rbDo5D7ihRci7QziUFxjbSaQW9WlLPK3cnDCFNRHEdIYQIJR/h3jV+/cm/Kf1svT1
         TBKMZ8T1/zh20CGKGoBzO0oHkrl6OIFp9Z+dBqDHv1yQOvDU6fbuDL8wyjAiDNBTjt
         izb0Kl57DvLa2nwfowMUwlmPY1IiBMMxAO0ej92E=
Date:   Fri, 13 May 2022 12:22:20 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, tglx@linutronix.de,
        bigeasy@linutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-use-raw_cpu_ptr-for-vmap_block_queue-access.patch removed from -mm tree
Message-Id: <20220513192220.BEC87C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: use raw_cpu_ptr() for vmap_block_queue access
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-raw_cpu_ptr-for-vmap_block_queue-access.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/vmalloc: use raw_cpu_ptr() for vmap_block_queue access

The per-CPU resource vmap_block_queue is accessed via get_cpu_var().  That
macro disables preemption and then loads the pointer from the current CPU.

This doesn't work on PREEMPT_RT because a spinlock_t is later accessed
within the preempt-disable section.

There is no need to disable preemption while accessing the per-CPU struct
vmap_block_queue because the list is protected with a spinlock_t.  The
per-CPU struct is also accessed cross-CPU in purge_fragmented_blocks().

It is possible that by using raw_cpu_ptr() the code migrates to another
CPU and uses struct from another CPU.  This is fine because the list is
locked and the locked section is very short.

Use raw_cpu_ptr() to access vmap_block_queue.

Link: https://lkml.kernel.org/r/YnKx3duAB53P7ojN@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-raw_cpu_ptr-for-vmap_block_queue-access
+++ a/mm/vmalloc.c
@@ -1938,11 +1938,10 @@ static void *new_vmap_block(unsigned int
 		return ERR_PTR(err);
 	}
 
-	vbq = &get_cpu_var(vmap_block_queue);
+	vbq = raw_cpu_ptr(&vmap_block_queue);
 	spin_lock(&vbq->lock);
 	list_add_tail_rcu(&vb->free_list, &vbq->free);
 	spin_unlock(&vbq->lock);
-	put_cpu_var(vmap_block_queue);
 
 	return vaddr;
 }
@@ -2021,7 +2020,7 @@ static void *vb_alloc(unsigned long size
 	order = get_order(size);
 
 	rcu_read_lock();
-	vbq = &get_cpu_var(vmap_block_queue);
+	vbq = raw_cpu_ptr(&vmap_block_queue);
 	list_for_each_entry_rcu(vb, &vbq->free, free_list) {
 		unsigned long pages_off;
 
@@ -2044,7 +2043,6 @@ static void *vb_alloc(unsigned long size
 		break;
 	}
 
-	put_cpu_var(vmap_block_queue);
 	rcu_read_unlock();
 
 	/* Allocate new block if nothing was found */
_

Patches currently in -mm which might be from bigeasy@linutronix.de are



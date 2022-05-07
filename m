Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AD0C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 20:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbiEGUOQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 16:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbiEGUOP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 16:14:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C64A5FB2
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 13:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 994A360DC9
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 20:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E988DC385A6;
        Sat,  7 May 2022 20:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651954226;
        bh=wCor+Z+HJ8gmkAHTMLlk6wEJwUGrPwaELMFiomyFyb0=;
        h=Date:To:From:Subject:From;
        b=CZVqtjjF6WzmgChhczcDmAsQHha1Zq7ymFa+ffR2hQ6SYxYQikbND4oZu4OKsmGFw
         mG4TycdFeydVXXRFbmfcKyIrsChM+mb/UTXxgMiTAxKZr20ubS3+wEZGEv7Eni4cBj
         TUT/b64zR5itfovEr7s5i3G16haxtuR6KLsUK14A=
Date:   Sat, 07 May 2022 13:10:25 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, tglx@linutronix.de,
        bigeasy@linutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-raw_cpu_ptr-for-vmap_block_queue-access.patch added to mm-unstable branch
Message-Id: <20220507201025.E988DC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: use raw_cpu_ptr() for vmap_block_queue access.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-use-raw_cpu_ptr-for-vmap_block_queue-access.patch

This patch should soon appear in the mm-unstable branch at
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
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/vmalloc: use raw_cpu_ptr() for vmap_block_queue access.

The per-CPU resource vmap_block_queue is accessed via the get_cpu_var(). 
That macro disables preemption and then loads the pointer from the current
CPU.

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

mm-vmalloc-use-raw_cpu_ptr-for-vmap_block_queue-access.patch


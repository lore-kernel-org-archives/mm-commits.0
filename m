Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FD4C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbjHKW7m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbjHKW7J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5972694
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85943672B1
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA815C433C8;
        Fri, 11 Aug 2023 22:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794748;
        bh=0GFP/JV/hPe6P+pi5p19aG0iKkBnQ/lxSJcAA4jekY4=;
        h=Date:To:From:Subject:From;
        b=JJDz7YMPSPXZs+SQVuFSe4B+AK+rAdgvufzkrRPi1BnzlZjh3Xu5uvOXc/eE7x1l1
         /2r977aLJOC2brtlahFzv675n52ZELJLT6rbRt4ILsWddFRmIssHCf/1+PoVfVB2Nz
         S5xR9J/DrZEJHjvcJ1sSkjFyIxImYWITaHa1wO8g=
Date:   Fri, 11 Aug 2023 15:59:07 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        pmladek@suse.com, peterz@infradead.org,
        penguin-kernel@I-love.SAKURA.ne.jp, mingo@redhat.com,
        mhocko@suse.com, mgorman@techsingularity.net, longman@redhat.com,
        lgoncalv@redhat.com, john.ogness@linutronix.de, david@redhat.com,
        boqun.feng@gmail.com, bigeasy@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-use-write_seqlock_irqsave-instead-write_seqlock-local_irq_save.patch removed from -mm tree
Message-Id: <20230811225907.DA815C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: use write_seqlock_irqsave() instead write_seqlock() + local_irq_save().
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-write_seqlock_irqsave-instead-write_seqlock-local_irq_save.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/page_alloc: use write_seqlock_irqsave() instead write_seqlock() + local_irq_save().
Date: Fri, 23 Jun 2023 22:15:17 +0200

__build_all_zonelists() acquires zonelist_update_seq by first disabling
interrupts via local_irq_save() and then acquiring the seqlock with
write_seqlock().  This is troublesome and leads to problems on PREEMPT_RT.
The problem is that the inner spinlock_t becomes a sleeping lock on
PREEMPT_RT and must not be acquired with disabled interrupts.

The API provides write_seqlock_irqsave() which does the right thing in one
step.  printk_deferred_enter() has to be invoked in non-migrate-able
context to ensure that deferred printing is enabled and disabled on the
same CPU.  This is the case after zonelist_update_seq has been acquired.

There was discussion on the first submission that the order should be:
	local_irq_disable();
	printk_deferred_enter();
	write_seqlock();

to avoid pitfalls like having an unaccounted printk() coming from
write_seqlock_irqsave() before printk_deferred_enter() is invoked.  The
only origin of such a printk() can be a lockdep splat because the lockdep
annotation happens after the sequence count is incremented.  This is
exceptional and subject to change.

It was also pointed that PREEMPT_RT can be affected by the printk problem
since its write_seqlock_irqsave() does not really disable interrupts. 
This isn't the case because PREEMPT_RT's printk implementation differs
from the mainline implementation in two important aspects:

- Printing happens in a dedicated threads and not at during the
  invocation of printk().
- In emergency cases where synchronous printing is used, a different
  driver is used which does not use tty_port::lock.

Acquire zonelist_update_seq with write_seqlock_irqsave() and then defer
printk output.

Link: https://lkml.kernel.org/r/20230623201517.yw286Knb@linutronix.de
Fixes: 1007843a91909 ("mm/page_alloc: fix potential deadlock on zonelist_update_seq seqlock")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-write_seqlock_irqsave-instead-write_seqlock-local_irq_save
+++ a/mm/page_alloc.c
@@ -5139,19 +5139,17 @@ static void __build_all_zonelists(void *
 	unsigned long flags;
 
 	/*
-	 * Explicitly disable this CPU's interrupts before taking seqlock
-	 * to prevent any IRQ handler from calling into the page allocator
-	 * (e.g. GFP_ATOMIC) that could hit zonelist_iter_begin and livelock.
+	 * The zonelist_update_seq must be acquired with irqsave because the
+	 * reader can be invoked from IRQ with GFP_ATOMIC.
 	 */
-	local_irq_save(flags);
+	write_seqlock_irqsave(&zonelist_update_seq, flags);
 	/*
-	 * Explicitly disable this CPU's synchronous printk() before taking
-	 * seqlock to prevent any printk() from trying to hold port->lock, for
+	 * Also disable synchronous printk() to prevent any printk() from
+	 * trying to hold port->lock, for
 	 * tty_insert_flip_string_and_push_buffer() on other CPU might be
 	 * calling kmalloc(GFP_ATOMIC | __GFP_NOWARN) with port->lock held.
 	 */
 	printk_deferred_enter();
-	write_seqlock(&zonelist_update_seq);
 
 #ifdef CONFIG_NUMA
 	memset(node_load, 0, sizeof(node_load));
@@ -5188,9 +5186,8 @@ static void __build_all_zonelists(void *
 #endif
 	}
 
-	write_sequnlock(&zonelist_update_seq);
 	printk_deferred_exit();
-	local_irq_restore(flags);
+	write_sequnlock_irqrestore(&zonelist_update_seq, flags);
 }
 
 static noinline void __init
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

seqlock-do-the-lockdep-annotation-before-locking-in-do_write_seqcount_begin_nested.patch


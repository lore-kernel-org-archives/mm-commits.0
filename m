Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58E7EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 23:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjGBXkv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 19:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjGBXku (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 19:40:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFC5E44
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 16:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC86460CBB
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 23:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A4BC433C8;
        Sun,  2 Jul 2023 23:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688341248;
        bh=CmvIW1tXTrZJkOGWPFXNu5FbLJKJs91u+4kuacWbqdA=;
        h=Date:To:From:Subject:From;
        b=BqnexRoscPinFalmZHjpzzi500YDKcTvC4/fgube07StnS5pAfmoZpYdKyOL43jwx
         EpbQvkEORJuEyoLn9PwarwBwa0MOWe2i0zEtswQQM46O3ciuXuBlydz2x3rg58+V9/
         LYimjnb1Pp3BtmWg9jxuMQxlMzL/XAsmuUv6guOI=
Date:   Sun, 02 Jul 2023 16:40:47 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        pmladek@suse.com, peterz@infradead.org,
        penguin-kernel@I-love.SAKURA.ne.jp, mingo@redhat.com,
        mhocko@suse.com, mgorman@techsingularity.net, longman@redhat.com,
        lgoncalv@redhat.com, john.ogness@linutronix.de, david@redhat.com,
        boqun.feng@gmail.com, bigeasy@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + seqlock-do-the-lockdep-annotation-before-locking-in-do_write_seqcount_begin_nested.patch added to mm-unstable branch
Message-Id: <20230702234047.E9A4BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seqlock: do the lockdep annotation before locking in do_write_seqcount_begin_nested()
has been added to the -mm mm-unstable branch.  Its filename is
     seqlock-do-the-lockdep-annotation-before-locking-in-do_write_seqcount_begin_nested.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/seqlock-do-the-lockdep-annotation-before-locking-in-do_write_seqcount_begin_nested.patch

This patch will later appear in the mm-unstable branch at
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
Subject: seqlock: do the lockdep annotation before locking in do_write_seqcount_begin_nested()
Date: Fri, 23 Jun 2023 19:12:31 +0200

Patch series "seqlock,mm: lockdep annotation + write_seqlock_irqsave()",
v2.


This patch (of 2):

It was brought up by Tetsuo that the following sequence
   write_seqlock_irqsave()
   printk_deferred_enter()

could lead to a deadlock if the lockdep annotation within
write_seqlock_irqsave() triggers.  The problem is that the sequence
counter is incremented before the lockdep annotation is performed.  The
lockdep splat would then attempt to invoke printk() but the reader side,
of the same seqcount, could have a tty_port::lock acquired waiting for the
sequence number to become even again.

The other lockdep annotations come before the actual locking because "we
want to see the locking error before it happens".  There is no reason why
seqcount should be different here.

Do the lockdep annotation first then perform the locking operation (the
sequence increment).

Link: https://lkml.kernel.org/r/20230623171232.892937-2-bigeasy@linutronix.de
Fixes: 1ca7d67cf5d5a ("seqcount: Add lockdep functionality to seqcount/seqlock structures")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
  Link: https://lore.kernel.org/20230621130641.-5iueY1I@linutronix.de
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seqlock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/seqlock.h~seqlock-do-the-lockdep-annotation-before-locking-in-do_write_seqcount_begin_nested
+++ a/include/linux/seqlock.h
@@ -512,8 +512,8 @@ do {									\
 
 static inline void do_write_seqcount_begin_nested(seqcount_t *s, int subclass)
 {
-	do_raw_write_seqcount_begin(s);
 	seqcount_acquire(&s->dep_map, subclass, 0, _RET_IP_);
+	do_raw_write_seqcount_begin(s);
 }
 
 /**
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

seqlock-do-the-lockdep-annotation-before-locking-in-do_write_seqcount_begin_nested.patch
mm-page_alloc-use-write_seqlock_irqsave-instead-write_seqlock-local_irq_save.patch


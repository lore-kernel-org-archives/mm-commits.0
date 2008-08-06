From: akpm@linux-foundation.org
Subject: + lockdep-shrink-held_lock-structure-fix-2.patch added to -mm tree
Date: Wed, 06 Aug 2008 09:06:03 -0700
Message-ID: <200808061606.m76G63Us002478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbYHFQHO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 12:07:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, davej@redhat.com, mingo@elte.hu


The patch titled
     lockdep-shrink-held_lock-structure fix 2
has been added to the -mm tree.  Its filename is
     lockdep-shrink-held_lock-structure-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockdep-shrink-held_lock-structure fix 2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

A build fix, probably run-away search-'n-replace damage..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/lockdep.c~lockdep-shrink-held_lock-structure-fix-2 kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-shrink-held_lock-structure-fix-2
+++ a/kernel/lockdep.c
@@ -2819,7 +2819,7 @@ static int lock_release_nested(struct ta
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 	hlock->prev_chain_key = 0;
-	hlock_class(hlock) = NULL;
+	hlock->class_idx = 0;
 	hlock->acquire_ip = 0;
 	hlock->irq_context = 0;
 #endif
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
sched-type-fix.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal-fix.patch
lockdep-lock_set_subclass-reset-a-held-locks-subclass.patch
lockdep-re-annotate-scheduler-runqueues.patch
lockdep-shrink-held_lock-structure.patch
lockdep-shrink-held_lock-structure-fix.patch
lockdep-shrink-held_lock-structure-fix-2.patch
lockdep-map_acquire.patch
lockdep-lock-protection-locks.patch
lockdep-spin_lock_nest_lock.patch


From: akpm@linux-foundation.org
Subject: + lockdep-shrink-held_lock-structure-fix.patch added to -mm tree
Date: Tue, 05 Aug 2008 09:34:04 -0700
Message-ID: <200808051634.m75GY429012160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756175AbYHEQfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 12:35:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, davej@redhat.com, mingo@elte.hu


The patch titled
     lockdep: shrink held_lock structure (fix)
has been added to the -mm tree.  Its filename is
     lockdep-shrink-held_lock-structure-fix.patch

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
Subject: lockdep: shrink held_lock structure (fix)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Replacement patch - on account of the old one having a bug that
basically disables lockdep.

Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/lockdep.h~lockdep-shrink-held_lock-structure-fix include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-shrink-held_lock-structure-fix
+++ a/include/linux/lockdep.h
@@ -229,10 +229,10 @@ struct held_lock {
 	 * The following field is used to detect when we cross into an
 	 * interrupt context:
 	 */
-	unsigned int irq_context:1;
+	unsigned int irq_context:2; /* bit 0 - soft, bit 1 - hard */
 	unsigned int trylock:1;
-	unsigned int read:2;
-	unsigned int check:1;
+	unsigned int read:2;        /* see lock_acquire() comment */
+	unsigned int check:2;       /* see lock_acquire() comment */
 	unsigned int hardirqs_off:1;
 };
 
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
lockdep-map_acquire.patch
lockdep-lock-protection-locks.patch
lockdep-spin_lock_nest_lock.patch


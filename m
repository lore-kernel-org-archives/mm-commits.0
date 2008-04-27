From: akpm@linux-foundation.org
Subject: + mutex-debug-check-mutex-magic-before-owner.patch added to -mm tree
Date: Sun, 27 Apr 2008 13:47:22 -0700
Message-ID: <200804272047.m3RKlMgY024122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbYD0UsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 16:48:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jk@ozlabs.org, a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     mutex-debug: check mutex magic before owner
has been added to the -mm tree.  Its filename is
     mutex-debug-check-mutex-magic-before-owner.patch

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
Subject: mutex-debug: check mutex magic before owner
From: Jeremy Kerr <jk@ozlabs.org>

Currently, the mutex debug code checks the lock->owner before lock->magic, so
a corrupt mutex will most likely result in failing the owner check, rather
than the magic check.

This change to debug_mutex_unlock does the magic check first, so
we have a better idea of what breaks.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/mutex-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/mutex-debug.c~mutex-debug-check-mutex-magic-before-owner kernel/mutex-debug.c
--- a/kernel/mutex-debug.c~mutex-debug-check-mutex-magic-before-owner
+++ a/kernel/mutex-debug.c
@@ -79,8 +79,8 @@ void debug_mutex_unlock(struct mutex *lo
 	if (unlikely(!debug_locks))
 		return;
 
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
+	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 }
_

Patches currently in -mm which might be from jk@ozlabs.org are

origin.patch
mutex-debug-check-mutex-magic-before-owner.patch


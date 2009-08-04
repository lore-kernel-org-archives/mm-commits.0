From: akpm@linux-foundation.org
Subject: + spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3.patch added to -mm tree
Date: Tue, 04 Aug 2009 00:11:10 -0700
Message-ID: <200908040711.n747BAP5017646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932493AbZHDHL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 03:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kilroyd@googlemail.com, a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3
has been added to the -mm tree.  Its filename is
     spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3
From: David Kilroy <kilroyd@googlemail.com>

 * Correct bug in _spin_trylock_bh

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock_api_up.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/spinlock_api_up.h~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3 include/linux/spinlock_api_up.h
--- a/include/linux/spinlock_api_up.h~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3
+++ a/include/linux/spinlock_api_up.h
@@ -97,7 +97,7 @@ static inline int _write_trylock(rwlock_
 { __LOCK(lock); return 1; }
 
 static inline int _spin_trylock_bh(spinlock_t *lock)
-{ __LOCK(lock); return 1; }
+{ __LOCK_BH(lock); return 1; }
 
 static inline void _spin_unlock(spinlock_t *lock)
 { __UNLOCK(lock); }
_

Patches currently in -mm which might be from kilroyd@googlemail.com are

linux-next.patch
spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds.patch
spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3.patch


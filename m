From: akpm@linux-foundation.org
Subject: [folded] spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3.patch removed from -mm tree
Date: Fri, 18 Sep 2009 12:56:31 -0700
Message-ID: <200909181956.n8IJuV1Z000713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771AbZIRT46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Sep 2009 15:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kilroyd@googlemail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3
has been removed from the -mm tree.  Its filename was
     spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3.patch

This patch was dropped because it was folded into spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds.patch

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

origin.patch
spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds.patch
spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3.patch


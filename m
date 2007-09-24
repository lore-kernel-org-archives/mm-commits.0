From: akpm@linux-foundation.org
Subject: - include-linux-mutexh-unclear-reference-to-convention.patch removed from -mm tree
Date: Mon, 24 Sep 2007 14:25:51 -0700
Message-ID: <200709242125.l8OLPpAo018500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbXIXV0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 17:26:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mattilinnanvuori@yahoo.com, mingo@elte.hu, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     include/linux/mutex.h: unclear reference to convention
has been removed from the -mm tree.  Its filename was
     include-linux-mutexh-unclear-reference-to-convention.patch

This patch was dropped because it is redundant

------------------------------------------------------
Subject: include/linux/mutex.h: unclear reference to convention
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Reference to two different conventions is unnecessarily unclear unless you
know them already and requires seeking and reading another file for
understanding.

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mutex.h |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff -puN include/linux/mutex.h~include-linux-mutexh-unclear-reference-to-convention include/linux/mutex.h
--- a/include/linux/mutex.h~include-linux-mutexh-unclear-reference-to-convention
+++ a/include/linux/mutex.h
@@ -133,9 +133,19 @@ extern int __must_check mutex_lock_inter
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
 #endif
 
-/*
- * NOTE: mutex_trylock() follows the spin_trylock() convention,
- *       not the down_trylock() convention!
+/***
+ * mutex_trylock - try acquire the mutex, without waiting
+ * @lock: the mutex to be acquired
+ *
+ * Try to acquire the mutex atomically. Returns 1 if the mutex
+ * has been acquired successfully, and 0 on contention.
+ *
+ * NOTE: this function follows the spin_trylock() convention, so
+ * it is negated to the down_trylock() return values! Be careful
+ * about this when converting semaphore users to mutexes.
+ *
+ * This function must not be used in interrupt context. The
+ * mutex must be released by the same task that acquired it.
  */
 extern int fastcall mutex_trylock(struct mutex *lock);
 extern void fastcall mutex_unlock(struct mutex *lock);
_

Patches currently in -mm which might be from mattilinnanvuori@yahoo.com are

mutex-documentation-is-unclear-about-software-interrupts-tasklets-and-timers.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
include-linux-mutexh-unclear-reference-to-convention.patch

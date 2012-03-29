From: akpm@linux-foundation.org
Subject: + include-linux-spinlockh-add-a-kerneldoc-comment-to-spin_is_locked-that-discourages-its-use.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:39:21 -0700
Message-ID: <20120329213921.D7510A05B5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:62183 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904Ab2C2VjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 17:39:22 -0400
Received: by yhgm50 with SMTP id m50so323241yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:39:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, w.sang@pengutronix.de


The patch titled
     Subject: include/linux/spinlock.h: add a kerneldoc comment to spin_is_locked() that discourages its use
has been added to the -mm tree.  Its filename is
     include-linux-spinlockh-add-a-kerneldoc-comment-to-spin_is_locked-that-discourages-its-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: include/linux/spinlock.h: add a kerneldoc comment to spin_is_locked() that discourages its use

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN include/linux/spinlock.h~include-linux-spinlockh-add-a-kerneldoc-comment-to-spin_is_locked-that-discourages-its-use include/linux/spinlock.h
--- a/include/linux/spinlock.h~include-linux-spinlockh-add-a-kerneldoc-comment-to-spin_is_locked-that-discourages-its-use
+++ a/include/linux/spinlock.h
@@ -360,6 +360,15 @@ static inline void spin_unlock_wait(spin
 	raw_spin_unlock_wait(&lock->rlock);
 }
 
+/**
+ * spin_is_locked() - Check if a spinlock is being held.
+ * @lock: Lock to check.
+ *
+ * This function should normally not be used. Especially using it in
+ * WARN and BUG_ONs is usually incorrect or redundant.
+ * If you want to check if a lock is held in a function
+ * use lockdep_assert_held(). A lot of other usages are racy.
+ */
 static inline int spin_is_locked(spinlock_t *lock)
 {
 	return raw_spin_is_locked(&lock->rlock);
_
Subject: Subject: include/linux/spinlock.h: add a kerneldoc comment to spin_is_locked() that discourages its use

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
brlocks-lglocks-cleanups.patch
block-use-lockdep_assert_held-for-queue-locking.patch
sgi-xp-use-lockdep_assert_held.patch
drivers-scsi-aha152xc-remove-broken-usage-of-spin_is_locked.patch
xfs-fix-lock-assert-on-up.patch
mm-huge_memoryc-use-lockdep_assert_held.patch
futex-use-lockdep_assert_held-for-lock-checking.patch
drivers-net-irda-sir_devc-remove-spin_is_locked.patch
drivers-net-ethernet-smsc-smsc911xh-use-lockdep_assert_held-instead-of-home-grown-buggy-construct.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad.patch
include-linux-spinlockh-add-a-kerneldoc-comment-to-spin_is_locked-that-discourages-its-use.patch
checkpatch-check-for-spin_is_locked.patch


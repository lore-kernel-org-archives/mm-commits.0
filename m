From: akpm@linux-foundation.org
Subject: + spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:39:19 -0700
Message-ID: <20120329213919.E607EA06A4@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:44739 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904Ab2C2VjV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 17:39:21 -0400
Received: by mail-vx0-f202.google.com with SMTP id fk26so321177vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:39:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, w.sang@pengutronix.de


The patch titled
     Subject: spinlocks.txt: add a discussion on why spin_is_locked() is bad
has been added to the -mm tree.  Its filename is
     spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad.patch

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
Subject: spinlocks.txt: add a discussion on why spin_is_locked() is bad

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spinlocks.txt |   43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff -puN Documentation/spinlocks.txt~spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad Documentation/spinlocks.txt
--- a/Documentation/spinlocks.txt~spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad
+++ a/Documentation/spinlocks.txt
@@ -146,6 +146,49 @@ indeed), while write-locks need to prote
 
 ----
 
+spin_is_locked is a bad idea
+
+spin_is_locked checks if a lock is currently hold.  On uniprocessor kernels
+it always returns 0. In general this function should be avoided because most
+uses of it are either redundant or broken.
+
+People often use spin_is_locked() to check if a particular lock is hold when a function
+is called to enforce a locking discipline, like
+
+	WARN_ON(!spin_is_locked(!my_lock))
+
+or
+
+	BUG_ON(!spin_is_locked(!my_lock))
+
+or some variant of those.
+
+This does not work on uniprocessor kernels because they will always fail.
+While there are ways around that they are ugly and not recommended.
+Better use lockdep_assert_held(). This also only checks on a lock debugging
+kernel (which you should occasionally run on your code anyways because
+it catches many more problems).
+
+In generally this would be better done with static annotation anyways
+(there's some support for it in sparse)
+
+	BUG_ON(spin_is_locked(obj->lock));
+	kfree(obj);
+
+Another usage is checking whether a lock is not hold when freeing an object.
+However this is redundant because lock debugging supports this anyways
+without explicit code. Just delete the BUG_ON.
+
+A third usage is to check in a console function if a lock is hold, to get
+a panic crash dump out even when some other thread died in it.
+This is better implemented with spin_try_lock() et.al. and a timeout.
+
+Other usages are usually simply races.
+
+In summary just don't use it.
+
+----
+
 Reference information:
 
 For dynamic initialization, use spin_lock_init() or rwlock_init() as
_
Subject: Subject: spinlocks.txt: add a discussion on why spin_is_locked() is bad

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


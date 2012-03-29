From: akpm@linux-foundation.org
Subject: + futex-use-lockdep_assert_held-for-lock-checking.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:39:12 -0700
Message-ID: <20120329213912.34389A05B5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:50823 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933437Ab2C2VjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2012 17:39:14 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id i8so149511laa.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:39:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, a.p.zijlstra@chello.nl, dvhart@linux.intel.com, tglx@linutronix.de


The patch titled
     Subject: futex: use lockdep_assert_held() for lock checking
has been added to the -mm tree.  Its filename is
     futex-use-lockdep_assert_held-for-lock-checking.patch

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
Subject: futex: use lockdep_assert_held() for lock checking

Use lockdep_assert_held() for lock checking instead of a strange homegrown
variant.  This removes the return for this case, but that is unlikely to
be useful anyway.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/futex.c~futex-use-lockdep_assert_held-for-lock-checking kernel/futex.c
--- a/kernel/futex.c~futex-use-lockdep_assert_held-for-lock-checking
+++ a/kernel/futex.c
@@ -823,8 +823,9 @@ static void __unqueue_futex(struct futex
 {
 	struct futex_hash_bucket *hb;
 
-	if (WARN_ON_SMP(!q->lock_ptr || !spin_is_locked(q->lock_ptr))
-	    || WARN_ON(plist_node_empty(&q->list)))
+	if (q->lock_ptr)
+		lockdep_assert_held(q->lock_ptr);
+	if (WARN_ON(plist_node_empty(&q->list)))
 		return;
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
_
Subject: Subject: futex: use lockdep_assert_held() for lock checking

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


From: akpm@linux-foundation.org
Subject: + drivers-scsi-aha152xc-remove-broken-usage-of-spin_is_locked.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:39:04 -0700
Message-ID: <20120329213904.E93DFA05B5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:46635 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386Ab2C2VjM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 17:39:12 -0400
Received: by bkcjm19 with SMTP id jm19so148043bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:39:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, James.Bottomley@HansenPartnership.com


The patch titled
     Subject: drivers/scsi/aha152x.c: remove broken usage of spin_is_locked()
has been added to the -mm tree.  Its filename is
     drivers-scsi-aha152xc-remove-broken-usage-of-spin_is_locked.patch

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
Subject: drivers/scsi/aha152x.c: remove broken usage of spin_is_locked()

Remove racy usage of spin_is_locked. The author seems to have been
unclear on the concept of locking.

This is debug code normally not enabled, but I caught it on a tree sweep.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aha152x.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/scsi/aha152x.c~drivers-scsi-aha152xc-remove-broken-usage-of-spin_is_locked drivers/scsi/aha152x.c
--- a/drivers/scsi/aha152x.c~drivers-scsi-aha152xc-remove-broken-usage-of-spin_is_locked
+++ a/drivers/scsi/aha152x.c
@@ -287,9 +287,6 @@ static LIST_HEAD(aha152x_host_list);
 
 #define DO_LOCK(flags)	\
 	do { \
-		if(spin_is_locked(&QLOCK)) { \
-			DPRINTK(debug_intr, DEBUG_LEAD "(%s:%d) already locked at %s:%d\n", CMDINFO(CURRENT_SC), __func__, __LINE__, QLOCKER, QLOCKERL); \
-		} \
 		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locking\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
 		spin_lock_irqsave(&QLOCK,flags); \
 		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locked\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
_
Subject: Subject: drivers/scsi/aha152x.c: remove broken usage of spin_is_locked()

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


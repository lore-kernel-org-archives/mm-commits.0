From: akpm@linux-foundation.org
Subject: + xfs-fix-lock-assert-on-up.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:39:07 -0700
Message-ID: <20120329213908.0AE6CA06A4@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:56892 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336Ab2C2VjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 17:39:09 -0400
Received: by ggnd2 with SMTP id d2so321363ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:39:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, bpm@sgi.com, elder@kernel.org


The patch titled
     Subject: XFS: fix lock ASSERT on UP
has been added to the -mm tree.  Its filename is
     xfs-fix-lock-assert-on-up.patch

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
Subject: XFS: fix lock ASSERT on UP

ASSERT(!spin_is_locked()) doesn't work on UP builds.  Replace with a
standard lockdep_assert_held()

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_iget.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/xfs/xfs_iget.c~xfs-fix-lock-assert-on-up fs/xfs/xfs_iget.c
--- a/fs/xfs/xfs_iget.c~xfs-fix-lock-assert-on-up
+++ a/fs/xfs/xfs_iget.c
@@ -76,7 +76,7 @@ xfs_inode_alloc(
 	}
 
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	lockdep_assert_held(&ip->i_flags_lock);
 	ASSERT(!xfs_isiflocked(ip));
 	ASSERT(ip->i_ino == 0);
 
@@ -146,7 +146,7 @@ xfs_inode_free(
 
 	/* asserts to verify all state is correct here */
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
+	lockdep_assert_held(&ip->i_flags_lock);
 	ASSERT(!xfs_isiflocked(ip));
 
 	/*
_
Subject: Subject: XFS: fix lock ASSERT on UP

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


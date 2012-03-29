From: akpm@linux-foundation.org
Subject: + checkpatch-check-for-spin_is_locked.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:39:24 -0700
Message-ID: <20120329213924.6511EA05B5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:37820 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904Ab2C2Vj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 17:39:26 -0400
Received: by wejx9 with SMTP id x9so99774wej.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:39:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: check for spin_is_locked()
has been added to the -mm tree.  Its filename is
     checkpatch-check-for-spin_is_locked.patch

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
Subject: checkpatch: check for spin_is_locked()

spin_is_locked() is usually misued. In checkpatch.pl:

- warn when it is used at all

- error out when it is asserted on free, because that's usually broken
  (e.g.  doesn't work on on uni processor builds).  Recommend
  lockdep_assert_held() instead.

[joe@perches.com: some improvements]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-for-spin_is_locked scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-for-spin_is_locked
+++ a/scripts/checkpatch.pl
@@ -3458,6 +3458,20 @@ sub process {
 			}
 		}
 
+# spin_is_locked is usually misused. warn about it.
+		if ($line =~ /\bspin_is_locked\s*\(/) {
+			# BUG_ON/WARN_ON(!spin_is_locked() is generally a bug
+			if ($line =~ /(BUG_ON|WARN_ON|ASSERT)\s*\(!spin_is_locked/) {
+				ERROR("SPIN_IS_LOCKED",
+				     "Use lockdep_assert_held() instead of asserts on !spin_is_locked\n"
+				      . $herecurr);
+			} else {
+				WARN("SPIN_IS_LOCKED",
+			     "spin_is_locked is usually misused. See Documentation/spinlocks.txt\n"
+					. $herecurr)
+			}
+		}
+
 # check for lockdep_set_novalidate_class
 		if ($line =~ /^.\s*lockdep_set_novalidate_class\s*\(/ ||
 		    $line =~ /__lockdep_no_validate__\s*\)/ ) {
_
Subject: Subject: checkpatch: check for spin_is_locked()

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


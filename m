From: akpm@linux-foundation.org
Subject: + drivers-net-ethernet-smsc-smsc911xh-use-lockdep_assert_held-instead-of-home-grown-buggy-construct.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:39:17 -0700
Message-ID: <20120329213917.DD17FA06A4@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:50823 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933860Ab2C2VjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2012 17:39:19 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id i8so149511laa.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:39:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, davem@davemloft.net, steve.glendinning@smsc.com


The patch titled
     Subject: drivers/net/ethernet/smsc/smsc911x.h: use lockdep_assert_held() instead of home grown buggy construct
has been added to the -mm tree.  Its filename is
     drivers-net-ethernet-smsc-smsc911xh-use-lockdep_assert_held-instead-of-home-grown-buggy-construct.patch

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
Subject: drivers/net/ethernet/smsc/smsc911x.h: use lockdep_assert_held() instead of home grown buggy construct

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Steve Glendinning <steve.glendinning@smsc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/smsc/smsc911x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/ethernet/smsc/smsc911x.h~drivers-net-ethernet-smsc-smsc911xh-use-lockdep_assert_held-instead-of-home-grown-buggy-construct drivers/net/ethernet/smsc/smsc911x.h
--- a/drivers/net/ethernet/smsc/smsc911x.h~drivers-net-ethernet-smsc-smsc911xh-use-lockdep_assert_held-instead-of-home-grown-buggy-construct
+++ a/drivers/net/ethernet/smsc/smsc911x.h
@@ -52,7 +52,7 @@
 
 #ifdef CONFIG_DEBUG_SPINLOCK
 #define SMSC_ASSERT_MAC_LOCK(pdata) \
-		WARN_ON(!spin_is_locked(&pdata->mac_lock))
+		lockdep_assert_held(&(pdata)->mac_lock)
 #else
 #define SMSC_ASSERT_MAC_LOCK(pdata) do {} while (0)
 #endif				/* CONFIG_DEBUG_SPINLOCK */
_
Subject: Subject: drivers/net/ethernet/smsc/smsc911x.h: use lockdep_assert_held() instead of home grown buggy construct

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


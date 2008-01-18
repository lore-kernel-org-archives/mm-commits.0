From: akpm@linux-foundation.org
Subject: + bonding-dont-hold-lock-when-calling-rtnl_unlock.patch added to -mm tree
Date: Thu, 17 Jan 2008 16:40:50 -0800
Message-ID: <200801180040.m0I0eoxx022623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36489 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757336AbYARAq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 19:46:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fubar@us.ibm.com, mshiokawa@miraclelinux.com


The patch titled
     bonding: don't hold lock when calling rtnl_unlock
has been added to the -mm tree.  Its filename is
     bonding-dont-hold-lock-when-calling-rtnl_unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bonding: don't hold lock when calling rtnl_unlock
From: Jay Vosburgh <fubar@us.ibm.com>

Change bond_mii_monitor to not hold any locks when calling rtnl_unlock,
as rtnl_unlock can sleep (when acquring another mutex in netdev_run_todo).

Bug reported by Makito SHIOKAWA <mshiokawa@miraclelinux.com>, who
included a different patch.

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/net/bonding/bond_main.c~bonding-dont-hold-lock-when-calling-rtnl_unlock drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~bonding-dont-hold-lock-when-calling-rtnl_unlock
+++ a/drivers/net/bonding/bond_main.c
@@ -2386,7 +2386,9 @@ void bond_mii_monitor(struct work_struct
 		rtnl_lock();
 		read_lock(&bond->lock);
 		__bond_mii_monitor(bond, 1);
-		rtnl_unlock();
+		read_unlock(&bond->lock);
+		rtnl_unlock();	/* might sleep, hold no other locks */
+		read_lock(&bond->lock);
 	}
 
 	delay = ((bond->params.miimon * HZ) / 1000) ? : 1;
_

Patches currently in -mm which might be from fubar@us.ibm.com are

git-netdev-all.patch
bonding-fix-locking-in-sysfs-primary-active-selection.patch
bonding-fix-assert_rtnl-that-produces-spurious-warnings.patch
bonding-fix-locking-during-alb-failover-and-slave-removal.patch
bonding-release-slaves-when-master-removed-via-sysfs.patch
bonding-fix-up-parameter-parsing.patch
bonding-fix-lock-ordering-for-rtnl-and-bonding_rwsem.patch
bonding-dont-hold-lock-when-calling-rtnl_unlock.patch

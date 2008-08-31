From: akpm@linux-foundation.org
Subject: + drivers-net-atl1e-dont-take-the-mdio_lock-in-atl1e_probe.patch added to -mm tree
Date: Sat, 30 Aug 2008 22:36:16 -0700
Message-ID: <200808310536.m7V5aGsl007046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbYHaFie (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 31 Aug 2008 01:38:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthew@wil.cx, jeff@garzik.org, jie.yang@atheros.com, willy@linux.intel.com


The patch titled
     drivers/net/atl1e/: don't take the mdio_lock in atl1e_probe
has been added to the -mm tree.  Its filename is
     drivers-net-atl1e-dont-take-the-mdio_lock-in-atl1e_probe.patch

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
Subject: drivers/net/atl1e/: don't take the mdio_lock in atl1e_probe
From: Matthew Wilcox <matthew@wil.cx>

Lockdep warns about the mdio_lock taken with interrupts enabled then later
taken from interrupt context.  Initially, I considered changing these to
spin_lock_irq/spin_unlock_irq, but then I looked at atl1e_phy_init() and
saw that it calls msleep().  Sleeping while holding a spinlock is not
allowed either.

In the probe path, we haven't registered the interrupt handler, so it
can't poke at this card yet.  It's before we call register_netdev(), so I
don't think any other threads can reach this card either.  If I'm right,
we don't need a spinlock at all.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Acked-by: Jie Yang <jie.yang@atheros.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1e/atl1e_main.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/net/atl1e/atl1e_main.c~drivers-net-atl1e-dont-take-the-mdio_lock-in-atl1e_probe drivers/net/atl1e/atl1e_main.c
--- a/drivers/net/atl1e/atl1e_main.c~drivers-net-atl1e-dont-take-the-mdio_lock-in-atl1e_probe
+++ a/drivers/net/atl1e/atl1e_main.c
@@ -2390,9 +2390,7 @@ static int __devinit atl1e_probe(struct 
 	}
 
 	/* Init GPHY as early as possible due to power saving issue  */
-	spin_lock(&adapter->mdio_lock);
 	atl1e_phy_init(&adapter->hw);
-	spin_unlock(&adapter->mdio_lock);
 	/* reset the controller to
 	 * put the device in a known good starting state */
 	err = atl1e_reset_hw(&adapter->hw);
_

Patches currently in -mm which might be from matthew@wil.cx are

linux-next.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
drivers-net-atl1e-dont-take-the-mdio_lock-in-atl1e_probe.patch
binfmt_somc-add-module_license.patch
make-sure-nobodys-leaking-resources.patch


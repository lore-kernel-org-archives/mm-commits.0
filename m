From: akpm@linux-foundation.org
Subject: - drivers-net-atl1e-dont-take-the-mdio_lock-in-atl1e_probe.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:52:33 -0700
Message-ID: <200810012152.m91LqXau006063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbYJAVx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, jeff@garzik.org, jie.yang@atheros.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/atl1e/: don't take the mdio_lock in atl1e_probe
has been removed from the -mm tree.  Its filename was
     drivers-net-atl1e-dont-take-the-mdio_lock-in-atl1e_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-nfsd.patch
git-scsi.patch
git-net.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
compat-generic-compat-get-settimeofday.patch
binfmt_somc-add-module_license.patch
make-sure-nobodys-leaking-resources.patch


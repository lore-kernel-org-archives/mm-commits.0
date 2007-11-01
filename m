From: akpm@linux-foundation.org
Subject: + sunhme-fix-missing-netif_f_vlan_challenged-on-pci-happy-meals.patch added to -mm tree
Date: Thu, 01 Nov 2007 12:12:48 -0700
Message-ID: <20071101191248.4D11B432BDE@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:44684 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbXKATNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 15:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, dev-null@telus.net, jeff@garzik.org


The patch titled
     SUNHME: fix missing NETIF_F_VLAN_CHALLENGED on PCI happy meals
has been added to the -mm tree.  Its filename is
     sunhme-fix-missing-netif_f_vlan_challenged-on-pci-happy-meals.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SUNHME: fix missing NETIF_F_VLAN_CHALLENGED on PCI happy meals
From: David Miller <davem@davemloft.net>

No HME parts can do VLANs correctly.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9270

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Chris Poon <dev-null@telus.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sunhme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/sunhme.c~sunhme-fix-missing-netif_f_vlan_challenged-on-pci-happy-meals drivers/net/sunhme.c
--- a/drivers/net/sunhme.c~sunhme-fix-missing-netif_f_vlan_challenged-on-pci-happy-meals
+++ a/drivers/net/sunhme.c
@@ -3143,8 +3143,8 @@ static int __devinit happy_meal_pci_prob
 	dev->irq = pdev->irq;
 	dev->dma = 0;
 
-	/* Happy Meal can do it all... */
-	dev->features |= NETIF_F_SG | NETIF_F_HW_CSUM;
+	/* Happy Meal can do it all... except VLAN. */
+	dev->features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_VLAN_CHALLENGED;
 
 #if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
 	/* Hook up PCI register/dma accessors. */
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
pfkey-sending-an-sadb_get-responds-with-an-sadb_get.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
sunhme-fix-missing-netif_f_vlan_challenged-on-pci-happy-meals.patch
git-block.patch
git-wireless.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
sysctl-fix-token-ring-procname.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
genericizing-iova.patch
iget-stop-openpromfs-from-using-iget-and.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch

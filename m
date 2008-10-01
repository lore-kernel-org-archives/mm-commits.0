From: akpm@linux-foundation.org
Subject: - netdev-drop-config_ppc_merge-from-kconfig.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:51:24 -0700
Message-ID: <200810012151.m91LpOeh005924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442AbYJAVxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:53:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: galak@kernel.crashing.org, benh@kernel.crashing.org, david@gibson.dropbear.id.au, jeff@garzik.org, jwboyer@linux.vnet.ibm.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     netdev: drop CONFIG_PPC_MERGE from Kconfig
has been removed from the -mm tree.  Its filename was
     netdev-drop-config_ppc_merge-from-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netdev: drop CONFIG_PPC_MERGE from Kconfig
From: Kumar Gala <galak@kernel.crashing.org>

Now that arch/ppc is dead CONFIG_PPC_MERGE is always defined for all
powerpc platforms so we don't need to depend on it.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig             |    2 +-
 drivers/net/ibm_newemac/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/Kconfig~netdev-drop-config_ppc_merge-from-kconfig drivers/net/Kconfig
--- a/drivers/net/Kconfig~netdev-drop-config_ppc_merge-from-kconfig
+++ a/drivers/net/Kconfig
@@ -1800,7 +1800,7 @@ config FEC2
 
 config FEC_MPC52xx
 	tristate "MPC52xx FEC driver"
-	depends on PPC_MERGE && PPC_MPC52xx && PPC_BESTCOMM_FEC
+	depends on PPC_MPC52xx && PPC_BESTCOMM_FEC
 	select CRC32
 	select PHYLIB
 	---help---
diff -puN drivers/net/ibm_newemac/Kconfig~netdev-drop-config_ppc_merge-from-kconfig drivers/net/ibm_newemac/Kconfig
--- a/drivers/net/ibm_newemac/Kconfig~netdev-drop-config_ppc_merge-from-kconfig
+++ a/drivers/net/ibm_newemac/Kconfig
@@ -1,6 +1,6 @@
 config IBM_NEW_EMAC
 	tristate "IBM EMAC Ethernet support"
-	depends on PPC_DCR && PPC_MERGE
+	depends on PPC_DCR
 	select CRC32
 	help
 	  This driver supports the IBM EMAC family of Ethernet controllers
_

Patches currently in -mm which might be from galak@kernel.crashing.org are

git-powerpc.patch
git-async_tx.patch
git-net.patch
git-mtd.patch
powerpc-convert-config_ppc_merge-to-config_ppc-for-legacy-io-checks.patch
pata_sil680-convert-config_ppc_merge-to-config_ppc.patch
serial-mpc52xx_uart-remove-code-associated-with-config_ppc_merge.patch
mpc52xx_psc_spi-remove-code-associated-with-config_ppc_merge.patch
rtc-use-config_ppc-instead-of-config_ppc_merge.patch


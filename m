From: akpm@linux-foundation.org
Subject: + netdev-drop-config_ppc_merge-from-kconfig.patch added to -mm tree
Date: Tue, 26 Aug 2008 14:16:38 -0700
Message-ID: <200808262116.m7QLGcdS028094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbYHZVSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 17:18:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: galak@kernel.crashing.org, benh@kernel.crashing.org, david@gibson.dropbear.id.au, jeff@garzik.org, jwboyer@linux.vnet.ibm.com, paulus@samba.org


The patch titled
     netdev: drop CONFIG_PPC_MERGE from Kconfig
has been added to the -mm tree.  Its filename is
     netdev-drop-config_ppc_merge-from-kconfig.patch

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

linux-next.patch
usb-remove-code-associated-with-config_ppc_merge.patch
fs-enet-remove-code-associated-with-config_ppc_merge.patch
netdev-drop-config_ppc_merge-from-kconfig.patch
rtc-use-config_ppc-instead-of-config_ppc_merge.patch
serial-mpc52xx_uart-remove-code-associated-with-config_ppc_merge.patch
mpc52xx_psc_spi-remove-code-associated-with-config_ppc_merge.patch
powerpc-convert-config_ppc_merge-to-config_ppc-for-legacy-io-checks.patch
pata_sil680-convert-config_ppc_merge-to-config_ppc.patch


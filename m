From: akpm@linux-foundation.org
Subject: + drivers-net-stmmac-add-has_iomem-dependency.patch added to -mm tree
Date: Thu, 23 Sep 2010 12:10:12 -0700
Message-ID: <201009231910.o8NJACH5013115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab0IWTKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 15:10:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwidefsky@de.ibm.com, davem@davemloft.net, heiko.carstens@de.ibm.com, peppe.cavallaro@st.com


The patch titled
     drivers/net/stmmac/: add HAS_IOMEM dependency
has been added to the -mm tree.  Its filename is
     drivers-net-stmmac-add-has_iomem-dependency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/stmmac/: add HAS_IOMEM dependency
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The stmmac driver does not compile on s390:

drivers/net/stmmac/stmmac_main.c: In function 'stmmac_adjust_link':
drivers/net/stmmac/stmmac_main.c:210: error: implicit declaration of function 'readl'
drivers/net/stmmac/stmmac_main.c:263: error: implicit declaration of function 'writel'
drivers/net/stmmac/stmmac_main.c: In function 'stmmac_dvr_probe':
drivers/net/stmmac/stmmac_main.c:1674: error: implicit declaration of function 'ioremap'
drivers/net/stmmac/stmmac_main.c:1674: warning: assignment makes pointer from integer without a cast
drivers/net/stmmac/stmmac_main.c:1761: error: implicit declaration of function 'iounmap'
make[3]: *** [drivers/net/stmmac/stmmac_main.o] Error 1

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/stmmac/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/stmmac/Kconfig~drivers-net-stmmac-add-has_iomem-dependency drivers/net/stmmac/Kconfig
--- a/drivers/net/stmmac/Kconfig~drivers-net-stmmac-add-has_iomem-dependency
+++ a/drivers/net/stmmac/Kconfig
@@ -3,7 +3,7 @@ config STMMAC_ETH
 	select MII
 	select PHYLIB
 	select CRC32
-	depends on NETDEVICES
+	depends on NETDEVICES && HAS_IOMEM
 	help
 	  This is the driver for the Ethernet IPs are built around a
 	  Synopsys IP Core and only tested on the STMicroelectronics
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

linux-next.patch
time-compensate-for-rounding-on-odd-frequency-clocksources.patch
drivers-net-stmmac-add-has_iomem-dependency.patch
s390-enable-arch_dma_addr_t_64bit-with-64bit.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
initramfs-generalize-initramfs_dataxxxs-variants.patch
initramfs-fix-initramfs-size-calculation.patch


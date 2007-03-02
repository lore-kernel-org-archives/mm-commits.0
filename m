From: akpm@linux-foundation.org
Subject: + fix-mv643xx_eth-compilation.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:41:52 -0800
Message-ID: <200703020241.l222fqGe030289@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36145 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753AbXCBCmN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:42:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com


The patch titled
     Fix mv643xx_eth compilation.
has been added to the -mm tree.  Its filename is
     fix-mv643xx_eth-compilation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix mv643xx_eth compilation.
From: Dave Jones <davej@redhat.com>

Commit 908b637fe793165b6aecdc875cdca67c4959a1ad removed ETH_DMA_ALIGN but
missed a usage of it in a macro, which broke the build.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/mv643xx_eth.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/net/mv643xx_eth.h~fix-mv643xx_eth-compilation drivers/net/mv643xx_eth.h
--- a/drivers/net/mv643xx_eth.h~fix-mv643xx_eth-compilation
+++ a/drivers/net/mv643xx_eth.h
@@ -9,6 +9,8 @@
 
 #include <linux/mv643xx.h>
 
+#include <asm/dma-mapping.h>
+
 /* Checksum offload for Tx works for most packets, but
  * fails if previous packet sent did not use hw csum
  */
@@ -47,7 +49,7 @@
 #define ETH_HW_IP_ALIGN		2		/* hw aligns IP header */
 #define ETH_WRAPPER_LEN		(ETH_HW_IP_ALIGN + ETH_HLEN + \
 					ETH_VLAN_HLEN + ETH_FCS_LEN)
-#define ETH_RX_SKB_SIZE		(dev->mtu + ETH_WRAPPER_LEN + ETH_DMA_ALIGN)
+#define ETH_RX_SKB_SIZE		(dev->mtu + ETH_WRAPPER_LEN + dma_get_cache_alignment())
 
 #define ETH_RX_QUEUES_ENABLED	(1 << 0)	/* use only Q0 for receive */
 #define ETH_TX_QUEUES_ENABLED	(1 << 0)	/* use only Q0 for transmit */
_

Patches currently in -mm which might be from davej@redhat.com are

fix-mv643xx_eth-compilation.patch

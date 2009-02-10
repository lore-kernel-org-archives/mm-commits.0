From: akpm@linux-foundation.org
Subject: + de2104x-support-for-systems-lacking-cache-coherence.patch added to -mm tree
Date: Mon, 09 Feb 2009 17:01:41 -0800
Message-ID: <200902100101.n1A11fDD011294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbZBJBCg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 20:02:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: risto.suominen@gmail.com, Risto.Suominen@gmail.com, grundler@parisc-linux.org


The patch titled
     de2104x: support for systems lacking cache coherence
has been added to the -mm tree.  Its filename is
     de2104x-support-for-systems-lacking-cache-coherence.patch

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
Subject: de2104x: support for systems lacking cache coherence
From: Risto Suominen <risto.suominen@gmail.com>

Add a configurable Descriptor Skip Length for systems that lack cache
coherence.

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/Kconfig   |   12 ++++++++++++
 drivers/net/tulip/de2104x.c |   13 ++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff -puN drivers/net/tulip/Kconfig~de2104x-support-for-systems-lacking-cache-coherence drivers/net/tulip/Kconfig
--- a/drivers/net/tulip/Kconfig~de2104x-support-for-systems-lacking-cache-coherence
+++ a/drivers/net/tulip/Kconfig
@@ -27,6 +27,18 @@ config DE2104X
 	  To compile this driver as a module, choose M here. The module will
 	  be called de2104x.
 
+config DE2104X_DSL
+	int "Descriptor Skip Length in 32 bit longwords"
+	depends on DE2104X
+	range 0 31
+	default 0
+	help
+	  Setting this value allows to align ring buffer descriptors into their
+	  own cache lines. Value of 4 corresponds to the typical 32 byte line
+	  (the descriptor is 16 bytes). This is necessary on systems that lack
+	  cache coherence, an example is PowerMac 5500. Otherwise 0 is safe.
+	  Default is 0, and range is 0 to 31.
+
 config TULIP
 	tristate "DECchip Tulip (dc2114x) PCI support"
 	depends on PCI
diff -puN drivers/net/tulip/de2104x.c~de2104x-support-for-systems-lacking-cache-coherence drivers/net/tulip/de2104x.c
--- a/drivers/net/tulip/de2104x.c~de2104x-support-for-systems-lacking-cache-coherence
+++ a/drivers/net/tulip/de2104x.c
@@ -82,6 +82,13 @@ MODULE_PARM_DESC (rx_copybreak, "de2104x
 				 NETIF_MSG_RX_ERR	| \
 				 NETIF_MSG_TX_ERR)
 
+/* Descriptor skip length in 32 bit longwords. */
+#ifndef CONFIG_DE2104X_DSL
+#define DSL			0
+#else
+#define DSL			CONFIG_DE2104X_DSL
+#endif
+
 #define DE_RX_RING_SIZE		64
 #define DE_TX_RING_SIZE		64
 #define DE_RING_BYTES		\
@@ -153,6 +160,7 @@ enum {
 	CmdReset		= (1 << 0),
 	CacheAlign16		= 0x00008000,
 	BurstLen4		= 0x00000400,
+	DescSkipLen		= (DSL << 2),
 
 	/* Rx/TxPoll bits */
 	NormalTxPoll		= (1 << 0),
@@ -246,7 +254,7 @@ static const u32 de_intr_mask =
  * Set the programmable burst length to 4 longwords for all:
  * DMA errors result without these values. Cache align 16 long.
  */
-static const u32 de_bus_mode = CacheAlign16 | BurstLen4;
+static const u32 de_bus_mode = CacheAlign16 | BurstLen4 | DescSkipLen;
 
 struct de_srom_media_block {
 	u8			opts;
@@ -266,6 +274,9 @@ struct de_desc {
 	__le32			opts2;
 	__le32			addr1;
 	__le32			addr2;
+#if DSL
+	__le32			skip[DSL];
+#endif
 };
 
 struct media_info {
_

Patches currently in -mm which might be from risto.suominen@gmail.com are

de2104x-force-correct-order-when-writing-to-rx-ring.patch
de2104x-support-for-systems-lacking-cache-coherence.patch


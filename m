From: akpm@linux-foundation.org
Subject: + ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:17:39 -0700
Message-ID: <200710152317.l9FNHdUo030365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55767 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901AbXJOXSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:18:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Emilian.Medve@Freescale.com, davem@davemloft.net, galak@gate.crashing.org, jeff@garzik.org, leoli@Freescale.com, paulus@samba.org


The patch titled
     ucc_geth: fix build break introduced by commit 09f75cd7bf13720738e6a196cc0107ce9a5bd5a0
has been added to the -mm tree.  Its filename is
     ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ucc_geth: fix build break introduced by commit 09f75cd7bf13720738e6a196cc0107ce9a5bd5a0
From: Emil Medve <Emilian.Medve@Freescale.com>

drivers/net/ucc_geth.c: In function 'ucc_geth_rx':
drivers/net/ucc_geth.c:3483: error: 'dev' undeclared (first use in this function)
drivers/net/ucc_geth.c:3483: error: (Each undeclared identifier is reported only once
drivers/net/ucc_geth.c:3483: error: for each function it appears in.)
make[2]: *** [drivers/net/ucc_geth.o] Error 1

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
Acked-by: Li Yang <leoli@freescale.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ucc_geth.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/net/ucc_geth.c~ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0 drivers/net/ucc_geth.c
--- a/drivers/net/ucc_geth.c~ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0
+++ a/drivers/net/ucc_geth.c
@@ -63,7 +63,7 @@
 #define UGETH_MSG_DEFAULT	(NETIF_MSG_IFUP << 1 ) - 1
 
 void uec_set_ethtool_ops(struct net_device *netdev);
-	
+
 static DEFINE_SPINLOCK(ugeth_lock);
 
 static struct {
@@ -3454,9 +3454,12 @@ static int ucc_geth_rx(struct ucc_geth_p
 	u16 length, howmany = 0;
 	u32 bd_status;
 	u8 *bdBuffer;
+	struct net_device * dev;
 
 	ugeth_vdbg("%s: IN", __FUNCTION__);
 
+	dev = ugeth->dev;
+
 	/* collect received buffers */
 	bd = ugeth->rxBd[rxQ];
 
_

Patches currently in -mm which might be from Emilian.Medve@Freescale.com are

origin.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch

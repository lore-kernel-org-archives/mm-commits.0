From: akpm@linux-foundation.org
Subject: + drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init.patch added to -mm tree
Date: Wed, 02 Jul 2008 01:35:59 -0700
Message-ID: <200807020835.m628Zx2e007473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716AbYGBIhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 04:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, Larry.Finger@lwfinger.net, bunk@kernel.org, dhowells@redhat.com, linville@tuxdriver.com, mb@bu3sch.de, stefano.brivio@polimi.it


The patch titled
     drivers/net/wireless/b43legacy/dma.c: remove the switch in b43legacy_dma_init()
has been added to the -mm tree.  Its filename is
     drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init.patch

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
Subject: drivers/net/wireless/b43legacy/dma.c: remove the switch in b43legacy_dma_init()
From: Adrian Bunk <bunk@stusta.de>

The gcc 3.4 fork used to compile the MN10300 port emits unwanted
__ucmpdi2() calls for this switch on a 64bit value.

Fix it by transforming the switch to equivalent "if ... else if ..."
statements.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43legacy/dma.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN drivers/net/wireless/b43legacy/dma.c~drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init drivers/net/wireless/b43legacy/dma.c
--- a/drivers/net/wireless/b43legacy/dma.c~drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init
+++ a/drivers/net/wireless/b43legacy/dma.c
@@ -1027,19 +1027,15 @@ int b43legacy_dma_init(struct b43legacy_
 	enum b43legacy_dmatype type;
 
 	dmamask = supported_dma_mask(dev);
-	switch (dmamask) {
-	default:
-		B43legacy_WARN_ON(1);
-	case DMA_30BIT_MASK:
+
+	if (dmamask == DMA_30BIT_MASK)
 		type = B43legacy_DMA_30BIT;
-		break;
-	case DMA_32BIT_MASK:
+	else if (dmamask == DMA_32BIT_MASK)
 		type = B43legacy_DMA_32BIT;
-		break;
-	case DMA_64BIT_MASK:
+	else if (dmamask == DMA_64BIT_MASK)
 		type = B43legacy_DMA_64BIT;
-		break;
-	}
+	else
+		B43legacy_WARN_ON(1);
 
 	err = ssb_dma_set_mask(dev->dev, dmamask);
 	if (err) {
_

Patches currently in -mm which might be from bunk@stusta.de are

mn10300-export-certain-arch-symbols-required-to-build-allmodconfig.patch
mn10300-provide-__ucmpdi2-for-mn10300.patch
linux-next.patch
git-unionfs.patch
remove-apparently-unused-fd1772h-header-file.patch
remove-the-oss-trident-driver-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init.patch


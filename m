From: akpm@linux-foundation.org
Subject: + net-yellowfin-parenthesis-fix.patch added to -mm tree
Date: Fri, 21 Mar 2008 14:44:38 -0700
Message-ID: <200803212144.m2LLicHB011911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754842AbYCUVov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 17:44:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl


The patch titled
     net: yellowfin parenthesis fix
has been added to the -mm tree.  Its filename is
     net-yellowfin-parenthesis-fix.patch

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
Subject: net: yellowfin parenthesis fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

The code is under unused #ifdef NO_TXSTATS branch but its better to have it
fixed.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/yellowfin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/yellowfin.c~net-yellowfin-parenthesis-fix drivers/net/yellowfin.c
--- a/drivers/net/yellowfin.c~net-yellowfin-parenthesis-fix
+++ a/drivers/net/yellowfin.c
@@ -770,14 +770,14 @@ static void yellowfin_init_ring(struct n
 		/* Branch on Tx error. */
 		yp->tx_ring[j].dbdma_cmd = cpu_to_le32(CMD_STOP);
 		yp->tx_ring[j].branch_addr = cpu_to_le32(yp->tx_ring_dma +
-			(j+1)*sizeof(struct yellowfin_desc);
+			(j+1)*sizeof(struct yellowfin_desc));
 		j++;
 		if (yp->flags & FullTxStatus) {
 			yp->tx_ring[j].dbdma_cmd =
 				cpu_to_le32(CMD_TXSTATUS | sizeof(*yp->tx_status));
 			yp->tx_ring[j].request_cnt = sizeof(*yp->tx_status);
 			yp->tx_ring[j].addr = cpu_to_le32(yp->tx_status_dma +
-				i*sizeof(struct tx_status_words);
+				i*sizeof(struct tx_status_words));
 		} else {
 			/* Symbios chips write only tx_errs word. */
 			yp->tx_ring[j].dbdma_cmd =
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-alsa-tiwai.patch
net-yellowfin-parenthesis-fix.patch
reiser4.patch


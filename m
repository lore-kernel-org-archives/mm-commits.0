From: akpm@linux-foundation.org
Subject: - drivers-net-wireless-libertas-rxc-fix.patch removed from -mm tree
Date: Tue, 29 May 2007 11:56:07 -0700
Message-ID: <200705291856.l4TIu6mq008627@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765400AbXE2S5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:57:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eugeneteo@kernel.sg, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/wireless/libertas/rx.c: fix use-after-free
has been removed from the -mm tree.  Its filename was
     drivers-net-wireless-libertas-rxc-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/net/wireless/libertas/rx.c: fix use-after-free
From: Eugene Teo <eugeneteo@kernel.sg>

skb could have been freed by then. Also, in libertas_upload_rx_packet(),
skb->protocol is initialized by eth_type_trans().

Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/libertas/rx.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/net/wireless/libertas/rx.c~drivers-net-wireless-libertas-rxc-fix drivers/net/wireless/libertas/rx.c
--- a/drivers/net/wireless/libertas/rx.c~drivers-net-wireless-libertas-rxc-fix
+++ a/drivers/net/wireless/libertas/rx.c
@@ -453,7 +453,5 @@ static int process_rxed_802_11_packet(wl
 done:
 	LEAVE();
 
-	skb->protocol = __constant_htons(0x0019);	/* ETH_P_80211_RAW */
-
 	return (ret);
 }
_

Patches currently in -mm which might be from eugeneteo@kernel.sg are

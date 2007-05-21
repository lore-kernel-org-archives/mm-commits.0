From: akpm@linux-foundation.org
Subject: + drivers-net-wireless-libertas-rxc-fix.patch added to -mm tree
Date: Mon, 21 May 2007 15:22:04 -0700
Message-ID: <200705212222.l4LMM4B6021387@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758895AbXEUWZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 18:25:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eugeneteo@kernel.sg, linville@tuxdriver.com


The patch titled
     drivers/net/wireless/libertas/rx.c: fix use-after-free
has been added to the -mm tree.  Its filename is
     drivers-net-wireless-libertas-rxc-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-net-wireless-libertas-rxc-fix.patch

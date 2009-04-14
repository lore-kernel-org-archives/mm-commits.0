From: akpm@linux-foundation.org
Subject: + staging-stlc45xx-replace-print_mac-with-%pm.patch added to -mm tree
Date: Tue, 14 Apr 2009 16:54:05 -0700
Message-ID: <200904142354.n3ENs5qa004806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754944AbZDNXzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 19:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, greg@kroah.com


The patch titled
     stlc45xx: replace print_mac with %pM
has been added to the -mm tree.  Its filename is
     staging-stlc45xx-replace-print_mac-with-%pm.patch

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
Subject: stlc45xx: replace print_mac with %pM
From: Alexander Beregalov <a.beregalov@gmail.com>

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/stlc45xx/stlc45xx.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/staging/stlc45xx/stlc45xx.c~staging-stlc45xx-replace-print_mac-with-%pm drivers/staging/stlc45xx/stlc45xx.c
--- a/drivers/staging/stlc45xx/stlc45xx.c~staging-stlc45xx-replace-print_mac-with-%pm
+++ a/drivers/staging/stlc45xx/stlc45xx.c
@@ -1787,7 +1787,6 @@ static int stlc45xx_tx_pspoll(struct stl
 	int payload_len, padding, i;
 	struct s_lm_data_out *data;
 	struct txbuffer *entry;
-	DECLARE_MAC_BUF(mac);
 	struct sk_buff *skb;
 	char *payload;
 	u16 fc;
@@ -1813,8 +1812,8 @@ static int stlc45xx_tx_pspoll(struct stl
 	memcpy(pspoll->addr1, stlc->bssid, ETH_ALEN);
 	memcpy(pspoll->addr2, stlc->mac_addr, ETH_ALEN);
 
-	stlc45xx_debug(DEBUG_PSM, "sending PS-Poll frame to %s (powersave %d, "
-		       "fc 0x%x, aid %d)", print_mac(mac, pspoll->addr1),
+	stlc45xx_debug(DEBUG_PSM, "sending PS-Poll frame to %pM (powersave %d, "
+		       "fc 0x%x, aid %d)", pspoll->addr1,
 		       powersave, fc, stlc->aid);
 
 	spin_lock_bh(&stlc->tx_lock);
@@ -1903,7 +1902,6 @@ static int stlc45xx_tx_nullfunc(struct s
 	int payload_len, padding, i;
 	struct s_lm_data_out *data;
 	struct txbuffer *entry;
-	DECLARE_MAC_BUF(mac);
 	struct sk_buff *skb;
 	char *payload;
 	u16 fc;
@@ -1928,9 +1926,8 @@ static int stlc45xx_tx_nullfunc(struct s
 	memcpy(nullfunc->addr2, stlc->mac_addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, stlc->bssid, ETH_ALEN);
 
-	stlc45xx_debug(DEBUG_PSM, "sending Null frame to %s (powersave %d, "
-		       "fc 0x%x)",
-		       print_mac(mac, nullfunc->addr1), powersave, fc);
+	stlc45xx_debug(DEBUG_PSM, "sending Null frame to %pM (powersave %d, "
+		       "fc 0x%x)", nullfunc->addr1, powersave, fc);
 
 	spin_lock_bh(&stlc->tx_lock);
 
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
linux-next.patch
agnx-replace-print_mac-with-%pm.patch
staging-stlc45xx-replace-print_mac-with-%pm.patch
reiserfs-fix-printk-format-warning.patch


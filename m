From: akpm@linux-foundation.org
Subject: + s2io-fix-__ucmpdi2-undefined.patch added to -mm tree
Date: Tue, 26 Jun 2007 00:01:45 -0700
Message-ID: <200706260701.l5Q71jQ3020501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46974 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbXFZHCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 03:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, Leonid.Grossman@neterion.com, Sivakumar.Subramani@neterion.com, Sreenivasa.Honnur@neterion.com, Sriram.Rapuru@neterion.com, jeff@garzik.org, ram.vepa@neterion.com, santosh.rastapur@neterion.com, shemminger@linux-foundation.org


The patch titled
     s2io: fix "__ucmpdi2" [drivers/net/s2io.ko] undefined!
has been added to the -mm tree.  Its filename is
     s2io-fix-__ucmpdi2-undefined.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s2io: fix "__ucmpdi2" [drivers/net/s2io.ko] undefined!
From: Olaf Hering <olaf@aepfle.de>

25805dcf9d83098cf5492117ad2669cd14cc9b24 adds two u64 >>= 48 followed by a
switch statement, so gcc emits a call to __ucmpdi2.

Prevent this via a cast to a smaller type (u8).

Cc: "Sivakumar Subramani" <Sivakumar.Subramani@neterion.com>
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>
Cc; "Leonid Grossman" <Leonid.Grossman@neterion.com>
Cc: "Rastapur Santosh" <santosh.rastapur@neterion.com>
Cc: "Ramkrishna Vepa" <ram.vepa@neterion.com>
Cc: "Sriram Rapuru" <Sriram.Rapuru@neterion.com>
Cc: "Sreenivasa Honnur" <Sreenivasa.Honnur@neterion.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/s2io.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/net/s2io.c~s2io-fix-__ucmpdi2-undefined drivers/net/s2io.c
--- a/drivers/net/s2io.c~s2io-fix-__ucmpdi2-undefined
+++ a/drivers/net/s2io.c
@@ -2878,6 +2878,7 @@ static void tx_intr_handler(struct fifo_
 	struct tx_curr_get_info get_info, put_info;
 	struct sk_buff *skb;
 	struct TxD *txdlp;
+	u8 err_mask;
 
 	get_info = fifo_data->tx_curr_get_info;
 	memcpy(&put_info, &fifo_data->tx_curr_put_info, sizeof(put_info));
@@ -2896,8 +2897,8 @@ static void tx_intr_handler(struct fifo_
 			}
 
 			/* update t_code statistics */
-			err >>= 48;
-			switch(err) {
+			err_mask = err >> 48;
+			switch(err_mask) {
 				case 2:
 					nic->mac_control.stats_info->sw_stat.
 							tx_buf_abort_cnt++;
@@ -6827,6 +6828,7 @@ static int rx_osm_handler(struct ring_in
 	u16 l3_csum, l4_csum;
 	unsigned long long err = rxdp->Control_1 & RXD_T_CODE;
 	struct lro *lro;
+	u8 err_mask;
 
 	skb->dev = dev;
 
@@ -6835,8 +6837,8 @@ static int rx_osm_handler(struct ring_in
 		if (err & 0x1) {
 			sp->mac_control.stats_info->sw_stat.parity_err_cnt++;
 		}
-		err >>= 48;
-		switch(err) {
+		err_mask = err >> 48;
+		switch(err_mask) {
 			case 1:
 				sp->mac_control.stats_info->sw_stat.
 				rx_parity_err_cnt++;
@@ -6889,9 +6891,9 @@ static int rx_osm_handler(struct ring_in
 		* Note that in this case, since checksum will be incorrect,
 		* stack will validate the same.
 		*/
-		if (err != 0x5) {
-			DBG_PRINT(ERR_DBG, "%s: Rx error Value: 0x%llx\n",
-				dev->name, err);
+		if (err_mask != 0x5) {
+			DBG_PRINT(ERR_DBG, "%s: Rx error Value: 0x%x\n",
+				dev->name, err_mask);
 			sp->stats.rx_crc_errors++;
 			sp->mac_control.stats_info->sw_stat.mem_freed 
 				+= skb->truesize;
_

Patches currently in -mm which might be from olaf@aepfle.de are

atyfb-fix-xclk-frequency-on-apple-ibook1.patch
fix-section-mismatch-in-chipsfb.patch
s2io-fix-__ucmpdi2-undefined.patch
keep-track-of-network-interface-renaming.patch

From: akpm@linux-foundation.org
Subject: - wireless-airo-waitbusy-wont-delay.patch removed from -mm tree
Date: Fri, 16 May 2008 15:54:29 -0700
Message-ID: <200805162254.m4GMsTZA003248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758235AbYEPWys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dcbw@redhat.com, mm-commits@vger.kernel.org


The patch titled
     wireless, airo: waitbusy() won't delay
has been removed from the -mm tree.  Its filename was
     wireless-airo-waitbusy-wont-delay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wireless, airo: waitbusy() won't delay
From: Roel Kluin <roel.kluin@gmail.com>

There will be no delay even when COMMAND_BUSY (defined 0x8000) is set:
0x8000 & (delay < 10000) will evaluate to 0 - when delay is 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/airo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/airo.c~wireless-airo-waitbusy-wont-delay drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~wireless-airo-waitbusy-wont-delay
+++ a/drivers/net/wireless/airo.c
@@ -2904,7 +2904,7 @@ EXPORT_SYMBOL(init_airo_card);
 
 static int waitbusy (struct airo_info *ai) {
 	int delay = 0;
-	while ((IN4500 (ai, COMMAND) & COMMAND_BUSY) & (delay < 10000)) {
+	while ((IN4500 (ai, COMMAND) & COMMAND_BUSY) && (delay < 10000)) {
 		udelay (10);
 		if ((++delay % 20) == 0)
 			OUT4500(ai, EVACK, EV_CLEARCOMMANDBUSY);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
ipg-fix-receivemode-ipg_rm_receivemulticasthash-in-ipg_nic_set_multicast_list.patch
fec_mpc52xx-mpc52xx_messages_default-2nd-netif_msg_ifdown-=-ifup.patch
wireless-airo-waitbusy-wont-delay-checkpatch-fixes.patch
pcmcia-ti113x-fix-ene_test_c9_pfenable-definition.patch


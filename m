From: akpm@linux-foundation.org
Subject: - memstick-try-harder-to-recover-from-unsuccessful-interface-mode-switch.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:22:01 -0700
Message-ID: <200803110322.m2B3M1i6019769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbYCKDWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: try harder to recover from unsuccessful interface mode switch
has been removed from the -mm tree.  Its filename was
     memstick-try-harder-to-recover-from-unsuccessful-interface-mode-switch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: try harder to recover from unsuccessful interface mode switch
From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-try-harder-to-recover-from-unsuccessful-interface-mode-switch drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-try-harder-to-recover-from-unsuccessful-interface-mode-switch
+++ a/drivers/memstick/core/mspro_block.c
@@ -16,6 +16,7 @@
 #include <linux/idr.h>
 #include <linux/hdreg.h>
 #include <linux/kthread.h>
+#include <linux/delay.h>
 #include <linux/memstick.h>
 
 #define DRIVER_NAME "mspro_block"
@@ -820,7 +821,7 @@ static int mspro_block_switch_to_paralle
 	struct memstick_host *host = card->host;
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	struct mspro_param_register param = {
-		.system = 0,
+		.system = MEMSTICK_SYS_PAR4,
 		.data_count = 0,
 		.data_address = 0,
 		.tpc_param = 0
@@ -845,8 +846,24 @@ static int mspro_block_switch_to_paralle
 	wait_for_completion(&card->mrq_complete);
 
 	if (card->current_mrq.error) {
-		msb->system = 0x80;
+		msb->system = MEMSTICK_SYS_SERIAL;
+		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+		msleep(1000);
+		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
 		host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
+
+		if (memstick_set_rw_addr(card))
+			return card->current_mrq.error;
+
+		param.system = msb->system;
+
+		card->next_request = h_mspro_block_req_init;
+		msb->mrq_handler = h_mspro_block_default;
+		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG, &param,
+				  sizeof(param));
+		memstick_new_req(host);
+		wait_for_completion(&card->mrq_complete);
+
 		return -EFAULT;
 	}
 
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch
fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch


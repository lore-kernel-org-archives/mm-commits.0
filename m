From: akpm@linux-foundation.org
Subject: - net-ehea-locking-order-correction.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:18:48 -0700
Message-ID: <200803312018.m2VKImq0024084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754773AbYCaUeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:34:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, jeff@garzik.org, raisch@de.ibm.com, themann@de.ibm.com, tklein@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     netdev: ehea: locking order correction
has been removed from the -mm tree.  Its filename was
     net-ehea-locking-order-correction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netdev: ehea: locking order correction
From: Daniel Walker <dwalker@mvista.com>

Nested locks always need to be taken in the same order.  This change factors
out the ehea_fw_handles.lock to make the locking order consistent.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: Jan-Bernd Themann <themann@de.ibm.com>
Cc: Thomas Klein <tklein@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/ehea/ehea_main.c~net-ehea-locking-order-correction drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~net-ehea-locking-order-correction
+++ a/drivers/net/ehea/ehea_main.c
@@ -2567,14 +2567,14 @@ static int ehea_down(struct net_device *
 	if (port->state == EHEA_PORT_DOWN)
 		return 0;
 
+	mutex_lock(&ehea_fw_handles.lock);
+
 	down(&ehea_bcmc_regs.lock);
 	ehea_drop_multicast_list(dev);
 	ehea_broadcast_reg_helper(port, H_DEREG_BCMC);
 
 	ehea_free_interrupts(dev);
 
-	mutex_lock(&ehea_fw_handles.lock);

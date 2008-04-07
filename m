From: akpm@linux-foundation.org
Subject: + ehea-fix-dlpar-memory-add-support.patch added to -mm tree
Date: Mon, 07 Apr 2008 16:57:33 -0700
Message-ID: <200804072357.m37NvX5n031465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753258AbYDGX5v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 19:57:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: osstklei@de.ibm.com, jeff@garzik.org, tklein@de.ibm.com


The patch titled
     ehea: fix DLPAR memory add support
has been added to the -mm tree.  Its filename is
     ehea-fix-dlpar-memory-add-support.patch

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
Subject: ehea: fix DLPAR memory add support
From: Thomas Klein <osstklei@de.ibm.com>

Fix two weaknesses in send/receive packet handling which may lead to kernel
panics during DLPAR memory add operations.

Signed-off-by: Thomas Klein <tklein@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea.h      |    3 ++-
 drivers/net/ehea/ehea_main.c |   24 ++++++++++++++++++++++--
 2 files changed, 24 insertions(+), 3 deletions(-)

diff -puN drivers/net/ehea/ehea.h~ehea-fix-dlpar-memory-add-support drivers/net/ehea/ehea.h
--- a/drivers/net/ehea/ehea.h~ehea-fix-dlpar-memory-add-support
+++ a/drivers/net/ehea/ehea.h
@@ -40,7 +40,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0089"
+#define DRV_VERSION	"EHEA_0090"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
@@ -371,6 +371,7 @@ struct ehea_port_res {
 	struct ehea_q_skb_arr rq2_skba;
 	struct ehea_q_skb_arr rq3_skba;
 	struct ehea_q_skb_arr sq_skba;
+	int sq_skba_size;
 	spinlock_t netif_queue;
 	int queue_stopped;
 	int swqe_refill_th;
diff -puN drivers/net/ehea/ehea_main.c~ehea-fix-dlpar-memory-add-support drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~ehea-fix-dlpar-memory-add-support
+++ a/drivers/net/ehea/ehea_main.c
@@ -350,7 +350,8 @@ static void ehea_refill_rq1(struct ehea_
 	pr->rq1_skba.os_skbs = 0;
 
 	if (unlikely(test_bit(__EHEA_STOP_XFER, &ehea_driver_flags))) {
-		pr->rq1_skba.index = index;
+		if (nr_of_wqes > 0)
+			pr->rq1_skba.index = index;
 		pr->rq1_skba.os_skbs = fill_wqes;
 		return;
 	}
@@ -1465,7 +1466,9 @@ static int ehea_init_port_res(struct ehe
 			  init_attr->act_nr_rwqes_rq2,
 			  init_attr->act_nr_rwqes_rq3);
 
-	ret = ehea_init_q_skba(&pr->sq_skba, init_attr->act_nr_send_wqes + 1);
+	pr->sq_skba_size = init_attr->act_nr_send_wqes + 1;
+
+	ret = ehea_init_q_skba(&pr->sq_skba, pr->sq_skba_size);
 	ret |= ehea_init_q_skba(&pr->rq1_skba, init_attr->act_nr_rwqes_rq1 + 1);
 	ret |= ehea_init_q_skba(&pr->rq2_skba, init_attr->act_nr_rwqes_rq2 + 1);
 	ret |= ehea_init_q_skba(&pr->rq3_skba, init_attr->act_nr_rwqes_rq3 + 1);
@@ -2622,6 +2625,22 @@ void ehea_purge_sq(struct ehea_qp *orig_
 	}
 }
 
+void ehea_flush_sq(struct ehea_port *port)
+{
+	int i;
+
+	for (i = 0; i < port->num_def_qps + port->num_add_tx_qps; i++) {
+		struct ehea_port_res *pr = &port->port_res[i];
+		int swqe_max = pr->sq_skba_size - 2 - pr->swqe_ll_count;
+		int k = 0;
+		while (atomic_read(&pr->swqe_avail) < swqe_max) {
+			msleep(5);
+			if (++k == 20)
+				break;
+		}
+	}
+}
+
 int ehea_stop_qps(struct net_device *dev)
 {
 	struct ehea_port *port = netdev_priv(dev);
@@ -2849,6 +2868,7 @@ static void ehea_rereg_mrs(struct work_s
 				if (dev->flags & IFF_UP) {
 					mutex_lock(&port->port_lock);
 					netif_stop_queue(dev);
+					ehea_flush_sq(port);
 					ret = ehea_stop_qps(dev);
 					if (ret) {
 						mutex_unlock(&port->port_lock);
_

Patches currently in -mm which might be from osstklei@de.ibm.com are

ehea-fix-dlpar-memory-add-support.patch


From: akpm@linux-foundation.org
Subject: + cxgb3-recovery-from-hw-starvation-of-response-queue.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:47:47 -0800
Message-ID: <200702272047.l1RKlp8t027988@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51132 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbXB0UsZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:48:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: divy@chelsio.com


The patch titled
     cxgb3: recovery from HW starvation of response queue entries
has been added to the -mm tree.  Its filename is
     cxgb3-recovery-from-hw-starvation-of-response-queue.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cxgb3: recovery from HW starvation of response queue entries
From: Divy Le Ray <divy@chelsio.com>

Improve the traffic recovery after the HW ran out of response queue entries.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/adapter.h |    2 ++
 drivers/net/cxgb3/sge.c     |   15 ++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/net/cxgb3/adapter.h~cxgb3-recovery-from-hw-starvation-of-response-queue drivers/net/cxgb3/adapter.h
--- a/drivers/net/cxgb3/adapter.h~cxgb3-recovery-from-hw-starvation-of-response-queue
+++ a/drivers/net/cxgb3/adapter.h
@@ -121,6 +121,8 @@ struct sge_rspq {		/* state for an SGE r
 	unsigned long empty;	/* # of times queue ran out of credits */
 	unsigned long nomem;	/* # of responses deferred due to no mem */
 	unsigned long unhandled_irqs;	/* # of spurious intrs */
+	unsigned long starved;
+	unsigned long restarted;
 };
 
 struct tx_desc;
diff -puN drivers/net/cxgb3/sge.c~cxgb3-recovery-from-hw-starvation-of-response-queue drivers/net/cxgb3/sge.c
--- a/drivers/net/cxgb3/sge.c~cxgb3-recovery-from-hw-starvation-of-response-queue
+++ a/drivers/net/cxgb3/sge.c
@@ -2376,13 +2376,26 @@ static void sge_timer_cb(unsigned long d
 		spin_unlock(&qs->txq[TXQ_OFLD].lock);
 	}
 	lock = (adap->flags & USING_MSIX) ? &qs->rspq.lock :
-	    &adap->sge.qs[0].rspq.lock;
+					    &adap->sge.qs[0].rspq.lock;
 	if (spin_trylock_irq(lock)) {
 		if (!napi_is_scheduled(qs->netdev)) {
+			u32 status = t3_read_reg(adap, A_SG_RSPQ_FL_STATUS);
+
 			if (qs->fl[0].credits < qs->fl[0].size)
 				__refill_fl(adap, &qs->fl[0]);
 			if (qs->fl[1].credits < qs->fl[1].size)
 				__refill_fl(adap, &qs->fl[1]);
+
+			if (status & (1 << qs->rspq.cntxt_id)) {
+				qs->rspq.starved++;
+				if (qs->rspq.credits) {
+					refill_rspq(adap, &qs->rspq, 1);
+					qs->rspq.credits--;
+					qs->rspq.restarted++;
+					t3_write_reg(adap, A_SG_RSPQ_FL_STATUS,
+						     1 << qs->rspq.cntxt_id);
+				}
+			}
 		}
 		spin_unlock_irq(lock);
 	}
_

Patches currently in -mm which might be from divy@chelsio.com are

cxgb3-manage-sysfs-attributes-per-port.patch
cxgb3-private-ioctl-cleanup.patch
cxgb3-fw-version-update.patch
cxgb3-unmap-offload-packets-when-they-are-freed.patch
cxgb3-recovery-from-hw-starvation-of-response-queue.patch
cxgb3-feed-rx-free-list-with-pages.patch
cxgb3-add-sw-lro-support.patch

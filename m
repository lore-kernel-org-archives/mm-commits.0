From: akpm@linux-foundation.org
Subject: - ehca-ret-is-unsigned-ibmebus_request_irq-negative-return-ignored-in-hca_create_eq.patch removed from -mm tree
Date: Wed, 14 May 2008 16:46:47 -0700
Message-ID: <200805142346.m4ENkluC027915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbYENXs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 19:48:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, fenkes@de.ibm.com, hnguyen@de.ibm.com, jeff@garzik.org, paulus@samba.org, stefan.roscher@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ehca: ret is unsigned, ibmebus_request_irq() negative return ignored in hca_create_eq()
has been removed from the -mm tree.  Its filename was
     ehca-ret-is-unsigned-ibmebus_request_irq-negative-return-ignored-in-hca_create_eq.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ehca: ret is unsigned, ibmebus_request_irq() negative return ignored in hca_create_eq()
From: Roel Kluin <12o3l@tiscali.nl>


Cc: Joachim Fenkes <fenkes@de.ibm.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Heiko J Schick <schickhj.ibm.com>
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ehca/ehca_eq.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/infiniband/hw/ehca/ehca_eq.c~ehca-ret-is-unsigned-ibmebus_request_irq-negative-return-ignored-in-hca_create_eq drivers/infiniband/hw/ehca/ehca_eq.c
--- a/drivers/infiniband/hw/ehca/ehca_eq.c~ehca-ret-is-unsigned-ibmebus_request_irq-negative-return-ignored-in-hca_create_eq
+++ a/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -60,6 +60,7 @@ int ehca_create_eq(struct ehca_shca *shc
 	u32 i;
 	void *vpage;
 	struct ib_device *ib_dev = &shca->ib_device;
+	int ret2;
 
 	spin_lock_init(&eq->spinlock);
 	spin_lock_init(&eq->irq_spinlock);
@@ -122,18 +123,18 @@ int ehca_create_eq(struct ehca_shca *shc
 
 	/* register interrupt handlers and initialize work queues */
 	if (type == EHCA_EQ) {
-		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
+		ret2 = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
 					  IRQF_DISABLED, "ehca_eq",
 					  (void *)shca);
-		if (ret < 0)
+		if (ret2 < 0)
 			ehca_err(ib_dev, "Can't map interrupt handler.");
 
 		tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
 	} else if (type == EHCA_NEQ) {
-		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
+		ret2 = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
 					  IRQF_DISABLED, "ehca_neq",
 					  (void *)shca);
-		if (ret < 0)
+		if (ret2 < 0)
 			ehca_err(ib_dev, "Can't map interrupt handler.");
 
 		tasklet_init(&eq->interrupt_task, ehca_tasklet_neq, (long)shca);
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
gigaset-gigaset_isowbuf_getbytes-may-return-signed-unnoticed.patch
ehca-ret-is-unsigned-ibmebus_request_irq-negative-return-ignored-in-hca_create_eq.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
aty128fb-test-below-0-on-unsigned-pll-post_divider.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
vga16fb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch


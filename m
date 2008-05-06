From: akpm@linux-foundation.org
Subject: + ehca-ret-is-unsigned-ibmebus_request_irq-negative-return-ignored-in-hca_create_eq.patch added to -mm tree
Date: Tue, 06 May 2008 14:53:56 -0700
Message-ID: <200805062153.m46LruHC029288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758798AbYEFVzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 17:55:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, fenkes@de.ibm.com, hnguyen@de.ibm.com, jeff@garzik.org, paulus@samba.org, stefan.roscher@de.ibm.com


The patch titled
     ehca: ret is unsigned, ibmebus_request_irq() negative return ignored in hca_create_eq()
has been added to the -mm tree.  Its filename is
     ehca-ret-is-unsigned-ibmebus_request_irq-negative-return-ignored-in-hca_create_eq.patch

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

linux-next.patch
ehca-ret-is-unsigned-ibmebus_request_irq-negative-return-ignored-in-hca_create_eq.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
spi_mpc83xx-much-improved-driver.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch


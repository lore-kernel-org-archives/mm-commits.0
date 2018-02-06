From: akpm@linux-foundation.org
Subject: [patch 064/114] rapidio: adjust 12 checks for null
 pointers
Date: Tue, 06 Feb 2018 15:39:44 -0800
Message-ID: <20180206233944.E1Cp69gxK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932067AbeBFXjq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:39:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.bounine@idt.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, mporter@kernel.crashing.org, torvalds@linux-foundation.org

From: Markus Elfring <elfring@users.sourceforge.net>
Subject: rapidio: adjust 12 checks for null pointers

checkpatch pointed information out like the following.

Comparison to NULL could be written ...

Thus fix the affected source code places.

Link: http://lkml.kernel.org/r/739f9f1c-3ebe-c21b-c5e2-31976cfbc0ee@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-adjust-12-checks-for-null-pointers drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-adjust-12-checks-for-null-pointers
+++ a/drivers/rapidio/rio.c
@@ -243,7 +243,7 @@ int rio_request_inb_mbox(struct rio_mpor
 	int rc = -ENOSYS;
 	struct resource *res;
 
-	if (mport->ops->open_inb_mbox == NULL)
+	if (!mport->ops->open_inb_mbox)
 		goto out;
 
 	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
@@ -326,7 +326,7 @@ int rio_request_outb_mbox(struct rio_mpo
 	int rc = -ENOSYS;
 	struct resource *res;
 
-	if (mport->ops->open_outb_mbox == NULL)
+	if (!mport->ops->open_outb_mbox)
 		goto out;
 
 	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
@@ -632,7 +632,7 @@ int rio_request_inb_pwrite(struct rio_de
 	int rc = 0;
 
 	spin_lock(&rio_global_list_lock);
-	if (rdev->pwcback != NULL)
+	if (rdev->pwcback)
 		rc = -ENOMEM;
 	else
 		rdev->pwcback = pwcback;
@@ -975,7 +975,7 @@ rio_chk_dev_route(struct rio_dev *rdev,
 		rdev = rdev->prev;
 	}
 
-	if (prev == NULL)
+	if (!prev)
 		goto err_out;
 
 	p_port = prev->rswitch->route_table[rdev->destid];
@@ -1054,7 +1054,7 @@ rio_get_input_status(struct rio_dev *rde
 		RIO_MNT_REQ_CMD_IS);
 
 	/* Exit if the response is not expected */
-	if (lnkresp == NULL)
+	if (!lnkresp)
 		return 0;
 
 	checkcount = 3;
@@ -1696,7 +1696,7 @@ int rio_route_add_entry(struct rio_dev *
 
 	spin_lock(&rdev->rswitch->lock);
 
-	if (ops == NULL || ops->add_entry == NULL) {
+	if (!ops || !ops->add_entry) {
 		rc = rio_std_route_add_entry(rdev->net->hport, rdev->destid,
 					     rdev->hopcount, table,
 					     route_destid, route_port);
@@ -1749,7 +1749,7 @@ int rio_route_get_entry(struct rio_dev *
 
 	spin_lock(&rdev->rswitch->lock);
 
-	if (ops == NULL || ops->get_entry == NULL) {
+	if (!ops || !ops->get_entry) {
 		rc = rio_std_route_get_entry(rdev->net->hport, rdev->destid,
 					     rdev->hopcount, table,
 					     route_destid, route_port);
@@ -1797,7 +1797,7 @@ int rio_route_clr_table(struct rio_dev *
 
 	spin_lock(&rdev->rswitch->lock);
 
-	if (ops == NULL || ops->clr_table == NULL) {
+	if (!ops || !ops->clr_table) {
 		rc = rio_std_route_clr_table(rdev->net->hport, rdev->destid,
 					     rdev->hopcount, table);
 	} else if (try_module_get(ops->owner)) {
@@ -1889,7 +1889,7 @@ struct dma_async_tx_descriptor *rio_dma_
 {
 	struct rio_dma_ext rio_ext;
 
-	if (dchan->device->device_prep_slave_sg == NULL) {
+	if (!dchan->device->device_prep_slave_sg) {
 		pr_err("%s: prep_rio_sg == NULL\n", __func__);
 		return NULL;
 	}
_

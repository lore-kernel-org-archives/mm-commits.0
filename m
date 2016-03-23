From: akpm@linux-foundation.org
Subject: [merged] rapidio-add-lock-protection-for-doorbell-list.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:41:48 -0700
Message-ID: <56f2d55c.HnGCTGtVYd8eGOdd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbcCWRlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: add lock protection for doorbell list
has been removed from the -mm tree.  Its filename was
     rapidio-add-lock-protection-for-doorbell-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: add lock protection for doorbell list

Add lock protection around doorbell list handling to prevent list
corruption on SMP platforms.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    9 ++++++---
 include/linux/rio.h   |    2 ++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-add-lock-protection-for-doorbell-list drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-lock-protection-for-doorbell-list
+++ a/drivers/rapidio/rio.c
@@ -362,7 +362,9 @@ rio_setup_inb_dbell(struct rio_mport *mp
 	dbell->dinb = dinb;
 	dbell->dev_id = dev_id;
 
+	mutex_lock(&mport->lock);
 	list_add_tail(&dbell->node, &mport->dbells);
+	mutex_unlock(&mport->lock);
 
       out:
 	return rc;
@@ -426,12 +428,15 @@ int rio_release_inb_dbell(struct rio_mpo
 	int rc = 0, found = 0;
 	struct rio_dbell *dbell;
 
+	mutex_lock(&mport->lock);
 	list_for_each_entry(dbell, &mport->dbells, node) {
 		if ((dbell->res->start == start) && (dbell->res->end == end)) {
+			list_del(&dbell->node);
 			found = 1;
 			break;
 		}
 	}
+	mutex_unlock(&mport->lock);
 
 	/* If we can't find an exact match, fail */
 	if (!found) {
@@ -439,9 +444,6 @@ int rio_release_inb_dbell(struct rio_mpo
 		goto out;
 	}
 
-	/* Delete from list */
-	list_del(&dbell->node);
-
 	/* Release the doorbell resource */
 	rc = release_resource(dbell->res);
 
@@ -2024,6 +2026,7 @@ int rio_mport_initialize(struct rio_mpor
 	mport->id = next_portid++;
 	mport->host_deviceid = rio_get_hdid(mport->id);
 	mport->nscan = NULL;
+	mutex_init(&mport->lock);
 
 	return 0;
 }
diff -puN include/linux/rio.h~rapidio-add-lock-protection-for-doorbell-list include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-lock-protection-for-doorbell-list
+++ a/include/linux/rio.h
@@ -248,6 +248,7 @@ enum rio_phy_type {
  * @node: Node in global list of master ports
  * @nnode: Node in network list of master ports
  * @net: RIO net this mport is attached to
+ * @lock: lock to synchronize lists manipulations
  * @iores: I/O mem resource that this master port interface owns
  * @riores: RIO resources that this master port interfaces owns
  * @inb_msg: RIO inbound message event descriptors
@@ -271,6 +272,7 @@ struct rio_mport {
 	struct list_head node;	/* node in global list of ports */
 	struct list_head nnode;	/* node in net list of ports */
 	struct rio_net *net;	/* RIO net this mport is attached to */
+	struct mutex lock;
 	struct resource iores;
 	struct resource riores[RIO_MAX_MPORT_RESOURCES];
 	struct rio_msg inb_msg[RIO_MAX_MBOX];
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are



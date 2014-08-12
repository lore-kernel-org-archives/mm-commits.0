From: akpm@linux-foundation.org
Subject: [merged] ipw2100-use-pci_zalloc_consistent.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:42:45 -0700
Message-ID: <53ea6e35.4xbSJug7/ylqgpQK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:58332 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbaHLTmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:46 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1921048obb.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linville@tuxdriver.com, stas.yakovlev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipw2100: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     ipw2100-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ipw2100: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ipw2x00/ipw2100.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN drivers/net/wireless/ipw2x00/ipw2100.c~ipw2100-use-pci_zalloc_consistent drivers/net/wireless/ipw2x00/ipw2100.c
--- a/drivers/net/wireless/ipw2x00/ipw2100.c~ipw2100-use-pci_zalloc_consistent
+++ a/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -3449,8 +3449,9 @@ static int ipw2100_msg_allocate(struct i
 		return -ENOMEM;
 
 	for (i = 0; i < IPW_COMMAND_POOL_SIZE; i++) {
-		v = pci_alloc_consistent(priv->pci_dev,
-					 sizeof(struct ipw2100_cmd_header), &p);
+		v = pci_zalloc_consistent(priv->pci_dev,
+					  sizeof(struct ipw2100_cmd_header),
+					  &p);
 		if (!v) {
 			printk(KERN_ERR DRV_NAME ": "
 			       "%s: PCI alloc failed for msg "
@@ -3459,8 +3460,6 @@ static int ipw2100_msg_allocate(struct i
 			break;
 		}
 
-		memset(v, 0, sizeof(struct ipw2100_cmd_header));
-
 		priv->msg_buffers[i].type = COMMAND;
 		priv->msg_buffers[i].info.c_struct.cmd =
 		    (struct ipw2100_cmd_header *)v;
@@ -4336,16 +4335,12 @@ static int status_queue_allocate(struct
 	IPW_DEBUG_INFO("enter\n");
 
 	q->size = entries * sizeof(struct ipw2100_status);
-	q->drv =
-	    (struct ipw2100_status *)pci_alloc_consistent(priv->pci_dev,
-							  q->size, &q->nic);
+	q->drv = pci_zalloc_consistent(priv->pci_dev, q->size, &q->nic);
 	if (!q->drv) {
 		IPW_DEBUG_WARNING("Can not allocate status queue.\n");
 		return -ENOMEM;
 	}
 
-	memset(q->drv, 0, q->size);
-
 	IPW_DEBUG_INFO("exit\n");
 
 	return 0;
@@ -4374,13 +4369,12 @@ static int bd_queue_allocate(struct ipw2
 
 	q->entries = entries;
 	q->size = entries * sizeof(struct ipw2100_bd);
-	q->drv = pci_alloc_consistent(priv->pci_dev, q->size, &q->nic);
+	q->drv = pci_zalloc_consistent(priv->pci_dev, q->size, &q->nic);
 	if (!q->drv) {
 		IPW_DEBUG_INFO
 		    ("can't allocate shared memory for buffer descriptors\n");
 		return -ENOMEM;
 	}
-	memset(q->drv, 0, q->size);
 
 	IPW_DEBUG_INFO("exit\n");
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch


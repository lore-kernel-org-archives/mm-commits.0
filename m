From: akpm@linux-foundation.org
Subject: - cxgb2-handle-possible-null-pointer-dereferencing-take-2.patch removed from -mm tree
Date: Tue, 26 Jun 2007 23:59:52 -0700
Message-ID: <200706270703.l5R73p4g011959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47031 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbXF0HD7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 03:03:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pradeep.rautela@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cxgb2: handle possible NULL pointer dereferencing
has been removed from the -mm tree.  Its filename was
     cxgb2-handle-possible-null-pointer-dereferencing-take-2.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: cxgb2: handle possible NULL pointer dereferencing
From: "pradeep singh" <pradeep.rautela@gmail.com>

Signed-off-by: Pradeep Singh <pradeep.rautela@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/chelsio/cxgb2.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/net/chelsio/cxgb2.c~cxgb2-handle-possible-null-pointer-dereferencing-take-2 drivers/net/chelsio/cxgb2.c
--- a/drivers/net/chelsio/cxgb2.c~cxgb2-handle-possible-null-pointer-dereferencing-take-2
+++ a/drivers/net/chelsio/cxgb2.c
@@ -1022,6 +1022,11 @@ static int __devinit init_one(struct pci
 	mmio_start = pci_resource_start(pdev, 0);
 	mmio_len = pci_resource_len(pdev, 0);
 	bi = t1_get_board_info(ent->driver_data);
+	if (!bi) {
+		CH_ERR("%s: Board info array index out of range\n",
+			pci_name(pdev));
+		goto out_disable_pdev;
+	}
 
 	for (i = 0; i < bi->port_number; ++i) {
 		struct net_device *netdev;
_

Patches currently in -mm which might be from pradeep.rautela@gmail.com are

cxgb2-handle-possible-null-pointer-dereferencing-take-2.patch

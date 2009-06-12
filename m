From: akpm@linux-foundation.org
Subject: [merged] pci-eliminate-redundant-pci_stop_dev-call-from-pci_destroy_dev.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:22:37 -0700
Message-ID: <200906121822.n5CIMbeg031354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755350AbZFLSZl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:25:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci: eliminate redundant pci_stop_dev() call from pci_destroy_dev()
has been removed from the -mm tree.  Its filename was
     pci-eliminate-redundant-pci_stop_dev-call-from-pci_destroy_dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: eliminate redundant pci_stop_dev() call from pci_destroy_dev()
From: Alex Chiang <achiang@hp.com>

We always call pci_stop_bus_device before calling pci_destroy_dev.

Since pci_stop_bus_device calls pci_stop_dev, there is no need
for pci_destroy_dev to repeat the call.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/remove.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/pci/remove.c~pci-eliminate-redundant-pci_stop_dev-call-from-pci_destroy_dev drivers/pci/remove.c
--- a/drivers/pci/remove.c~pci-eliminate-redundant-pci_stop_dev-call-from-pci_destroy_dev
+++ a/drivers/pci/remove.c
@@ -32,8 +32,6 @@ static void pci_stop_dev(struct pci_dev 
 
 static void pci_destroy_dev(struct pci_dev *dev)
 {
-	pci_stop_dev(dev);

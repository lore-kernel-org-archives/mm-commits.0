From: akpm@linux-foundation.org
Subject: - tifm-clear-interrupt-mask-bits-before-setting-them-on-adapter-init.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:21:55 -0700
Message-ID: <200803110321.m2B3Ltfq019758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbYCKDV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:21:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     tifm: clear interrupt mask bits before setting them on adapter init
has been removed from the -mm tree.  Its filename was
     tifm-clear-interrupt-mask-bits-before-setting-them-on-adapter-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tifm: clear interrupt mask bits before setting them on adapter init
From: Alex Dubov <oakad@yahoo.com>

This should improve reliability of detection of cards already in socket on
driver load.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/tifm_7xx1.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/misc/tifm_7xx1.c~tifm-clear-interrupt-mask-bits-before-setting-them-on-adapter-init drivers/misc/tifm_7xx1.c
--- a/drivers/misc/tifm_7xx1.c~tifm-clear-interrupt-mask-bits-before-setting-them-on-adapter-init
+++ a/drivers/misc/tifm_7xx1.c
@@ -368,6 +368,8 @@ static int tifm_7xx1_probe(struct pci_de
 		goto err_out_irq;
 
 	writel(TIFM_IRQ_ENABLE | TIFM_IRQ_SOCKMASK((1 << fm->num_sockets) - 1),
+	       fm->addr + FM_CLEAR_INTERRUPT_ENABLE);
+	writel(TIFM_IRQ_ENABLE | TIFM_IRQ_SOCKMASK((1 << fm->num_sockets) - 1),
 	       fm->addr + FM_SET_INTERRUPT_ENABLE);
 	return 0;
 
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch
fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch


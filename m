From: akpm@linux-foundation.org
Subject: [merged] alpha-use-printk_once.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:44:20 -0700
Message-ID: <200909222044.n8MKiKgn013406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270AbZIVUoX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:44:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: use printk_once
has been removed from the -mm tree.  Its filename was
     alpha-use-printk_once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: use printk_once
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/alpha/kernel/pci_iommu.c~alpha-use-printk_once arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-use-printk_once
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -268,11 +268,7 @@ pci_map_single_1(struct pci_dev *pdev, v
 	   assume it doesn't support sg mapping, and, since we tried to
 	   use direct_map above, it now must be considered an error. */
 	if (! alpha_mv.mv_pci_tbi) {
-		static int been_here = 0; /* Only print the message once. */
-		if (!been_here) {
-		    printk(KERN_WARNING "pci_map_single: no HW sg\n");
-		    been_here = 1;
-		}
+		printk_once(KERN_WARNING "pci_map_single: no HW sg\n");
 		return 0;
 	}
 
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
linux-next.patch
ia64-use-printk_once.patch
ide-use-printk_once.patch
cciss-fix-schedule_timeout-parameters.patch


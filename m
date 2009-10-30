From: akpm@linux-foundation.org
Subject: [merged] edac-i5400-fix-missing-config_pci-define.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:51:42 -0700
Message-ID: <200910302051.n9UKpgoJ013537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932576AbZJ3UwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:52:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iws@ovro.caltech.edu, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: i5400 fix missing CONFIG_PCI define
has been removed from the -mm tree.  Its filename was
     edac-i5400-fix-missing-config_pci-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: i5400 fix missing CONFIG_PCI define
From: Ira W. Snyder <iws@ovro.caltech.edu>

When building without CONFIG_PCI the edac_pci_idx variable is unused,
causing a build-time warning.  Wrap the variable in #ifdef CONFIG_PCI,
just like the rest of the PCI support.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/edac/mpc85xx_edac.c~edac-i5400-fix-missing-config_pci-define drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-i5400-fix-missing-config_pci-define
+++ a/drivers/edac/mpc85xx_edac.c
@@ -26,7 +26,9 @@
 #include "mpc85xx_edac.h"
 
 static int edac_dev_idx;
+#ifdef CONFIG_PCI
 static int edac_pci_idx;
+#endif
 static int edac_mc_idx;
 
 static u32 orig_ddr_err_disable;
_

Patches currently in -mm which might be from iws@ovro.caltech.edu are

origin.patch


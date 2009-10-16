From: akpm@linux-foundation.org
Subject: + edac-i5400-fix-missing-config_pci-define.patch added to -mm tree
Date: Thu, 15 Oct 2009 20:39:38 -0700
Message-ID: <200910160339.n9G3dcAD015008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbZJPDkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 23:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: iws@ovro.caltech.edu, dougthompson@xmission.com


The patch titled
     edac: i5400 fix missing CONFIG_PCI define
has been added to the -mm tree.  Its filename is
     edac-i5400-fix-missing-config_pci-define.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/edac/mpc85xx_edac.c |    2 ++
 1 file changed, 2 insertions(+)

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

edac-i5400-fix-missing-config_pci-define.patch


From: akpm@linux-foundation.org
Subject: + edac-mpc85xx-fix-mpc85xx-dependency.patch added to -mm tree
Date: Wed, 07 Jul 2010 14:45:19 -0700
Message-ID: <201007072145.o67LjJ8O028411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758008Ab0GGVp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2010 17:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, djiang@mvista.com, dougthompson@xmission.com, galak@kernel.crashing.org, ptyser@xes-inc.com, stable@kernel.org


The patch titled
     edac: mpc85xx: fix MPC85xx dependency
has been added to the -mm tree.  Its filename is
     edac-mpc85xx-fix-mpc85xx-dependency.patch

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
Subject: edac: mpc85xx: fix MPC85xx dependency
From: Anton Vorontsov <avorontsov@mvista.com>

Since commit 5753c082f66eca5be81f6bda85c1718c5eea6ada ("powerpc/85xx:
Kconfig cleanup"), there is no MPC85xx Kconfig symbol anymore, so the
driver became non-selectable.

This patch fixes the issue by switching to PPC_85xx symbol.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Peter Tyser <ptyser@xes-inc.com>
Cc: Dave Jiang <djiang@mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/Kconfig~edac-mpc85xx-fix-mpc85xx-dependency drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-mpc85xx-fix-mpc85xx-dependency
+++ a/drivers/edac/Kconfig
@@ -209,7 +209,7 @@ config EDAC_I5100
 
 config EDAC_MPC85XX
 	tristate "Freescale MPC83xx / MPC85xx"
-	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || MPC85xx)
+	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || PPC_85xx)
 	help
 	  Support for error detection and correction on the Freescale
 	  MPC8349, MPC8560, MPC8540, MPC8548
_

Patches currently in -mm which might be from avorontsov@mvista.com are

edac-mpc85xx-fix-mpc85xx-dependency.patch
edac-mpc85xx-add-support-for-mpc8569-edac-controllers.patch
linux-next.patch
sdhci-pltfm-switch-to-module-device-table-matching.patch
sdhci-pltfm-reorganize-makefile-entries-to-support-soc-devices.patch
sdhci-pltfm-add-support-for-cns3xxx-soc-devices.patch


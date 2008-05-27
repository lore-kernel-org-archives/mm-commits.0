From: akpm@linux-foundation.org
Subject: - edac-mpc85xx-fix-building-as-a-module.patch removed from -mm tree
Date: Tue, 27 May 2008 00:28:08 -0700
Message-ID: <200805270728.m4R7S8g0014892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756019AbYE0HaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:30:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: galak@kernel.crashing.org, djiang@mvista.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: mpc85xx: fix building as a module
has been removed from the -mm tree.  Its filename was
     edac-mpc85xx-fix-building-as-a-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: mpc85xx: fix building as a module
From: Kumar Gala <galak@kernel.crashing.org>

including of <asm/mpc85xx.h> causes build problems since it doesn't exist.

Also removed warning:
drivers/edac/mpc85xx_edac.c:45: warning: 'mpc85xx_ctl_name' defined but not used

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Acked-by: Doug Thompson <dougthompson@xmission.com>
Acked-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-fix-building-as-a-module drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-fix-building-as-a-module
+++ a/drivers/edac/mpc85xx_edac.c
@@ -20,7 +20,6 @@
 
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
-#include <asm/mpc85xx.h>
 #include "edac_module.h"
 #include "edac_core.h"
 #include "mpc85xx_edac.h"
@@ -43,8 +42,6 @@ static u32 orig_pci_err_en;
 static u32 orig_l2_err_disable;
 static u32 orig_hid1;
 
-static const char *mpc85xx_ctl_name = "MPC85xx";

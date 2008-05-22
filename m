From: akpm@linux-foundation.org
Subject: + edac-mpc85xx-fix-building-as-a-module.patch added to -mm tree
Date: Wed, 21 May 2008 21:30:22 -0700
Message-ID: <200805220430.m4M4UMb5017037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570AbYEVEaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 00:30:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: galak@kernel.crashing.org, dougthompson@xmission.com


The patch titled
     edac: mpc85xx: fix building as a module
has been added to the -mm tree.  Its filename is
     edac-mpc85xx-fix-building-as-a-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: mpc85xx: fix building as a module
From: Kumar Gala <galak@kernel.crashing.org>

including of <asm/mpc85xx.h> causes build problems since it doesn't exist.

Also removed warning:
drivers/edac/mpc85xx_edac.c:45: warning: 'mpc85xx_ctl_name' defined but not used

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: Doug Thompson <dougthompson@xmission.com>
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

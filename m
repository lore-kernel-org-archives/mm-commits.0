From: akpm@linux-foundation.org
Subject: + omap_hsmmc-add-missing-probe-handler-hook.patch added to -mm tree
Date: Fri, 09 Oct 2009 15:47:49 -0700
Message-ID: <200910092247.n99Mloq0011732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934518AbZJIWsm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:48:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-roger.quadros@nokia.com, ext-denis.2.karpov@nokia.com, felipe.contreras@gmail.com, gregkh@suse.de, jkosina@suse.cz, madhu.cr@ti.com, tony@atomide.com


The patch titled
     omap_hsmmc: add missing probe handler hook
has been added to the -mm tree.  Its filename is
     omap_hsmmc-add-missing-probe-handler-hook.patch

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
Subject: omap_hsmmc: add missing probe handler hook
From: Roger Quadros <ext-roger.quadros@nokia.com>

The missing probe handler hook will never probe the driver. Add it back.
Fixes broken MMC on OMAP.

We use platform_driver_probe() API since omap_hsmmc is not a hot-pluggable
device.

Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
Tested-by: Felipe Contreras <felipe.contreras@gmail.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-add-missing-probe-handler-hook drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-add-missing-probe-handler-hook
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -2013,7 +2013,7 @@ static struct platform_driver omap_hsmmc
 static int __init omap_hsmmc_init(void)
 {
 	/* Register the MMC driver */
-	return platform_driver_register(&omap_hsmmc_driver);
+	return platform_driver_probe(&omap_hsmmc_driver, omap_hsmmc_probe);
 }
 
 static void __exit omap_hsmmc_cleanup(void)
_

Patches currently in -mm which might be from ext-roger.quadros@nokia.com are

omap_hsmmc-add-missing-probe-handler-hook.patch


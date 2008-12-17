From: akpm@linux-foundation.org
Subject: - ibmphp-fix-module-ref-count-underflow.patch removed from -mm tree
Date: Wed, 17 Dec 2008 12:48:38 -0800
Message-ID: <200812172048.mBHKmcED006922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbYLQUtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 15:49:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, gregkh@suse.de, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     ibmphp: fix module ref count underflow
has been removed from the -mm tree.  Its filename was
     ibmphp-fix-module-ref-count-underflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmphp: fix module ref count underflow
From: Neil Horman <nhorman@tuxdriver.com>

-ENOCHANGELOG (I changed my mind)

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/ibmphp_core.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/pci/hotplug/ibmphp_core.c~ibmphp-fix-module-ref-count-underflow drivers/pci/hotplug/ibmphp_core.c
--- a/drivers/pci/hotplug/ibmphp_core.c~ibmphp-fix-module-ref-count-underflow
+++ a/drivers/pci/hotplug/ibmphp_core.c
@@ -1402,10 +1402,6 @@ static int __init ibmphp_init(void)
 		goto error;
 	}
 
-	/* lock ourselves into memory with a module 
-	 * count of -1 so that no one can unload us. */
-	module_put(THIS_MODULE);

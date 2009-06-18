From: akpm@linux-foundation.org
Subject: [merged] edac-add-missing-__devexit_p.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:55 -0700
Message-ID: <200906182247.n5IMlt07006993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754730AbZFRW5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:57:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: add missing __devexit_p()
has been removed from the -mm tree.  Its filename was
     edac-add-missing-__devexit_p.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: add missing __devexit_p()
From: Mike Frysinger <vapier@gentoo.org>

The remove function uses __devexit, so the .remove assignment needs
__devexit_p() to fix a build error with hotplug disabled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/cell_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/cell_edac.c~edac-add-missing-__devexit_p drivers/edac/cell_edac.c
--- a/drivers/edac/cell_edac.c~edac-add-missing-__devexit_p
+++ a/drivers/edac/cell_edac.c
@@ -227,7 +227,7 @@ static struct platform_driver cell_edac_
 		.owner	= THIS_MODULE,
 	},
 	.probe		= cell_edac_probe,
-	.remove		= cell_edac_remove,
+	.remove		= __devexit_p(cell_edac_remove),
 };
 
 static int __init cell_edac_init(void)
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
istallion-add-missing-__devexit-marking.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch


From: akpm@linux-foundation.org
Subject: + edac-add-missing-__devexit_p.patch added to -mm tree
Date: Wed, 27 May 2009 23:21:18 -0700
Message-ID: <200905280621.n4S6LIoh031552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbZE1GVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:21:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dougthompson@xmission.com


The patch titled
     edac: add missing __devexit_p()
has been added to the -mm tree.  Its filename is
     edac-add-missing-__devexit_p.patch

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
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
plat_nand-add-missing-__devexit_p.patch
irda-new-blackfin-on-chip-sir-irda-driver.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch


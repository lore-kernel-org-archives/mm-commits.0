From: akpm@linux-foundation.org
Subject: + sm501-suspend-support-fix-fix.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:46:31 -0700
Message-ID: <200706231646.l5NGkVVw019451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55347 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756795AbXFWQrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:47:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@fluff.org, ben-linux@fluff.org


The patch titled
     SM501: only compile suspend/resume if CONFIG_PM
has been added to the -mm tree.  Its filename is
     sm501-suspend-support-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SM501: only compile suspend/resume if CONFIG_PM
From: Ben Dooks <ben@fluff.org>

The suspend and resume support only needs to be built if CONFIG_PM is
defined.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/mfd/sm501.c~sm501-suspend-support-fix-fix drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-suspend-support-fix-fix
+++ a/drivers/mfd/sm501.c
@@ -977,6 +977,7 @@ static int sm501_plat_probe(struct platf
 
 }
 
+#ifdef CONFIG_PM
 /* power management support */
 
 static int sm501_plat_suspend(struct platform_device *pdev, pm_message_t state)
@@ -1022,7 +1023,10 @@ static int sm501_plat_resume(struct plat
 
 	return 0;
 }
-
+#else
+#define sm501_plat_suspend NULL
+#define sm501_plat_resume NULL
+#endif
 
 /* Initialisation data for PCI devices */
 
_

Patches currently in -mm which might be from ben@fluff.org are

sm501-suspend-support-fix-fix.patch

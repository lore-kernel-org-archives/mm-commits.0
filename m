From: akpm@linux-foundation.org
Subject: + phy-implement-release-function-fix.patch added to -mm tree
Date: Tue, 04 Dec 2007 09:25:51 -0800
Message-ID: <200712041725.lB4HPptB028561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567AbXLDR1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 12:27:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, afleming@freescale.com, thierry.reding@avionic-design.de


The patch titled
     phy-implement-release-function fix
has been added to the -mm tree.  Its filename is
     phy-implement-release-function-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: phy-implement-release-function fix
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Makes sense, I think. Here is the newer patch, the only difference is
removed EXPORT_SYMBOL().

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Andy Fleming <afleming@freescale.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/phy/phy_device.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/net/phy/phy_device.c~phy-implement-release-function-fix drivers/net/phy/phy_device.c
--- a/drivers/net/phy/phy_device.c~phy-implement-release-function-fix
+++ a/drivers/net/phy/phy_device.c
@@ -48,7 +48,6 @@ void phy_device_free(struct phy_device *
 {
 	kfree(phydev);
 }
-EXPORT_SYMBOL(phy_device_free);
 
 static void phy_device_release(struct device *dev)
 {
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

phy-implement-release-function.patch
phy-implement-release-function-fix.patch
ucc_geth-fix-module-removal.patch
ucc_geth-add-support-for-netpoll.patch

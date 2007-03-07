From: akpm@linux-foundation.org
Subject: + ehea-strlcpy-is-smart-enough.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:16:23 -0800
Message-ID: <200703070116.l271GNvE015224@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41764 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161106AbXCGBRE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:17:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, osstklei@de.ibm.com, themann@de.ibm.com


The patch titled
     strlcpy is smart enough
has been added to the -mm tree.  Its filename is
     ehea-strlcpy-is-smart-enough.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: strlcpy is smart enough
From: Jean Delvare <khali@linux-fr.org>

strlcpy already accounts for the trailing zero in its length
computation, so there is no need to substract one to the buffer size.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jan-Bernd Themann <themann@de.ibm.com>
Cc: Thomas Klein <osstklei@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea_ethtool.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/ehea/ehea_ethtool.c~ehea-strlcpy-is-smart-enough drivers/net/ehea/ehea_ethtool.c
--- a/drivers/net/ehea/ehea_ethtool.c~ehea-strlcpy-is-smart-enough
+++ a/drivers/net/ehea/ehea_ethtool.c
@@ -144,8 +144,8 @@ static int ehea_nway_reset(struct net_de
 static void ehea_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver) - 1);
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version) - 1);
+	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static u32 ehea_get_msglevel(struct net_device *dev)
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
git-dvb.patch
scatterlisth-needs-typesh.patch
cleanup-the-includes-of-linux-pcih.patch
s390-strlcpy-is-smart-enough.patch
sound-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
xtensa-strlcpy-is-smart-enough.patch
ehea-strlcpy-is-smart-enough.patch

From: akpm@linux-foundation.org
Subject: - cxgb3-firwmare-update.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:39 -0700
Message-ID: <200704050200.l3520dDJ004840@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38061 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501AbXDECAt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: divy@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     cxgb3: firwmare update
has been removed from the -mm tree.  Its filename was
     cxgb3-firwmare-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cxgb3: firwmare update
From: Divy Le Ray <divy@chelsio.com>

Introduce FW micro version.
Bump up FW version to 3.3.0

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/cxgb3_main.c |    4 ++--
 drivers/net/cxgb3/version.h    |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/net/cxgb3/cxgb3_main.c~cxgb3-firwmare-update drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~cxgb3-firwmare-update
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -721,7 +721,7 @@ static void bind_qsets(struct adapter *a
 	}
 }
 
-#define FW_FNAME "t3fw-%d.%d.bin"
+#define FW_FNAME "t3fw-%d.%d.%d.bin"
 
 static int upgrade_fw(struct adapter *adap)
 {
@@ -731,7 +731,7 @@ static int upgrade_fw(struct adapter *ad
 	struct device *dev = &adap->pdev->dev;
 
 	snprintf(buf, sizeof(buf), FW_FNAME, FW_VERSION_MAJOR,
-		 FW_VERSION_MINOR);
+		 FW_VERSION_MINOR, FW_VERSION_MICRO);
 	ret = request_firmware(&fw, buf, dev);
 	if (ret < 0) {
 		dev_err(dev, "could not upgrade firmware: unable to load %s\n",
diff -puN drivers/net/cxgb3/version.h~cxgb3-firwmare-update drivers/net/cxgb3/version.h
--- a/drivers/net/cxgb3/version.h~cxgb3-firwmare-update
+++ a/drivers/net/cxgb3/version.h
@@ -36,6 +36,9 @@
 #define DRV_NAME "cxgb3"
 /* Driver version */
 #define DRV_VERSION "1.0-ko"
+
+/* Firmware version */
 #define FW_VERSION_MAJOR 3
-#define FW_VERSION_MINOR 2
+#define FW_VERSION_MINOR 3
+#define FW_VERSION_MICRO 0
 #endif				/* __CHELSIO_VERSION_H */
_

Patches currently in -mm which might be from divy@chelsio.com are

origin.patch

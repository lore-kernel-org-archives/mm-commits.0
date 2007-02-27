From: akpm@linux-foundation.org
Subject: + cxgb3-fw-version-update.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:47:41 -0800
Message-ID: <200702272047.l1RKlioD027980@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51113 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbXB0UsT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:48:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: divy@chelsio.com


The patch titled
     cxgb3: FW version update
has been added to the -mm tree.  Its filename is
     cxgb3-fw-version-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cxgb3: FW version update
From: Divy Le Ray <divy@chelsio.com>

Update FW version to 3.2

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/t3_hw.c   |    6 ++++--
 drivers/net/cxgb3/version.h |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/net/cxgb3/t3_hw.c~cxgb3-fw-version-update drivers/net/cxgb3/t3_hw.c
--- a/drivers/net/cxgb3/t3_hw.c~cxgb3-fw-version-update
+++ a/drivers/net/cxgb3/t3_hw.c
@@ -884,11 +884,13 @@ int t3_check_fw_version(struct adapter *
 	major = G_FW_VERSION_MAJOR(vers);
 	minor = G_FW_VERSION_MINOR(vers);
 
-	if (type == FW_VERSION_T3 && major == 3 && minor == 1)
+	if (type == FW_VERSION_T3 && major == FW_VERSION_MAJOR &&
+	    minor == FW_VERSION_MINOR)
 		return 0;
 
 	CH_ERR(adapter, "found wrong FW version(%u.%u), "
-	       "driver needs version 3.1\n", major, minor);
+	       "driver needs version %u.%u\n", major, minor,
+	       FW_VERSION_MAJOR, FW_VERSION_MINOR);
 	return -EINVAL;
 }
 
diff -puN drivers/net/cxgb3/version.h~cxgb3-fw-version-update drivers/net/cxgb3/version.h
--- a/drivers/net/cxgb3/version.h~cxgb3-fw-version-update
+++ a/drivers/net/cxgb3/version.h
@@ -36,4 +36,6 @@
 #define DRV_NAME "cxgb3"
 /* Driver version */
 #define DRV_VERSION "1.0"
+#define FW_VERSION_MAJOR 3
+#define FW_VERSION_MINOR 2
 #endif				/* __CHELSIO_VERSION_H */
_

Patches currently in -mm which might be from divy@chelsio.com are

cxgb3-manage-sysfs-attributes-per-port.patch
cxgb3-private-ioctl-cleanup.patch
cxgb3-fw-version-update.patch
cxgb3-unmap-offload-packets-when-they-are-freed.patch
cxgb3-recovery-from-hw-starvation-of-response-queue.patch
cxgb3-feed-rx-free-list-with-pages.patch
cxgb3-add-sw-lro-support.patch

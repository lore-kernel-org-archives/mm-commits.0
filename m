From: akpm@linux-foundation.org
Subject: - cciss-include-scsi-scsih-unconditionally.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:08 -0700
Message-ID: <200705090250.l492o81t009315@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970039AbXEICu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve.cameron@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: include scsi/scsi.h unconditionally
has been removed from the -mm tree.  Its filename was
     cciss-include-scsi-scsih-unconditionally.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: include scsi/scsi.h unconditionally
From: Stephen Cameron <steve.cameron@hp.com>

Make cciss unconditionally include scsi/scsi.h, because of the use of
SCSI_IOCTL_GET_IDLUN and SCSI_IOCTL_GET_BUS_NUMBER.

Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c      |    1 +
 drivers/block/cciss_scsi.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-include-scsi-scsih-unconditionally drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-include-scsi-scsih-unconditionally
+++ a/drivers/block/cciss.c
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
 #include <linux/completion.h>
+#include <scsi/scsi.h>
 #include <scsi/sg.h>
 #include <scsi/scsi_ioctl.h>
 #include <linux/cdrom.h>
diff -puN drivers/block/cciss_scsi.c~cciss-include-scsi-scsih-unconditionally drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c~cciss-include-scsi-scsih-unconditionally
+++ a/drivers/block/cciss_scsi.c
@@ -35,7 +35,6 @@
 
 #include <asm/atomic.h>
 
-#include <scsi/scsi.h> 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h> 
_

Patches currently in -mm which might be from steve.cameron@hp.com are

origin.patch

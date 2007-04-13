From: akpm@linux-foundation.org
Subject: + cciss-include-scsi-scsih-unconditionally.patch added to -mm tree
Date: Fri, 13 Apr 2007 14:33:58 -0700
Message-ID: <200704132133.l3DLXwiq009946@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53325 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030521AbXDMVeB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 17:34:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve.cameron@hp.com


The patch titled
     cciss: include scsi/scsi.h unconditionally
has been added to the -mm tree.  Its filename is
     cciss-include-scsi-scsih-unconditionally.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cciss: include scsi/scsi.h unconditionally
From: Stephen Cameron <steve.cameron@hp.com>

Make cciss unconditionally include scsi/scsi.h

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

cciss-reformat-error-handling.patch
cciss-add-sg_io-ioctl-to-cciss.patch
cciss-set-rq-errors-more-correctly-in-driver.patch
cciss-include-scsi-scsih-unconditionally.patch

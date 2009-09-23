From: akpm@linux-foundation.org
Subject: [merged] cciss-fix-schedule_timeout-parameters.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:05:44 -0700
Message-ID: <200909232005.n8NK5iKf023994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbZIWUKJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, Steve.Cameron@hp.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: fix schedule_timeout() parameters
has been removed from the -mm tree.  Its filename was
     cciss-fix-schedule_timeout-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix schedule_timeout() parameters
From: Randy Dunlap <randy.dunlap@oracle.com>

Change schedule_timeout() parameter to not be specific to HZ=1000.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: "Cameron, Steve" <Steve.Cameron@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-schedule_timeout-parameters drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-schedule_timeout-parameters
+++ a/drivers/block/cciss.c
@@ -36,6 +36,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
+#include <linux/jiffies.h>
 #include <linux/hdreg.h>
 #include <linux/spinlock.h>
 #include <linux/compat.h>
@@ -3489,7 +3490,7 @@ static int __devinit cciss_pci_init(ctlr
 		if (scratchpad == CCISS_FIRMWARE_READY)
 			break;
 		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(HZ / 10);	/* wait 100ms */
+		schedule_timeout(msecs_to_jiffies(100));	/* wait 100ms */
 	}
 	if (scratchpad != CCISS_FIRMWARE_READY) {
 		printk(KERN_WARNING "cciss: Board not ready.  Timed out.\n");
@@ -3615,7 +3616,7 @@ static int __devinit cciss_pci_init(ctlr
 			break;
 		/* delay and try again */
 		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(10);
+		schedule_timeout(msecs_to_jiffies(1));
 	}
 
 #ifdef CCISS_DEBUG
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
isdn-fix-netjet-build-errors.patch
include-linux-credh-fix-build.patch
scsi-fix-func-names-in-kernel-doc.patch
scsi_transport_fc-fix-missing-kernel-doc.patch
wl12xx-fix-kconfig-link-errors.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
docs-fix-various-documentation-paths-in-header-files.patch
reiser4-export-remove_from_page_cache-fix.patch


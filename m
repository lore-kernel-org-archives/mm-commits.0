From: akpm@linux-foundation.org
Subject: - fix-signedness-of-parameters-in-scsi-module.patch removed from -mm tree
Date: Sun, 23 Sep 2007 18:09:24 -0700
Message-ID: <200709240109.l8O19Opx002989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753736AbXIXBKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 23 Sep 2007 21:10:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jet@gyve.org, James.Bottomley@steeleye.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Fix signedness of parameters in scsi module
has been removed from the -mm tree.  Its filename was
     fix-signedness-of-parameters-in-scsi-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix signedness of parameters in scsi module
From: Masatake YAMATO <jet@gyve.org>

In scsi module I've found some inconsistency between variable type used in
module_param_named and type passed to module_param_named as an argument. 
Especially the inconsistency of `max_scsi_luns' parameter is a bit serious
because the description text says "last scsi LUN (should be between 1 and
2^32-1)".

Signed-off-by: Masatake YAMATO <jet@gyve.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_scan.c         |    6 +++---
 drivers/scsi/scsi_transport_fc.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/scsi_scan.c~fix-signedness-of-parameters-in-scsi-module drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~fix-signedness-of-parameters-in-scsi-module
+++ a/drivers/scsi/scsi_scan.c
@@ -85,7 +85,7 @@ static unsigned int max_scsi_luns = MAX_
 static unsigned int max_scsi_luns = 1;
 #endif
 
-module_param_named(max_luns, max_scsi_luns, int, S_IRUGO|S_IWUSR);
+module_param_named(max_luns, max_scsi_luns, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_luns,
 		 "last scsi LUN (should be between 1 and 2^32-1)");
 
@@ -109,14 +109,14 @@ MODULE_PARM_DESC(scan, "sync, async or n
  */
 static unsigned int max_scsi_report_luns = 511;
 
-module_param_named(max_report_luns, max_scsi_report_luns, int, S_IRUGO|S_IWUSR);
+module_param_named(max_report_luns, max_scsi_report_luns, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_report_luns,
 		 "REPORT LUNS maximum number of LUNS received (should be"
 		 " between 1 and 16384)");
 
 static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+3;
 
-module_param_named(inq_timeout, scsi_inq_timeout, int, S_IRUGO|S_IWUSR);
+module_param_named(inq_timeout, scsi_inq_timeout, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(inq_timeout, 
 		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
 		 " Default is 5. Some non-compliant devices need more.");
diff -puN drivers/scsi/scsi_transport_fc.c~fix-signedness-of-parameters-in-scsi-module drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c~fix-signedness-of-parameters-in-scsi-module
+++ a/drivers/scsi/scsi_transport_fc.c
@@ -474,7 +474,7 @@ static DECLARE_TRANSPORT_CLASS(fc_vport_
  */
 static unsigned int fc_dev_loss_tmo = 60;		/* seconds */
 
-module_param_named(dev_loss_tmo, fc_dev_loss_tmo, int, S_IRUGO|S_IWUSR);
+module_param_named(dev_loss_tmo, fc_dev_loss_tmo, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(dev_loss_tmo,
 		 "Maximum number of seconds that the FC transport should"
 		 " insulate the loss of a remote port. Once this value is"
_

Patches currently in -mm which might be from jet@gyve.org are

git-scsi-misc.patch

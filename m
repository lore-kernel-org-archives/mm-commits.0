From: akpm@linux-foundation.org
Subject: - scsi-clean-up-warnings-in-advansys-driver.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:48:14 -0800
Message-ID: <200702080948.l189mEhD011023@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35745 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423196AbXBHJsX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:48:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ken@krwtech.com, jeffreyfreeman@syncleus.com, mm-commits@vger.kernel.org


The patch titled
     scsi: clean up warnings in Advansys driver
has been removed from the -mm tree.  Its filename was
     scsi-clean-up-warnings-in-advansys-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: clean up warnings in Advansys driver
From: Ken Witherow <ken@krwtech.com>

Fix typecast warnings and switch from check_region to request_region

(akpm: Ken and Jeffrey Phillips Freeman <jeffreyfreeman@syncleus.com> are
possible advansys testers)

Signed-off-by: Ken Witherow <ken@krwtech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/advansys.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/advansys.c~scsi-clean-up-warnings-in-advansys-driver drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~scsi-clean-up-warnings-in-advansys-driver
+++ a/drivers/scsi/advansys.c
@@ -4403,7 +4403,7 @@ advansys_detect(struct scsi_host_templat
                         ASC_DBG1(1,
                                 "advansys_detect: probing I/O port 0x%x...\n",
                             iop);
-                        if (check_region(iop, ASC_IOADR_GAP) != 0) {
+			if (!request_region(iop, ASC_IOADR_GAP, "advansys")){
                             printk(
 "AdvanSys SCSI: specified I/O Port 0x%X is busy\n", iop);
                             /* Don't try this I/O port twice. */
@@ -4413,6 +4413,7 @@ advansys_detect(struct scsi_host_templat
                             printk(
 "AdvanSys SCSI: specified I/O Port 0x%X has no adapter\n", iop);
                             /* Don't try this I/O port twice. */
+			    release_region(iop, ASC_IOADR_GAP);
                             asc_ioport[ioport] = 0;
                             goto ioport_try_again;
                         } else {
@@ -4431,6 +4432,7 @@ advansys_detect(struct scsi_host_templat
                                   * 'ioport' past this board.
                                   */
                                  ioport++;
+				 release_region(iop, ASC_IOADR_GAP);
                                  goto ioport_try_again;
                             }
                         }
@@ -9740,13 +9742,14 @@ AscSearchIOPortAddr11(
     }
     for (; i < ASC_IOADR_TABLE_MAX_IX; i++) {
         iop_base = _asc_def_iop_base[i];
-        if (check_region(iop_base, ASC_IOADR_GAP) != 0) {
+	if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")){
             ASC_DBG1(1,
                "AscSearchIOPortAddr11: check_region() failed I/O port 0x%x\n",
                      iop_base);
             continue;
         }
         ASC_DBG1(1, "AscSearchIOPortAddr11: probing I/O port 0x%x\n", iop_base);
+	release_region(iop_base, ASC_IOADR_GAP);
         if (AscFindSignature(iop_base)) {
             return (iop_base);
         }
_

Patches currently in -mm which might be from ken@krwtech.com are

git-scsi-misc.patch

From: akpm@linux-foundation.org
Subject: + drivers-scsi-iprh-fix-buffer-overflow.patch added to -mm tree
Date: Thu, 30 Jul 2009 17:39:18 -0700
Message-ID: <200907310039.n6V0dIDL015276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747AbZGaAjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 20:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brking@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, brking@us.ibm.com, roel.kluin@gmail.com


The patch titled
     drivers/scsi/ipr.h: fix buffer overflow
has been added to the -mm tree.  Its filename is
     drivers-scsi-iprh-fix-buffer-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/ipr.h: fix buffer overflow
From: Brian King <brking@linux.vnet.ibm.com>

ioa_cfg->ipr_cmd_label is 8 bytes, IPR_CMD_LABEL is the string "ipr_cmnd",
ie 9 bytes including terminating null.

Found with Parfait, http://research.sun.com/projects/parfait/

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Cc: Roel Kluin <roel.kluin@gmail.com>
Cc: Brian King <brking@us.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ipr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.h~drivers-scsi-iprh-fix-buffer-overflow drivers/scsi/ipr.h
--- a/drivers/scsi/ipr.h~drivers-scsi-iprh-fix-buffer-overflow
+++ a/drivers/scsi/ipr.h
@@ -1199,7 +1199,7 @@ struct ipr_ioa_cfg {
 
 	struct ata_host ata_host;
 	char ipr_cmd_label[8];
-#define IPR_CMD_LABEL		"ipr_cmnd"
+#define IPR_CMD_LABEL		"ipr_cmd"
 	struct ipr_cmnd *ipr_cmnd_list[IPR_NUM_CMD_BLKS];
 	u32 ipr_cmnd_list_dma[IPR_NUM_CMD_BLKS];
 };
_

Patches currently in -mm which might be from brking@linux.vnet.ibm.com are

drivers-scsi-iprh-fix-buffer-overflow.patch


From: akpm@linux-foundation.org
Subject: + aacraid-2621-rc6-mm1-aacraid-not-finding-device.patch added to -mm tree
Date: Fri, 13 Apr 2007 14:18:22 -0700
Message-ID: <200704132118.l3DLIMtx009640@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52677 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030323AbXDMVS2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 17:18:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark_salyzyn@adaptec.com, James.Bottomley@steeleye.com, aacraid@adaptec.com


The patch titled
     aacraid: 2.6.21-rc6-mm1 aacraid not finding device
has been added to the -mm tree.  Its filename is
     aacraid-2621-rc6-mm1-aacraid-not-finding-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aacraid: 2.6.21-rc6-mm1 aacraid not finding device
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>

Thanks for the help from Steve Fox and Duane Cox investigating this
issue, I'd like to report that we found the problem. The issue is with
the patch Steve Fox isolated below, by not accommodating older adapters
properly and issuing a command they do not support when retrieving
storage parameters about the arrays. This simple patch resolves the
problem (and more accurately mimics the logic of the original code
before the patch).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/aachba.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/aacraid/aachba.c~aacraid-2621-rc6-mm1-aacraid-not-finding-device drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c~aacraid-2621-rc6-mm1-aacraid-not-finding-device
+++ a/drivers/scsi/aacraid/aachba.c
@@ -503,8 +503,7 @@ static int _aac_probe_container1(void * 
 	dresp = (struct aac_mount *) fib_data(fibptr);
 	dresp->mnt[0].capacityhigh = 0;
 	if ((le32_to_cpu(dresp->status) != ST_OK) ||
-	    ((le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
-	     (le32_to_cpu(dresp->mnt[0].state) == FSCS_HIDDEN)))
+	    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE))
 		return _aac_probe_container2(context, fibptr);
 	scsicmd = (struct scsi_cmnd *) context;
 	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
_

Patches currently in -mm which might be from mark_salyzyn@adaptec.com are

git-scsi-misc.patch
aacraid-2621-rc6-mm1-aacraid-not-finding-device.patch

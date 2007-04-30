From: akpm@linux-foundation.org
Subject: - aacraid-2621-rc6-mm1-aacraid-not-finding-device.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:45:03 -0700
Message-ID: <200704302145.l3ULj3CW015665@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423714AbXD3Vph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark_salyzyn@adaptec.com, James.Bottomley@steeleye.com, aacraid@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     aacraid: 2.6.21-rc6-mm1 aacraid not finding device
has been removed from the -mm tree.  Its filename was
     aacraid-2621-rc6-mm1-aacraid-not-finding-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 2 deletions(-)

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

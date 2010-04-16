From: akpm@linux-foundation.org
Subject: + hpsa-remove-unneeded-defines.patch added to -mm tree
Date: Fri, 16 Apr 2010 15:33:19 -0700
Message-ID: <201004162233.o3GMXJjg030534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932649Ab0DPWdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Apr 2010 18:33:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, James.Bottomley@HansenPartnership.com, steve.cameron@hp.com


The patch titled
     hpsa: remove unneeded defines
has been added to the -mm tree.  Its filename is
     hpsa-remove-unneeded-defines.patch

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
Subject: hpsa: remove unneeded defines
From: Mike Miller <mike.miller@hp.com>

Remove unnecessary #define's from hpsa.  The SCSI midlayer handles all
this for us.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Steve Cameron <steve.cameron@hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c     |    8 --------
 drivers/scsi/hpsa_cmd.h |   15 ---------------
 2 files changed, 23 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-remove-unneeded-defines drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-remove-unneeded-defines
+++ a/drivers/scsi/hpsa.c
@@ -2708,14 +2708,6 @@ static void fill_cmd(struct CommandList 
 			c->Request.CDB[8] = (size >> 8) & 0xFF;
 			c->Request.CDB[9] = size & 0xFF;
 			break;
-
-		case HPSA_READ_CAPACITY:
-			c->Request.CDBLen = 10;
-			c->Request.Type.Attribute = ATTR_SIMPLE;
-			c->Request.Type.Direction = XFER_READ;
-			c->Request.Timeout = 0;
-			c->Request.CDB[0] = cmd;
-			break;
 		case HPSA_CACHE_FLUSH:
 			c->Request.CDBLen = 12;
 			c->Request.Type.Attribute = ATTR_SIMPLE;
diff -puN drivers/scsi/hpsa_cmd.h~hpsa-remove-unneeded-defines drivers/scsi/hpsa_cmd.h
--- a/drivers/scsi/hpsa_cmd.h~hpsa-remove-unneeded-defines
+++ a/drivers/scsi/hpsa_cmd.h
@@ -152,21 +152,6 @@ struct SenseSubsystem_info {
 	u8 reserved1[1108];
 };
 
-#define HPSA_READ_CAPACITY 0x25 /* Read Capacity */
-struct ReadCapdata {
-	u8 total_size[4];	/* Total size in blocks */
-	u8 block_size[4];	/* Size of blocks in bytes */
-};
-
-#if 0
-/* 12 byte commands not implemented in firmware yet. */
-#define HPSA_READ 	0xa8
-#define HPSA_WRITE	0xaa
-#endif
-
-#define HPSA_READ   0x28    /* Read(10) */
-#define HPSA_WRITE  0x2a    /* Write(10) */

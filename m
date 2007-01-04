From: akpm@osdl.org
Subject: + msdos-partitions-fix-logic-error-in-aix-detection.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:01:56 -0800
Message-ID: <200701041901.l04J1u35028023@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:44098 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252AbXADTCf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:02:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olh@suse.de, anton@samba.org, hirofumi@mail.parknet.co.jp


The patch titled
     msdos partitions: fix logic error in AIX detection
has been added to the -mm tree.  Its filename is
     msdos-partitions-fix-logic-error-in-aix-detection.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: msdos partitions: fix logic error in AIX detection
From: Olaf Hering <olh@suse.de>

Correct the AIX magic check to let 'echo > /dev/sdb' actually work.

Signed-off-by: Olaf Hering <olh@suse.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/partitions/msdos.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/partitions/msdos.c~msdos-partitions-fix-logic-error-in-aix-detection fs/partitions/msdos.c
--- a/fs/partitions/msdos.c~msdos-partitions-fix-logic-error-in-aix-detection
+++ a/fs/partitions/msdos.c
@@ -68,10 +68,10 @@ static int aix_magic_present(unsigned ch
 	unsigned char *d;
 	int slot, ret = 0;
 
-	if (p[0] != AIX_LABEL_MAGIC1 &&
-		p[1] != AIX_LABEL_MAGIC2 &&
-		p[2] != AIX_LABEL_MAGIC3 &&
-		p[3] != AIX_LABEL_MAGIC4)
+	if (!(p[0] == AIX_LABEL_MAGIC1 &&
+		p[1] == AIX_LABEL_MAGIC2 &&
+		p[2] == AIX_LABEL_MAGIC3 &&
+		p[3] == AIX_LABEL_MAGIC4))
 		return 0;
 	/* Assume the partition table is valid if Linux partitions exists */
 	for (slot = 1; slot <= 4; slot++, pt++) {
_

Patches currently in -mm which might be from olh@suse.de are

relax-check-for-aix-in-msdos-partition-table.patch
msdos-partitions-fix-logic-error-in-aix-detection.patch

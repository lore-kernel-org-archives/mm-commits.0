From: akpm@linux-foundation.org
Subject: - msdos-partitions-fix-logic-error-in-aix-detection.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:53:16 -0800
Message-ID: <200702112253.l1BMrGae016085@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60341 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796AbXBKWxW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:53:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olh@suse.de, anton@samba.org, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     msdos partitions: fix logic error in AIX detection
has been removed from the -mm tree.  Its filename was
     msdos-partitions-fix-logic-error-in-aix-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: msdos partitions: fix logic error in AIX detection
From: Olaf Hering <olh@suse.de>

Correct the AIX magic check to let 'echo > /dev/sdb' actually work.

Signed-off-by: Olaf Hering <olh@suse.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/msdos.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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

origin.patch

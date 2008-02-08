From: akpm@linux-foundation.org
Subject: - eccbuf-is-statically-defined-and-always-evaluate-to-true.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:10:50 -0800
Message-ID: <200802080810.m188AVLB014946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759927AbYBHITf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@rfc1149.net, dwmw2@infradead.org, joern@logfs.org, mm-commits@vger.kernel.org


The patch titled
     mtd: eccbuf is statically defined and always evaluate to true
has been removed from the -mm tree.  Its filename was
     eccbuf-is-statically-defined-and-always-evaluate-to-true.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: eccbuf is statically defined and always evaluate to true
From: Samuel Tardieu <sam@rfc1149.net>

Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
Acked-by: Joern Engel <joern@logfs.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/doc2000.c     |    4 ++--
 drivers/mtd/devices/doc2001plus.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/devices/doc2000.c~eccbuf-is-statically-defined-and-always-evaluate-to-true drivers/mtd/devices/doc2000.c
--- a/drivers/mtd/devices/doc2000.c~eccbuf-is-statically-defined-and-always-evaluate-to-true
+++ a/drivers/mtd/devices/doc2000.c
@@ -632,7 +632,7 @@ static int doc_read(struct mtd_info *mtd
 			len = ((from | 0x1ff) + 1) - from;
 
 		/* The ECC will not be calculated correctly if less than 512 is read */
-		if (len != 0x200 && eccbuf)
+		if (len != 0x200)
 			printk(KERN_WARNING
 			       "ECC needs a full sector read (adr: %lx size %lx)\n",
 			       (long) from, (long) len);
@@ -896,7 +896,7 @@ static int doc_write(struct mtd_info *mt
 		/* Let the caller know we completed it */
 		*retlen += len;
 
-		if (eccbuf) {
+		{
 			unsigned char x[8];
 			size_t dummy;
 			int ret;
diff -puN drivers/mtd/devices/doc2001plus.c~eccbuf-is-statically-defined-and-always-evaluate-to-true drivers/mtd/devices/doc2001plus.c
--- a/drivers/mtd/devices/doc2001plus.c~eccbuf-is-statically-defined-and-always-evaluate-to-true
+++ a/drivers/mtd/devices/doc2001plus.c
@@ -748,7 +748,7 @@ static int doc_write(struct mtd_info *mt
 	WriteDOC(DoC_GetDataOffset(mtd, &fto), docptr, Mplus_FlashCmd);
 
 	/* On interleaved devices the flags for 2nd half 512 are before data */
-	if (eccbuf && before)
+	if (before)
 		fto -= 2;
 
 	/* issue the Serial Data In command to initial the Page Program process */
_

Patches currently in -mm which might be from sam@rfc1149.net are

origin.patch
git-watchdog.patch

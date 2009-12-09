From: akpm@linux-foundation.org
Subject: [folded] synclink_gt-dropped-transmit-data-bugfix-fix.patch removed from -mm tree
Date: Wed, 09 Dec 2009 12:30:47 -0800
Message-ID: <200912092030.nB9KUlAQ001829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754261AbZLIUav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2009 15:30:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     synclink_gt: use DIV_ROUND_UP()
has been removed from the -mm tree.  Its filename was
     synclink_gt-dropped-transmit-data-bugfix-fix.patch

This patch was dropped because it was folded into synclink_gt-dropped-transmit-data-bugfix.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink_gt: use DIV_ROUND_UP()
From: Paul Fulghum <paulkf@microgate.com>

Use DIV_ROUND_UP macro to simplify code.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-dropped-transmit-data-bugfix-fix drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-dropped-transmit-data-bugfix-fix
+++ a/drivers/char/synclink_gt.c
@@ -4779,13 +4779,9 @@ static bool tx_load(struct slgt_info *in
 	unsigned short count;
 	unsigned int i;
 	struct slgt_desc *d;
-	unsigned int bufs_needed;
 
 	/* check required buffer space */
-	bufs_needed = (size/DMABUFSIZE);
-	if (size % DMABUFSIZE)
-		++bufs_needed;
-	if (bufs_needed > free_tbuf_count(info))
+	if (DIV_ROUND_UP(size, DMABUFSIZE) > free_tbuf_count(info))
 		return false;
 
 	DBGDATA(info, buf, size, "tx");
_

Patches currently in -mm which might be from paulkf@microgate.com are

synclink_gt-dropped-transmit-data-bugfix.patch
synclink_gt-dropped-transmit-data-bugfix-fix.patch


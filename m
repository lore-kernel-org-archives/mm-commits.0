From: akpm@linux-foundation.org
Subject: + synclink_gt-dropped-transmit-data-bugfix-fix.patch added to -mm tree
Date: Wed, 09 Dec 2009 12:29:40 -0800
Message-ID: <200912092029.nB9KTeWW031533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623AbZLIU3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2009 15:29:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     synclink_gt: use DIV_ROUND_UP()
has been added to the -mm tree.  Its filename is
     synclink_gt-dropped-transmit-data-bugfix-fix.patch

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


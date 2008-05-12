From: akpm@linux-foundation.org
Subject: + gigaset-gigaset_isowbuf_getbytes-may-return-signed-unnoticed.patch added to -mm tree
Date: Mon, 12 May 2008 15:39:56 -0700
Message-ID: <200805122239.m4CMduPo012766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667AbYELWkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 18:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, 12o3l@tiscali.nl


The patch titled
     gigaset: gigaset_isowbuf_getbytes() may return signed unnoticed
has been added to the -mm tree.  Its filename is
     gigaset-gigaset_isowbuf_getbytes-may-return-signed-unnoticed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gigaset: gigaset_isowbuf_getbytes() may return signed unnoticed
From: Tilman Schmidt <tilman@imap.cc>

ifd->offset is unsigned.  gigaset_isowbuf_getbytes() may return signed
unnoticed.  Revised version of patch originally submitted by Roel Kluin
<12o3l@tiscali.nl>.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/bas-gigaset.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/isdn/gigaset/bas-gigaset.c~gigaset-gigaset_isowbuf_getbytes-may-return-signed-unnoticed drivers/isdn/gigaset/bas-gigaset.c
--- a/drivers/isdn/gigaset/bas-gigaset.c~gigaset-gigaset_isowbuf_getbytes-may-return-signed-unnoticed
+++ a/drivers/isdn/gigaset/bas-gigaset.c
@@ -1050,10 +1050,9 @@ static int submit_iso_write_urb(struct i
 		}
 
 		/* retrieve block of data to send */
-		ifd->offset = gigaset_isowbuf_getbytes(ubc->isooutbuf,
-						       ifd->length);
-		if (ifd->offset < 0) {
-			if (ifd->offset == -EBUSY) {
+		rc = gigaset_isowbuf_getbytes(ubc->isooutbuf, ifd->length);
+		if (rc < 0) {
+			if (rc == -EBUSY) {
 				gig_dbg(DEBUG_ISO,
 					"%s: buffer busy at frame %d",
 					__func__, nframe);
@@ -1062,11 +1061,12 @@ static int submit_iso_write_urb(struct i
 			} else {
 				dev_err(ucx->bcs->cs->dev,
 					"%s: buffer error %d at frame %d\n",
-					__func__, ifd->offset, nframe);
-				return ifd->offset;
+					__func__, rc, nframe);
+				return rc;
 			}
 			break;
 		}
+		ifd->offset = rc;
 		ucx->limit = ubc->isooutbuf->nextread;
 		ifd->status = 0;
 		ifd->actual_length = 0;
_

Patches currently in -mm which might be from tilman@imap.cc are

gigaset-use-dev_-macros-for-messages.patch
gigaset-gigaset_isowbuf_getbytes-may-return-signed-unnoticed.patch

